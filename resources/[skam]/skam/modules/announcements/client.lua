RegisterCommand('ogloszenia', function(src, args, raw)
    local disabled = GetResourceKvpString('skam-aa:toggled') == 'true'
    disabled = not disabled

    ESX.ShowNotification(disabled and 'Wyłączono automatyczne ogłoszenia' or 'Włączono automatyczne ogłoszenia', 'info')

    SetResourceKvp('skam-aa:toggled', tostring(disabled))
    TriggerServerEvent('skam-announcements:SetPlayerUnsubscribed', disabled)
end)

CreateThread(function()
    TriggerServerEvent('skam-announcements:SetPlayerUnsubscribed', GetResourceKvpString('skam-aa:toggled') == 'true')
    TriggerEvent('chat:addSuggestion', 'ogloszenia', 'Włącz/Wyłącz automatyczne ogłoszenia na czacie')
end)