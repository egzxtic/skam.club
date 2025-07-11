SKAM = exports['skam-markers']:getSharedObject()
local CurrentActionData, handcuffTimer, dragStatus, blipsMech, currentTask = {}, {}, {}, {}, {}
-- local Kajdanki = {}
local HasAlreadyEnteredMarker, isDead, isHandcuffed, hasAlreadyJoined, playerInService = false, false, false, false, false
-- local CanSearch = false
local LastStation, LastPart, LastPartNum, LastEntity, CurrentAction, CurrentActionMsg
dragStatus.isDragged, isInShopMenu = false, false

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	ESX.PlayerLoaded = true

	--AddRelationshipGroup('skam_cuffedped')
	--SetRelationshipBetweenGroups(0, `player`, `skam_cuffedped`)
end)

RegisterNetEvent('esx:onPlayerLogout')
AddEventHandler('esx:onPlayerLogout', function()
	ESX.PlayerLoaded = false
	ESX.PlayerData = {}
end)

function OpenCloakroomMenu()
	local elements = {
		{label = 'Prywatne ubrania', value = 'civil_wear'},
		{label = 'Edytuj strój', value = 'edit_wear'},
	}
	if ESX.PlayerData.dualjob.grade == 1 or ESX.PlayerData.dualjob.grade_permissions["edit_clothes"] then
		table.insert(elements, {label = 'Zapisz strój', value = 'save_wear'})
	end
	table.insert(elements, {label = 'Zapisane stroje', value = 'saved_wear'})

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom_menu', {
		title    = 'Przebieralnia',
		align    = 'center',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'civil_wear' then
			exports['skam']:PlayerDressings()
		elseif data.current.value == 'edit_wear' then
			TriggerEvent('esx_skin:openRestrictedMenu', function(data2, menu2)
				menu2.close()
		
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mechanik_skin_confirm', {
					title = 'Potwierdzasz wybór?',
					align = 'center',
					elements = {
						{label = 'Tak', value = 'yes'},
						{label = 'Nie', value = 'no'}
				}}, function(data3, menu3)
					menu3.close()
		
					if data3.current.value == 'yes' then
						TriggerEvent('skinchanger:getSkin', function(skin)
							TriggerServerEvent('esx_skin:save', skin)
						end)
					elseif data3.current.value == 'no' then
						ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
							TriggerEvent('skinchanger:loadSkin', skin)
						end)
					end
				end, function(data3, menu3)
					menu3.close()
				end)
			end, function(data2, menu2)
				menu2.close()
			end, {
				'tshirt_1', 'tshirt_2',
				'torso_1', 'torso_2',
				'decals_1', 'decals_2',
				'arms',
				'pants_1', 'pants_2',
				'shoes_1', 'shoes_2',
				'bags_1', 'bags_2',
				'chain_1', 'chain_2',
				'helmet_1', 'helmet_2',
				'glasses_1', 'glasses_2',
				'mask_1', 'mask_2',
			})
		elseif data.current.value == 'save_wear' then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'save_wear_name', {
				title = 'Nazwa stroju'
			}, function(data2, menu2)
				menu2.close()

				TriggerEvent('skinchanger:getSkin', function(skin)
					TriggerServerEvent('skam-dressings:saveSharedOutfit', data2.value, skin, 'mechanik')
					ESX.ShowNotification('~g~Pomyślnie zapisano ubiór o nazwie: ' .. data2.value, "info")
				end)
			end, function(data2, menu2)
				menu2.close()
			end)
		elseif data.current.value == 'saved_wear' then
			ESX.TriggerServerCallback('skam-dressings:getSharedDressing', function(dressing)
				local clothesElements = {}
				for i=1, #dressing, 1 do
				  table.insert(clothesElements, {label = dressing[i], value = i})
				end
				local secondClothesElements = {}
				if ESX.PlayerData.dualjob.grade == 1 or ESX.PlayerData.dualjob.grade_permissions["edit_clothes"]then
					table.insert(secondClothesElements, {label = 'Ubierz strój', value = 'wear'})
					table.insert(secondClothesElements, {label = 'Usuń strój', value = 'delete_wear'})
				end
				if #clothesElements > 0 then
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'saved_wear_menu', {
					title    = 'Zapisane stroje',
					align    = 'center',
					elements = clothesElements
					}, function(data2, menu2)
						if #secondClothesElements > 0 then
							ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'saved_wear_menu_choose', {
								title    = 'Wybierz opcje',
								align    = 'center',
								elements = secondClothesElements
							}, function(data3, menu3)
								if data3.current.value == 'wear' then
									TriggerEvent('skinchanger:getSkin', function(skin)
										ESX.TriggerServerCallback('skam-dressings:getSharedOutfit', function(clothes)
											TriggerEvent('skinchanger:loadClothes', skin, clothes)
											TriggerEvent('esx_skin:setLastSkin', skin)
											TriggerEvent('skinchanger:getSkin', function(skin)
												TriggerServerEvent('esx_skin:save', skin)
											end)
											ESX.ShowNotification('Pomyślnie zmieniono strój', 'success')
											ClearPedBloodDamage(playerPed)
										end, data2.current.value, 'mechanik')
									end)
								elseif data3.current.value == 'delete_wear' then
									TriggerServerEvent('skam-dressings:removeSharedOutfit', data2.current.value, 'mechanik')
									ESX.ShowNotification('Pomyślnie usunięto strój o nazwie: ' .. data2.current.label, 'success')
									menu3.close()
									menu2.close()
								end
							end, function(data3, menu3)
								menu3.close()
							end)
						else
							TriggerEvent('skinchanger:getSkin', function(skin)
								ESX.TriggerServerCallback('skam-dressings:getSharedOutfit', function(clothes)
									TriggerEvent('skinchanger:loadClothes', skin, clothes)
									TriggerEvent('esx_skin:setLastSkin', skin)
									TriggerEvent('skinchanger:getSkin', function(skin)
										TriggerServerEvent('esx_skin:save', skin)
									end)
									ESX.ShowNotification('Pomyślnie zmieniono strój', 'success')
									ClearPedBloodDamage(playerPed)
								end, data2.current.value, 'mechanik')
							end)
						end
					end, function(data2, menu2)
						menu2.close()
					end)
				else
					ESX.ShowNotification('Brak zapisanych strojów', 'error')
				end
			end, 'mechanik')
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenStashBoard(station)
	local elements = {}

	if ESX.PlayerData.dualjob.grade == 1 or ESX.PlayerData.dualjob.grade_permissions["withdraw_item"] then
		elements[#elements+1] = {label = 'Schowaj przedmiot', value = 'put_stock'}
	else
		elements[#elements+1] = {label = '<span style="color:gray;">Schowaj przedmiot</span>'}
	end

	if ESX.PlayerData.dualjob.grade == 1 or ESX.PlayerData.dualjob.grade_permissions["withdraw_item"] then
		elements[#elements+1] = {label = 'Wyciągnij przedmiot', value = 'get_stock'}
	else
		elements[#elements+1] = {label = '<span style="color:gray;">Wyciągnij przedmiot</span>'}
	end

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open("default", GetCurrentResourceName(), 'LSCStashBoardMenu', {
		title    = 'Schowek LSC',
		align    = 'center',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'put_stock' then
			menu.close()
			ESX.TriggerServerCallback('esx_mechanikjob:getPlayerInventory', function(inventory)
				OpenPutStocksMenu(inventory)
			end)
		elseif data.current.value == 'get_stock' then
			menu.close()
			ESX.TriggerServerCallback('esx_mechanikjob:getStockItems', function(items)
				OpenGetStocksMenu(items)
			end)
		else
			TriggerEvent('skam:showNotification', {
				type = 'error',
				title = 'LSC',
				text = "Nie masz uprawnień, aby tego użyć",
			})
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenPutStocksMenu(inventory)
	local elements = {}

	for i = 1, #inventory do
		local item = inventory[i]

		if item.count > 0 then
			elements[#elements+1] = {
				label = item.label .. ' x' .. item.count,
				type = 'item_standard',
				value = item.name
			}
		end
	end

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open("default", GetCurrentResourceName(), 'LSCPutStocksMenu', {
		title    = "Ekwipunek",
		align    = 'center',
		elements = elements
	}, function(data, menu)
		menu.close()

		ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
			title = "Ilość"
		}, function(data2, menu2)
			if not tonumber(data2.value) then
				TriggerEvent('skam:showNotification', {
					type = 'error',
					title = 'LSC',
					text = "Nieprawidłowa wartość",
				})
			else
				menu2.close()
				ESX.TriggerServerCallback('esx_mechanikjob:putStockItems', function(inventory_)
					OpenPutStocksMenu(inventory_)
				end, data.current.value, tonumber(data2.value))
			end
		end, function(data2, menu2)
			menu2.close()
			OpenPutStocksMenu(inventory)
		end)
	end, function(data, menu)
		menu.close()
		OpenStashBoard()
	end)
end

function OpenGetStocksMenu(items)
	local elements = {}

	for i = 1, #items do
		local item = items[i]

		if item.count > 0 then
			elements[#elements+1] = {
				label = item.label .. ' x' .. item.count,
				value = item.name
			}
		end
	end

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open("default", GetCurrentResourceName(), 'LSCGetStocksMenu', {
		title    = "Schowek",
		align    = 'center',
		elements = elements
	}, function(data, menu)
		menu.close()
		ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
			title = "Ilość"
		}, function(data2, menu2)
			if not tonumber(data2.value) then
				TriggerEvent('skam:showNotification', {
					type = 'error',
					title = 'LSC',
					text = "Nieprawidłowa wartość",
				})
			else
				menu2.close()
				ESX.TriggerServerCallback('esx_mechanikjob:getStockItem', function(data3)
					OpenGetStocksMenu(data3)
				end, data.current.value, tonumber(data2.value))
			end
		end, function(data2, menu2)
			menu2.close()
			OpenGetStocksMenu(items)
		end)
	end, function(data, menu)
		menu.close()
		OpenStashBoard()
	end)
end


function OpenmechanikActionsMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mechanik_actions', {
		title    = 'LSC',
		align    = 'center',
		elements = {
			{label = 'interakcja z cywilami', value = 'citizen_interaction'},
			{label = 'interakcja z pojazdami', value = 'vehicle_interaction'},
			-- {label = 'przedmioty do postawienia', value = 'object_spawner'},
			{label = 'tuning', value = 'tuner'}
	}}, function(data, menu)
		if data.current.value == 'citizen_interaction' then
			local elements = {
				{label = 'dowód osobisty', value = 'identity_card'},
			}

			if Config.EnableLicenses then
				table.insert(elements, {label = 'zarządzaj licencjami', value = 'license'})
			end

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
				title    = _U('citizen_interaction'),
				align    = 'center',
				elements = elements
			}, function(data2, menu2)
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				local closestPed, closestDistancePed = ESX.Game.GetClosestPed()
				if closestPlayer ~= -1 and closestDistance <= 3.0 then
					local action = data2.current.value

					if action == 'identity_card' then
						OpenIdentityCardMenu(closestPlayer)
					elseif action == 'license' then
						ShowPlayerLicense(closestPlayer)
					end
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		elseif data.current.value == 'vehicle_interaction' then
			local elements  = {}
			local playerPed = PlayerPedId()
			local vehicle = ESX.Game.GetVehicleInDirection()

			if DoesEntityExist(vehicle) then
				table.insert(elements, {label = 'informacje o pojeździe', value = 'vehicle_infos'})
				table.insert(elements, {label = 'Napraw pojazd', value = 'fix'})
			end

			table.insert(elements, {label = _U('search_database'), value = 'search_database'})

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_interaction', {
				title    = _U('vehicle_interaction'),
				align    = 'center',
				elements = elements
			}, function(data2, menu2)
				local coords  = GetEntityCoords(playerPed)
				vehicle = ESX.Game.GetVehicleInDirection()
				action  = data2.current.value

				if action == 'search_database' then
					LookupVehicle()
				elseif DoesEntityExist(vehicle) then
					if action == 'vehicle_infos' then
						local vehicleData = ESX.Game.GetVehicleProperties(vehicle)
						OpenVehicleInfosMenu(vehicleData)
					elseif action == 'fix' then
						TriggerEvent('skam:onRepairKit', true)
					end
				else
					ESX.ShowNotification(_U('no_vehicles_nearby'), "error")
				end

			end, function(data2, menu2)
				menu2.close()
			end)
		elseif data.current.value == 'object_spawner' then
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
				title    = _U('traffic_interaction'),
				align    = 'center',
				elements = {
					{label = _U('cone'), model = 'prop_roadcone02a'}
			}}, function(data2, menu2)
				local playerPed = PlayerPedId()
				local coords, forward = GetEntityCoords(playerPed), GetEntityForwardVector(playerPed)
				local objectCoords = (coords + forward * 1.0)

				ESX.Game.SpawnObject(data2.current.model, objectCoords, function(obj)
					SetEntityHeading(obj, GetEntityHeading(playerPed))
					PlaceObjectOnGroundProperly(obj)
				end)
			end, function(data2, menu2)
				menu2.close()
			end)
		elseif data.current.value == 'tuner' then
			local playerPed = PlayerPedId()
			if GetDistanceBetweenCoords(56.4548, -1759.5818, 29.6143, GetEntityCoords(GetPlayerPed(-1))) < 25.0 then
				if IsPedInAnyVehicle(playerPed, false) then
					if (ESX.PlayerData.dualjob and ESX.PlayerData.dualjob.name == 'mechanik' or ESX.PlayerData.dualjob.name == 'offmechanik') then
						local vehicle = GetVehiclePedIsIn(playerPed, false)
						FreezeEntityPosition(vehicle, true)
						myCar = ESX.Game.GetVehicleProperties(vehicle)

						local netId = NetworkGetNetworkIdFromEntity(vehicle)
						TriggerServerEvent('esx_lscustom:startModing', myCar, netId)

						ESX.UI.Menu.CloseAll()
						kurwa = {value = 'main'}
						exports['esx_lscustom']:GetAction(kurwa)

						CreateThread(function()
							while true do
								DisableControlAction(2, 288, true)
								DisableControlAction(2, 289, true)
								DisableControlAction(2, 170, true)
								DisableControlAction(2, 167, true)
								DisableControlAction(2, 168, true)
								DisableControlAction(2, 23, true)
								DisableControlAction(0, 75, true)
								DisableControlAction(27, 75, true)
								Wait(1000)
							end
						end)
					end
				else
					TriggerEvent('skam:showNotification', {
						type = 'error',
						title = 'LOS SANTOS CUSTOMS',
						text = "Musisz być w pojeździe!"
					})
				end
			else
				TriggerEvent('skam:showNotification', {
					type = 'error',
					title = 'LOS SANTOS CUSTOMS',
					text = "Musisz znajdować się w warsztacie."
				})
			end
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenIdentityCardMenu(player)
	ESX.TriggerServerCallback('esx_mechanikjob:getOtherPlayerData', function(data)
		local elements = {
			{label = _U('name', data.name)},
			-- {label = 'Imię i nazwisko: '..data.characterName},
			{label = _U('job', ('%s - %s'):format(data.job, data.grade))}
		}

		if Config.EnableESXIdentity then
			table.insert(elements, {label = _U('sex', _U(data.sex))})
		end

		if Config.EnableESXOptionalneeds and data.drunk then
			table.insert(elements, {label = _U('bac', data.drunk)})
		end

		if data.licenses then
			table.insert(elements, {label = _U('license_label')})

			for i=1, #data.licenses, 1 do
				table.insert(elements, {label = data.licenses[i].label})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
			title    = _U('citizen_interaction'),
			align    = 'center',
			elements = elements
		}, nil, function(data, menu)
			menu.close()
		end)
	end, GetPlayerServerId(player))
end

function OpenGetWeaponMenu()
	ESX.TriggerServerCallback('esx_mechanikjob:getArmoryWeapons', function(weapons)
		local elements = {}

		for i=1, #weapons, 1 do
			if weapons[i].count > 0 then
				table.insert(elements, {
					label = 'x' .. weapons[i].count .. ' ' .. ESX.GetWeaponLabel(weapons[i].name),
					value = weapons[i].name
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_get_weapon', {
			title    = _U('get_weapon_menu'),
			align    = 'center',
			elements = elements
		}, function(data, menu)
			menu.close()

			ESX.TriggerServerCallback('esx_mechanikjob:removeArmoryWeapon', function()
				OpenGetWeaponMenu()
			end, data.current.value)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenPutWeaponMenu()
	local elements   = {}
	local playerPed  = PlayerPedId()
	local weaponList = ESX.GetWeaponList()

	for i=1, #weaponList, 1 do
		local weaponHash = joaat(weaponList[i].name)

		if HasPedGotWeapon(playerPed, weaponHash, false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
			table.insert(elements, {
				label = weaponList[i].label,
				value = weaponList[i].name
			})
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_put_weapon', {
		title    = _U('put_weapon_menu'),
		align    = 'center',
		elements = elements
	}, function(data, menu)
		menu.close()

		ESX.TriggerServerCallback('esx_mechanikjob:addArmoryWeapon', function()
			OpenPutWeaponMenu()
		end, data.current.value, true)
	end, function(data, menu)
		menu.close()
	end)
end

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.dualjob = job
	if job.name == 'mechanik' then
		Wait(1000)
		TriggerServerEvent('esx_mechanikjob:forceBlip')
	end
end)

RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)
	local specialContact = {
		name       = 'mechanik',
		number     = 'mechanik',
		base64Icon = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyJpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENTNiAoV2luZG93cykiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6NDFGQTJDRkI0QUJCMTFFN0JBNkQ5OENBMUI4QUEzM0YiIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6NDFGQTJDRkM0QUJCMTFFN0JBNkQ5OENBMUI4QUEzM0YiPiA8eG1wTU06RGVyaXZlZEZyb20gc3RSZWY6aW5zdGFuY2VJRD0ieG1wLmlpZDo0MUZBMkNGOTRBQkIxMUU3QkE2RDk4Q0ExQjhBQTMzRiIgc3RSZWY6ZG9jdW1lbnRJRD0ieG1wLmRpZDo0MUZBMkNGQTRBQkIxMUU3QkE2RDk4Q0ExQjhBQTMzRiIvPiA8L3JkZjpEZXNjcmlwdGlvbj4gPC9yZGY6UkRGPiA8L3g6eG1wbWV0YT4gPD94cGFja2V0IGVuZD0iciI/PoW66EYAAAjGSURBVHjapJcLcFTV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'
	}

	TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)
end)

-- don't show dispatches if the player isn't in service
AddEventHandler('esx_phone:cancelMessage', function(dispatchNumber)
	if ESX.PlayerData.dualjob and ESX.PlayerData.dualjob.name == 'mechanik' and ESX.PlayerData.dualjob.name == dispatchNumber then
		-- if esx_service is enabled
		if Config.EnableESXService and not playerInService then
			CancelEvent()
		end
	end
end)

AddEventHandler('esx_mechanikjob:hasEnteredMarker', function(station, part, partNum)
	if part == 'Helicopters' then
		CurrentAction     = 'Helicopters'
		CurrentActionMsg  = _U('helicopter_prompt')
		CurrentActionData = {station = station, part = part, partNum = partNum}
	elseif part == 'Deleter' then
		if IsPedInAnyVehicle(PlayerPedId(), false) then
			CurrentAction     = 'menu_vehicle_deleter'
			CurrentActionMsg  = 'Naciśnij [E], aby zaparkować pojazd'
			CurrentActionData = {}
		end
	elseif part == 'HeliDeleter' then
		if IsPedInAnyHeli(PlayerPedId()) then
			CurrentAction     = 'menu_vehicle_deleter'
			CurrentActionMsg  = 'Naciśnij [E], aby zaparkować helikopter'
			CurrentActionData = {}
		end
	elseif part == 'BossActions' then
		CurrentAction     = 'menu_boss_actions'
		CurrentActionMsg  = _U('open_bossmenu')
		CurrentActionData = {}
	end
end)

AddEventHandler('esx_mechanikjob:hasExitedMarker', function(station, part, partNum)
	if not isInShopMenu then
		ESX.UI.Menu.CloseAll()
	end

	CurrentAction = nil
end)

AddEventHandler('esx_mechanikjob:hasEnteredEntityZone', function(entity)
	local playerPed = PlayerPedId()

	if ESX.PlayerData.dualjob and ESX.PlayerData.dualjob.name == 'mechanik' and IsPedOnFoot(playerPed) then
		CurrentAction     = 'remove_entity'
		CurrentActionMsg  = 'naciśnij [E] aby usunąć ten obiekt'
		CurrentActionData = {entity = entity}
	end

	if GetEntityModel(entity) == `p_ld_stinger_s` then
		local playerPed = PlayerPedId()
		local coords    = GetEntityCoords(playerPed)

		if IsPedInAnyVehicle(playerPed, false) then
			local vehicle = GetVehiclePedIsIn(playerPed)

			for i=0, 7, 1 do
				SetVehicleTyreBurst(vehicle, i, true, 1000)
			end
		end
	end
end)

AddEventHandler('esx_mechanikjob:hasExitedEntityZone', function(entity)
	if CurrentAction == 'remove_entity' then
		CurrentAction = nil
	end
end)

-- Draw markers and more
CreateThread(function()
	while true do
		local Sleep = 1500
		if ESX.PlayerData.dualjob and ESX.PlayerData.dualjob.name == 'mechanik' then
			Sleep = 500
			local playerPed = PlayerPedId()
			local playerCoords = GetEntityCoords(playerPed)
			local isInMarker, hasExited = false, false
			local currentStation, currentPart, currentPartNum

			for k,v in pairs(Config.WarsztatMechanika) do

				if ESX.PlayerData.dualjob.grade == 1 or ESX.PlayerData.dualjob.grade_permissions["get_car"] then
					for i=1, #v.Vehicles, 1 do
						if v.Vehicles[i].Deleter then
							distance = #(playerCoords - v.Vehicles[i].Deleter)

							if distance < Config.DrawDistance then
								DrawMarker(25, v.Vehicles[i].Deleter, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 1.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
								Sleep = 0

								if distance < 1.5 then
									isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Deleter', i
								end
							end
						end
					end
				end

				if ESX.PlayerData.dualjob.grade == 1 or ESX.PlayerData.dualjob.grade_permissions["members_menager"] then
					for i=1, #v.BossActions, 1 do
						local distance = #(playerCoords - v.BossActions[i])

						if distance < Config.DrawDistance then
							DrawMarker(Config.MarkerType.BossActions, v.BossActions[i], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
							Sleep = 0

							if distance < Config.MarkerSize.x then
								isInMarker, currentStation, currentPart, currentPartNum = true, k, 'BossActions', i
							end
						end
					end
				end
			end

			if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)) then
				if
					(LastStation and LastPart and LastPartNum) and
					(LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
				then
					TriggerEvent('esx_mechanikjob:hasExitedMarker', LastStation, LastPart, LastPartNum)
					hasExited = true
				end

				HasAlreadyEnteredMarker = true
				LastStation             = currentStation
				LastPart                = currentPart
				LastPartNum             = currentPartNum

				TriggerEvent('esx_mechanikjob:hasEnteredMarker', currentStation, currentPart, currentPartNum)
			end

			if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('esx_mechanikjob:hasExitedMarker', LastStation, LastPart, LastPartNum)
			end
		end
	Wait(Sleep)
	end
end)

SKAM.RegisterPlace({
	coords = vector3(-329.1911, -1336.4678, 31.4549),
	Marker = { size = vector3(2.5, 2.5, 1.0), dist = 5.0 },
	pedModel = { model = 'mp_m_waremech_01', heading = 0.0 },
	txt3d = 'wyciągnać furke',
	onPress = function()
		if ESX.PlayerData.dualjob.name == 'mechanik' then
			if not IsPedInAnyVehicle(PlayerPedId(), false) then
				OpenVehicleSpawnerMenu('car', "LSC", Vehicles, 1)
			end
		else
			TriggerEvent('skam:showNotification', {
				type = 'error',
				title = 'LOS SANTOS CUSTOMS',
				text = "Nie masz uprawnień, aby tego użyć"
			})
		end
	end,
	jobs = 'mechanik'
})

SKAM.RegisterPlace({
	coords = vector3(81.1590, -1732.7957, 29.6142-0.95),
	Marker = { size = vector3(2.5, 2.5, 1.0), dist = 5.0 },
	pedModel = { model = 's_m_y_winclean_01', heading = 0.0 },
	txt3d = 'otworzyć zarządzanie',
	onPress = function()
		if ESX.PlayerData.dualjob.name == 'mechanik' then
			if not IsPedInAnyVehicle(PlayerPedId(), false) then
				if ESX.PlayerData.dualjob.grade == 1 or ESX.PlayerData.dualjob.grade_permissions["members_menager"] then
					OpenBossMenu()
				else
					TriggerEvent('skam:showNotification', {
						type = 'error',
						title = 'LOS SANTOS CUSTOMS',
						text = "Nie masz uprawnień, aby tego użyć"
					})
				end
			else
				TriggerEvent('skam:showNotification', {
					type = 'error',
					title = 'LOS SANTOS CUSTOMS',
					text = "Nie masz uprawnień, aby tego użyć"
				})
			end
		end
	end,
	jobs = 'mechanik'
})

-- Enter / Exit entity zone events
CreateThread(function()
	local trackedEntities = {
		`prop_roadcone02a`,
		`prop_barrier_work05`,
		`p_ld_stinger_s`
	}

	while true do
		local Sleep = 1500

		local GetEntityCoords = GetEntityCoords
		local GetClosestObjectOfType = GetClosestObjectOfType
		local DoesEntityExist = DoesEntityExist
		local playerCoords = GetEntityCoords(ESX.PlayerData.ped)

		local closestDistance = -1
		local closestEntity   = nil

		for i=1, #trackedEntities, 1 do
			local object = GetClosestObjectOfType(playerCoords, 3.0, trackedEntities[i], false, false, false)

			if DoesEntityExist(object) then
				Sleep = 500
				local objCoords = GetEntityCoords(object)
				local distance = #(playerCoords - objCoords)

				if closestDistance == -1 or closestDistance > distance then
					closestDistance = distance
					closestEntity   = object
				end
			end
		end

		if closestDistance ~= -1 and closestDistance <= 3.0 then
			if LastEntity ~= closestEntity then
				TriggerEvent('esx_mechanikjob:hasEnteredEntityZone', closestEntity)
				LastEntity = closestEntity
			end
		else
			if LastEntity then
				TriggerEvent('esx_mechanikjob:hasExitedEntityZone', LastEntity)
				LastEntity = nil
			end
		end
		Wait(Sleep)
	end
end)

ESX.RegisterInput("mechanik:interact", "Interakcje (LSC)", "keyboard", "E", function()
	if not CurrentAction then
		return
	end
	
	if not ESX.PlayerData.dualjob or (xPlayer.dualjob and xPlayer.dualjob.name == 'mechanik') then
		return
	end
	
	if CurrentAction == 'menu_cloakroom' then
		OpenCloakroomMenu()
	elseif CurrentAction == 'menu_armory' then
		if not Config.EnableESXService then
			OpenStashBoard(CurrentActionData.station)
		elseif playerInService then
			OpenStashBoard(CurrentActionData.station)
		else
			ESX.ShowNotification(_U('service_not'), "error")
		end
	elseif CurrentAction == 'menu_vehicle_spawner' then
		if not Config.EnableESXService then
			-- print(CurrentActionData.station, CurrentActionData.part, CurrentActionData.partNum)
			OpenVehicleSpawnerMenu('car', CurrentActionData.station, CurrentActionData.part, CurrentActionData.partNum)
		elseif playerInService then
			-- print(CurrentActionData.station, CurrentActionData.part, CurrentActionData.partNum)
			OpenVehicleSpawnerMenu('car', CurrentActionData.station, CurrentActionData.part, CurrentActionData.partNum)
		else
			ESX.ShowNotification(_U('service_not'), "error")
		end
	elseif CurrentAction == 'menu_vehicle_deleter' then
		local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		ESX.Game.DeleteVehicle(vehicle)
	elseif CurrentAction == 'Helicopters' then
		if not Config.EnableESXService then
			OpenVehicleSpawnerMenu('helicopter', CurrentActionData.station, CurrentActionData.part, CurrentActionData.partNum)
		elseif playerInService then
			OpenVehicleSpawnerMenu('helicopter', CurrentActionData.station, CurrentActionData.part, CurrentActionData.partNum)
		else
			ESX.ShowNotification(_U('service_not'), "error")
		end
	elseif CurrentAction == 'delete_vehicle' then
		ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
	elseif CurrentAction == 'menu_boss_actions' then
		ESX.UI.Menu.CloseAll()

		if ESX.PlayerData.dualjob.grade == 1 or ESX.PlayerData.dualjob.grade_permissions["members_menager"] then
			OpenBossMenu()
		else
			TriggerEvent('skam:showNotification', {
				type = 'error',
				title = 'LSC',
				text = "Nie masz uprawnień, aby tego użyć"
			})
		end

		--CurrentAction     = 'menu_boss_actions'
		--CurrentActionMsg  = _U('open_bossmenu')
		--CurrentActionData = {}
	elseif CurrentAction == 'remove_entity' then
		CreateThread(function()
			if not NetworkHasControlOfEntity(CurrentActionData.entity) then
				NetworkRequestControlOfEntity(CurrentActionData.entity)

				local timeout = 0
				while not NetworkHasControlOfEntity(CurrentActionData.entity) and (timeout < 2000) do
					timeout = timeout + 1
					Wait(0)
				end
			end

			DeleteEntity(CurrentActionData.entity)
		end)
	end

	CurrentAction = nil
end)

function OpenBossMenu()
	local elements = {}

	if ESX.PlayerData.dualjob.grade == 1 or ESX.PlayerData.dualjob.grade_permissions["withdraw_money"] or ESX.PlayerData.dualjob.grade_permissions["deposit_money"] then
		elements[#elements+1] = {label = "Konto", value = "bank"}
	else
		elements[#elements+1] = {label = '<span style="color:gray;">Konto</span>'}
	end

	if ESX.PlayerData.dualjob.grade == 1 then
		elements[#elements+1] = {label = "Rangi", value = "grades"}
	else
		elements[#elements+1] = {label = '<span style="color:gray;">Rangi</span>'}
	end

	if ESX.PlayerData.dualjob.grade == 1 or ESX.PlayerData.dualjob.grade_permissions["members_menager"] then
		elements[#elements+1] = {label = "Licencje", value = "licenses"}
	else
		elements[#elements+1] = {label = '<span style="color:gray;">Licencje</span>'}
	end

	if ESX.PlayerData.dualjob.grade == 1 or ESX.PlayerData.dualjob.grade_permissions["members_menager"] then
		elements[#elements+1] = {label = "Członkowie", value = "members"}
	else
		elements[#elements+1] = {label = '<span style="color:gray;">Członkowie</span>'}
	end

	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "LSCBossMenu", {
		title    = "Menu szefa LSC",
		align    = "center",
		elements = elements
	}, function(data, menu)

		if data.current.value == "grades" then
			menu.close()
			ESX.TriggerServerCallback("esx_mechanikjob:GetGrades", function(grades)
				OpenGradesMenu(grades)
			end)
		elseif data.current.value == "members" then
			menu.close()
			ESX.TriggerServerCallback("esx_mechanikjob:GetMembers", function(members)
				OpenMembersMenu(members)
			end)
		elseif data.current.value == "bank" then
			menu.close()
			ESX.TriggerServerCallback("esx_mechanikjob:getAccount", function(orgMoney_, playerMoney_)
				OpenAccountMenu(orgMoney_, playerMoney_)
			end)
		elseif data.current.value == "licenses" then
			menu.close()
			ESX.TriggerServerCallback("esx_mechanikjob:getLicenseDataOfLSC", function(players, licensesCfg)
				OpenLicensesMenu(players, licensesCfg)
			end)
		else
			TriggerEvent('skam:showNotification', {
				type = 'error',
				title = 'LSC',
				text = "Nie masz uprawnień, aby tego użyć"
			})
		end

	end, function(data, menu)
		menu.close()
	end)
end

function DynamicInputMenu(title)
	local result = nil
	ESX.UI.Menu.Open("dialog", GetCurrentResourceName(), "LSCMenu", {
		title = title
	}, function(data, menu)
		menu.close()

		ESX.TriggerServerCallback("esx_mechanikjob:GetGrades", function(grades)
			local used = false
			for i = 1, #grades do
				if grades[i].name == data.value then
					used = true
				end
			end
			if data.value then
				if string.len(data.value) > 30 then
					TriggerEvent('skam:showNotification', {
						type = 'error',
						title = 'LSC',
						text = "Nazwa rangi musi mieć do 30 znaków"
					})
					result = false
				elseif string.len(data.value) < 4 then
					TriggerEvent('skam:showNotification', {
						type = 'error',
						title = 'LSC',
						text = "Nazwa rangi musi mieć co najmniej 4 znaki"
					})
					result = false
				elseif used then
					TriggerEvent('skam:showNotification', {
						type = 'error',
						title = 'LSC',
						text = "Nazwa jest już zajęta"
					})
					result = false
				else
					result = data.value
				end
			else
				result = false
			end
		end)

	end, function(data, menu)
		menu.close()
		result = false
	end)

	while result == nil do
        Wait(0)
    end

    return result
end

function OpenGradesMenu(elements)
	for i = 1, #elements do
		elements[i].label = elements[i].name
		elements[i].name = nil
	end

	elements[#elements + 1] = {label = "<b>Dodaj rangę</b>", addNew = true}

	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "LSCGradesMenu", {
		title    = "Menu Rang",
		align    = "center",
		elements = elements
	}, function(data, menu)
		menu.close()

		if data.current.addNew then
			local name = DynamicInputMenu("Podaj nazwę rangi")
			-- print(name)
			if name then
				OpenNewGradePermissionsMenu(name, nil)
			else
				ESX.TriggerServerCallback("esx_mechanikjob:GetGrades", function(grades)
					OpenGradesMenu(grades)
				end)
			end
		else
			OpenSpecifiedGradeMenu(data.current)
		end

	end, function(data, menu)
		menu.close()
		OpenBossMenu()
	end)
end

function OpenNewGradePermissionsMenu(name, elements)

	if not elements then
		elements = {
			{label = "Wyciąganie Aut",        name = "get_car",         value = false},
			{label = "Zbrojownia", 			  name = "withdraw_item",   value = false},
			{label = "Wkładanie do sejfu", 	  name = "deposit_money",   value = false},
			{label = "Wyciąganie z sejfu", 	  name = "withdraw_money",  value = false},
			{label = "Zarządzanie ubraniami", name = "edit_clothes", 	value = false},
			{label = "Zarządzanie członkami", name = "members_menager", value = false},

			{label = "<b>Potwierdź</b>", name = "confirm"},
		}

		for i = 1, #elements do
			if elements[i].name ~= "confirm" then
				elements[i].clearlabel = elements[i].label
				elements[i].label = elements[i].label..' - <span style="color:red;">Nie</span>'
			end
		end
	end

	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "LSCNewGradePermissionsMenu", {
		title    = "Uprawnienia rangi",
		align    = "center",
		elements = elements
	}, function(data, menu)
		menu.close()

		if data.current.name == "confirm" then
			local permissions = {}
			for i = 1, #elements do
				if elements[i].value then
					permissions[elements[i].name] = true
				end
			end

			local newGrade = {name = name, permissions = permissions, salary = 0}
			ESX.TriggerServerCallback("esx_mechanikjob:AddNewGrade", function(grades)
				OpenGradesMenu(grades)
			end, newGrade)
		else
			for i = 1, #elements do
				if data.current.name == elements[i].name then
					if data.current.value then
						elements[i].label = elements[i].clearlabel..' - <span style="color:red;">Nie</span>'
						elements[i].value = false
					else
						elements[i].label = elements[i].clearlabel..' - <span style="color:green;">Tak</span>'
						elements[i].value = true
					end
					OpenNewGradePermissionsMenu(name, elements)
				end
			end
		end


	end, function(data, menu)
		menu.close()
		ESX.TriggerServerCallback("esx_mechanikjob:GetGrades", function(grades)
			OpenGradesMenu(grades)
		end)
	end)
end

-- function Kajdanki:SetCanSearch(x1) 
--     CanSearch = x1
-- end

function OpenSpecifiedGradeMenu(grade)
	local elements = {
		{label = "Zmień nazwę", value = "name"},
	}

	if grade.id and grade.id > 1 then
		elements[#elements+1] = {label = "Zmień uprawnienia", value = "perms"}
		elements[#elements+1] = {label = "Posiadacze rangi", value = "members"}
		elements[#elements+1] = {label = '<span style="color:red;"><b>Usuń</b></span>', value = "remove"}
	end

	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "LSCSpecifiedGradeMenu", {
		title    = grade.label,
		align    = "center",
		elements = elements
	}, function(data, menu)
		menu.close()

		if data.current.value == "members" then

			ESX.TriggerServerCallback("esx_mechanikjob:GetMembers", function(members)
				OpenMembersMenu(members, grade)
			end, grade.id)

		elseif data.current.value == "name" then

			local name = DynamicInputMenu("Podaj nową nazwę rangi")
			if name then
				ESX.TriggerServerCallback("esx_mechanikjob:ChangeGradeName", function(grades)
					TriggerEvent('skam:showNotification', {
						type = 'success',
						title = 'LSC',
						text = "Pomyślnie zapisano zmiany"
					})
					for i = 1, #grades do
						if grades[i].name == name then
							grades[i].label = grades[i].name
							grades[i].name = nil
							OpenSpecifiedGradeMenu(grades[i])
						end
					end
				end, grade.label, name)
			else
				OpenSpecifiedGradeMenu(grade)
			end

		elseif data.current.value == "perms" then

			OpenSpecifiedGradePermsMenu(grade, nil)

		elseif data.current.value == "remove" then
			TriggerEvent('skam:showNotification', {
				type = 'error',
				title = 'LSC',
				text = "Wyrzuci to wszystkie osoby posiadające tą range",
				duration = 10000
			})
			ESX.UI.Menu.Open("default", GetCurrentResourceName(), "LSCtruefalseMenu", {
				title    = 'Czy na pewno chcesz usunąć: "'..grade.label..'"',
				align    = "center",
				elements = {
					{label = "Nie", value = false},
                	{label = "Tak", value = true},
				}
			}, function(data2, menu2)
				menu2.close()
				if data2.current.value then
					ESX.TriggerServerCallback("esx_mechanikjob:RemoveGrade", function(grades)
						OpenGradesMenu(grades)
					end, grade.id)
				else
					OpenSpecifiedGradeMenu(grade)
				end
			end, function(data2, menu2)
				menu2.close()
				OpenSpecifiedGradeMenu(grade)
			end)

		end

	end, function(data, menu)
		menu.close()
		ESX.TriggerServerCallback("esx_mechanikjob:GetGrades", function(grades)
			OpenGradesMenu(grades)
		end)
	end)
end

function OpenSpecifiedGradePermsMenu(grade, elements)

	if not elements then
		elements = {
			{label = "Wyciąganie Aut",        name = "get_car",         value = false},
			{label = "Zbrojownia", 			  name = "withdraw_item",   value = false},
			{label = "Wkładanie do sejfu", 	  name = "deposit_money",   value = false},
			{label = "Wyciąganie z sejfu", 	  name = "withdraw_money",  value = false},
			{label = "Zarządzanie ubraniami", name = "edit_clothes", 	value = false},
			{label = "Zarządzanie członkami", name = "members_menager", value = false},

			{label = "<b>Potwierdź</b>", name = "confirm"},
		}

		for i = 1, #elements do
			if elements[i].name ~= "confirm" then
				elements[i].clearlabel = elements[i].label
				for perm, bool in pairs(grade.permissions) do
					if elements[i].name == perm then
						elements[i].value = true
					end
				end
				if elements[i].value then
					elements[i].label = elements[i].label..' - <span style="color:green;">Tak</span>'
				else
					elements[i].label = elements[i].label..' - <span style="color:red;">Nie</span>'
				end
			end
		end
	end

	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "LSCSpecifiedGradePermsMenu", {
		title    = 'Uprawnienia: "'..grade.label..'"',
		align    = "center",
		elements = elements
	}, function(data, menu)
		menu.close()

		if data.current.name == "confirm" then
			local permissions = {}
			for i = 1, #elements do
				if elements[i].value then
					permissions[elements[i].name] = true
				end
			end

			local updateGrade = {name = grade.label, permissions = permissions, salary = 0}
			ESX.TriggerServerCallback("esx_mechanikjob:UpdateGrade", function(grades)
				TriggerEvent('skam:showNotification', {
					type = 'success',
					title = 'LSC',
					text = "Pomyślnie zapisano zmiany",
				})
				for i = 1, #grades do
					if grades[i].name == grade.label then
						grades[i].label = grades[i].name
						grades[i].name = nil
						OpenSpecifiedGradeMenu(grades[i])
					end
				end
			end, updateGrade)
		else
			for i = 1, #elements do
				if data.current.name == elements[i].name then
					if data.current.value then
						elements[i].label = elements[i].clearlabel..' - <span style="color:red;">Nie</span>'
						elements[i].value = false
					else
						elements[i].label = elements[i].clearlabel..' - <span style="color:green;">Tak</span>'
						elements[i].value = true
					end
					OpenSpecifiedGradePermsMenu(grade, elements)
				end
			end
		end

	end, function(data, menu)
		menu.close()
		OpenSpecifiedGradeMenu(grade)
	end)
end

function minutesToHoursAndMinutes(minutes)
	local hours = math.floor(minutes / 60)
	local remainingMinutes = minutes % 60
	return hours, remainingMinutes
end

function OpenMembersMenu(members, grade)
	local elements = {}

	if ESX.PlayerData.dualjob.grade == 1 or ESX.PlayerData.dualjob.grade_permissions["members_menager"] then
		elements[#elements+1] = {label = "<b>Dodaj Robola</b>", addNew = true}
	else
		elements[#elements+1] = {label = '<span style="color:gray;"><b>Dodaj Robola</b></span>', noPerm = true}
	end

	if ESX.PlayerData.dualjob.grade == 1 then
		elements[#elements+1] = {label = '<span style="color:red;"><b>Zresetuj godziny</b></span>', hoursReset = true}
	end

	local gradesQuantity = 1

	for identifier, xPlayer in pairs(members) do
		if xPlayer.dualjob.grade > gradesQuantity then
			gradesQuantity = xPlayer.dualjob.grade
		end
	end

	for i = 1, gradesQuantity do
		for identifier, xPlayer in pairs(members) do
			if xPlayer.online and xPlayer.dualjob.grade == i then

				if not xPlayer.duty_hours then
					xPlayer.duty_hours = 0
				end

				local hours, remainingMinutes = minutesToHoursAndMinutes(xPlayer.duty_hours)

				if grade then
					elements[#elements+1] = {label = xPlayer.name.." ("..hours.." godzin, "..remainingMinutes.." minut)", value = xPlayer}
				else
					elements[#elements+1] = {label = xPlayer.name.." ("..hours.." godzin, "..remainingMinutes.." minut) ["..xPlayer.dualjob.grade_name.."]", value = xPlayer}
				end
			end
		end
	end

	for i = 1, gradesQuantity do
		for identifier, xPlayer in pairs(members) do
			if not xPlayer.online and xPlayer.dualjob.grade == i then

				if not xPlayer.duty_hours then
					xPlayer.duty_hours = 0
				end

				local hours, remainingMinutes = minutesToHoursAndMinutes(xPlayer.duty_hours)

				if grade then
					elements[#elements+1] = {label = '<span style="color:gray;">'..xPlayer.name.." ("..hours.." godzin, "..remainingMinutes.." minut)"..'</span>', value = xPlayer}
				else
					elements[#elements+1] = {label = '<span style="color:gray;">'..xPlayer.name..'</span>'.." ("..hours.." godzin, "..remainingMinutes.." minut) ["..xPlayer.dualjob.grade_name.."]", value = xPlayer}
				end
			end
		end
	end

	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "LSCMembersMenu", {
		title    = grade and "Lista Roboli ["..grade.label.."]" or "Lista Roboli",
		align    = "center",
		elements = elements
	}, function(data, menu)
		menu.close()

		if data.current.addNew then
			if grade then
				ESX.TriggerServerCallback("esx_mechanikjob:GetNearPlayers", function(nearPlayers)
					OpenSelectPlayerToIviteMenu(nearPlayers, grade)
				end)
			else
				ESX.TriggerServerCallback("esx_mechanikjob:GetGrades", function(grades)
					OpenSelectGradeToIviteMenu(grades)
				end)
			end
		elseif data.current.noPerm then
			TriggerEvent('skam:showNotification', {
				type = 'error',
				title = 'LSC',
				text = "Nie masz uprawnień, aby tego użyć",
			})
		elseif data.current.hoursReset then
			ESX.TriggerServerCallback("esx_mechanikjob:ResetDutyHours", function()
				ESX.ShowNotification('Pomyślnie zresetowano godziny dla wszystkich LSC', 'success')
				OpenBossMenu()
			end)
		else
			OpenSpecifiedMemberMenu(data.current.value)
		end

	end, function(data, menu)
		menu.close()
		OpenBossMenu()
	end)
end

function OpenSelectGradeToIviteMenu(elements)
	for i = 1, #elements do
		elements[i].label = elements[i].name
		elements[i].name = nil
		if elements[i].id == 1 then
			elements[i].label = '<span style="color:gray;">'..elements[i].label..'</span>'
		end
	end

	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "LSCSelectGradeToIviteMenu", {
		title    = "Wybierz rangę",
		align    = "center",
		elements = elements
	}, function(data, menu)

		if data.current.id > 1 then
			menu.close()
			ESX.TriggerServerCallback("esx_mechanikjob:GetNearPlayers", function(nearPlayers)
				OpenSelectPlayerToIviteMenu(nearPlayers, data.current)
			end)
		end

	end, function(data, menu)
		menu.close()
		OpenBossMenu()
	end)
end

function OpenSelectPlayerToIviteMenu(nearPlayers, grade)
	local elements = {}

	for src, name in pairs(nearPlayers) do
		elements[#elements+1] = {label = name.." ["..src.."]", value = src}
	end

	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "LSCSelectPlayerToIviteMenu", {
		title    = "Wybierz gracza",
		align    = "center",
		elements = elements
	}, function(data, menu)
		menu.close()

		TriggerServerEvent("esx_mechanikjob:server:AskToJoin", data.current.value, grade)

	end, function(data, menu)
		menu.close()
		OpenBossMenu()
	end)
end

RegisterNetEvent("esx_mechanikjob:client:AskToJoin", function(senderId, grade)
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "LSCtruefalse2Menu", {
		title    = 'Czy chcesz dołączyć do: "LSC"?',
		align    = "center",
		elements = {
			{label = "Nie", value = false},
			{label = "Tak", value = true},
		}
	}, function(data, menu)
		menu.close()
		TriggerEvent('skam:showNotification', {
			type = 'info',
			title = 'LSC',
			text = 'Dołączono do "LSC" na stanowisko "'..grade.label..'"',
		})
		TriggerServerEvent("esx_mechanikjob:server:ResponseToJoin", senderId, grade, data.current.value)
	end, function(data, menu)
		menu.close()
	end)
end)

function OpenSpecifiedMemberMenu(xPlayer)
	local elements = {
		{label = xPlayer.online and '<span style="color:green;">Online</span>' or '<span style="color:red;">Offline</span>'},
	}

	if xPlayer.dualjob.grade > ESX.PlayerData.dualjob.grade then
		elements[#elements+1] = {label = 'Zmień range', value = "changeMemberGrade"}
		elements[#elements+1] = {label = '<span style="color:red;"><b>Wyrzuć</b></span>', value = "kickMember"}
	end

	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "LSCSpecifiedMemberMenu", {
		title    = xPlayer.name,
		align    = "center",
		elements = elements
	}, function(data, menu)

		if data.current.value == "changeMemberGrade" then
			menu.close()
			ESX.TriggerServerCallback("esx_mechanikjob:GetGrades", function(grades)
				OpenChangeMemberGradeMenu(xPlayer, grades)
			end)
		elseif data.current.value == "kickMember" then
			menu.close()

			ESX.UI.Menu.Open("default", GetCurrentResourceName(), "LSCtruefalse3Menu", {
				title    = 'Czy na pewno chcesz wyrzucić: "'..xPlayer.name..'"',
				align    = "center",
				elements = {
					{label = "Nie", value = false},
                	{label = "Tak", value = true},
				}
			}, function(data2, menu2)
				menu2.close()
				if data2.current.value then
					ESX.TriggerServerCallback("esx_mechanikjob:KickMember", function()
						TriggerEvent('skam:showNotification', {
							type = 'success',
							title = 'LSC',
							text = 'Pomyślnie Wyrzucono: '..xPlayer.name..'"',
						})
						OpenBossMenu()
					end, xPlayer)
				else
					OpenSpecifiedMemberMenu(xPlayer)
				end
			end, function(data2, menu2)
				menu2.close()
				OpenSpecifiedMemberMenu(xPlayer)
			end)
		end

	end, function(data, menu)
		menu.close()
		OpenBossMenu()
	end)
end

function OpenChangeMemberGradeMenu(xPlayer, elements)
	for i = 1, #elements do
		elements[i].label = elements[i].name
		elements[i].name = nil
		if xPlayer.dualjob.grade == elements[i].id or elements[i].id <= ESX.PlayerData.dualjob.grade then
			elements[i].label = '<span style="color:gray;">'..elements[i].label..'</span>'
			elements[i].disable = true
		end
	end

	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "LSCChangeMemberGradeMenu", {
		title    = "Wybierz rangę",
		align    = "center",
		elements = elements
	}, function(data, menu)

		if not data.current.disable then
			menu.close()
			ESX.TriggerServerCallback("esx_mechanikjob:ChangeMemberRank", function(newxPlayer)
				OpenSpecifiedMemberMenu(newxPlayer)
			end, data.current, xPlayer)
		end

	end, function(data, menu)
		menu.close()
		OpenSpecifiedMemberMenu(xPlayer)
	end)
end

function OpenLicensesMenu(data, licensesCfg)
	local elements = {
		head = {"Mechanik", "UPS", "Akcje"},
		rows = {}
	}

	for k, v in pairs(data) do
		local allowedLicenses = {
			['ups_lsc'] = '❌',
		}

		local Owned = {}
		local NotOwned = {}

		for license, value in pairs(allowedLicenses) do
			if v.license[license] then
				allowedLicenses[license] = '✔️'
				Owned[#Owned+1] = {label = licensesCfg[license], value = license}
			else
				NotOwned[#NotOwned+1] = {label = licensesCfg[license], value = license}
			end
		end

		data[k].identifier = k
		data[k].Owned = Owned
		data[k].NotOwned = NotOwned
		
		elements.rows[#elements.rows+1] = {
			data = data[k],
			cols = {
				data[k].name,
				allowedLicenses['ups_lsc'],
				'{{' .. "Nadaj licencję" .. '|add}} {{' .. "Odbierz licencję" .. '|revoke}}'
			}
		}
	end

	table.sort(elements.rows, function(a, b)
		return a.cols[1] < b.cols[1]
	end)

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'lsc_licenses', elements, function(data, menu)
		if data.value == 'add' then
			OpenManageLicensesMenu(data.data, true)
			menu.close()
		elseif data.value == 'revoke' then
			OpenManageLicensesMenu(data.data, false)
			menu.close()
		end	
	end, function(data, menu)
		menu.close()
		OpenBossMenu()
	end)
end

function OpenManageLicensesMenu(member, status)
	local elements = {}
	if not status then
		for i = 1, #member.Owned do
			elements[#elements+1] = {label = member.Owned[i].label, value = member.Owned[i].value}
		end
	else
		for i = 1, #member.NotOwned do
			elements[#elements+1] = {label = member.NotOwned[i].label, value = member.NotOwned[i].value}
		end
	end
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open("default", GetCurrentResourceName(), 'lsc_manage_licenses', {
		title    = '--- Licencje ---',
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)
		if data.current.value then
			ESX.TriggerServerCallback('skam:manageLiceses', function(cb)
				if cb then
					TriggerEvent('skam:showNotification', {
						type = 'success',
						title = 'LSC',
						text = 'Pomyślnie zmieniono licencje dla gracza',
					})
					menu.close()
					ESX.TriggerServerCallback("esx_mechanikjob:getLicenseDataOfLSC", function(players, licensesCfg)
						OpenLicensesMenu(players, licensesCfg)
					end)
				end
			end, member.identifier, data.current.value, status)
		end
	end, function(data, menu)
		menu.close()
		ESX.TriggerServerCallback("esx_mechanikjob:getLicenseDataOfLSC", function(players, licensesCfg)
			OpenLicensesMenu(players, licensesCfg)
		end)
	end)
end

function OpenAccountMenu(orgMoney, playerMoney)
	local elements = {
		{label = '<span style="color:gray;">Sejf: '..orgMoney..'</span>'},
		{label = '<span style="color:gray;">Twoja gotówka: '..playerMoney..'</span>'},
	}

	if ESX.PlayerData.dualjob.grade == 1 or ESX.PlayerData.dualjob.grade_permissions["deposit_money"] then
		elements[#elements+1] = {label = 'Schowaj gotówkę', value = 'put_money'}
	else
		elements[#elements+1] = {label = '<span style="color:gray;">Schowaj gotówkę</span>', value = "no_perm"}
	end

	if ESX.PlayerData.dualjob.grade == 1 or ESX.PlayerData.dualjob.grade_permissions["withdraw_money"] then
		elements[#elements+1] = {label = 'Wyciągnij gotówkę', value = 'get_money'}
	else
		elements[#elements+1] = {label = '<span style="color:gray;">Wyciągnij gotówkę</span>', value = "no_perm"}
	end

	ESX.UI.Menu.Open("default", GetCurrentResourceName(), 'LSCStashBoardMenu', {
		title    = '--- Sejf ---',
		align    = 'center',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'put_money' then

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'menu_put_money_count', {
				title = "Ilość"
			}, function(data2, menu2)

				if not tonumber(data2.value) then
					TriggerEvent('skam:showNotification', {
						type = 'error',
						title = 'LSC',
						text = "Nieprawidłowa wartość",
					})
				else
					menu.close()
					menu2.close()
					ESX.TriggerServerCallback('esx_mechanikjob:putMoney', function(orgMoney_, playerMoney_)
						OpenAccountMenu(orgMoney_, playerMoney_)
					end, tonumber(data2.value))
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		elseif data.current.value == 'get_money' then

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'menu_get_money_count', {
				title = "Ilość"
			}, function(data2, menu2)

				if not tonumber(data2.value) then
					TriggerEvent('skam:showNotification', {
						type = 'error',
						title = 'LSC',
						text = "Nieprawidłowa wartość",
					})
				else
					menu.close()
					menu2.close()
					ESX.TriggerServerCallback('esx_mechanikjob:getMoney', function(orgMoney_, playerMoney_)
						OpenAccountMenu(orgMoney_, playerMoney_)
					end, tonumber(data2.value))
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		elseif data.current.value == 'no_perm' then
			TriggerEvent('skam:showNotification', {
				type = 'error',
				title = 'LSC',
				text = "Nie masz uprawnień, aby tego użyć",
			})
		end
	end, function(data, menu)
		menu.close()
		OpenBossMenu()
	end)
end

ESX.RegisterInput("mechanik:quickactions", "Menu policyjne", "keyboard", "F6", function()
	if not ESX.PlayerData.dualjob or (ESX.PlayerData.dualjob.name ~= 'mechanik') or isDead or isHandcuffed then
		return
	end

	if not Config.EnableESXService then
		OpenmechanikActionsMenu()
	elseif playerInService then
		OpenmechanikActionsMenu()
	else
		ESX.ShowNotification(_U('service_not'), "error")
	end
end)

CreateThread(function()
	while true do
		local Sleep = 1000

		if CurrentAction then
			Sleep = 0
			ESX.ShowHelpNotification(CurrentActionMsg)
		end
		Wait(Sleep)
	end
end)

-- Create blip for colleagues
function createBlip(id)
	local ped = GetPlayerPed(id)
	local blip = GetBlipFromEntity(ped)

	if not DoesBlipExist(blip) then -- Add blip and create head display on player
		blip = AddBlipForEntity(ped)
		SetBlipSprite(blip, 1)
		ShowHeadingIndicatorOnBlip(blip, true) -- Player Blip indicator
		SetBlipRotation(blip, math.ceil(GetEntityHeading(ped))) -- update rotation
		SetBlipNameToPlayerName(blip, id) -- update blip name
		SetBlipScale(blip, 0.85) -- set scale
		SetBlipAsShortRange(blip, true)

		table.insert(blipsMech, blip) -- add blip to array so we can remove it later
	end
end

RegisterNetEvent('esx_mechanikjob:updateBlip')
AddEventHandler('esx_mechanikjob:updateBlip', function()

	-- Refresh all blips
	for k, existingBlip in pairs(blipsMech) do
		RemoveBlip(existingBlip)
	end

	-- Clean the blip table
	blipsMech = {}

	-- Enable blip?
	if Config.EnableESXService and not playerInService then
		return
	end

	if not Config.EnableJobBlip then
		return
	end

	-- Is the player a cop? In that case show all the blips for other cops
	-- if ESX.PlayerData.dualjob and ESX.PlayerData.dualjob.name == 'mechanik' then -- TODO
	-- 	ESX.TriggerServerCallback('esx_society:getOnlinePlayers', function(players)
	-- 		for i=1, #players, 1 do
	-- 			if players[i].job.name == 'mechanik' then
	-- 				local id = GetPlayerFromServerId(players[i].source)
	-- 				if NetworkIsPlayerActive(id) and GetPlayerPed(id) ~= PlayerPedId() then
	-- 					createBlip(id)
	-- 				end
	-- 			end
	-- 		end
	-- 	end)
	-- end
end)

AddEventHandler('esx:onPlayerSpawn', function(spawn)
	isDead = false
	TriggerEvent('esx_mechanikjob:unrestrain')

	if not hasAlreadyJoined then
		TriggerServerEvent('esx_mechanikjob:spawned')
	end
	hasAlreadyJoined = true
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('esx_mechanikjob:unrestrain')
		TriggerEvent('esx_phone:removeSpecialContact', 'mechanik')

		if Config.EnableESXService then
			TriggerServerEvent('esx_service:disableService', 'mechanik')
		end

		if Config.EnableHandcuffTimer and handcuffTimer.active then
			ESX.ClearTimeout(handcuffTimer.task)
		end
	end
end)

if ESX.PlayerLoaded and ESX.PlayerData.dualjob == 'mechanik' then
	SetTimeout(1000, function()
		TriggerServerEvent('esx_mechanikjob:forceBlip')
	end)
end