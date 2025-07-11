local globalKeysTable = {}
local searchedCars = {}

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
    if not globalKeysTable[xPlayer.identifier] then
        globalKeysTable[xPlayer.identifier] = {}
        MySQL.Async.fetchAll("SELECT identifier, plate FROM owned_vehicles WHERE identifier = @identifier",{
            ['@identifier'] = xPlayer.identifier
        }, function(data)
            for k, v in pairs(data) do
                plate = string.lower(v.plate:gsub("%s$", ""))
                table.insert(globalKeysTable[xPlayer.identifier], {plate = plate})
                searchedCars[plate] = true
            end
        end)
    end
end)

ESX.RegisterServerCallback('skam$locksystem:checkKeys', function(source, cb, plate)
	local xPlayer = ESX.GetPlayerFromId(source)
    local hasKey = false
    local canSearch = false
    local plate = string.lower(plate)

    if globalKeysTable[xPlayer.identifier] then
        for k, v in pairs(globalKeysTable[xPlayer.identifier]) do
            if plate == v.plate then
                hasKey = true
                break
            end
        end
    end

    if not searchedCars[plate] then
        canSearch = true
    end
	
	cb(hasKey, canSearch)
end)

ESX.RegisterServerCallback('skam$locksystem:getAllKeys', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end
	cb(globalKeysTable[xPlayer.identifier])
end)

RegisterServerEvent("skam$locksystem:blockCarSearch")
AddEventHandler("skam$locksystem:blockCarSearch", function(plate)
    local plate = string.lower(plate)
    if not searchedCars[plate] then
        searchedCars[plate] = true
    end
end)

RegisterServerEvent("skam$locksystem:addCarKeys")
AddEventHandler("skam$locksystem:addCarKeys", function(plate, target)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xPlayerSecond = nil

    if target then
        xPlayer = ESX.GetPlayerFromId(target)
        xPlayerSecond = ESX.GetPlayerFromId(source)
    end

    local plate = string.lower(plate)
    local haveKeys = false
    
    if not searchedCars[plate] then
        searchedCars[plate] = true
    end

    if globalKeysTable[xPlayer.identifier] then
        for k, v in pairs(globalKeysTable[xPlayer.identifier]) do
            if plate == v.plate then
                haveKeys = true
                break
            end
        end
    end

    if not haveKeys then
        table.insert(globalKeysTable[xPlayer.identifier], {plate = plate, ownerType = target and 0 or 1})
        if target then

            if globalKeysTable[xPlayerSecond.identifier] then
                for k, v in pairs(globalKeysTable[xPlayerSecond.identifier]) do
                    if plate == v.plate and v.ownerType == 0 then
                        table.remove(globalKeysTable[xPlayerSecond.identifier], k)
                        break
                    end
                end
            end

            xPlayerSecond.showNotification('~g~Przekazano kluczyki do ('..string.upper(plate)..') dla '..target)
            xPlayer.showNotification('~g~Otrzymano kluczyki do ('..string.upper(plate)..') od '..source)
        end
    end
end)

RegisterServerEvent("skam$locksystem:removeCarKeys")
AddEventHandler("skam$locksystem:removeCarKeys", function(plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    local plate = string.lower(plate)
    if globalKeysTable[xPlayer.identifier] then
        for k, v in pairs(globalKeysTable[xPlayer.identifier]) do
            if plate == v.plate then
                table.remove(globalKeysTable[xPlayer.identifier], k)
                break
            end
        end
    end
end)