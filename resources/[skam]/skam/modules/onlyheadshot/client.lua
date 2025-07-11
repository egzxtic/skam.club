local OnlyHead = {
	{
		zone = vec3(1542.3049, 2202.2253, 78.5763),
		size = 100,
	}
}

local currentInZone = false 

Citizen.CreateThread(function()
    local sleep = 0
    while true do
        Citizen.Wait(sleep)

        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local isInAnyZone = false

        for _, v in ipairs(OnlyHead) do
            if #(playerCoords - v.zone) <= v.size then
                if not currentInZone then
                    ESX.ShowNotification('Wkroczyłeś/aś do strefy Only Headshot!')
                    currentInZone = true
                end
                isInAnyZone = true
                break
            end
        end

        if currentInZone and not isInAnyZone then
            ESX.ShowNotification('Opuszczasz strefę Only Headshot!')
            currentInZone = false
        end

        sleep = currentInZone and 1000 or 2000
    end
end)

AddEventHandler("gameEventTriggered", function(eventName, eventData)
    if eventName == "CEventNetworkEntityDamage" then
        local victim = eventData[1]
        local attacker = eventData[2]

        for k,v in ipairs(OnlyHead) do
            if IsEntityAPed(victim) and IsPedAPlayer(victim) and (#(GetEntityCoords(PlayerPedId()) - v.zone) <= v.size) then
                local isHeadshot = GetPedLastDamageBone(victim) == 310

                if not isHeadshot then
                    SetEntityHealth(PlayerPedId(), 200)
                    CancelEvent()
                end
            end
        end
    end
end)