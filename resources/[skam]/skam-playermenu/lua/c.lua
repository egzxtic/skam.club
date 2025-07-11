RegisterCommand('panel', function()
    if LocalPlayer.state.dead or IsPauseMenuActive() then
        return
    end
    SetNuiFocus(true, true)
    SendNUIMessage({ type = 'showMenu' })
end, false)
RegisterKeyMapping('panel', 'Otwórz Panel', 'keyboard', 'F4')

RegisterNUICallback('closePanel', function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('GetAllPlayerData', function(data, cb)
    if not LocalPlayer.state.dead then
        ESX.TriggerServerCallback('skam$panel:getData', function(result)
            cb(result)
        end)
    end
end)

RegisterNUICallback('deposit', function(data, cb)
    TriggerServerEvent('skam$bank:deposit', data)
    cb('ok')
end)

RegisterNUICallback('withdraw', function(data, cb)
    TriggerServerEvent('skam$bank:withdraw', data)
    cb('ok')
end)

RegisterNUICallback('transfer', function(data, cb)
    TriggerServerEvent('skam$bank:transfer', data)
    cb('ok')
end)