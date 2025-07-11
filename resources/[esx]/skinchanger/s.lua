AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
    if xPlayer.getGroup() ~= 'user' then
        xPlayer.triggerEvent('skinchanger:restrictAllow')
    end
end)