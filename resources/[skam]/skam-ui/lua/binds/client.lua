local function safeName(name)
    return name:gsub("[^%w_%-]", "")
end

updateBinds = function(binds)
    local data = {}
    for i = 1, 5 do
        if binds[i] then
            data[i] = {
                slot = i,
                image = './items/'..safeName(binds[i].name)..'.png',
            }
        else
            data[i] = { slot = i }
        end
    end

    SendNUIMessage({
        eventName = 'nui:binds:update',
        data = data
    })
end

exports('updateBinds', updateBinds)

CreateThread(function()
    Wait(5000)
    if GetResourceState('es_extended') == 'started' then
        updateBinds(exports['es_extended']:getBinds())
    end
end)

local showBinds = false
SKAM.addKeybind({
    key = 'F1',
    description = 'Ukryj/Pokaż - Bindy',
    onPressed = function()
        showBinds = not showBinds
        SendNUIMessage({ eventName = 'nui:binds:toggle', value = showBinds })
    end
})