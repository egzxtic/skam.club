local function showNotification(data)
    -- print(json.encode(data))

    if type(data) ~= "table" or not data.description then
        local dataStr = (type(data) == "table") and json.encode(data) or tostring(data)
        print('Błąd (showNotification): Nieprawidłowe dane wejściowe: ' .. dataStr)
        return
    end

    local title = (data.title and #data.title > 0) and data.title or "Powiadomienie"
    local description = type(data.description) == "table" and table.concat(data.description, "\n") or data.description
    local variant = (type(data.variant) == "string" and #data.variant > 0) and data.variant or "info"

    SendNUIMessage({
        type = 'notify',
        title = title,
        description = description,
        variant = variant,
    })

    -- if data.sound ~= false then
    --     if variant == 'error' then
    --         PlaySoundFrontend(-1, 'Bomb_Disarmed', 'GTAO_Speed_Convoy_Soundset', 1)
    --     else
    --         PlaySoundFrontend(-1, 'Menu_Accept', 'Phone_SoundSet_Default', 1)
    --     end
    -- end
end

RegisterNetEvent('skam:showNotification')
AddEventHandler('skam:showNotification', function(data)
    showNotification(data)
end)

RegisterNetEvent('skam:txNotify')
AddEventHandler('skam:txNotify', function(message)
    SendNUIMessage({
        type = 'restart',
        message = message
    })
end)

exports('showNotification', showNotification)