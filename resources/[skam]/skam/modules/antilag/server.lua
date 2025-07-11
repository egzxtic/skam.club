RegisterNetEvent("antilagsystem")
AddEventHandler("antilagsystem", function(vehNet, vehiclePos)
    TriggerClientEvent("antilagsystem", -1, vehNet, vehiclePos)
end)

