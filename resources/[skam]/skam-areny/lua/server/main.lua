cache = {}
ESX = exports['es_extended']:getSharedObject()

for i = 1001, 15000 do
    SetRoutingBucketPopulationEnabled(i, false)
end

getVehicleFreeSeat = function(vehicle)
    local seats = 6
    local seatIndex = false
    for seatIdx = -1, seats do
        local pedAtSeat = GetPedInVehicleSeat(vehicle, seatIdx)
        if (pedAtSeat == 0) then
            seatIndex = seatIdx
            break
        end
    end
    return seatIndex
end

getVehiclePassengers = function(vehicle)
    local passengers = {}
    local seats = 12
    local driverJob = ''

    for seatIdx = -1, seats do
        local pedAtSeat = GetPedInVehicleSeat(vehicle, seatIdx)
        if (pedAtSeat and IsPedAPlayer(pedAtSeat)) then
            local isDriver = seatIdx == -1
            local pedSource = NetworkGetEntityOwner(pedAtSeat)

            if (isDriver) then
                driverJob = ESX.GetPlayerFromId(pedSource).job.name
            end
            passengers[#passengers + 1] = {seatIndex = seatIdx,source = pedSource, handle = pedAtSeat, isDriver = (seatIdx == -1)}
        end
    end
    passengers.driverJob = driverJob
    return passengers
end

jobCheck = function(xPlayer, customBucket)
    if (Player(xPlayer.source).state.customOrgBucket ~= nil) then
        if (customBucket) then
            return Player(xPlayer.source).state.customOrgBucket == customBucket
        else
            return true
        end
    else
        if (customBucket) then
            return xPlayer.job.name == customBucket
        else
            return xPlayer.job.name ~= 'unemployed'
        end
    end
end