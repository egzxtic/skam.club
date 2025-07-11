local kolejka = {}
local activeDuels = {}
local lastBucket = 1000

Locations = {
    ['Rury'] = {
        vector4(2483.7212, 1533.5035, 33.9439, 94.8406),
        vector4(2419.0771, 1535.2861, 33.9942, 266.3807)
    },
    ['Szopa'] = {
        vector4(1551.9854, 2193.9490, 77.9731, 180.0976),
        vector4(1552.2271, 2152.1086, 77.9916, 358.9707)
    },
    ['Rampy'] = {
        vector4(-262.9098, -1556.7623, 30.9489, 168.0365),
        vector4(-268.9475, -1586.0828, 30.9493, 348.3157)
    },
    ['Domki'] = {
        vector4(249.6030, 3092.6907, 41.6532, 6.0100),
        vector4(253.1388, 3185.8748, 41.8008, 182.7244)
    },
    ['La Fuenta'] = {
        vector4(1434.8208, 1154.1841, 114.1708-.9, 266.6116),
        vector4(1475.1462, 1154.2867, 114.2992-.9, 85.4899)
    },
    ['Mini Losty'] = {
        vector4(2329.5444, 2558.6035, 45.6894, 349.1674),
        vector4(2331.0789, 2599.3416, 45.6676, 181.8025)
    },
    ['Kościół'] = {
        vector4(-304.4837, 2828.6611, 57.6459, 149.9363),
        vector4(-330.0071, 2790.3962, 58.2699, 320.4191)
    },
}

RegisterServerEvent('skam-duel:join')
AddEventHandler('skam-duel:join', function()
    local _source = source
    
    for i, player in ipairs(kolejka) do
        if player == _source then
            TriggerClientEvent('skam:showNotification', _source, {
                title = 'Teparki',
                description = 'Już jesteś w kolejce.',
            })
            return
        end
    end
    
    if activeDuels[_source] then
        TriggerClientEvent('skam:showNotification', _source, {
            title = 'Teparki',
            description = 'Już jesteś w pojedynku.',
        })
        return
    end
    
    table.insert(kolejka, _source)
    TriggerClientEvent('skam:showNotification', _source, {
        title = 'Teparki',
        description = 'Czekasz na przeciwnika... Pozycja w kolejce: ' .. #kolejka,
    })

    if #kolejka >= 2 then
        local player1 = table.remove(kolejka, 1)
        local player2 = table.remove(kolejka, 1)
        StartDuel(player1, player2)
        
        for i, player in ipairs(kolejka) do
            TriggerClientEvent('skam:showNotification', player, {
                title = 'Teparki',
                description = 'Pozycja w kolejce: ' .. i,
            })
        end
    end
end)

RegisterServerEvent('skam-duel:quit')
AddEventHandler('skam-duel:quit', function()
    local _source = source
    RemoveFromQueue(_source)
end)

function RemoveFromQueue(playerId)
    for i, player in ipairs(kolejka) do
        if player == playerId then
            table.remove(kolejka, i)
            TriggerClientEvent('skam:showNotification', player, {
                title = 'Teparki',
                description = 'Opuszczono kolejkę.',
            })
            
            for j, remainingPlayer in ipairs(kolejka) do
                TriggerClientEvent('skam:showNotification', remainingPlayer, {
                    title = 'Teparki',
                    description = 'Pozycja w kolejce: ' .. j,
                })
            end
            return true
        end
    end
    return false
end

AddEventHandler('playerDropped', function()
    local _source = source
    
    RemoveFromQueue(_source)
    
    if activeDuels[_source] then
        local opponent = activeDuels[_source].opponent
        local bucket = activeDuels[_source].bucket
        
        activeDuels[_source] = nil
        if opponent and activeDuels[opponent] then
            activeDuels[opponent] = nil
        end
        
        if opponent then
            TriggerClientEvent('skam-duel:playerLeft', opponent)
            
            local startCoords = vector3(1008.9351, -2531.2434, 28.3020)
            TriggerClientEvent('skam-duel:teleportPlayer', opponent, startCoords)
            Wait(500)
            TriggerClientEvent('skam$death:revive', opponent)
            
            SetRoutingBucketSafe(opponent, 0)
        end
    end
end)


function SetRoutingBucketSafe(playerId, bucketId)
    local success = SetPlayerRoutingBucket(playerId, bucketId)
    if not success then
        Citizen.SetTimeout(100, function()
            SetPlayerRoutingBucket(playerId, bucketId)
        end)
    end
    return success
end

function StartDuel(player1, player2)
    if not DoesPlayerExist(player1) or not DoesPlayerExist(player2) then
        if DoesPlayerExist(player1) then
            table.insert(kolejka, 1, player1)
            TriggerClientEvent('skam:showNotification', player1, {
                title = 'Teparki',
                description = 'Przeciwnik się rozłączył. Wracasz do kolejki.',
            })
        elseif DoesPlayerExist(player2) then
            table.insert(kolejka, 1, player2)
            TriggerClientEvent('skam:showNotification', player2, {
                title = 'Teparki',
                description = 'Przeciwnik się rozłączył. Wracasz do kolejki.',
            })
        end
        return
    end

    local locationKeys = {}
    for k in pairs(Locations) do
        table.insert(locationKeys, k)
    end
    local randomLocation = locationKeys[math.random(1, #locationKeys)]
    local coords = Locations[randomLocation]

    lastBucket = lastBucket + 1
    local bucket = lastBucket
    
    local bucket1Success = SetRoutingBucketSafe(player1, bucket)
    local bucket2Success = SetRoutingBucketSafe(player2, bucket)
    
    activeDuels[player1] = {opponent = player2, bucket = bucket}
    activeDuels[player2] = {opponent = player1, bucket = bucket}

    TriggerClientEvent('skam:showNotification', player1, {
        title = 'Teparki',
        description = 'Pojedynek w lokacji: ' .. randomLocation,
    })
    TriggerClientEvent('skam:showNotification', player2, {
        title = 'Teparki',
        description = 'Pojedynek w lokacji: ' .. randomLocation,
    })

    TriggerClientEvent('skam-duel:start', player1, coords[1], player2)
    TriggerClientEvent('skam-duel:start', player2, coords[2], player1)
    
    Citizen.SetTimeout(1000, function()
        TriggerClientEvent('skam-duel:startCountdown', player1, player2)
        TriggerClientEvent('skam-duel:startCountdown', player2, player1)
    end)
end

function DoesPlayerExist(playerId)
    if playerId and GetPlayerPing(playerId) > 0 then
        return true
    end
    return false
end

RegisterServerEvent('skam-duel:win')
AddEventHandler('skam-duel:win', function(winner, loser)
    if not activeDuels[winner] or activeDuels[winner].opponent ~= loser then
        return
    end
    
    activeDuels[winner] = nil
    activeDuels[loser] = nil
    
    TriggerClientEvent('skam-duel:showDuelResult', winner, true)
    TriggerClientEvent('skam-duel:showDuelResult', loser, false)

    TriggerClientEvent('skam$death:revive', winner)
    TriggerClientEvent('skam$death:revive', loser)

    Citizen.SetTimeout(2000, function()
        local startCoords = vector3(1008.9351, -2531.2434, 28.3020)
        TriggerClientEvent('skam-duel:teleportPlayer', winner, startCoords)
        TriggerClientEvent('skam-duel:teleportPlayer', loser, startCoords)

        SetRoutingBucketSafe(winner, 0)
        SetRoutingBucketSafe(loser, 0)
    end)
end)

RegisterServerEvent('skam-duel:playerLeftDuel')
AddEventHandler('skam-duel:playerLeftDuel', function(enemyPlayer)
    local _source = source
    
    if not activeDuels[_source] or activeDuels[_source].opponent ~= enemyPlayer then
        return
    end
    
    local winner = enemyPlayer
    local loser = _source
    
    activeDuels[_source] = nil
    activeDuels[enemyPlayer] = nil

    TriggerClientEvent('skam-duel:showDuelResult', winner, true)
    TriggerClientEvent('skam-duel:showDuelResult', loser, false)

    TriggerClientEvent('skam$death:revive', winner)
    TriggerClientEvent('skam$death:revive', loser)

    Citizen.SetTimeout(2000, function() 
        local startCoords = vector3(1008.9351, -2531.2434, 28.3020)
        TriggerClientEvent('skam-duel:teleportPlayer', winner, startCoords)
        TriggerClientEvent('skam-duel:teleportPlayer', loser, startCoords)

        SetRoutingBucketSafe(winner, 0)
        SetRoutingBucketSafe(loser, 0)
    end)
end)

RegisterServerEvent('skam-duel:teleportVerify')
AddEventHandler('skam-duel:teleportVerify', function(success)
    local _source = source
    if not success and activeDuels[_source] then
        local opponent = activeDuels[_source].opponent
        
        TriggerClientEvent('skam:showNotification', _source, {
            title = 'Teparki',
            description = 'Pojedynek przerwany z powodu problemów z teleportacją.',
        })
        TriggerClientEvent('skam:showNotification', opponent, {
            title = 'Teparki',
            description = 'Pojedynek przerwany z powodu problemów z teleportacją.',
        })

        activeDuels[_source] = nil
        activeDuels[opponent] = nil
        
        local startCoords = vector3(1008.9351, -2531.2434, 28.3020)
        TriggerClientEvent('skam-duel:teleportPlayer', _source, startCoords)
        TriggerClientEvent('skam-duel:teleportPlayer', opponent, startCoords)
        TriggerClientEvent('skam$death:revive', _source)
        TriggerClientEvent('skam$death:revive', opponent)
        
        SetRoutingBucketSafe(_source, 0)
        SetRoutingBucketSafe(opponent, 0)
    end
end)