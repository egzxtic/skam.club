local function formatPlayTime(seconds)
    local days = math.floor(seconds / 86400)
    local hours = math.floor((seconds % 86400) / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    return string.format('%dd %dh %dm', days, hours, minutes)
end

local function getRankingData(cb)
    local rankingData = { bitki = {}, ranking = {}, czas = {}, duele = {} }

    MySQL.Async.fetchAll("SELECT label, bitkipoints FROM jobs WHERE name LIKE 'org%' ORDER BY bitkipoints DESC LIMIT 10", {}, function(orgs)
        for _, org in ipairs(orgs) do
            table.insert(rankingData.bitki, {
                name = org.label or 'Brak',
                score = tonumber(org.bitkipoints) or 0
            })
        end

        MySQL.Async.fetchAll('SELECT name, points FROM users ORDER BY points DESC LIMIT 10', {}, function(pointsRows)
            for _, row in ipairs(pointsRows) do
                table.insert(rankingData.ranking, {
                    name = row.name or 'Brak',
                    score = tonumber(row.points) or 0
                })
            end

            MySQL.Async.fetchAll('SELECT name, playTime FROM users ORDER BY playTime DESC LIMIT 10', {}, function(timeRows)
                for _, row in ipairs(timeRows) do
                    local secs = tonumber(row.playTime) or 0
                    table.insert(rankingData.czas, {
                        name = row.name or 'Brak',
                        score = secs,
                        scoreFormatted = formatPlayTime(secs)
                    })
                end

                cb(rankingData)
            end)
        end)
    end)
end

local playTimeStart = {}

AddEventHandler('esx:playerLoaded', function(source, xPlayer)
    playTimeStart[source] = os.time()
end)

AddEventHandler('esx:playerDropped', function(source, reason)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer and playTimeStart[source] then
        local sessionSeconds = os.time() - playTimeStart[source]
        if sessionSeconds > 0 then
            MySQL.Async.fetchScalar('SELECT playTime FROM users WHERE identifier = @identifier', {
                ['@identifier'] = xPlayer.identifier
            }, function(currentPlayTime)
                local totalPlayTime = (tonumber(currentPlayTime) or 0) + sessionSeconds
                MySQL.Async.execute('UPDATE users SET playTime = @playTime WHERE identifier = @identifier', {
                    ['@playTime'] = totalPlayTime,
                    ['@identifier'] = xPlayer.identifier
                })
            end)
        end
    end
    playTimeStart[source] = nil
end)

local function timeAgo(ts)
    local diff = os.time() - ts
    if diff < 60 then
        return string.format('%d sek. temu', diff)
    elseif diff < 3600 then
        return string.format('%d min. temu', math.floor(diff / 60))
    elseif diff < 86400 then
        return string.format('%d godz. temu', math.floor(diff / 3600))
    end
end

ESX.RegisterServerCallback('skam$panel:getData', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.fetchAll('SELECT playTime, points, zoneCount FROM users WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    }, function(userData)
        local playTime, points, zoneCount = 0, 0, 0
        if userData and userData[1] then
            zoneCount = tonumber(userData[1].zoneCount) or 0
            playTime = tonumber(userData[1].playTime) or 0
            points = tonumber(userData[1].points) or 0
        end

        MySQL.Async.fetchScalar('SELECT 1 + COUNT(*) FROM users WHERE points > @points', {
            ['@points'] = points
        }, function(pos)
            local rankingPosition = tonumber(pos) or 0

            local kd, kills, deaths = exports['skam-ui']:getStats(source)
            local playerData = {
                name = GetPlayerName(source) or 'N/A',
                discordId = exports['skam']:GetPlayerDiscordId(source) or 'N/A',
                avatar = exports['skam']:GetUserDiscordAvatar(source),
                rank = xPlayer.getGroup() or 'N/A',
                organization = xPlayer.getJob().label or 'N/A',
                kills = kills or 0,
                deaths = deaths or 0,
                kd = kd or '0.00',
                rankingPoints = points,
                playTime = formatPlayTime(playTime) or '0d 0h 0m',
                coins = exports['skam-itemshop']:GetPlayerCoins(source) or 0,
                rankingPosition = rankingPosition or 0,
                capturedZones = zoneCount or 0,
                account = xPlayer.getAccount('bank').money or 0,
                cash = xPlayer.getMoney() or 0
            }

            local rawZones = exports['skam']:getZoneStatus()
            local panelStatus = {
                free = 'wolna',
                capturing = 'przejmowana',
                owned = 'przejeta'
            }
            local layerData = {}
            for _, strefa in ipairs(rawZones) do
                local entry = {
                    name = strefa.name,
                    status = panelStatus[strefa.status] or strefa.status
                }
                if strefa.status == 'przejmowana' then
                    entry.owner = strefa.capturing or 'Nieznany'
                elseif strefa.status == 'przejeta' then
                    entry.owner = strefa.owner or 'Nieznany'
                    entry.lastActivity = strefa.capturedAt and timeAgo(strefa.capturedAt) or 'Brak'
                else
                    entry.owner = 'Brak'
                    entry.lastActivity = 'Brak'
                end
                table.insert(layerData, entry)
            end

            getRankingData(function(rankingData)
                cb({ playerData = playerData, rankingData = rankingData, layerData = layerData })
            end)
        end)
    end)
end)

RegisterNetEvent('skam$bank:deposit', function(data)
    local xPlayer = ESX.GetPlayerFromId(source)
    local amount = tonumber(data.amount)
    if not xPlayer or not amount or amount <= 0 then return end

    local gotCash = xPlayer.getMoney()
    if gotCash >= amount then
        xPlayer.removeMoney(amount)
        xPlayer.addAccountMoney('bank', amount)
        TriggerClientEvent('skam:showNotification', xPlayer.source, {
            title = 'Panel Gracza',
            description = string.format('Wpłacono %s$ do banku!', amount),
            variant = 'bank'
        })
    else
        xPlayer.showNotification('Nie masz tyle gotówki przy sobie!', 'error')
    end
end)

RegisterNetEvent('skam$bank:withdraw', function(data)
    local xPlayer = ESX.GetPlayerFromId(source)
    local amount = tonumber(data.amount)
    if not xPlayer or not amount or amount <= 0 then return end

    local bankCash = xPlayer.getAccount('bank').money
    if bankCash >= amount then
        xPlayer.removeAccountMoney('bank', amount)
        xPlayer.addMoney(amount)
        TriggerClientEvent('skam:showNotification', xPlayer.source, {
            title = 'Panel Gracza',
            description = string.format('Wypłacono %s$ z banku!', amount),
            variant = 'bank'
        })
    else
        xPlayer.showNotification('Nie masz tyle środków na koncie bankowym!', 'error')
    end
end)

RegisterNetEvent('skam$bank:transfer', function(data)
    local xPlayer = ESX.GetPlayerFromId(source)
    local amount = tonumber(data.amount)
    local target = tonumber(data.target)
    local tPlayer = ESX.GetPlayerFromId(target)
    if not xPlayer or not tPlayer or not amount or amount <= 0 then return end
    if source == target then
        xPlayer.showNotification('Nie masz tyle środków na koncie bankowym!', 'error')
        return
    end

    local bankCash = xPlayer.getAccount('bank').money
    if bankCash >= amount then
        xPlayer.removeAccountMoney('bank', amount)
        tPlayer.addAccountMoney('bank', amount)
        TriggerClientEvent('skam:showNotification', xPlayer.source, {
            title = 'Panel Gracza',
            description = string.format('Przelano %s$ do gracza ID: %s', amount, target),
            variant = 'bank'
        })
        TriggerClientEvent('skam:showNotification', tPlayer.source, {
            title = 'Panel Gracza',
            description = string.format('Otrzymano przelew %s$ od gracza ID: %s!', amount, source),
            variant = 'bank'
        })
    else
        xPlayer.showNotification('Nie masz tyle środków na koncie bankowym!', 'error')
    end
end)