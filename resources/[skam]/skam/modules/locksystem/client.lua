local Ped = {
	Exists = false,
	Id = nil,
	InVehicle = false,
	VehicleInFront = nil,
}

local Timer = 2000
local lastEngineTimer = 0
local lastLockTimer = 0
local lastGiveKeysTimer = 0

local doors = {
	["seat_dside_f"] = -1,
	["seat_pside_f"] = 0,
	["seat_dside_r"] = 1,
	["seat_pside_r"] = 2
}

CreateThread(function()
	while true do
		Wait(500)
		if not IsPauseMenuActive() then
			Ped.Exists = true
			Ped.Id = PlayerPedId()
			Ped.InVehicle = IsPedInAnyVehicle(Ped.Id, false)
			if not Ped.InVehicle then
				Ped.VehicleInFront = ESX.Game.GetVehicleInDirection()
			else
				Ped.VehicleInFront = nil
			end
		else
			Ped.Exists = false
		end
	end
end)

CreateThread(function()
	while true do
		Wait(0)
		if Ped.VehicleInFront then
			if IsControlJustPressed(0, 47) then
				local doorDistances = {}
				for bone, seat in pairs(doors) do
					local doorBone = GetEntityBoneIndexByName(Ped.VehicleInFront, bone)
					if doorBone ~= -1 then
						local coords = GetEntityCoords(Ped.Id, true)
						local doorCoords = GetWorldPositionOfEntityBone(Ped.VehicleInFront, doorBone)
						table.insert(doorDistances, {seat = seat, distance = #(coords - doorCoords)})
					end
				end

				local seat, distance
				if #doorDistances > 0 then
					seat = doorDistances[1].seat
					distance = doorDistances[1].distance

					table.remove(doorDistances, 1)
					for _, data in ipairs(doorDistances) do
						if data.distance < distance then
							seat, distance = data.seat, data.distance
						end
					end
				end

				if seat then
					TaskEnterVehicle(Ped.Id, Ped.VehicleInFront, -1, seat, 1.0, 1, 0)
				end
			end
		else
			Wait(500)
		end
	end
end)

CreateThread(function()
	while true do
		Wait(0)
		if Ped.Exists and Ped.InVehicle then
			if IsControlPressed(2, 75) then
				local vehicle = GetVehiclePedIsIn(Ped.Id, false)
				if vehicle and DoesEntityExist(vehicle) then
					local engine = GetIsVehicleEngineRunning(vehicle)
					repeat
						Wait(0)
						if engine then
							SetVehicleEngineOn(vehicle, true, true, true)
						end
					until not IsPedInAnyVehicle(Ped.Id, false)
				end
			end
		else
			Wait(500)
		end
	end
end)

function carKeys(playerPed)

    if GetGameTimer() < lastLockTimer then
		return
	end

    local vehicle = nil
    
    if Ped.InVehicle then
		vehicle = GetVehiclePedIsIn(playerPed, false)
		if vehicle and (vehicle == 0 or GetPedInVehicleSeat(vehicle, -1) ~= playerPed) then
			vehicle = nil
		end
	else
		vehicle = ESX.Game.GetVehicleInDirection()
	end

    if vehicle and DoesEntityExist(vehicle) then
        lastLockTimer = GetGameTimer() + Timer
        local plate = GetVehicleNumberPlateText(vehicle):gsub("%s$", "")
        ESX.TriggerServerCallback('skam$locksystem:checkKeys', function(hasKey, canSearch)
            if hasKey then
                lockCar(playerPed, plate, vehicle)
            elseif canSearch then
                if Ped.InVehicle then
                    local chance = math.random(100)
                    if chance <= 70 then
                        TriggerServerEvent('skam$locksystem:addCarKeys', plate)
                        ESX.ShowNotification('Znaleziono klucze do tego pojazdu', 'info')
                    else
                        TriggerServerEvent('skam$locksystem:blockCarSearch', plate)
                        ESX.ShowNotification('Nie znaleziono kluczy do tego pojazdu', 'info')
                    end
                end
            end
        end, plate)
    else
        longRangeKeys(playerPed)
    end
end

function longRangeKeys(playerPed)
    ESX.TriggerServerCallback('skam$locksystem:getAllKeys', function(carKeysTable)
		if carKeysTable then
			local elements = {}

			local pedCoords = GetEntityCoords(playerPed)
			local closestVehicles = ESX.Game.GetVehiclesInArea(pedCoords, 40.0)

			for k, v in pairs(carKeysTable) do
				for k2, vehicle in pairs(closestVehicles) do
					local plate = string.lower(GetVehicleNumberPlateText(vehicle):gsub("%s$", ""))
					if v.plate == plate then
						table.insert(elements, {label = string.upper(v.plate), value = v.plate, vehicle = vehicle})
					end
				end
			end

			if #elements >= 1 then
				ESX.UI.Menu.CloseAll()
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'locksystem_keys', {
					title    = 'Twoje kluczyki',
					align    = 'center',
					elements = elements
				}, function(data, menu)
					local options = {
						{label = 'Zamknij/otwórz pojazd', value = 'closeCar'},
						{label = 'Wyrzuć kluczyki', value = 'dropKeys'},
						{label = 'Daj kluczyki', value = 'giveKeys'},
					}
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'locksystem_options', {
						title    = 'Opcje',
						align    = 'center',
						elements = options
					}, function(data2, menu2)
						if data2.current.value == 'closeCar' then
							if GetGameTimer() > lastLockTimer then
								lastLockTimer = GetGameTimer() + Timer

								if data.current.vehicle and DoesEntityExist(data.current.vehicle) then
									lockCar(playerPed, data.current.label, data.current.vehicle)
								end
							end
						elseif data2.current.value == 'dropKeys' then
							menu.close()
							menu2.close()
							TriggerServerEvent('skam$locksystem:removeCarKeys', data.current.value)
							ESX.ShowNotification('Wyrzucono kluczyki ('..data.current.label..')', 'info')
						elseif data2.current.value == 'giveKeys' then
							menu.close()
							menu2.close()
							giveTempKeys(Ped.Id, data.current.value)
						end
					end, function(data2, menu2)
						menu2.close()
					end)
				end, function(data, menu)
					menu.close()
				end)
			else
				ESX.ShowNotification('Nie znaleziono twoich pojazdów w okolicy (40 metrów)', 'error')
			end
		end
    end)
end

function lockCar(playerPed, plate, vehicle)
    NetworkRequestControlOfEntity(vehicle)
    local lockStatus = GetVehicleDoorLockStatus(vehicle)
    if lockStatus < 2 then
        SetVehicleDoorsLocked(vehicle, 2)
        SetVehicleDoorsShut(vehicle, false)
        SetVehicleAlarm(vehicle, true)
		TriggerEvent('skam:showNotification', {
			type = 'info',
			title = 'System kluczyków',
			text = 'Pojazd zamknięty - '..plate
		})
    elseif lockStatus > 1 then
        SetVehicleDoorsLocked(vehicle, 1)
        SetVehicleAlarm(vehicle, false)
		TriggerEvent('skam:showNotification', {
			type = 'info',
			title = 'System kluczyków',
			text = 'Pojazd otwarty - '..plate
		})
    end
	TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 20.0, 'lock', 0.3)
	ESX.Streaming.RequestAnimDict('gestures@m@standing@casual', function()
		TaskPlayAnim(PlayerPedId(), 'gestures@m@standing@casual', 'gesture_you_soft', 8.0, -8.0, -1, 48, 1, false, false, false)
		RemoveAnimDict('gestures@m@standing@casual')
	end)
    if not Ped.InVehicle then
        SetVehicleInteriorlight(vehicle, false)

        SetVehicleLights(vehicle, 2)
        SetVehicleBrakeLights(vehicle, true)
        Wait(200)

        SetVehicleLights(vehicle, 0)
        SetVehicleBrakeLights(vehicle, false)
        Wait(200)
        
        SetVehicleLights(vehicle, 2)
        SetVehicleBrakeLights(vehicle, true)
        Wait(200)

        SetVehicleLights(vehicle, 0)
        SetVehicleBrakeLights(vehicle, false)
    end
end

function EngineToggle(playerPed)
	if GetGameTimer() < lastEngineTimer then
		return
	end

	local vehicle = GetVehiclePedIsIn(playerPed, false)
	if vehicle and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, -1) == playerPed then
		lastEngineTimer = GetGameTimer() + Timer
		local plate = GetVehicleNumberPlateText(vehicle):gsub("%s$", "")
		local status = IsVehicleEngineOn(vehicle)
		
		if not status then
			ESX.TriggerServerCallback('skam$locksystem:checkKeys', function(hasKey, canSearch)
				if hasKey then
					SetVehicleEngineOn(vehicle, true, false, true)
					TriggerEvent('skam:showNotification', {
						type = 'info',
						title = 'System kluczyków',
						text = 'Silnik włączony - '..plate
					})
				else
					SetVehicleNeedsToBeHotwired(vehicle, true)
				end
			end, plate)
		else
			SetVehicleEngineOn(vehicle, false, false, true)
			TriggerEvent('skam:showNotification', {
				type = 'info',
				title = 'System kluczyków',
				text = 'Silnik wyłączony - '..plate
			})
		end
	end
end

function giveKeys(vehicle)
	if vehicle and DoesEntityExist(vehicle) then
		local plate = GetVehicleNumberPlateText(vehicle):gsub("%s$", "")
		TriggerServerEvent("skam$locksystem:addCarKeys", plate)
		TriggerEvent('skam:showNotification', {
			type = 'info',
			title = 'System kluczyków',
			text = 'Otrzymano kluczyki do pojazdu - '..plate
		})
	end
end

exports('giveKeys', giveKeys)

function giveTempKeys(playerPed, plate)
	local playersInArea = ESX.Game.GetPlayersInArea(GetEntityCoords(playerPed, true), 5.0)
	if #playersInArea >= 1 then
		local elements = {}
		for _, player in ipairs(playersInArea) do
			if player ~= PlayerId() then
				local sid = GetPlayerServerId(player)

				table.insert(elements, {label = sid, value = sid})
			end
		end
		ESX.UI.Menu.Open("default", GetCurrentResourceName(), "locksystem_givekeys",
		{
			title = "Wybierz obywatela",
			align = "center",
			elements = elements
		},
		function(data, menu)
			menu.close()

			if GetGameTimer() < lastGiveKeysTimer then
				ESX.ShowNotification('Odczekaj chwilę przed ponownym użyciem tej akcji', 'error')
				return
			end

			lastGiveKeysTimer = GetGameTimer() + 10000

			TriggerServerEvent('skam$locksystem:addCarKeys', plate, data.current.value)
		end, function(data, menu)
			menu.close()
		end)
	else
		ESX.ShowNotification('Brak graczy w pobliżu', 'error')
	end
end

RegisterCommand('keys', function(source, args, raw)
    carKeys(Ped.Id)
end, false)

RegisterCommand('engine', function(source, args, raw)
    EngineToggle(Ped.Id)
end, false)

RegisterKeyMapping('keys', 'Kluczyki', 'keyboard', 'U')
RegisterKeyMapping('engine', 'Silnik', 'keyboard', 'K')