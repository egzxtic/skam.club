local currentMsgIndex = 0
local unsubscribedIds = {}

RegisterNetEvent('skam-announcements:SetPlayerUnsubscribed', function(value)
    local src = tostring(source)
    unsubscribedIds[src] = (value == true and true or nil)
end)

CreateThread(function()
    while true do
        Wait(3*60*1000)
        if not Config['announcements'].Enabled then
            return
        end
        currentMsgIndex = (currentMsgIndex % #Config['announcements'].Messages) + 1
        local message = Config['announcements'].Messages[currentMsgIndex]

        for _, playerId in pairs(GetPlayers()) do
            if not unsubscribedIds[playerId] then
                TriggerClientEvent("skam$chat", tonumber(playerId), {
                    label = 'INFORMACJA',
                    color = "#666666",
                }, {
                    type = "AUTOMATYCZNE OGŁOSZENIE",
                    content = message,
                })
            end
        end
    end
end)

AddEventHandler('playerDropped', function()
    local src = tostring(source)
    unsubscribedIds[src] = nil
end)