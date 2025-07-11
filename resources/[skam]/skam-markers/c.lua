local PlaceTable = {}
local isInMarker = nil

local SKAM = {}

function SKAM.CheckJob(job)
    if not job or not ESX.PlayerData.job then return true end
    if string.find(job, 'org') then
        return string.find(ESX.PlayerData.job.name, 'org') ~= nil
    else
        return job == ESX.PlayerData.job.name
    end
end

function SKAM.drawText(text, coords)
    local distanceToText = #(GetEntityCoords(PlayerPedId()) - coords)
    if distanceToText <= 5.0 then
        AddTextEntry('SKAM', text)
        SetFloatingHelpTextStyle(1, 1, 2, 255, 3, 0)
        SetFloatingHelpTextWorldPosition(1, coords)
        BeginTextCommandDisplayHelp('SKAM')
        EndTextCommandDisplayHelp(2, false, false, -1)
    end
end

local function createPedAtMarker(pedModel, coords)
    if not pedModel or not pedModel.model then return nil end

    local model = GetHashKey(pedModel.model)
    RequestModel(model)
    local timeout = 0
    while not HasModelLoaded(model) and timeout < 100 do
        Citizen.Wait(50)
        timeout = timeout + 1
    end
    if not HasModelLoaded(model) then return nil end

    local heading = pedModel.heading or 0.0
    local ped = CreatePed(4, model, coords.x, coords.y, coords.z, heading, false, false)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)
    SetEntityAsMissionEntity(ped, true, true)

    if pedModel.scenario then
        TaskStartScenarioInPlace(ped, pedModel.scenario, 0, true)
    elseif pedModel.animation and pedModel.animation.dict and pedModel.animation.name then
        RequestAnimDict(pedModel.animation.dict)
        while not HasAnimDictLoaded(pedModel.animation.dict) do Citizen.Wait(10) end
        TaskPlayAnim(
            ped,
            pedModel.animation.dict,
            pedModel.animation.name,
            8.0, -8.0, -1,
            1,
            0, false, false, false
        )
    end

    if pedModel.weapon then
        GiveWeaponToPed(ped, GetHashKey(pedModel.weapon), 1, false, true)
        SetCurrentPedWeapon(ped, GetHashKey(pedModel.weapon), true)
    end

    return ped
end

function SKAM.RegisterPlace(args)
    local coords = args.coords
    if not coords then
        error('Brak współrzędnych (coords) w wywołaniu RegisterPlace')
    end
    if coords.w then
        coords = vector3(coords.x, coords.y, coords.z)
    elseif not coords.x or not coords.y or not coords.z then
        error('Nieprawidłowe współrzędne przekazane do RegisterPlace')
    end

    local Marker = args.Marker
    local txt3d = args.txt3d
    local pedModel = args.pedModel
    local PressEcb = args.onPress
    local ExitMarkercb = args.onExit
    local EnterMarkercb = args.onEnter
    local jobs = args.jobs

    local DrawMarker = false
    local MarkerProperties = {
        type = 1,
        size = vector3(1.0, 1.0, 1.0),
        color = nil,
        dist = 20.0
    }

    if type(Marker) == 'boolean' then
        DrawMarker = Marker
    elseif type(Marker) == 'table' then
        DrawMarker = true
        MarkerProperties.type  = Marker.type  or MarkerProperties.type
        MarkerProperties.size  = Marker.size  or MarkerProperties.size
        MarkerProperties.color = Marker.color or MarkerProperties.color
        MarkerProperties.dist  = Marker.dist  or MarkerProperties.dist
    end

    if MarkerProperties.type == 1 and MarkerProperties.size.x >= 5.0 then
        MarkerProperties.isInMarkerSize = MarkerProperties.size.x / 1.7
    elseif MarkerProperties.type == 27 then
        MarkerProperties.isInMarkerSize = MarkerProperties.size.x / 2
    else
        MarkerProperties.isInMarkerSize = MarkerProperties.size.x
    end

    local ped = nil
    if pedModel then
        ped = createPedAtMarker(pedModel, coords)
    end

    local markerData = {
        coords = coords,
        DrawMarker = DrawMarker,
        MarkerProperties = MarkerProperties,
        txt3d = txt3d,
        pedModel = pedModel,
        ped = ped,
        PressEcb = PressEcb,
        ExitMarkercb = ExitMarkercb,
        EnterMarkercb = EnterMarkercb,
        Jobs = jobs
    }

    table.insert(PlaceTable, markerData)
    return #PlaceTable
end

function SKAM.RemoveMarker(markerId)
    if PlaceTable[markerId] then
        table.remove(PlaceTable, markerId)
        if isInMarker == markerId then
            isInMarker = nil
        end
    end
end

CreateThread(function()
    while true do
        local sleep = 500
        local coords = GetEntityCoords(PlayerPedId())
        local nearestHelp = nil

        for i, place in ipairs(PlaceTable) do
            local dist = #(coords - place.coords) - place.MarkerProperties.isInMarkerSize

            if dist < place.MarkerProperties.dist and SKAM.CheckJob(place.Jobs) then
                if dist < 0 then
                    if isInMarker ~= i and place.EnterMarkercb then
                        place.EnterMarkercb()
                    end
                    isInMarker = i
                else
                    if isInMarker == i then
                        isInMarker = nil
                        if place.ExitMarkercb then
                            place.ExitMarkercb()
                        end
                    end
                end

                if place.txt3d then
                    if not nearestHelp or dist < nearestHelp.dist then
                        nearestHelp = {txt = dist < 0 and ('Naciśnij [~m~E~w~], aby '..place.txt3d) or
                                                          ('Podejdź bliżej, aby '..place.txt3d), coords = place.coords, dist = dist}
                    end
                end

                if place.DrawMarker then
                    local maxAlpha = 200
                    local minAlpha = 5
                    local fadeDist = place.MarkerProperties.dist

                    local alpha
                    if dist < 0 then
                        alpha = maxAlpha
                    elseif dist < fadeDist then
                        alpha = minAlpha + ((maxAlpha - minAlpha) * (1 - (dist / fadeDist)))
                        alpha = math.floor(alpha)
                    else
                        alpha = minAlpha
                    end

                    local color = {
                        r = place.MarkerProperties.color and place.MarkerProperties.color.r or 255,
                        g = place.MarkerProperties.color and place.MarkerProperties.color.g or 255,
                        b = place.MarkerProperties.color and place.MarkerProperties.color.b or 255,
                        a = alpha
                    }

                    DrawMarker(
                        place.MarkerProperties.type or 1,
                        place.coords,
                        0, 0, 0,
                        0, 0, 0,
                        place.MarkerProperties.size.x,
                        place.MarkerProperties.size.y,
                        place.MarkerProperties.size.z,
                        color.r, color.g, color.b, color.a,
                        false, false, 2, false, false, false, false
                    )
                end

                sleep = 0
            end
        end

        if nearestHelp then
            SKAM.drawText(nearestHelp.txt, vector3(nearestHelp.coords.x, nearestHelp.coords.y, nearestHelp.coords.z + 2.0))
        end

        Wait(sleep)
    end
end)

local registeredButtons = {}

function SKAM.addKeybind(opts)
    assert(type(opts) == 'table', 'Musisz podać parametry jako tabelę!')
    assert(opts.key, 'Brakuje klawisza!')
    assert(opts.onPressed, 'Brakuje funkcji onPressed!')

    local upperKey = string.upper(opts.key)
    if registeredButtons[upperKey] then
        table.insert(registeredButtons[upperKey].press, opts.onPressed)
        if opts.onReleased then
            table.insert(registeredButtons[upperKey].release, opts.onReleased)
        end
    else
        local commandName = 'skam.keybind'..upperKey
        registeredButtons[upperKey] = {
            press = {opts.onPressed},
            release = {opts.onReleased or function() end},
            activeWhen = opts.activeWhen or function() return true end,
        }

        RegisterCommand('+'..commandName, function()
            if registeredButtons[upperKey].activeWhen() then
                for _, cb in ipairs(registeredButtons[upperKey].press) do
                    cb()
                end
            end
        end, false)
        RegisterCommand('-'..commandName, function()
            if registeredButtons[upperKey].activeWhen() then
                for _, cb in ipairs(registeredButtons[upperKey].release) do
                    cb()
                end
            end
        end, false)

        RegisterKeyMapping('+'..commandName, opts.description, 'KEYBOARD' or opts.second, opts.key)

        CreateThread(function()
            Wait(1000)
            TriggerEvent('chat:removeSuggestion', '/+'..commandName)
            TriggerEvent('chat:removeSuggestion', '/-'..commandName)
        end)
    end
end

exports('getSharedObject', function()
    return SKAM
end)

SKAM.addKeybind({
    key = 'E',
    description = 'Użyj Markera',
    onPressed = function()
        if isInMarker then
            local cb = PlaceTable[isInMarker].PressEcb
            if cb then cb() end
        end
    end
})