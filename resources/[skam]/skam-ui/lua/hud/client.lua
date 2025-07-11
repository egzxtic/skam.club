local function GetProximity()
    for _, v in pairs(Config.proximityModes) do
        if v[1] == NetworkGetTalkerProximity() then
            return v[2]
        end
    end
    return 0
end

CreateThread(function()
    while not NetworkIsPlayerActive(PlayerId()) or not NetworkIsSessionStarted() do
        Wait(500)
    end

    local lastInVehicle = false
    local lastHealth, lastArmor, lastVoice, lastTalking = nil, nil, nil, nil
    local lastVehicleSpeed, lastVehicleRPM = nil, nil

    while true do
        local ped = PlayerPedId()
        local playerId = PlayerId()
        local health = GetEntityHealth(ped)
        local armor = GetPedArmour(ped)
        local inVehicle = IsPedInAnyVehicle(ped, false) and not IsPauseMenuActive()
        local vehicle = inVehicle and GetVehiclePedIsUsing(ped) or nil
        local vehicleSpeed = vehicle and math.floor(GetEntitySpeed(vehicle) * 3.6 + 0.5) or 0
        local getVehicleRPM = vehicle and (GetVehicleCurrentRpm(vehicle) * 100) or 0
        local voice = GetProximity()
        local talking = NetworkIsPlayerTalking(playerId)

        if inVehicle ~= lastInVehicle then
            SendNUIMessage({ type = inVehicle and 'loadcarhud' or 'stopcarhud' })
            lastInVehicle = inVehicle
        end

        if lastVehicleSpeed ~= vehicleSpeed or lastVehicleRPM ~= getVehicleRPM or lastInVehicle ~= inVehicle then
            SendNUIMessage({
                type     = 'carhud:update',
                predkosc = vehicleSpeed,
                progres  = getVehicleRPM,
                jadymy   = inVehicle
            })
            lastVehicleSpeed = vehicleSpeed
            lastVehicleRPM = getVehicleRPM
        end

        if lastHealth ~= health or lastArmor ~= armor or lastVoice ~= voice then
            SendNUIMessage({
                type  = 'loadhud',
                zycie = health,
                armor = armor,
                voice = voice,
            })
            lastHealth = health
            lastArmor = armor
            lastVoice = voice
        end

        if lastTalking ~= talking then
            SendNUIMessage({
                type = 'hud:active',
                active = talking,
            })
            lastTalking = talking
        end

        Wait(200)
    end
end)

local viewMap = true
SKAM.addKeybind({
    description = 'Włącza lub wyłącza widok mapy.',
    key = 'MOUSE_MIDDLE',
    second = 'MOUSE_BUTTON',
    onPressed  = function()
        viewMap = not viewMap
        DisplayRadar(viewMap)
    end
})

RegisterCommand('ustawienia', function()
    SendNUIMessage({
        type = 'nui:settings:show',
    })
end, false)

CreateThread(function()
    local minimap = RequestScaleformMovie('minimap')
    while not HasScaleformMovieLoaded(minimap) do
        Wait(10)
    end

    while true do
        Wait(1000)
        SetRadarBigmapEnabled(false, true)

        BeginScaleformMovieMethod(minimap, 'SETUP_HEALTH_ARMOUR')
        ScaleformMovieMethodAddParamInt(3)
        EndScaleformMovieMethod()
    end

    SetBlipAlpha(GetNorthRadarBlip(), 0)
end)

local nuiOpen = false
 
RegisterCommand('hud', function()
    if not nuiOpen then
        nuiOpen = true
        SetNuiFocus(true, true)
        SendNUIMessage({ type = 'OPEN_SETTINGS' })
    end
end, false)

RegisterNUICallback('CloseSettings', function(_, cb)
    if nuiOpen then
        nuiOpen = false
        SetNuiFocus(false, false)
    end
    cb('ok')
end)

RegisterNUICallback('hud:basic', function(data, cb)
    --print('BASIC')
    cb('ok')
end)

RegisterNUICallback('hud:klasyczny', function(data, cb)
    --print('KLASYCZNY')
    cb('ok')
end)