local sprawdzamykurwa = false

CreateThread(function()
    while true do
        Citizen.Wait(100)
        local sleep = true
        local wstrefie = false
        for zoneTitle, zoneData in pairs(Config['noloot'].zones) do
            if #(zoneData.center - GetEntityCoords(PlayerPedId())) < zoneData.radius then
                sleep = false
                wstrefie = true
                if not sprawdzamykurwa then
                    Wait(100)
                    sprawdzamykurwa = true
                end
            end
        end
        if not wstrefie and sprawdzamykurwa then
            sprawdzamykurwa = false
        end
        if sleep then
            Wait(200)
        end
    end
end)

exports('canSearch', function()
    return sprawdzamykurwa
end)