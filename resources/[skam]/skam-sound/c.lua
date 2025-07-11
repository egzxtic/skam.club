RegisterNetEvent('skam$sound:client:play')
AddEventHandler('skam$sound:client:play', function(soundFile, soundVolume)
    SendNUIMessage({
        transactionType = 'playSound',
        transactionFile  = soundFile,
        transactionVolume = soundVolume
    })
end)

RegisterNetEvent('skam$sound:client:playdist')
AddEventHandler('skam$sound:client:playdist', function(otherPlayerCoords, maxDistance, soundFile, soundVolume)
    local myCoords = GetEntityCoords(PlayerPedId())
    if #(myCoords - otherPlayerCoords) < maxDistance then
        SendNUIMessage({
            transactionType = 'playSound',
            transactionFile  = soundFile,
            transactionVolume = soundVolume
        })
    end
end)