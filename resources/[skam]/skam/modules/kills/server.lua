GlobalPoints = {}
-- local lastKill = {}

-- local function lastDead(victimid, killerid)
--     return not lastKill[killerid] or not lastKill[killerid][victimid] or lastKill[killerid][victimid] <= os.time()
-- end

AddEventHandler('esx:playerLoaded', function(source, xPlayer)
    local result = MySQL.single.await('SELECT points, kills, deaths, name FROM users WHERE identifier = ?', {xPlayer.identifier})
    if result then
        GlobalPoints[xPlayer.identifier] = {
            points = tonumber(result.points) or 0,
            kills = tonumber(result.kills) or 0,
            deaths = tonumber(result.deaths) or 0,
            name = result.name or xPlayer.name
        }
    else
        GlobalPoints[xPlayer.identifier] = { points = 0, kills = 0, deaths = 0, name = xPlayer.name }
    end
    xPlayer.set('playerPoints', GlobalPoints[xPlayer.identifier].points)
end)

local deadData = {}
CreateThread(function()
    while true do
        for killerPlayer, cooldownTime in pairs(deadData) do
            if cooldownTime <= os.time() then
                deadData[killerPlayer] = nil
            end
        end
        Wait(500)
    end
end)

RegisterNetEvent('skam$death')
AddEventHandler('skam$death', function(data)
    local victimPlayer = ESX.GetPlayerFromId(data.victimid)
    local killerPlayer = ESX.GetPlayerFromId(data.killerid)

    if not victimPlayer or not killerPlayer then
        --print('Nieprawidłowy gracz zabity lub zabijający')
        return
    end

    if data.victimid and data.killerid then
        deadData[killerPlayer] = os.time() + 30
        exports['skam-ui']:addDeath(victimPlayer.source)
        exports['skam-ui']:addKill(killerPlayer.source)
        return
    end

    if data.victimid and data.killerid then
        local vId, kId = victimPlayer.identifier, killerPlayer.identifier

        GlobalPoints[vId] = GlobalPoints[vId] or {points=0, kills=0, deaths=0, name=data.playername}
        GlobalPoints[kId] = GlobalPoints[kId] or {points=0, kills=0, deaths=0, name=data.killername}

        local victimPoints = GlobalPoints[vId].points
        local killerPoints = GlobalPoints[kId].points
        local victimKills = GlobalPoints[vId].kills
        local killerKills = GlobalPoints[kId].kills
        local victimDeaths = GlobalPoints[vId].deaths
        local killerDeaths = GlobalPoints[kId].deaths

        local baseRanking = 100
        local difference = math.abs(killerPoints - victimPoints)
        local victimNewPoints, killerNewPoints

        if killerPoints > victimPoints then
            victimNewPoints = victimPoints - math.ceil((baseRanking / (difference ^ 0.05)) / 2)
            killerNewPoints = killerPoints + math.ceil((baseRanking / (difference ^ 0.05)))
        elseif killerPoints < victimPoints then
            victimNewPoints = victimPoints - math.ceil((baseRanking * (difference ^ 0.1)) / 2)
            killerNewPoints = killerPoints + math.ceil((baseRanking * (difference ^ 0.1)))
        else
            victimNewPoints = victimPoints - (baseRanking / 2)
            killerNewPoints = killerPoints + baseRanking
        end

        killerNewPoints = ESX.Math.Round(math.max(killerNewPoints, 0))
        victimNewPoints = ESX.Math.Round(math.max(victimNewPoints, 0))

        GlobalPoints[kId].points = killerNewPoints
        GlobalPoints[kId].kills = (killerKills or 0) + 1
        GlobalPoints[vId].points = victimNewPoints
        GlobalPoints[vId].deaths = (victimDeaths or 0) + 1

        killerPlayer.set('playerPoints', killerNewPoints)
        victimPlayer.set('playerPoints', victimNewPoints)

        local rewardMoney = math.random(2500, 3000)
        local victimCoords = GetEntityCoords(GetPlayerPed(data.victimid))
        local killerCoords = GetEntityCoords(GetPlayerPed(data.killerid))
        local distance = math.ceil(#(killerCoords - victimCoords) * 10) / 10 
        local pointsDiff = math.abs(killerNewPoints - killerPoints)

        exports['skam-ui']:addKill(killerPlayer.source)
        exports['skam-ui']:addDeath(victimPlayer.source)

        TriggerClientEvent('skam:showNotification', killerPlayer.source, {
            title = 'ZABITO',
            description = string.format("Zabiłeś: [%s] %s\nZ broni: %s\nZ odległości: %sm\nOtrzymałeś: %s$\nZyskano +%s rankingu", data.victimid, data.playername, data.weaponLabel, distance, rewardMoney, pointsDiff),
            variant = 'kill'
        })
        killerPlayer.addAccountMoney('money', rewardMoney)

        local victimPointsDiff = math.abs(victimPoints - victimNewPoints)
        TriggerClientEvent('skam:showNotification', victimPlayer.source, {
            title = 'Śmierć',
            description = string.format('Zostałeś zabity przez: [%s] %s\nZ broni: %s\nZ odległości: %sm\nUtracono -%s rankingu', data.killerid, data.killername, data.weaponLabel, distance, victimPointsDiff),
            variant = 'kill'
        })

        --lastKill[data.killerid] = lastKill[data.killerid] or {}
        --lastKill[data.killerid][data.victimid] = os.time() + 15 * 60
    end
end)

CreateThread(function()
    while true do
        Wait(5 * 60 * 1000)
        for identifier, data in pairs(GlobalPoints) do
            MySQL.update('UPDATE users SET points = ?, kills = ?, deaths = ? WHERE identifier = ?', {
                data.points, data.kills, data.deaths, identifier
            })
        end
    end
end)

AddEventHandler('esx:playerDropped', function(playerId, reason)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    if xPlayer and GlobalPoints[xPlayer.identifier] then
        local data = GlobalPoints[xPlayer.identifier]
        MySQL.update('UPDATE users SET points = ?, kills = ?, deaths = ? WHERE identifier = ?', {
            data.points, data.kills, data.deaths, xPlayer.identifier
        })
        GlobalPoints[xPlayer.identifier] = nil
        --lastKill[playerId] = nil
    end
end)

ESX.RegisterCommand('ranking', 'user', function(xPlayer, args, showError)
    local targetPlayer
    local targetIdentifier
    if args.playerId then
        targetPlayer = ESX.GetPlayerFromId(args.playerId)
        if not targetPlayer then
            xPlayer.showNotification('Nie znaleziono gracza o podanym ID.', 'error')
            return
        end
        targetIdentifier = targetPlayer.identifier
    else
        targetPlayer = xPlayer
        targetIdentifier = xPlayer.identifier
    end

    local pointsData = GlobalPoints[targetIdentifier]
    local points = pointsData and pointsData.points or nil

    if not points then
        if args.playerId then
            xPlayer.showNotification('Nie znaleziono rankingu dla tego gracza.', 'error')
        else
            xPlayer.showNotification('Nie znaleziono Twojego rankingu.', 'error')
        end
        return
    end

    if args.playerId then
        xPlayer.showNotification(('Ranking gracza [%s] wynosi: %s'):format(args.playerId, points), 'info')
    else
        xPlayer.showNotification(('Twój ranking wynosi: %s'):format(points), 'info')
    end
end, false, {
    help = 'Sprawdź swój ranking lub innego gracza',
    arguments = {
        {name = 'playerId', validate = false, help = 'ID gracza', type = 'player'},
    }
})