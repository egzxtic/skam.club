CreateThread( function()
    local weatherType = "CLEAR"
    SetWeatherTypePersist(weatherType)
    SetWeatherTypeNow(weatherType)
    SetWeatherTypeNowPersist(weatherType)
end)

function OpenTimeMenu()
    local elements = {
        {label = '06:00', value = {6, 0, 0}},
        {label = '12:00', value = {12, 0, 0}},
        {label = '18:00', value = {18, 0, 0}},
        {label = '00:00', value = {0, 0, 0}},
    }

    OpenMenu('Godzina', elements, function(data)
        NetworkOverrideClockTime(data.current.value[1], data.current.value[2], data.current.value[3])
    end)
end

function OpenWeatherMenu()
    local elements = {
        {label = 'Blizzard', value = 'BLIZZARD'},
        {label = 'Clear', value = 'CLEAR'},
        {label = 'Clearing', value = 'CLEARING'},
        {label = 'Clouds', value = 'CLOUDS'},
        {label = 'Extrasunny', value = 'EXTRASUNNY'},
        {label = 'Foggy', value = 'FOGGY'},
        {label = 'Halloween', value = 'HALLOWEEN'},
        {label = 'Neutral', value = 'NEUTRAL'},
        {label = 'Overcast', value = 'OVERCAST'},
        {label = 'Rain', value = 'RAIN'},
        {label = 'Smog', value = 'SMOG'},
        {label = 'Snow', value = 'SNOW'},
        {label = 'Snowlight', value = 'SNOWLIGHT'},
        {label = 'Thunder', value = 'THUNDER'},
        {label = 'XMas', value = 'XMAS'},
    }

    OpenMenu('Pogoda', elements, function(data)
        Citizen.Wait(100)
        SetWeatherTypePersist(data.current.value)
        SetWeatherTypeNow(data.current.value)
        SetWeatherTypeNowPersist(data.current.value)
    end)
end

function OpenMenu(title, elements, action)
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'headbagging', {
        title = title,
        align = 'right',
        elements = elements
    }, action, function(data, menu)
        menu.close()
    end)
end

RegisterCommand('czas', OpenTimeMenu)
RegisterCommand('pogoda', OpenWeatherMenu)