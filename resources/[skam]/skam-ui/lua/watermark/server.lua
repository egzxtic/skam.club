local playerStats = {}

AddEventHandler('esx:playerLoaded', function(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    if not xPlayer then return end
    MySQL.Async.fetchAll('SELECT kills, deaths FROM users WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    }, function(result)
        local kills, deaths = 0, 0
        if result and result[1] then
            kills = tonumber(result[1].kills) or 0
            deaths = tonumber(result[1].deaths) or 0
        end
        playerStats[playerId] = { kills = kills, deaths = deaths }
    end)
end)

AddEventHandler('esx:playerDropped', function(playerId)
    local stats = playerStats[playerId]
    if stats then
        local xPlayer = ESX.GetPlayerFromId(playerId)
        if xPlayer then
            MySQL.Async.execute('UPDATE users SET kills = @kills, deaths = @deaths WHERE identifier = @identifier', {
                ['@kills'] = stats.kills,
                ['@deaths'] = stats.deaths,
                ['@identifier'] = xPlayer.identifier
            })
        end
    end
    playerStats[playerId] = nil
end)

ESX.RegisterCommand('kd', 'user', function(xPlayer, args, showError)
    if not xPlayer then return end
    local targetId = tonumber(args[1]) or xPlayer.source
    local stats = playerStats[targetId] or { kd = 0.0, kills = 0, deaths = 0 }
    if not stats then
        xPlayer.showNotification('Gracz nie istnieje lub nie jest online.')
        return
    end
    stats.kd = stats.deaths > 0 and (stats.kills / stats.deaths) or stats.kills
    xPlayer.showNotification(('KD: %.2f\nZabójstwa: %s\nŚmierci: %s'):format(stats.kd, stats.kills, stats.deaths))
end, true)

CreateThread(function()
    while true do
        Wait(60*1000)
        for playerId, stats in pairs(playerStats) do
            local kd = stats.deaths > 0 and (stats.kills / stats.deaths) or stats.kills
            TriggerClientEvent('skam$stats:update', tonumber(playerId), ('%.2f'):format(kd))
        end
    end
end)

exports('getStats', function(playerId)
    local stats = playerStats[playerId] or { kd = 0.0, kills = 0, deaths = 0 }
    stats.kd = stats.deaths > 0 and (stats.kills / stats.deaths) or stats.kills
    return ('%.2f'):format(stats.kd), stats.kills, stats.deaths
end)

exports('addKill', function(playerId)
    local stats = playerStats[playerId] or { kills = 0, deaths = 0 }
    stats.kills = stats.kills + 1
    playerStats[playerId] = stats
end)

exports('addDeath', function(playerId)
    local stats = playerStats[playerId] or { kills = 0, deaths = 0 }
    stats.deaths = stats.deaths + 1
    playerStats[playerId] = stats
end)