local playerCooldowns = {}

ESX.RegisterUsableItem('ability-amulet', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local currentTime = os.time()   
    local lastUsed = playerCooldowns[source] or 0
    local cooldownTime = 10 * 60

    if (currentTime - lastUsed) >= cooldownTime then
        playerCooldowns[source] = currentTime
        TriggerClientEvent('skam:amulet', source)
    else
        local remaining = cooldownTime - (currentTime - lastUsed)
        xPlayer.showNotification(('Musisz poczekać jeszcze %d sekund przed ponownym użyciem amuletu.'):format(remaining))
    end
end)