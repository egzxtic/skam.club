local antilag = false;
local timer = GetGameTimer();

if GetResourceKvpInt("antilag_state") == 1 then
    antilag = true
else
    antilag = false
end

local commands = {
	"als", "antilag", "antilagsystem"
}

for i = 1, #commands do
	RegisterCommand(commands[i], function()
		antilag = not antilag;
		SetResourceKvpInt("antilag_state", antilag and 1 or 0);
		ESX.ShowNotification((antilag and "Włączono" or "Wyłączono").." strzały z wydechu!", (antilag and "on" or "off"));
	end)
end

AntiLagCars = {
    [`lc_bmwf90`] = true,
    [`18huracanperf`] = true,
    [`aq_m3g80`] = true,
    [`m2track`] = true,
}

RegisterCommand("AntiLagUse", function()
	if not antilag then return end
    CreateThread(function()
        while IsControlPressed(1, 21) do
            local playerPed = PlayerPedId()
            if IsPedInAnyVehicle(playerPed) then
                local veh = GetVehiclePedIsIn(playerPed)
                if GetPedInVehicleSeat(veh, -1) == playerPed then
                    local vehicleModel = GetEntityModel(veh)
                    if AntiLagCars[vehicleModel] then
                        local RPM = GetVehicleCurrentRpm(veh)
                        if RPM > 0.75 then
                            local vehiclePos = GetEntityCoords(veh)
                            TriggerServerEvent("antilagsystem", VehToNet(veh), vehiclePos)
                            SetVehicleTurboPressure(veh, 25)
                        end
                    end
                end
            end
            Wait(math.random(50, 350))
        end
    end)
end)

RegisterKeyMapping("AntiLagUse", "Funkcja AntiLag", "keyboard", "LSHIFT")

p_flame_location = {
	"exhaust",
	"exhaust_2",
	"exhaust_3",
	"exhaust_4"	
}
p_flame_particle = "veh_backfire"
p_flame_particle_asset = "core" 
p_flame_size = 2.5

RegisterNetEvent("antilagsystem", function(c_veh, vehiclePos)
	AddExplosion(vehiclePos.x, vehiclePos.y, vehiclePos.z, 61, 0.0, true, true, 0.0, true)
	AddExplosion(vehiclePos.x, vehiclePos.y, vehiclePos.z, 61, 0.0, true, true, 0.0, true)
	for _,bones in pairs(p_flame_location) do
		UseParticleFxAssetNextCall(p_flame_particle_asset)
		createdPart = StartParticleFxLoopedOnEntityBone(p_flame_particle, NetToVeh(c_veh), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, GetEntityBoneIndexByName(NetToVeh(c_veh), bones), p_flame_size, 0.0, 0.0, 0.0)
		StopParticleFxLooped(createdPart, 1)
	end
end)