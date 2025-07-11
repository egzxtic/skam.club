CreateThread(function()
    local send = false
    Wait(500)
    if not send then
        send = true
        TriggerServerEvent("a_queue:playerSpawned")
    end
end)