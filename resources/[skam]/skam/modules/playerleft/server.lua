AddEventHandler('esx:playerDropped', function(playerId, reason)
    local xPlayer = ESX.GetPlayerFromId(playerId)

    if xPlayer then
        TriggerClientEvent('skam:playerLeft', -1, {
            source = xPlayer.source,
            name = xPlayer.getName(),
            coords = GetEntityCoords(GetPlayerPed(xPlayer.source)),
            date = os.date("%Y/%m/%d %H:%M"),
            reason = reason
        })
    end
end)