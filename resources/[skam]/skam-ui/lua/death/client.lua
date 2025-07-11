exports('showDeathscreen', function(timer, killerName, deathCause, distance)
    SendNUIMessage({
        type = 'nui:deathscreen:show',
        timer = timer,
        killer = killerName,
        weapon = deathCause,
        distance = distance and string.format('%.1f', distance) or nil,
    })
end)

exports('hideDeathscreen', function()
    SendNUIMessage({ type = 'nui:deathscreen:hide' })
end)