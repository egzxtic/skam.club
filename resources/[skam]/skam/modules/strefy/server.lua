local Capturing = {} -- [zoneId] = {player, timeLeft}
local Cooldowns = {} -- [zoneId] = timestamp
local CapturedZones = {} -- [zoneId] = { owner, capturedAt }

RegisterNetEvent('skam$strefa:try', function(zoneId)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not Config['strefy'].zones[zoneId] then return end
    if Capturing[zoneId] then return end
    if (Cooldowns[zoneId] or 0) > os.time() then
        local secondsLeft = Cooldowns[zoneId] - os.time()
        TriggerClientEvent('skam:showNotification', src, {
            title = 'Strefy',
            description = string.format('Strefa będzie dostępna za %d sek.', secondsLeft),
            variant = 'strefy'
        })
        TriggerClientEvent('skam$strefa:fail', src, zoneId)
        return
    end

    Capturing[zoneId] = {player = src, timeLeft = Config['strefy'].captureTime}
    TriggerClientEvent('skam$strefa:start', src, zoneId, Config['strefy'].captureTime)
    TriggerClientEvent("skam$chat", -1, {
        label = 'STREFY',
        color = "#EB4B4B",
    }, {
        type = "PRZEJMOWANIE",
        content = ('%s rozpoczął przejmowanie strefy %s!'):format(xPlayer.getName(), Config['strefy'].zones[zoneId].name)
    })
    
    Citizen.CreateThread(function()
        while Capturing[zoneId] and Capturing[zoneId].timeLeft > 0 do
            Citizen.Wait(1000)
            if not Capturing[zoneId] then break end
            Capturing[zoneId].timeLeft = Capturing[zoneId].timeLeft - 1
        end

        if Capturing[zoneId] then
            local winner = ESX.GetPlayerFromId(Capturing[zoneId].player)
            local rewardMoney = math.random(600000,1200000)
            if winner then
                winner.addMoney(rewardMoney)
                winner.addInventoryItem(Config['strefy'].zones[zoneId].rewardItem.name, Config['strefy'].zones[zoneId].rewardItem.count)
                TriggerClientEvent('skam:showNotification', src, {
                    title = 'Strefy',
                    description = string.format('Przejąłeś strefę %s!\nZgarniasz: %d$', Config['strefy'].zones[zoneId].name, rewardMoney),
                    variant = 'strefy'
                })
                MySQL.Async.execute([[
                    UPDATE users SET zoneCount = IFNULL(zoneCount, 0) + 1 WHERE identifier = @identifier
                ]], {
                    ['@identifier'] = xPlayer.identifier
                })
            end
            Cooldowns[zoneId] = os.time() + Config['strefy'].cooldown
            TriggerClientEvent('skam$strefa:success', src, zoneId)
            TriggerClientEvent('skam$strefa:cooldown', -1, zoneId, Config['strefy'].cooldown)
            local winnerName = winner and winner.getName() or 'Nieznany'
            CapturedZones[zoneId] = {
                owner = winnerName,
                capturedAt = os.time()
            }
            Capturing[zoneId] = nil
        end
    end)
end)

exports('getZoneStatus', function()
    local result = {}
    for zoneId, zone in ipairs(Config['strefy'].zones) do
        if Capturing[zoneId] then
            local player = ESX.GetPlayerFromId(Capturing[zoneId].player)
            local playerName = player and player.getName() or 'Nieznany'
            table.insert(result, {
                name = zone.name,
                status = 'przejmowana',
                capturing = playerName
            })
        elseif CapturedZones[zoneId] then
            table.insert(result, {
                name = zone.name,
                status = 'przejeta',
                owner = CapturedZones[zoneId].owner,
                capturedAt = CapturedZones[zoneId].capturedAt
            })
        else
            table.insert(result, {
                name = zone.name,
                status = 'wolna'
            })
        end
    end
    return result
end)

RegisterNetEvent('skam$strefa:cancel', function(zoneId)
    local src = source
    if Capturing[zoneId] and Capturing[zoneId].player == src then
        Capturing[zoneId] = nil
        --Cooldowns[zoneId] = os.time() + Config['strefy'].cooldown
        TriggerClientEvent('skam:showNotification', src, {
            title = 'Strefy',
            description = '~r~Przejęcie strefy zostało anulowane lub przerwane!',
            variant = 'strefy'
        })
        TriggerClientEvent('skam$strefa:fail', src, zoneId)
        TriggerClientEvent('skam$strefa:cooldown', -1, zoneId, Config['strefy'].cooldown)
    end
end)

AddEventHandler('playerDropped', function(src)
    for zoneId, data in pairs(Capturing) do
        if data.player == src then
            Capturing[zoneId] = nil
            --Cooldowns[zoneId] = os.time() + Config['strefy'].cooldown
            TriggerClientEvent('skam$strefa:fail', -1, zoneId)
            TriggerClientEvent('skam$strefa:cooldown', -1, zoneId, Config['strefy'].cooldown)
        end
    end
end)