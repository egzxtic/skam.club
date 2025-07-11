RegisterNetEvent('skam$stats:update', function(kd)
    SendNUIMessage({
        type = 'nui:watermark',
        playerid = GetPlayerServerId(PlayerId()),
        kd = kd,
    })
end)