local cooldownTime <const> = 200
local tickRate <const> = 500

local visible = false
local isInGreenZone = false
local lastTabPress = 0

local checkZone = function()
    return exports['skam']:inGreenzone()
end

local function toggleTab()
    if inZone then
        local now = GetGameTimer()
        if now - lastTabPress >= cooldownTime then
            visible = not visible
            lastTabPress = now

            SendNUIMessage({
                type = 'showTab',
                show = visible,
                inGreenZone = inZone
            })
        end
    end
end

CreateThread(function()
    while true do
        local prevZone = inZone
        inZone = checkZone()

        SendNUIMessage({
            type = 'showTabOpen',
            inGreenZone = inZone
        })

        if prevZone and not inZone and visible then
            visible = false
            SendNUIMessage({
                type = 'showTab',
                show = false
            })
        end
        Wait(tickRate)
    end
end)

RegisterNUICallback('tabPressed', function(data, cb)
    toggleTab()
    cb('ok')
end)

RegisterCommand('toggleTab', function()
    toggleTab()
end, false)

RegisterKeyMapping('toggleTab', 'Sugestie (TAB)', 'keyboard', 'TAB')