local CurrentCallback = nil

function StartGame(difficulty, cb)
    CurrentCallback = cb
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = 'openGame',
        game = 'easy',
        difficulty = difficulty
    })
end

RegisterNUICallback('endGame', function(data, cb)
    if CurrentCallback then
        CurrentCallback(data.result)
        CurrentCallback = nil
    end
    SetNuiFocus(false, false)
    cb('ok')
end)

exports('StartGame', StartGame)

AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() then
        SetNuiFocus(false, false)
        CurrentCallback = nil
    end
end)