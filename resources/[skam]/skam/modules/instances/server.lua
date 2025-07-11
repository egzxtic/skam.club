SetRoutingBucketEntityLockdownMode(0, "relaxed")
local Instances = {}

function AddPlayersToInstance(players)
    local freeInstanceId = 1
    for i, v in ipairs(Instances) do
        freeInstanceId = i + 1
    end

    Instances[freeInstanceId] = {players = players, vehs = {}}

    SetRoutingBucketEntityLockdownMode(freeInstanceId, "strict")
    SetRoutingBucketPopulationEnabled(freeInstanceId, false)

    local vehList = {}
    for i = 1, #players do
        local veh = GetVehiclePedIsIn(GetPlayerPed(players[i]), false)
        if veh ~= 0 then
            vehList[veh] = {}
            for seatIndex = 1, 16 do
                if GetPedInVehicleSeat(veh, seatIndex) == GetPlayerPed(players[i]) then
                    vehList[veh][players[i]] = seatIndex
                end
            end
        end
        SetPlayerRoutingBucket(players[i], freeInstanceId)
    end

    for veh, values in pairs(vehList) do
        SetEntityRoutingBucket(veh, freeInstanceId)
        for src, seatIndex in pairs(values) do
            SetPedIntoVehicle(GetPlayerPed(src), veh, seatIndex)
        end
        Instances[freeInstanceId].vehs[veh] = true
    end

    return freeInstanceId
end

function ReturnPlayersToMainInstance(InstanceId)
    local players = Instances[InstanceId].players

    local vehList = {}
    for i = 1, #players do
        local veh = GetVehiclePedIsIn(GetPlayerPed(players[i]), false)
        if veh ~= 0 then
            Instances[InstanceId].vehs[veh] = nil
            vehList[veh] = {}
            for seatIndex = 1, 16 do
                if GetPedInVehicleSeat(veh, seatIndex) == GetPlayerPed(players[i]) then
                    vehList[veh][players[i]] = seatIndex
                end
            end
        end
        SetPlayerRoutingBucket(players[i], 0)
    end

    for veh, values in pairs(vehList) do
        if DoesEntityExist(veh) then
            SetEntityRoutingBucket(veh, 0)
            for src, seatIndex in pairs(values) do
                SetPedIntoVehicle(GetPlayerPed(src), veh, seatIndex)
            end
        end
    end

    for veh, _ in pairs(Instances[InstanceId].vehs) do
        if DoesEntityExist(veh) then
            SetEntityRoutingBucket(veh, 0)
        end
    end

    Instances[InstanceId] = nil
end