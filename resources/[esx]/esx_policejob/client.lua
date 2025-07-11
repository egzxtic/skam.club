local CurrentActionData, handcuffTimer, dragStatus, blipsCops, currentTask = {}, {}, {}, {}, {}
local Kajdanki = {}
local HasAlreadyEnteredMarker, isDead, isHandcuffed, hasAlreadyJoined, playerInService = false, false, false, false, false
local CanSearch = false
local LastStation, LastPart, LastPartNum, LastEntity, CurrentAction, CurrentActionMsg
dragStatus.isDragged, isInShopMenu = false, false

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	ESX.PlayerLoaded = true

	AddRelationshipGroup('skam_cuffedped')
	SetRelationshipBetweenGroups(0, `player`, `skam_cuffedped`)
end)

RegisterNetEvent('esx:onPlayerLogout')
AddEventHandler('esx:onPlayerLogout', function()
	ESX.PlayerLoaded = false
	ESX.PlayerData = {}
end)

function OpenCloakroomMenu()
	local elements = {
		{label = 'Kamizelki', value = 'vest_wear'},
		{label = 'Prywatne ubrania', value = 'civil_wear'},
		{label = 'Edytuj strój', value = 'edit_wear'},
	}
	if ESX.PlayerData.job.grade == 1 or ESX.PlayerData.job.grade_permissions["edit_clothes"] then
		table.insert(elements, {label = 'Zapisz strój', value = 'save_wear'})
	end
	table.insert(elements, {label = 'Zapisane stroje', value = 'saved_wear'})

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom_menu', {
		title    = 'Przebieralnia',
		align    = 'center',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'vest_wear' then
			local vestElements = {
				{label = 'Lekka kamizelka', value = 'light_vest'},
				{label = 'Ciężka kamizelka', value = 'heavy_vest'}
			}
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vest_wear_menu', {
				title    = 'Wybierz kamizelkę',
				align    = 'center',
				elements = vestElements
			}, function(data2, menu2)
				if data2.current.value == 'light_vest' then
					SetPedArmour(PlayerPedId(), 50)
				elseif data2.current.value == 'heavy_vest' then
					SetPedArmour(PlayerPedId(), 100)
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		elseif data.current.value == 'civil_wear' then
			exports['skam']:PlayerDressings()
		elseif data.current.value == 'edit_wear' then
			TriggerEvent('esx_skin:openRestrictedMenu', function(data2, menu2)
				menu2.close()
		
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'police_skin_confirm', {
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
					TriggerServerEvent('skam-dressings:saveSharedOutfit', data2.value, skin, 'police')
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
				if ESX.PlayerData.job.grade == 1 or ESX.PlayerData.job.grade_permissions["edit_clothes"]then
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
										end, data2.current.value, 'police')
									end)
								elseif data3.current.value == 'delete_wear' then
									TriggerServerEvent('skam-dressings:removeSharedOutfit', data2.current.value, 'police')
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
								end, data2.current.value, 'police')
							end)
						end
					end, function(data2, menu2)
						menu2.close()
					end)
				else
					ESX.ShowNotification('Brak zapisanych strojów', 'error')
				end
			end, 'police')
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenStashBoard(station)
	local elements = {}

	if ESX.PlayerData.job.grade == 1 or ESX.PlayerData.job.grade_permissions["withdraw_item"] then
		elements[#elements+1] = {label = 'Schowaj przedmiot', value = 'put_stock'}
	else
		elements[#elements+1] = {label = '<span style="color:gray;">Schowaj przedmiot</span>'}
	end

	if ESX.PlayerData.job.grade == 1 or ESX.PlayerData.job.grade_permissions["withdraw_item"] then
		elements[#elements+1] = {label = 'Wyciągnij przedmiot', value = 'get_stock'}
	else
		elements[#elements+1] = {label = '<span style="color:gray;">Wyciągnij przedmiot</span>'}
	end

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open("default", GetCurrentResourceName(), 'PDStashBoardMenu', {
		title    = 'Zbrojownia',
		align    = 'center',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'put_stock' then
			menu.close()
			ESX.TriggerServerCallback('esx_policejob:getPlayerInventory', function(inventory)
				OpenPutStocksMenu(inventory)
			end)
		elseif data.current.value == 'get_stock' then
			menu.close()
			ESX.TriggerServerCallback('esx_policejob:getStockItems', function(items)
				OpenGetStocksMenu(items)
			end)
		else
			TriggerEvent('skam:showNotification', {
				type = 'error',
				title = 'SASP',
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
	ESX.UI.Menu.Open("default", GetCurrentResourceName(), 'PDPutStocksMenu', {
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
					title = 'SASP',
					text = "Nieprawidłowa wartość",
				})
			else
				menu2.close()
				ESX.TriggerServerCallback('esx_policejob:putStockItems', function(inventory_)
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
	ESX.UI.Menu.Open("default", GetCurrentResourceName(), 'PDGetStocksMenu', {
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
					title = 'SASP',
					text = "Nieprawidłowa wartość",
				})
			else
				menu2.close()
				ESX.TriggerServerCallback('esx_policejob:getStockItem', function(data3)
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

function OpenPoliceActionsMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'police_actions', {
		title    = 'SASP',
		align    = 'center',
		elements = {
			{label = _U('citizen_interaction'), value = 'citizen_interaction'},
			{label = _U('vehicle_interaction'), value = 'vehicle_interaction'},
	}}, function(data, menu)
		if data.current.value == 'citizen_interaction' then
			local elements = {
				{label = _U('search'), value = 'search'},
				{label = _U('handcuff'), value = 'handcuff'},
				{label = _U('drag'), value = 'drag'},
				{label = _U('put_in_vehicle'), value = 'put_in_vehicle'},
				{label = _U('out_the_vehicle'), value = 'out_the_vehicle'}
			}

			-- if Config.EnableLicenses then
			-- 	table.insert(elements, {label = _U('license_check'), value = 'license'})
			-- end

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
				title    = _U('citizen_interaction'),
				align    = 'center',
				elements = elements
			}, function(data2, menu2)
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				local closestPed, closestDistancePed = ESX.Game.GetClosestPed()
				if closestPlayer ~= -1 and closestDistance <= 3.0 then
					if data2.current.value == 'search' then
						CanSearch = true
						OpenBodySearchMenu(player)
					elseif data2.current.value == 'handcuff' then
						if IsPedCuffed(closestPed) or IsEntityPlayingAnim(closestPed, 'missminuteman_1ig_2', 'handsup_enter', 3) or Player(GetPlayerServerId(player)).state.dead or IsPedBeingStunned(closestPed) then
							TriggerServerEvent('esx_policejob:handcuff', GetPlayerServerId(closestPlayer))
						else
							ESX.ShowNotification('Gracz nie ma podniesionych rąk', 'error')
						end
					elseif data2.current.value == 'drag' then
						TriggerServerEvent('esx_policejob:drag', GetPlayerServerId(closestPlayer))
					elseif data2.current.value == 'put_in_vehicle' then
						TriggerServerEvent('esx_policejob:putInVehicle', GetPlayerServerId(closestPlayer))
					elseif data2.current.value == 'out_the_vehicle' then
						TriggerServerEvent('esx_policejob:OutVehicle', GetPlayerServerId(closestPlayer))
					elseif data2.current.value == 'license' then
						ShowPlayerLicense(closestPlayer)
					end
				else
					if data.current.value == "search" then
						OpenBodySearchMenuOffline()
					else
						ESX.ShowNotification(_U('no_players_nearby'), "error")
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
				table.insert(elements, {label = _U('vehicle_info'), value = 'vehicle_infos'})
				table.insert(elements, {label = _U('pick_lock'), value = 'hijack_vehicle'})
				table.insert(elements, {label = _U('impound'), value = 'impound'})
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

				if data2.current.value == 'search_database' then
					LookupVehicle()
				elseif DoesEntityExist(vehicle) then
					if data2.current.value == 'vehicle_infos' then
						local vehicleData = ESX.Game.GetVehicleProperties(vehicle)
						OpenVehicleInfosMenu(vehicleData)
					elseif data2.current.value == 'hijack_vehicle' then
						if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 3.0) then
							TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_WELDING', 0, true)
							Wait(20000)
							ClearPedTasksImmediately(playerPed)

							SetVehicleDoorsLocked(vehicle, 1)
							SetVehicleDoorsLockedForAllPlayers(vehicle, false)
							ESX.ShowNotification(_U('vehicle_unlocked'), "error")
						end
					elseif data2.current.value == 'impound' then
						if currentTask.busy then
							return
						end

						ESX.ShowHelpNotification(_U('impound_prompt'))
						TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)

						currentTask.busy = true
						currentTask.task = ESX.SetTimeout(10000, function()
							ClearPedTasks(playerPed)
							ImpoundVehicle(vehicle)
							Wait(100)
						end)

						CreateThread(function()
							while currentTask.busy do
								Wait(1000)

								vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 3.0, 0, 71)
								if not DoesEntityExist(vehicle) and currentTask.busy then
									ESX.ShowNotification(_U('impound_canceled_moved'), "error")
									ESX.ClearTimeout(currentTask.task)
									ClearPedTasks(playerPed)
									currentTask.busy = false
									break
								end
							end
						end)
					elseif data2.current.value == 'fix' then
						TriggerEvent('skam:onRepairKit', true)
					end
				else
					ESX.ShowNotification(_U('no_vehicles_nearby'), "error")
				end

			end, function(data2, menu2)
				menu2.close()
			end)
		end
	end, function(data, menu)
		menu.close()
	end)
end

RegisterNetEvent('skam:onHandcuffs')
AddEventHandler('skam:onHandcuffs', function()
	OpenHandcuffsMenu()
end)

function OpenHandcuffsMenu()
    local elements = {
        {label = 'Zakuj/Rozkuj', value = 'handcuff'},
        {label = 'Przeszukaj', value = 'search'},
        {label = 'Chwyć/Puść', value = 'drag'},
        {label = 'Wsadź do pojazdu', value = 'put_in_vehicle'},
        {label = 'Wyjmij z pojazdu', value = 'out_the_vehicle'},
        {label = 'Skopiuj strój', value = 'steal_clothes'}
    }

    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'skam_handcuffs', {
        title    = 'Kajdanki',
        align    = 'center',
        elements = elements
    }, function(data, menu)
        local inGreenzone = exports['skam']:inGreenzone()
        if not inGreenzone then
            if not exports['skam']:canSearch() then 
                if not IsPedInAnyVehicle(PlayerPedId(), false) then
                    local closestPed, closestDistance = ESX.Game.GetClosestPed()
                    local player = nil

                    if closestPed ~= -1 and closestDistance <= 3.0 then
                        local action = data.current.value
                        
                        if IsPedAPlayer(closestPed) then
                            player = NetworkGetPlayerIndexFromPed(closestPed)
                        end

                        if action == 'search' then
                            if player then
                                OpenBodySearchMenu(player)
                            else
                                OpenBodySearchMenuOffline()
                            end
                        elseif action == 'handcuff' then
                            if not LocalPlayer.state.inBitka and not exports['skam']:canSearch() then
                                if player then
                                    if IsPedCuffed(closestPed) or IsEntityPlayingAnim(closestPed, 'missminuteman_1ig_2', 'handsup_enter', 3) or Player(GetPlayerServerId(player)).state.dead or IsPedBeingStunned(closestPed) then
                                        TriggerServerEvent('esx_policejob:handcuff', GetPlayerServerId(player))
                                    else
                                        ESX.ShowNotification('Gracz nie ma podniesionych rąk', 'error')
                                    end
                                else
                                    TriggerServerEvent('esx_policejob:handcuff', NetworkGetNetworkIdFromEntity(closestPed), true)
                                end
                            else
                                ESX.ShowNotification('Nie możesz zakować nikogo na strefie bez lootu', 'error')
                            end
                        elseif action == 'drag' then
                            if player then
                                TriggerServerEvent('esx_policejob:drag', GetPlayerServerId(player))
                            else
                                TriggerServerEvent('esx_policejob:drag', NetworkGetNetworkIdFromEntity(closestPed), true)
                            end
                        elseif action == 'put_in_vehicle' then
                            if player then
                                TriggerServerEvent('esx_policejob:putInVehicle', GetPlayerServerId(player))
                            end
                        elseif action == 'out_the_vehicle' then
                            if player then
                                TriggerServerEvent('esx_policejob:OutVehicle', GetPlayerServerId(player))
                            end
                        elseif action == 'steal_clothes' then
                            if player then
                                if IsPedCuffed(closestPed) and not Player(GetPlayerServerId(player)).state.dead then
                                    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(otherSkin)
                                        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(mySkin)
                                            if mySkin.sex == otherSkin.sex then
                                                TriggerEvent('skinchanger:loadClothes', mySkin, {
                                                    ['tshirt_1'] = otherSkin.tshirt_1, ['tshirt_2'] = otherSkin.tshirt_2,
                                                    ['torso_1'] = otherSkin.torso_1, ['torso_2'] = otherSkin.torso_2,
                                                    ['pants_1'] = otherSkin.pants_1, ['pants_2'] = otherSkin.pants_2,
                                                    ['shoes_1'] = otherSkin.shoes_1, ['shoes_2'] = otherSkin.shoes_2,
                                                    ['bags_1'] = otherSkin.bags_1, ['bags_2'] = otherSkin.bags_2,
                                                    ['decals_1'] = otherSkin.decals_1, ['decals_2'] = otherSkin.decals_2,
                                                    ['mask_1'] = otherSkin.mask_1, ['mask_2'] = otherSkin.mask_2,
                                                    ['bproof_1'] = otherSkin.bproof_1, ['bproof_2'] = otherSkin.bproof_2,
                                                    ['chain_1'] = otherSkin.chain_1, ['chain_2'] = otherSkin.chain_2,
                                                    ['helmet_1'] = otherSkin.helmet_1, ['helmet_2'] = otherSkin.helmet_2,
                                                    ['glasses_1'] = otherSkin.glasses_1, ['glasses_2'] = otherSkin.glasses_2,
                                                    ['arms'] = otherSkin.arms
                                                })
                                                TriggerEvent('skinchanger:getSkin', function(skin)
                                                    TriggerServerEvent('esx_skin:save', skin)
                                                end)
                                            else
                                                ESX.ShowNotification('Nie możesz zabrać tych ciuchów', 'error')
                                            end
                                        end)
                                    end, GetPlayerServerId(player))
                                else
                                    ESX.ShowNotification('Strój możesz skopiować tylko z żywych osób', 'error')
                                end
                            else
                                ESX.ShowNotification('Gracz nie jest zakuty', 'error')
                            end
                        end
                    else
                        ESX.ShowNotification('Brak graczy/pedów w pobliżu', 'error')
                    end
                else
                    ESX.ShowNotification('Nie możesz zakować nikogo w pojeździe', 'error')
                end
            else
                ESX.ShowNotification('Nie możesz zakować nikogo w strefie bez lootu', 'error')
            end
        else
            ESX.ShowNotification('Nie możesz zakować nikogo w GZ', 'error')
        end
    end, function(data, menu)
        menu.close()
    end)
end

exports('OpenHandcuffsMenu', OpenHandcuffsMenu)

local invisibleItems = {
    ['energydrink'] = true,
    ['narco-coke'] = true,
    ['clip_extended'] = true,
    ['clip_default'] = true,
    ['clip'] = true,
    ['ceramicpistol'] = true,
    ['bandage'] = true,
    ['narco-coke-paczka'] = true,
    ['handcuffs'] = true,
    ['heavypistol'] = true,
    ['narco-meth'] = true,
    ['narco-meth-paczka'] = true,
	['skam_ump45'] = true,
    ['pistol'] = true,
    ['pistol_ammo'] = true,
	['smg_ammo'] = true,
    ['pistol_ammo_box'] = true,
    ['pistol_mk2'] = true,
    ['radio'] = true,
    ['radiocrime'] = true,
    ['repairkit'] = true,
    ['snspistol_mk2'] = true,
    ['snspistol'] = true,
    ['suppressor'] = true,
    ['vintagepistol'] = true,
    ['vest-heavy'] = true,
    ['vest-light'] = true,
    ['vest-medium'] = true,
}

function isItemInvisible(itemName)
	if invisibleItems[itemName] then
		return true
	end
	return false
end

exports('isItemInvisible', isItemInvisible)

function OpenBodySearchMenu(player, reOpened)
	local playerPed = GetPlayerPed(player)

	if not IsPedCuffed(playerPed) then
		return ESX.ShowNotification('Gracz nie jest zakuty', 'error')
	end

	ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(data)
		local elements = {}

		for i=1, #data.inventory, 1 do
			if data.inventory[i].count > 0 and not invisibleItems[data.inventory[i].name] then
				table.insert(elements, {
					label    = _U('confiscate_inv', data.inventory[i].count, data.inventory[i].label),
					value    = data.inventory[i].name,
					itemType = 'item_standard',
					amount   = data.inventory[i].count
				})
			end
		end

		if #elements > 0 then
			if not reOpened then
				ESX.ShowNotification('Przytrzymaj SHIFT, aby zabrać całą ilość danego przedmiotu', 'info')
			end

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'body_search', {
				title    = _U('search'),
				align    = 'center',
				elements = elements
			}, function(data, menu)
				if data.current.value then
					if #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(playerPed)) <= 2.0 then
						if IsControlPressed(0, 21) then
							TriggerServerEvent('esx_policejob:confiscatePlayerItem', GetPlayerServerId(player), data.current.itemType, data.current.value, data.current.amount)
							OpenBodySearchMenu(player, true)
						else
							if data.current.amount > 1 then
								ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'bodysearch_count', {
									title = 'Ilość',
								}, function(data2, menu2)
									local quantity = tonumber(data2.value)
									if not quantity or quantity > data.current.amount then
										ESX.ShowNotification('Nieprawidłowa ilość', 'error')
									else
										menu2.close()
										TriggerServerEvent('esx_policejob:confiscatePlayerItem', GetPlayerServerId(player), data.current.itemType, data.current.value, quantity)
										OpenBodySearchMenu(player, true)
									end
								end, function(data2, menu2)
									menu2.close()
								end)
							else
								TriggerServerEvent('esx_policejob:confiscatePlayerItem', GetPlayerServerId(player), data.current.itemType, data.current.value, data.current.amount)
								OpenBodySearchMenu(player, true)
							end
						end
					end
				end
			end, function(data, menu)
				menu.close()
			end)
		else
			ESX.ShowNotification('Gracz nie posiada przedmiotów', 'error')
			if ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'body_search') then
				ESX.UI.Menu.CloseAll()
			end
		end
	end, GetPlayerServerId(player))
end

-- local offlineBodySearchTable = {}
-- RegisterNetEvent("esx_policejob:droppedPlayer", function(license, coords)
-- 	if #(GetEntityCoords(PlayerPedId()) - coords) < 100.0 then
-- 		offlineBodySearchTable[license] = coords
-- 		local Timeout = ESX.SetTimeout(120000, function()
-- 			offlineBodySearchTable[license] = nil
-- 		end)
-- 	end
-- end)

-- function OpenBodySearchMenuOffline()
-- 	for license, coords in pairs(offlineBodySearchTable) do
-- 		if #(GetEntityCoords(PlayerPedId()) - coords) <= 2.0 then
-- 			ESX.TriggerServerCallback('esx_policejob:getOtherPlayerDataOffline', function(data)
-- 				if not data then return end
-- 				local elements = {}

-- 				for i=1, #data.inventory, 1 do
-- 					if data.inventory[i].count > 0 and not invisibleItems[data.inventory[i].name] then
-- 						if data.inventory[i].label ~= nil then
-- 							table.insert(elements, {
-- 								label    = _U('confiscate_inv', data.inventory[i].count, data.inventory[i].label),
-- 								value    = data.inventory[i].name,
-- 								itemType = 'item_standard',
-- 								amount   = data.inventory[i].count
-- 							})
-- 						end
-- 					end
-- 				end

-- 				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'body_search_offline', {
-- 					title    = _U('search'),
-- 					align    = 'center',
-- 					elements = elements
-- 				}, function(data, menu)
-- 					if data.current.value then
-- 						if #(GetEntityCoords(PlayerPedId()) - coords) <= 2.0 then
-- 							TriggerServerEvent('esx_policejob:confiscatePlayerItemOffline', license, data.current.itemType, data.current.value, data.current.amount)
-- 							OpenBodySearchMenuOffline()
-- 						end
-- 					end
-- 				end, function(data, menu)
-- 					menu.close()
-- 				end)
-- 			end, license)
-- 			break
-- 		end
-- 	end
-- end

function LookupVehicle()
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'lookup_vehicle', {
		title = _U('search_database_title'),
	}, function(data, menu)
		local length = data.value and string.len(data.value) or 0
		if length < 2 or length > 8 then
			ESX.ShowNotification(_U('search_database_error_invalid'))
		else
			ESX.TriggerServerCallback('esx_policejob:getVehicleInfos', function(retrivedInfo)
				local elements = {{label = _U('plate', retrivedInfo.plate)}}
				menu.close()

				if not retrivedInfo.owner then
					table.insert(elements, {label = _U('owner_unknown')})
				else
					table.insert(elements, {label = _U('owner', retrivedInfo.owner)})
				end

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_infos', {
					title    = _U('vehicle_info'),
					align    = 'center',
					elements = elements
				}, nil, function(data2, menu2)
					menu2.close()
				end)
			end, data.value)

		end
	end, function(data, menu)
		menu.close()
	end)
end

function ShowPlayerLicense(player)
	local elements = {}

	ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(playerData)
		if playerData.licenses then
			for i=1, #playerData.licenses, 1 do
				if playerData.licenses[i].label and playerData.licenses[i].type then
					table.insert(elements, {
						label = playerData.licenses[i].label,
						type = playerData.licenses[i].type
					})
				end
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_license', {
			title    = _U('license_revoke'),
			align    = 'center',
			elements = elements,
		}, function(data, menu)
			ESX.ShowNotification(_U('licence_you_revoked', data.current.label, playerData.name))
			TriggerServerEvent('esx_policejob:message', GetPlayerServerId(player), _U('license_revoked', data.current.label))

			TriggerServerEvent('esx_license:removeLicense', GetPlayerServerId(player), data.current.type)

			ESX.SetTimeout(300, function()
				ShowPlayerLicense(player)
			end)
		end, function(data, menu)
			menu.close()
		end)

	end, GetPlayerServerId(player))
end

function OpenVehicleInfosMenu(vehicleData)
	ESX.TriggerServerCallback('esx_policejob:getVehicleInfos', function(retrivedInfo)
		local elements = {{label = _U('plate', retrivedInfo.plate)}}

		if not retrivedInfo.owner then
			table.insert(elements, {label = _U('owner_unknown')})
		else
			table.insert(elements, {label = _U('owner', retrivedInfo.owner)})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_infos', {
			title    = _U('vehicle_info'),
			align    = 'center',
			elements = elements
		}, nil, function(data, menu)
			menu.close()
		end)
	end, vehicleData.plate)
end

function OpenGetWeaponMenu()
	ESX.TriggerServerCallback('esx_policejob:getArmoryWeapons', function(weapons)
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

			ESX.TriggerServerCallback('esx_policejob:removeArmoryWeapon', function()
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

		ESX.TriggerServerCallback('esx_policejob:addArmoryWeapon', function()
			OpenPutWeaponMenu()
		end, data.current.value, true)
	end, function(data, menu)
		menu.close()
	end)
end

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
	if job.name == 'police' then
		Wait(1000)
		TriggerServerEvent('esx_policejob:forceBlip')
	end
end)

AddEventHandler('esx_policejob:hasEnteredMarker', function(station, part, partNum)
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

AddEventHandler('esx_policejob:hasExitedMarker', function(station, part, partNum)
	if not isInShopMenu then
		ESX.UI.Menu.CloseAll()
	end

	CurrentAction = nil
end)

AddEventHandler('esx_policejob:hasEnteredEntityZone', function(entity)
	local playerPed = PlayerPedId()

	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' and IsPedOnFoot(playerPed) then
		CurrentAction     = 'remove_entity'
		CurrentActionMsg  = _U('remove_prop')
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

AddEventHandler('esx_policejob:hasExitedEntityZone', function(entity)
	if CurrentAction == 'remove_entity' then
		CurrentAction = nil
	end
end)

RegisterNetEvent('esx_policejob:handcuff')
AddEventHandler('esx_policejob:handcuff', function()
	isHandcuffed = not isHandcuffed
	local playerPed = PlayerPedId()

	if isHandcuffed then

		ESX.UI.Menu.CloseAll()

		TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 4.5, 'cuff', 0.3)

		RequestAnimDict('mp_arresting')
		while not HasAnimDictLoaded('mp_arresting') do
			Wait(100)
		end

		TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
		RemoveAnimDict('mp_arresting')

		SetEnableHandcuffs(playerPed, true)
		DisablePlayerFiring(playerPed, true)
		SetCurrentPedWeapon(playerPed, `WEAPON_UNARMED`, true) -- unarm player
		SetPedCanPlayGestureAnims(playerPed, false)
		DisplayRadar(false)
		-- exports['skam']:disableHands()

		if Config.EnableHandcuffTimer then
			if handcuffTimer.active then
				ESX.ClearTimeout(handcuffTimer.task)
			end

			StartHandcuffTimer()
		end
	else
		TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 4.5, 'uncuff', 0.3)
		if Config.EnableHandcuffTimer and handcuffTimer.active then
			ESX.ClearTimeout(handcuffTimer.task)
		end

		ClearPedTasks(playerPed)
		SetEnableHandcuffs(playerPed, false)
		DisablePlayerFiring(playerPed, false)
		SetPedCanPlayGestureAnims(playerPed, true)
		DisplayRadar(true)
	end
end)

RegisterNetEvent('esx_policejob:handcuffPed')
AddEventHandler('esx_policejob:handcuffPed', function(netId)
	if NetworkDoesNetworkIdExist(netId) then
		local ped = NetworkGetEntityFromNetworkId(netId)
		if DoesEntityExist(ped) then
			if IsEntityAPed(ped) and not IsPedAPlayer(ped) and not IsEntityAttachedToEntity(ped, PlayerPedId()) then
				local isHandcuffed = not IsPedCuffed(ped)

				if not NetworkHasControlOfEntity(ped) then
				  NetworkRequestControlOfEntity(ped)
		
				  local timeout = 0
				  while not NetworkHasControlOfEntity(ped) and (timeout < 2000) do
					timeout = timeout + 1
		
					Wait(0)
				  end
				end

				if isHandcuffed then
					RequestAnimDict('mp_arresting')
					while not HasAnimDictLoaded('mp_arresting') do
					 	Wait(0)
					end

					TaskPlayAnim(ped, 'mp_arresting', 'idle', 8.0, -8.0, -1, 1, 0.0, 0, 0, 0)
					SetPedKeepTask(ped, true)
		
					CreateThread(function ()
					  while DoesEntityExist(ped) and not IsEntityDead(ped) and IsPedCuffed(ped) do
						if not IsPedInAnyVehicle(ped, true) then
						  if not IsEntityPlayingAnim(ped, 'mp_arresting', 'idle', 3) then
							TaskPlayAnim(ped, 'mp_arresting', 'idle', 8.0, 3.0, -1, 1, 0.0, 0, 0, 0)
							SetBlockingOfNonTemporaryEvents(ped, true)
							SetPedKeepTask(ped, true)
						  end
						else
						  if IsEntityPlayingAnim(ped, 'mp_arresting', 'idle', 3) then
							StopAnimTask(ped, 'mp_arresting', 'idle', 8.0)
						  end
						end
		
						Wait(0)
					  end
					end)

					TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 4.5, 'cuff', 0.3)
					SetCurrentPedWeapon(ped, `weapon_unarmed`, true)
					SetIgnoreLowPriorityShockingEvents(ped, true)
					SetBlockingOfNonTemporaryEvents(ped, true)
					SetPedCanPlayGestureAnims(ped, false)
					SetEnableHandcuffs(ped, true)
		  
					SetPedConfigFlag(ped, 17, true)
					SetPedConfigFlag(ped, 122, true)
					SetPedConfigFlag(ped, 128, false)
					SetPedConfigFlag(ped, 208, true)
					SetPedConfigFlag(ped, 294, true)
					SetPedConfigFlag(ped, 430, true)
					SetRagdollBlockingFlags(ped, 16)
		  
					SetEntityAsMissionEntity(ped, true, true)
					SetPedRelationshipGroupHash(ped, `skam_cuffedped`)
				else
					TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 4.5, 'uncuff', 0.3)
					local group = GetPedRelationshipGroupDefaultHash(ped)
					SetPedRelationshipGroupHash(ped, group)
		  
					SetBlockingOfNonTemporaryEvents(ped, false)
					SetPedCanPlayGestureAnims(ped, true)
					SetEnableHandcuffs(ped, false)
		   
					SetPedResetFlag(ped, 17, true)
					SetPedResetFlag(ped, 122, true)
					SetPedResetFlag(ped, 128, true)
					SetPedResetFlag(ped, 208, true)
					SetPedResetFlag(ped, 294, true)
					SetPedResetFlag(ped, 430, true)
					ClearRagdollBlockingFlags(ped, 16)
		  
					SetEntityAsNoLongerNeeded(ped)
					ClearPedTasksImmediately(ped)
				end
			end
		end
	end
end)

RegisterNetEvent('esx_policejob:unrestrain')
AddEventHandler('esx_policejob:unrestrain', function()
	if isHandcuffed then
		local playerPed = PlayerPedId()
		isHandcuffed = false

		ClearPedSecondaryTask(playerPed)
		SetEnableHandcuffs(playerPed, false)
		DisablePlayerFiring(playerPed, false)
		SetPedCanPlayGestureAnims(playerPed, true)
		DisplayRadar(true)

		-- end timer
		if Config.EnableHandcuffTimer and handcuffTimer.active then
			ESX.ClearTimeout(handcuffTimer.task)
		end
	end
end)

RegisterNetEvent('esx_policejob:drag')
AddEventHandler('esx_policejob:drag', function(copId)
	if isHandcuffed or LocalPlayer.state.dead then
		dragStatus.isDragged = not dragStatus.isDragged
		dragStatus.CopId = copId
	end
end)

RegisterNetEvent('esx_policejob:dragPed')
AddEventHandler('esx_policejob:dragPed', function(netId)
  if NetworkDoesNetworkIdExist(netId) then
    local ped = NetworkGetEntityFromNetworkId(netId)

    if DoesEntityExist(ped) then
      if IsEntityAPed(ped) and not IsPedAPlayer(ped) then
        if IsPedCuffed(ped) or IsEntityDead(ped) then
          local playerPed = PlayerPedId()
        
          if not IsEntityAttachedToAnyPed(ped) then
            if not IsEntityAttachedToAnyPed(playerPed) then
              
              AttachEntityToEntity(ped, playerPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)

              while IsEntityAttachedToEntity(ped, playerPed) do
                if DoesEntityExist(GetVehiclePedIsTryingToEnter(ped)) and not LocalPlayer.state.dead then
                  DetachEntity(ped, true, false)

                  break
                end

                Wait(0)
              end

            end
          elseif IsEntityAttachedToEntity(ped, playerPed) then
            DetachEntity(ped, true, false)
          end
        end
      end
    end
  end
end)

CreateThread(function()
	local wasDragged

	while true do
		local Sleep = 500

		if dragStatus.isDragged then
			Sleep = 50
			local targetPed = GetPlayerPed(GetPlayerFromServerId(dragStatus.CopId))

			if DoesEntityExist(targetPed) then
				if not wasDragged then
					AttachEntityToEntity(ESX.PlayerData.ped, targetPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
					wasDragged = true
				else
					Wait(1000)
				end
			else
				wasDragged = false
				dragStatus.isDragged = false
				DetachEntity(ESX.PlayerData.ped, true, false)
			end
		elseif wasDragged then
			wasDragged = false
			DetachEntity(ESX.PlayerData.ped, true, false)
		end
		Wait(Sleep)
	end
end)

RegisterNetEvent('esx_policejob:putInVehicle')
AddEventHandler('esx_policejob:putInVehicle', function()
	if isHandcuffed then
		local playerPed = PlayerPedId()
		local vehicle, distance = ESX.Game.GetClosestVehicle()

		if vehicle and distance < 5 then
			local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)

			for i=maxSeats - 1, 0, -1 do
				if IsVehicleSeatFree(vehicle, i) then
					freeSeat = i
					break
				end
			end

			if freeSeat then
				TaskWarpPedIntoVehicle(playerPed, vehicle, freeSeat)
				dragStatus.isDragged = false
			end
		end
	end
end)

RegisterNetEvent('esx_policejob:OutVehicle')
AddEventHandler('esx_policejob:OutVehicle', function()
	if isHandcuffed then
		local GetVehiclePedIsIn = GetVehiclePedIsIn
		local IsPedSittingInAnyVehicle = IsPedSittingInAnyVehicle
		local TaskLeaveVehicle = TaskLeaveVehicle
		if IsPedSittingInAnyVehicle(ESX.PlayerData.ped) then
			local vehicle = GetVehiclePedIsIn(ESX.PlayerData.ped, false)
			TaskLeaveVehicle(ESX.PlayerData.ped, vehicle, 64)
		end
	end
end)

-- Handcuff
CreateThread(function()
	local DisableControlAction = DisableControlAction
	local IsEntityPlayingAnim = IsEntityPlayingAnim
	while true do
		local Sleep = 1000

		if isHandcuffed then
			Sleep = 0
			DisableControlAction(0, 24, true) -- Attack
			DisableControlAction(0, 257, true) -- Attack 2
			DisableControlAction(0, 25, true) -- Aim
			DisableControlAction(0, 263, true) -- Melee Attack 1

			DisableControlAction(0, 45, true) -- Reload
			DisableControlAction(0, 22, true) -- Jump
			DisableControlAction(0, 44, true) -- Cover
			DisableControlAction(0, 37, true) -- Select Weapon
			DisableControlAction(0, 23, true) -- Also 'enter'?

			DisableControlAction(0, 288,  true) -- Disable phone
			DisableControlAction(0, 289, true) -- Inventory
			DisableControlAction(0, 170, true) -- Animations
			DisableControlAction(0, 167, true) -- Job

			DisableControlAction(0, 73, true) -- Disable clearing animation
			DisableControlAction(2, 199, true) -- Disable pause screen

			DisableControlAction(0, 59, true) -- Disable steering in vehicle
			DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
			DisableControlAction(0, 72, true) -- Disable reversing in vehicle

			DisableControlAction(2, 36, true) -- Disable going stealth

			DisableControlAction(0, 47, true)  -- Disable weapon
			DisableControlAction(0, 264, true) -- Disable melee
			DisableControlAction(0, 257, true) -- Disable melee
			DisableControlAction(0, 140, true) -- Disable melee
			DisableControlAction(0, 141, true) -- Disable melee
			DisableControlAction(0, 142, true) -- Disable melee
			DisableControlAction(0, 143, true) -- Disable melee
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle

			DisableControlAction(0, 21, true) -- Sprint

			if IsEntityPlayingAnim(ESX.PlayerData.ped, 'mp_arresting', 'idle', 3) ~= 1 then
				ESX.Streaming.RequestAnimDict('mp_arresting', function()
					TaskPlayAnim(ESX.PlayerData.ped, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
					RemoveAnimDict('mp_arresting')
				end)
			end
		end
	Wait(Sleep)
	end
end)

CreateThread(function()
	for k,v in pairs(Config.PoliceStations) do
		local blip = AddBlipForCoord(v.Blip.Coords)

		SetBlipSprite (blip, 60)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, 0.8)
		SetBlipColour (blip, 29)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName(_U('map_blip'))
		EndTextCommandSetBlipName(blip)
	end
end)

SKAM.RegisterPlace({
	coords = vector3(-581.4646, -427.5160, 31.1603),
	Marker = { size = vector3(2.0, 2.0, 0.3), dist = 5.0 },
	pedModel = { model = 'csb_trafficwarden', heading = 0.0 },
	txt3d = 'otworzyć menu pojazdów',
	onPress = function()
		if ESX.PlayerData.job.name == 'police' then
			if not IsPedInAnyVehicle(PlayerPedId(), false) then
				OpenVehicleSpawnerMenu('car', "LSPD", Vehicles, 1)
			end
		end
	end,
	jobs = 'police'
})

SKAM.RegisterPlace({
	coords = vector3(-605.5781, -416.6281, 35.1721),
	Marker = { size = vector3(2.0, 2.0, 0.3), dist = 5.0 },
	pedModel = { model = 'ig_michelle', heading = 0.0 },
	txt3d = 'otworzyć szatnię',
	onPress = function()
		if ESX.PlayerData.job.name == 'police' then
			if not IsPedInAnyVehicle(PlayerPedId(), false) then
				OpenCloakroomMenu()
			end
		end
	end,
	jobs = 'police'
})

SKAM.RegisterPlace({
	coords = vector3(-608.4526, -411.8459, 35.1720),
	Marker = { size = vector3(2.0, 2.0, 0.3), dist = 5.0 },
	pedModel = { model = 's_m_y_swat_01', heading = 0.0 },
	txt3d = 'otworzyć zbrojownię',
	onPress = function()
		if ESX.PlayerData.job.name == 'police' then
			if not IsPedInAnyVehicle(PlayerPedId(), false) then
				OpenStashBoard("LSPD")
			end
		end
	end,
	jobs = 'police'
})

SKAM.RegisterPlace({
	coords = vector3(-566.7425, -418.2988, 39.6326),
	Marker = { size = vector3(2.0, 2.0, 0.3), dist = 5.0 },
	pedModel = { model = 's_m_y_swat_01', heading = 0.0 },
	txt3d = 'otworzyć menu szefa',
	onPress = function()
		if not IsPedInAnyVehicle(PlayerPedId(), false) then
			if ESX.PlayerData.job.grade == 1 or ESX.PlayerData.job.grade_permissions["members_menager"] then
				OpenBossMenu()
			else
				TriggerEvent('skam:showNotification', {
					type = 'error',
					title = 'SASP',
					text = "Nie masz uprawnień, aby tego użyć"
				})
			end
		end
	end,
	jobs = 'police'
})

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
				TriggerEvent('esx_policejob:hasEnteredEntityZone', closestEntity)
				LastEntity = closestEntity
			end
		else
			if LastEntity then
				TriggerEvent('esx_policejob:hasExitedEntityZone', LastEntity)
				LastEntity = nil
			end
		end
		Wait(Sleep)
	end
end)

ESX.RegisterInput("police:interact", "Interakcje (Policja)", "keyboard", "E", function()
	if not CurrentAction then
		return
	end

	if not ESX.PlayerData.job or (ESX.PlayerData.job and not ESX.PlayerData.job.name == 'police') then
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

		if ESX.PlayerData.job.grade == 1 or ESX.PlayerData.job.grade_permissions["members_menager"] then
			OpenBossMenu()
		else
			TriggerEvent('skam:showNotification', {
				type = 'error',
				title = 'SASP',
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

	if ESX.PlayerData.job.grade == 1 or ESX.PlayerData.job.grade_permissions["withdraw_money"] or ESX.PlayerData.job.grade_permissions["deposit_money"] then
		elements[#elements+1] = {label = "Konto", value = "bank"}
	else
		elements[#elements+1] = {label = '<span style="color:gray;">Konto</span>'}
	end

	if ESX.PlayerData.job.grade == 1 then
		elements[#elements+1] = {label = "Rangi", value = "grades"}
	else
		elements[#elements+1] = {label = '<span style="color:gray;">Rangi</span>'}
	end

	if ESX.PlayerData.job.grade == 1 or ESX.PlayerData.job.grade_permissions["members_menager"] then
		elements[#elements+1] = {label = "Licencje", value = "licenses"}
	else
		elements[#elements+1] = {label = '<span style="color:gray;">Licencje</span>'}
	end

	if ESX.PlayerData.job.grade == 1 or ESX.PlayerData.job.grade_permissions["members_menager"] then
		elements[#elements+1] = {label = "Członkowie", value = "members"}
	else
		elements[#elements+1] = {label = '<span style="color:gray;">Członkowie</span>'}
	end

	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "PDBossMenu", {
		title    = "Menu szefa SASP",
		align    = "center",
		elements = elements
	}, function(data, menu)

		if data.current.value == "grades" then
			menu.close()
			ESX.TriggerServerCallback("esx_policejob:GetGrades", function(grades)
				OpenGradesMenu(grades)
			end)
		elseif data.current.value == "members" then
			menu.close()
			ESX.TriggerServerCallback("esx_policejob:GetMembers", function(members)
				OpenMembersMenu(members)
			end)
		elseif data.current.value == "bank" then
			menu.close()
			ESX.TriggerServerCallback("esx_policejob:getAccount", function(orgMoney_, playerMoney_)
				OpenAccountMenu(orgMoney_, playerMoney_)
			end)
		elseif data.current.value == "licenses" then
			menu.close()
			ESX.TriggerServerCallback("esx_policejob:getLicenseDataOfPsiaki", function(players, licensesCfg)
				OpenLicensesMenu(players, licensesCfg)
			end)
		else
			TriggerEvent('skam:showNotification', {
				type = 'error',
				title = 'SASP',
				text = "Nie masz uprawnień, aby tego użyć"
			})
		end

	end, function(data, menu)
		menu.close()
	end)
end

function DynamicInputMenu(title)
	local result = nil
	ESX.UI.Menu.Open("dialog", GetCurrentResourceName(), "PDMenu", {
		title = title
	}, function(data, menu)
		menu.close()

		ESX.TriggerServerCallback("esx_policejob:GetGrades", function(grades)
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
						title = 'SASP',
						text = "Nazwa rangi musi mieć do 30 znaków"
					})
					result = false
				elseif string.len(data.value) < 4 then
					TriggerEvent('skam:showNotification', {
						type = 'error',
						title = 'SASP',
						text = "Nazwa rangi musi mieć co najmniej 4 znaki"
					})
					result = false
				elseif used then
					TriggerEvent('skam:showNotification', {
						type = 'error',
						title = 'SASP',
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

	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "PDGradesMenu", {
		title    = "Menu Rang",
		align    = "center",
		elements = elements
	}, function(data, menu)
		menu.close()

		if data.current.addNew then
			local name = DynamicInputMenu("Podaj nazwę rangi")
			if name then
				OpenNewGradePermissionsMenu(name, nil)
			else
				ESX.TriggerServerCallback("esx_policejob:GetGrades", function(grades)
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

	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "PDNewGradePermissionsMenu", {
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
			ESX.TriggerServerCallback("esx_policejob:AddNewGrade", function(grades)
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
		ESX.TriggerServerCallback("esx_policejob:GetGrades", function(grades)
			OpenGradesMenu(grades)
		end)
	end)
end

function OpenSpecifiedGradeMenu(grade)
	local elements = {
		{label = "Zmień nazwę", value = "name"},
	}

	if grade.id and grade.id > 1 then
		elements[#elements+1] = {label = "Zmień uprawnienia", value = "perms"}
		elements[#elements+1] = {label = "Posiadacze rangi", value = "members"}
		elements[#elements+1] = {label = '<span style="color:red;"><b>Usuń</b></span>', value = "remove"}
	end

	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "PDSpecifiedGradeMenu", {
		title    = grade.label,
		align    = "center",
		elements = elements
	}, function(data, menu)
		menu.close()

		if data.current.value == "members" then

			ESX.TriggerServerCallback("esx_policejob:GetMembers", function(members)
				OpenMembersMenu(members, grade)
			end, grade.id)

		elseif data.current.value == "name" then

			local name = DynamicInputMenu("Podaj nową nazwę rangi")
			if name then
				ESX.TriggerServerCallback("esx_policejob:ChangeGradeName", function(grades)
					TriggerEvent('skam:showNotification', {
						type = 'success',
						title = 'SASP',
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
				title = 'SASP',
				text = "Wyrzuci to wszystkie osoby posiadające tą range",
				duration = 10000
			})
			ESX.UI.Menu.Open("default", GetCurrentResourceName(), "PDtruefalseMenu", {
				title    = 'Czy na pewno chcesz usunąć: "'..grade.label..'"',
				align    = "center",
				elements = {
					{label = "Nie", value = false},
                	{label = "Tak", value = true},
				}
			}, function(data2, menu2)
				menu2.close()
				if data2.current.value then
					ESX.TriggerServerCallback("esx_policejob:RemoveGrade", function(grades)
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
		ESX.TriggerServerCallback("esx_policejob:GetGrades", function(grades)
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

	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "PDSpecifiedGradePermsMenu", {
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
			ESX.TriggerServerCallback("esx_policejob:UpdateGrade", function(grades)
				TriggerEvent('skam:showNotification', {
					type = 'success',
					title = 'SASP',
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

	if ESX.PlayerData.job.grade == 1 or ESX.PlayerData.job.grade_permissions["members_menager"] then
		elements[#elements+1] = {label = "<b>Dodaj psiaka</b>", addNew = true}
	else
		elements[#elements+1] = {label = '<span style="color:gray;"><b>Dodaj psiaka</b></span>', noPerm = true}
	end

	if ESX.PlayerData.job.grade == 1 then
		elements[#elements+1] = {label = '<span style="color:red;"><b>Zresetuj godziny</b></span>', hoursReset = true}
	end

	local gradesQuantity = 1

	for identifier, xPlayer in pairs(members) do
		if xPlayer.job.grade > gradesQuantity then
			gradesQuantity = xPlayer.job.grade
		end
	end

	for i = 1, gradesQuantity do
		for identifier, xPlayer in pairs(members) do
			if xPlayer.online and xPlayer.job.grade == i then

				if not xPlayer.duty_hours then
					xPlayer.duty_hours = 0
				end

				local hours, remainingMinutes = minutesToHoursAndMinutes(xPlayer.duty_hours)

				if grade then
					elements[#elements+1] = {label = xPlayer.name.." ("..hours.." godzin, "..remainingMinutes.." minut)", value = xPlayer}
				else
					elements[#elements+1] = {label = xPlayer.name.." ("..hours.." godzin, "..remainingMinutes.." minut) ["..xPlayer.job.grade_name.."]", value = xPlayer}
				end
			end
		end
	end

	for i = 1, gradesQuantity do
		for identifier, xPlayer in pairs(members) do
			if not xPlayer.online and xPlayer.job.grade == i then

				if not xPlayer.duty_hours then
					xPlayer.duty_hours = 0
				end

				local hours, remainingMinutes = minutesToHoursAndMinutes(xPlayer.duty_hours)

				if grade then
					elements[#elements+1] = {label = '<span style="color:gray;">'..xPlayer.name.." ("..hours.." godzin, "..remainingMinutes.." minut)"..'</span>', value = xPlayer}
				else
					elements[#elements+1] = {label = '<span style="color:gray;">'..xPlayer.name..'</span>'.." ("..hours.." godzin, "..remainingMinutes.." minut) ["..xPlayer.job.grade_name.."]", value = xPlayer}
				end
			end
		end
	end

	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "PDMembersMenu", {
		title    = grade and "Lista psiaka ["..grade.label.."]" or "Lista psiaka",
		align    = "center",
		elements = elements
	}, function(data, menu)
		menu.close()

		if data.current.addNew then
			if grade then
				ESX.TriggerServerCallback("esx_policejob:GetNearPlayers", function(nearPlayers)
					OpenSelectPlayerToIviteMenu(nearPlayers, grade)
				end)
			else
				ESX.TriggerServerCallback("esx_policejob:GetGrades", function(grades)
					OpenSelectGradeToIviteMenu(grades)
				end)
			end
		elseif data.current.noPerm then
			TriggerEvent('skam:showNotification', {
				type = 'error',
				title = 'SASP',
				text = "Nie masz uprawnień, aby tego użyć",
			})
		elseif data.current.hoursReset then
			ESX.TriggerServerCallback("esx_policejob:ResetDutyHours", function()
				ESX.ShowNotification('Pomyślnie zresetowano godziny dla wszystkich PD', 'success')
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

	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "PDSelectGradeToIviteMenu", {
		title    = "Wybierz rangę",
		align    = "center",
		elements = elements
	}, function(data, menu)

		if data.current.id > 1 then
			menu.close()
			ESX.TriggerServerCallback("esx_policejob:GetNearPlayers", function(nearPlayers)
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

	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "PDSelectPlayerToIviteMenu", {
		title    = "Wybierz gracza",
		align    = "center",
		elements = elements
	}, function(data, menu)
		menu.close()

		TriggerServerEvent("esx_policejob:server:AskToJoin", data.current.value, grade)

	end, function(data, menu)
		menu.close()
		OpenBossMenu()
	end)
end

RegisterNetEvent("esx_policejob:client:AskToJoin", function(senderId, grade)
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "PDtruefalse2Menu", {
		title    = 'Czy chcesz dołączyć do: "SASP"?',
		align    = "center",
		elements = {
			{label = "Nie", value = false},
			{label = "Tak", value = true},
		}
	}, function(data, menu)
		menu.close()
		TriggerEvent('skam:showNotification', {
			type = 'info',
			title = 'SASP',
			text = 'Dołączono do "SASP" na stanowisko "'..grade.label..'"',
		})
		TriggerServerEvent("esx_policejob:server:ResponseToJoin", senderId, grade, data.current.value)
	end, function(data, menu)
		menu.close()
	end)
end)

function OpenSpecifiedMemberMenu(xPlayer)
	local elements = {
		{label = xPlayer.online and '<span style="color:green;">Online</span>' or '<span style="color:red;">Offline</span>'},
	}

	if xPlayer.job.grade > ESX.PlayerData.job.grade then
		elements[#elements+1] = {label = 'Zmień range', value = "changeMemberGrade"}
		elements[#elements+1] = {label = '<span style="color:red;"><b>Wyrzuć</b></span>', value = "kickMember"}
	end

	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "PDSpecifiedMemberMenu", {
		title    = xPlayer.name,
		align    = "center",
		elements = elements
	}, function(data, menu)

		if data.current.value == "changeMemberGrade" then
			menu.close()
			ESX.TriggerServerCallback("esx_policejob:GetGrades", function(grades)
				OpenChangeMemberGradeMenu(xPlayer, grades)
			end)
		elseif data.current.value == "kickMember" then
			menu.close()

			ESX.UI.Menu.Open("default", GetCurrentResourceName(), "PDtruefalse3Menu", {
				title    = 'Czy na pewno chcesz wyrzucić: "'..xPlayer.name..'"',
				align    = "center",
				elements = {
					{label = "Nie", value = false},
                	{label = "Tak", value = true},
				}
			}, function(data2, menu2)
				menu2.close()
				if data2.current.value then
					ESX.TriggerServerCallback("esx_policejob:KickMember", function()
						TriggerEvent('skam:showNotification', {
							type = 'success',
							title = 'SASP',
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
		if xPlayer.job.grade == elements[i].id or elements[i].id <= ESX.PlayerData.job.grade then
			elements[i].label = '<span style="color:gray;">'..elements[i].label..'</span>'
			elements[i].disable = true
		end
	end

	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "PDChangeMemberGradeMenu", {
		title    = "Wybierz rangę",
		align    = "center",
		elements = elements
	}, function(data, menu)

		if not data.current.disable then
			menu.close()
			ESX.TriggerServerCallback("esx_policejob:ChangeMemberRank", function(newxPlayer)
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
		head = {"FP", "SEU", "ASU", "C.T.T.F", "HWP", "Zarząd", "MR", "Akcje"},
		rows = {}
	}

	for k, v in pairs(data) do
		local allowedLicenses = {
			['seu_pd'] = '❌',
			['heli_pd'] = '❌',
			['cttf_pd'] = '❌',
			['hwp_pd'] = '❌',
			['cs_pd'] = '❌',
			['mr_pd'] = '❌',
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
				allowedLicenses['seu_pd'],
				allowedLicenses['heli_pd'],
				allowedLicenses['cttf_pd'],
				allowedLicenses['hwp_pd'],
				allowedLicenses['cs_pd'],
				allowedLicenses['mr_pd'],
				'{{' .. "Nadaj licencję" .. '|add}} {{' .. "Odbierz licencję" .. '|revoke}}'
			}
		}
	end

	table.sort(elements.rows, function(a, b)
		return a.cols[1] < b.cols[1]
	end)

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'pd_licenses', elements, function(data, menu)
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
	ESX.UI.Menu.Open("default", GetCurrentResourceName(), 'pd_manage_licenses', {
		title    = '--- Licencje ---',
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)
		if data.current.value then
			ESX.TriggerServerCallback('skam:manageLiceses', function(cb)
				if cb then
					TriggerEvent('skam:showNotification', {
						type = 'success',
						title = 'SASP',
						text = 'Pomyślnie zmieniono licencje dla gracza',
					})
					menu.close()
					ESX.TriggerServerCallback("esx_policejob:getLicenseDataOfPsiaki", function(players, licensesCfg)
						OpenLicensesMenu(players, licensesCfg)
					end)
				end
			end, member.identifier, data.current.value, status)
		end
	end, function(data, menu)
		menu.close()
		ESX.TriggerServerCallback("esx_policejob:getLicenseDataOfPsiaki", function(players, licensesCfg)
			OpenLicensesMenu(players, licensesCfg)
		end)
	end)
end

function OpenAccountMenu(orgMoney, playerMoney)
	local elements = {
		{label = '<span style="color:gray;">Sejf: '..orgMoney..'</span>'},
		{label = '<span style="color:gray;">Twoja gotówka: '..playerMoney..'</span>'},
	}

	if ESX.PlayerData.job.grade == 1 or ESX.PlayerData.job.grade_permissions["deposit_money"] then
		elements[#elements+1] = {label = 'Schowaj gotówkę', value = 'put_money'}
	else
		elements[#elements+1] = {label = '<span style="color:gray;">Schowaj gotówkę</span>', value = "no_perm"}
	end

	if ESX.PlayerData.job.grade == 1 or ESX.PlayerData.job.grade_permissions["withdraw_money"] then
		elements[#elements+1] = {label = 'Wyciągnij gotówkę', value = 'get_money'}
	else
		elements[#elements+1] = {label = '<span style="color:gray;">Wyciągnij gotówkę</span>', value = "no_perm"}
	end

	ESX.UI.Menu.Open("default", GetCurrentResourceName(), 'PDStashBoardMenu', {
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
						title = 'SASP',
						text = "Nieprawidłowa wartość",
					})
				else
					menu.close()
					menu2.close()
					ESX.TriggerServerCallback('esx_policejob:putMoney', function(orgMoney_, playerMoney_)
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
						title = 'SASP',
						text = "Nieprawidłowa wartość",
					})
				else
					menu.close()
					menu2.close()
					ESX.TriggerServerCallback('esx_policejob:getMoney', function(orgMoney_, playerMoney_)
						OpenAccountMenu(orgMoney_, playerMoney_)
					end, tonumber(data2.value))
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		elseif data.current.value == 'no_perm' then
			TriggerEvent('skam:showNotification', {
				type = 'error',
				title = 'SASP',
				text = "Nie masz uprawnień, aby tego użyć",
			})
		end
	end, function(data, menu)
		menu.close()
		OpenBossMenu()
	end)
end

ESX.RegisterInput("police:quickactions", "Menu policyjne", "keyboard", "F6", function()
	if not ESX.PlayerData.job or (ESX.PlayerData.job.name ~= 'police') or isDead or isHandcuffed then
		return
	end

	if not Config.EnableESXService then
		OpenPoliceActionsMenu()
	elseif playerInService then
		OpenPoliceActionsMenu()
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

function createBlip(id)
	local ped = GetPlayerPed(id)
	local blip = GetBlipFromEntity(ped)

	if not DoesBlipExist(blip) then
		blip = AddBlipForEntity(ped)
		SetBlipSprite(blip, 1)
		ShowHeadingIndicatorOnBlip(blip, true)
		SetBlipRotation(blip, math.ceil(GetEntityHeading(ped)))
		SetBlipNameToPlayerName(blip, id)
		SetBlipScale(blip, 0.85)
		SetBlipAsShortRange(blip, true)

		table.insert(blipsCops, blip)
	end
end

RegisterNetEvent('esx_policejob:updateBlip')
AddEventHandler('esx_policejob:updateBlip', function()
	for k, existingBlip in pairs(blipsCops) do
		RemoveBlip(existingBlip)
	end

	blipsCops = {}

	if Config.EnableESXService and not playerInService then
		return
	end

	-- if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' then -- TODO
	-- 	ESX.TriggerServerCallback('esx_society:getOnlinePlayers', function(players)
	-- 		for i=1, #players, 1 do
	-- 			if players[i].job.name == 'police' then
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
	TriggerEvent('esx_policejob:unrestrain')

	if not hasAlreadyJoined then
		TriggerServerEvent('esx_policejob:spawned')
	end
	hasAlreadyJoined = true
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	isDead = true
	TriggerServerEvent("esx_policejob:death-offlineBodySearch")
end)

AddEventHandler('playerSpawned', function()
	TriggerServerEvent("esx_policejob:revive-offlineBodySearch")
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('esx_policejob:unrestrain')

		if Config.EnableESXService then
			TriggerServerEvent('esx_service:disableService', 'police')
		end

		if Config.EnableHandcuffTimer and handcuffTimer.active then
			ESX.ClearTimeout(handcuffTimer.task)
		end
	end
end)

function StartHandcuffTimer()
	if Config.EnableHandcuffTimer and handcuffTimer.active then
		ESX.ClearTimeout(handcuffTimer.task)
	end

	handcuffTimer.active = true
	handcuffTimer.task = ESX.SetTimeout(Config.HandcuffTimer, function()
		ESX.ShowNotification(_U('unrestrained_timer'), "error")
		TriggerEvent('esx_policejob:unrestrain')
		handcuffTimer.active = false
	end)
end

function ImpoundVehicle(vehicle)
	--local vehicleName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
	ESX.Game.DeleteVehicle(vehicle)
	ESX.ShowNotification(_U('impound_successful'), "error")
	currentTask.busy = false
end

if ESX.PlayerLoaded and ESX.PlayerData.job == 'police' then
	SetTimeout(1000, function()
		TriggerServerEvent('esx_policejob:forceBlip')
	end)
end

RegisterNetEvent('esx_policejob:send1013')
AddEventHandler('esx_policejob:send1013', function(coords)
	PlaySoundFrontend(-1, "TIMER_STOP", "HUD_MINI_GAME_SOUNDSET", 1)
	local transG = 250
	local emergencyBlip = AddBlipForCoord(coords)
	SetBlipSprite(emergencyBlip, 42)
	SetBlipAlpha(emergencyBlip, transG)
	SetBlipAsShortRange(emergencyBlip, true)
	SetBlipScale(emergencyBlip, 0.6)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('# Ranny Funkcjonariusz!')
	EndTextCommandSetBlipName(emergencyBlip)
	SetTimeout(30000, function()
		RemoveBlip(emergencyBlip)
	end)
end)

RegisterNetEvent('esx_policejob:sendCode0')
AddEventHandler('esx_policejob:sendCode0', function(coords)
	PlaySoundFrontend(-1, "TIMER_STOP", "HUD_MINI_GAME_SOUNDSET", 1)
	local transG = 250
	local emergencyBlip = AddBlipForCoord(coords)
	SetBlipSprite(emergencyBlip, 280)
	SetBlipAlpha(emergencyBlip, transG)
	SetBlipColour(emergencyBlip, 1)
	SetBlipAsShortRange(emergencyBlip, true)
	SetBlipScale(emergencyBlip, 1.2)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('# Potrzebne wsparcie')
	EndTextCommandSetBlipName(emergencyBlip)
	SetTimeout(30000, function()
		RemoveBlip(emergencyBlip)
	end)
end)

local pedsRobbing = {}

CreateThread(function ()
	RequestAnimDict('rcmminute2')
	while not HasAnimDictLoaded('rcmminute2') do
		Wait(0)
	end

	while true do
		local playerPed = PlayerPedId()

		if IsPedArmed(playerPed, 4) then
			if IsAimCamActive() then
				local src = GetEntityCoords(playerPed)
				local dest = GetObjectOffsetFromCoords(src, GetEntityHeading(playerPed), 0.0, 6.0, 0.0)
				local shapeTest = StartExpensiveSynchronousShapeTestLosProbe(src.x, src.y, src.z, dest.x, dest.y, dest.z, 12, 0, 4)
				local entity = table.pack(GetShapeTestResult(shapeTest))[5]

				if DoesEntityExist(entity) then
					if IsEntityAPed(entity) and IsPedHuman(entity) and not IsPedAPlayer(entity) and not IsPedFleeing(entity) and not IsPedCuffed(entity) and not IsEntityDead(entity) and not IsEntityPositionFrozen(entity) then
						if not pedsRobbing[entity] then
							pedsRobbing[entity] = true
							
							if IsPedUsingAnyScenario(entity) then
								SetCurrentPedWeapon(entity, `weapon_unarmed`, true)
							end

							ClearPedTasksImmediately(entity)

							TaskPlayAnim(entity, 'rcmminute2', 'handsup', 8.0, -8.0, -1, 1, 1.0, false, false, false)
							SetBlockingOfNonTemporaryEvents(entity, true)
							SetRagdollBlockingFlags(entity, 16)
							SetEntityAsMissionEntity(entity, true, true)

							SetTimeout(8000, function ()
								if DoesEntityExist(entity) and not IsEntityDead(entity) then
									if IsEntityPlayingAnim(entity, 'rcmminute2', 'handsup', 3) then
										StopAnimTask(entity, 'rcmminute2', 'handsup', 4.0)

										TaskSmartFleePed(entity, playerPed, 50.0, 30000, false, false)
										SetBlockingOfNonTemporaryEvents(entity, false)
										ClearRagdollBlockingFlags(entity, 16)
										SetEntityAsNoLongerNeeded(entity)
									end
								end
				
								pedsRobbing[entity] = nil
							end)
						end
					end
				end
			end
		end
		Wait(1000)
	end
end)