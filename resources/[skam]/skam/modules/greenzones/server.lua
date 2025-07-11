RegisterNetEvent('skam$changeBucket')
AddEventHandler('skam$changeBucket', function(bckt)
    local player = source
    local ped = GetPlayerPed(player)
    local veh = GetVehiclePedIsIn(ped, false)
    local routingVeh = false

    if veh ~= 0 then
        routingVeh = true
    end

    if bckt == 'random' then
        local rndm = math.random(111111111,999999999)
        SetPlayerRoutingBucket(player, rndm)
        if routingVeh then
            SetEntityRoutingBucket(veh, rndm)
        end
    elseif type(bckt) == 'number' then
        SetPlayerRoutingBucket(player, bckt)
        if routingVeh then
            SetEntityRoutingBucket(veh, bckt)
        end
    end

    Citizen.Wait(50)
    SetPlayerRoutingBucket(player, bckt)
    if routingVeh then
        SetEntityRoutingBucket(veh, bckt)
    end
end)
