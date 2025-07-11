local isCapturing = {}
local zoneCooldown = {}

local drawBlip = function(data)
    local blip = AddBlipForCoord(data.coords.x, data.coords.y, data.coords.z)
    if data.third then
        SetBlipSprite(blip, 774)
        SetBlipColour(blip, 47)
        SetBlipScale(blip, 0.9)
        SetBlipAlpha(blip, 255)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString("STREFA TRZECIA: " .. (data.thirdLabel or data.name))
        EndTextCommandSetBlipName(blip)

        local radius = data.thirdRadius or 50.0
        local radiusBlip = AddBlipForRadius(data.coords.x, data.coords.y, data.coords.z, radius)
        SetBlipColour(radiusBlip, 47)
        SetBlipAlpha(radiusBlip, 80)
    else
        SetBlipSprite(blip, 774)
        SetBlipColour(blip, 1)
        SetBlipScale(blip, 0.8)
        SetBlipAlpha(blip, 255)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString("STREFA: " .. data.name)
        EndTextCommandSetBlipName(blip)
    end
end

local inThirdZone = false

Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        inThirdZone = false
        for _, v in ipairs(Config['strefy'].zones) do
            if v.third then
                local radius = v.thirdRadius or 50.0
                local dist = #(playerCoords - v.coords)
                if dist < radius then
                    inThirdZone = true
                    break
                end
            end
        end
        Citizen.Wait(500)
    end
end)

SKAM.addKeybind({
    key = "F",
    description = "Usuń pojazd ~ TRZECIA",
    onPressed = function()
        if inThirdZone then
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            if vehicle and vehicle ~= 0 then
                SetEntityAsMissionEntity(vehicle, true, true)
                DeleteVehicle(vehicle)
            end
        end
    end
})

exports('thirdZone', function()
    return inThirdZone
end)

for _, zone in pairs(Config['strefy'].zones) do
    drawBlip(zone)
end

for i, zone in ipairs(Config['strefy'].zones) do
    SKAM.RegisterPlace({
        coords = zone.coords,
        Marker = {size = vector3(10.0,10.0,0.3)},
        txt3d = (zone.third and 'przejąć STREFĘ TRZECIĄ: %s' or 'przejąć strefę: %s'):format(zone.thirdLabel or zone.name),
        onPress = function()
            if not IsPedInAnyVehicle(PlayerPedId(), false) and not LocalPlayer.state.dead and not isCapturing[i] then
                local weapon = GetSelectedPedWeapon(PlayerPedId())
                if weapon ~= GetHashKey('WEAPON_UNARMED') then
                    TriggerServerEvent('skam$strefa:try', i)
                else
                    ESX.ShowNotification('Musisz mieć pistolet w ręce!')
                end
            end
        end,
        onExit = function()
            if isCapturing[i] then
                TriggerServerEvent('skam$strefa:cancel', i)
            end
        end
    })
end

RegisterNetEvent('skam$strefa:start', function(zoneId, captureTime)
    isCapturing[zoneId] = true
    exports['skam-ui']:showProgress('Przejmowanie strefy...', captureTime * 1000)
end)

RegisterNetEvent('skam$strefa:fail', function(zoneId)
    isCapturing[zoneId] = false
    exports['skam-ui']:hideProgress()
end)

RegisterNetEvent('skam$strefa:success', function(zoneId)
    isCapturing[zoneId] = false
end)

RegisterNetEvent('skam$strefa:cooldown', function(zoneId, cooldown)
    zoneCooldown[zoneId] = true
    Citizen.SetTimeout(cooldown * 1000, function()
        zoneCooldown[zoneId] = false
    end)
end)

AddEventHandler('skam$death', function()
    for zoneId, capturing in pairs(isCapturing) do
        if capturing then
            TriggerServerEvent('skam$strefa:cancel', zoneId)
            isCapturing[zoneId] = false
        end
    end
end)