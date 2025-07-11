local playersLeft = {}

CreateThread(function()
    while true do
        local sleep = true

        for k, v in pairs(playersLeft) do
            if #(GetEntityCoords(PlayerPedId()) - v.coords) < 15.0 then
                sleep = false
                ESX.Game.Utils.DrawText3D(v.coords, '~w~ID: ~m~'..k..' ('..v.name..')\n~w~Opuścił/a serwer: ~m~'..v.date..'\n~w~Powód: ~m~'..(v.reason or 'Brak powodu'), 1.1, 4)
            end
        end

        if sleep then
            Wait(1000)
        else
            Wait(0)
        end
    end
end)

RegisterNetEvent('skam:playerLeft')
AddEventHandler('skam:playerLeft', function(data)
    playersLeft[data.source] = data
    SetTimeout(120000, function()
        playersLeft[data.source] = nil
    end)
end)
