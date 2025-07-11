

function OpenVehicleSpawnerMenu(type, station, part, partNum)
	if type == 'helicopter' then
		ESX.TriggerServerCallback('skam:getlicenses', function(cb)
			if cb then
				OpenHeliSpawner(station, part, partNum, cb)
			end
		end)
	elseif type == 'car' then
		OpenVehicleSpawner(station, part, partNum)
	end
end 

function OpenVehicleSpawner(station, part, partNum)
	local mainElements = {}

	for k, v in pairs(Config.VehiclesGroups) do
		table.insert(mainElements, {label = v, value = k, station = station, partNum = partNum})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'pd_vehicle_groups', {
		title    = 'Kategorie pojazdów',
		align    = 'center',
		elements = mainElements
	}, function(data, menu)
		if data.current.value and data.current.station and data.current.partNum then
			ESX.TriggerServerCallback('skam:getlicenses', function(cb)
				if cb then
					OpenVehicleSubGroups(data.current.value, data.current.station, data.current.partNum, cb)
				end
			end)
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenVehicleSubGroups(groupNumber, station, partNum, licenses)
	local elements = {}
	local partTable = Config.PoliceStations[station].Vehicles

	for k, v in pairs(Config.AuthorizedVehicles) do
		for k2, v2 in pairs(v.groups) do
			if groupNumber == v2 then
				if v.license then
					if licenses[v.license] then
						table.insert(elements, {label = v.label, model = v.model, extras = v.extras})
					end
				else
					table.insert(elements, {label = v.label, model = v.model, extras = v.extras})
				end
			end
		end
	end

	if #elements > 0 then
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'pd_vehicles', {
			title    = 'Dostępne pojazdy',
			align    = 'center',
			elements = elements
		}, function(data, menu)
			if ESX.Game.IsSpawnPointClear(partTable[partNum].SpawnPoint, 3.0) then
				ESX.TriggerServerCallback('skam:requestCarSpawn', function(netVehicle)
					if netVehicle then
						local vehicle = NetworkGetEntityFromNetworkId(netVehicle)
						SetVehicleMaxMods(vehicle)
						exports['skam']:giveKeys(vehicle)
					end
				end, data.current.model, partTable[partNum].SpawnPoint, partTable[partNum].Heading)
			end
		end, function(data, menu)
			menu.close()
		end)
	else
		ESX.ShowNotification('Ta kategoria nie posiada pojazdów', 'error')
	end
end

function OpenHeliSpawner(station, part, partNum, licenses)
	local elements = {}
	local partTable = Config.PoliceStations[station].Helicopters

	for k, v in pairs(Config.AuthorizedHelicopters) do
		if v.license and licenses[v.license] then
			table.insert(elements, {label = v.label, model = v.model})
		end
	end

	if #elements > 0 then
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'pd_helicopters', {
			title    = 'Dostępne helikoptery',
			align    = 'center',
			elements = elements
		}, function(data, menu)
			if ESX.Game.IsSpawnPointClear(partTable[partNum].SpawnPoint, 3.0) then
				ESX.TriggerServerCallback('skam:requestCarSpawn', function(netVehicle)
					if netVehicle then
						local vehicle = NetworkGetEntityFromNetworkId(netVehicle)
						exports['skam']:giveKeys(vehicle)
					end
				end, data.current.model, partTable[partNum].SpawnPoint, GetEntityHeading(PlayerPedId()))
			end
		end, function(data, menu)
			menu.close()
		end)
	else
		ESX.ShowNotification('Nie posiadasz dostępu do helikopterów', 'error')
	end
end

function SetVehicleMaxMods(vehicle)
	local props = {
		modEngine       = 3,
		modBrakes       = 2,
		modTransmission = 2,
		modSuspension   = 3,
    	modArmor        = 4,
		modTurbo        = true,
	}

	ESX.Game.SetVehicleProperties(vehicle, props)
end