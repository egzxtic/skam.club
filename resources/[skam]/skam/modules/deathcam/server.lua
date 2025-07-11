local lastRevive = {}
local cooldown = {
    revive = 10,
}

ESX.RegisterCommand('revive', 'revivator', function(xPlayer, args, showError)
    local src = xPlayer.source
    local group = xPlayer.getGroup()

    if group ~= 'owner' then
        if lastRevive[src] and os.time() - lastRevive[src] < cooldown.revive then
            xPlayer.showNotification('Musisz poczekać jeszcze ' .. (cooldown.revive - (os.time() - lastRevive[src])) .. ' sekund przed ponownym użyciem /revive!')
            return
        end
        lastRevive[src] = os.time()
    end

    if args.playerId then
        args.playerId.triggerEvent('skam$death:revive')
        xPlayer.showNotification('Ożywiłeś gracza o ID: ' .. args.playerId.source)
    else
        xPlayer.triggerEvent('skam$death:revive')
        xPlayer.showNotification('Ożywiłeś się!')
    end
end, true, { help = 'Ożyw siebie lub innego gracza', validate = false, arguments = {
        {name = 'playerId', validate = false, help = 'Gracz (ID)', type = 'player'}
    }
})

local lastReviveDist = {}

ESX.RegisterCommand('revivedist', 'support', function(xPlayer, args, showError)
    local maxDist = 500

    if group ~= 'owner' then
        if lastReviveDist[src] and os.time() - lastReviveDist[src] < cooldown.revive then
            xPlayer.showNotification('Musisz poczekać jeszcze ' .. (cooldown.revive - (os.time() - lastReviveDist[src])) .. ' sekund przed ponownym użyciem /revivedist!')
            return
        end
        lastReviveDist[src] = os.time()
    end
    
    if args.distance then
        if args.distance <= maxDist then
            local adminCoords = GetEntityCoords(GetPlayerPed(xPlayer.source))
            for k, v in pairs(GetPlayers()) do
                local playerCoords = GetEntityCoords(GetPlayerPed(v))
                local distance = #(adminCoords - playerCoords)
                if distance < args.distance then
                    TriggerClientEvent('skam$death:revive', v)
                end
            end

			--exports['bojowka']:SendLog(xPlayer.source, string.format('Użyto komendy /revivedist %s', args.distance), 'revive')
        else
			xPlayer.showNotification('Maksymalna odległość wynosi: '..maxDist, 'error')
        end
	end
end, true, { help = 'Ożyw wszystkich graczy w pobliżu', validate = false, arguments = {
        {name = 'distance', validate = false, help = 'Promień działania w metrach (domyślnie 5)', type = 'number'}
    }
})

ESX.RegisterCommand('heal', 'mod', function(xPlayer, args, showError)
    if args.player then
        args.player.triggerEvent('skam$death:heal')
        xPlayer.showNotification('Uleczyłeś gracza o ID: ' .. args.player.source)
    else
        xPlayer.triggerEvent('skam$death:heal')
        xPlayer.showNotification('Uleczyłeś się!')
    end
end, true, {
    help = 'Ulecz siebie lub innego gracza',
    validate = true,
    arguments = {
        {name = 'player', help = 'Gracz (ID)', type = 'player'}
    }
})

RegisterNetEvent('skam$death')
AddEventHandler('skam$death', function(data)
    if data.killedByPlayer and data.killerid and data.victimCoords then
        TriggerClientEvent('skam$cwel', data.killerid, data.victimCoords)
    end
end)

-- RegisterNetEvent('skam$death')
-- AddEventHandler('skam$death', function(data)
--     print(('NAZWA %s ID %s KILLER %s ID %s WEAPON %s DISTANCE %s BY %s LABEL %s COORDS %s'):format(
--         tostring(data.playername or 'BRAK'),
--         tostring(data.victimid or 'BRAK'),
--         tostring(data.killername or 'BRAK'),
--         tostring(data.killerid or 'BRAK'),
--         tostring(data.killerweapon or 'BRAK'),
--         tostring(data.distance or 'BRAK'),
--         tostring(data.killedByPlayer or 'BRAK'),
--         tostring(data.weaponLabel or 'BRAK'),
--         tostring(data.killerCoords or 'BRAK'),
--         tostring(data.victimCoords or 'BRAK')
--     ))
-- end)