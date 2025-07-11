local pickups = {}
local Keys = {
	['ESC'] = 322, ['F1'] = 288, ['F2'] = 289, ['F3'] = 170, ['F5'] = 166, ['F6'] = 167, ['F7'] = 168, ['F8'] = 169, ['F9'] = 56, ['F10'] = 57, 
	['~'] = 243, ['1'] = 157, ['2'] = 158, ['3'] = 160, ['4'] = 164, ['5'] = 165, ['6'] = 159, ['7'] = 161, ['8'] = 162, ['9'] = 163, ['-'] = 84, ['='] = 83, ['BACKSPACE'] = 177, 
	['TAB'] = 37, ['Q'] = 44, ['W'] = 32, ['E'] = 38, ['R'] = 45, ['T'] = 245, ['Y'] = 246, ['U'] = 303, ['P'] = 199, ['['] = 39, [']'] = 40, ['ENTER'] = 18,
	['CAPS'] = 137, ['A'] = 34, ['S'] = 8, ['D'] = 9, ['F'] = 23, ['G'] = 47, ['H'] = 74, ['K'] = 311, ['L'] = 182,
	['LEFTSHIFT'] = 21, ['Z'] = 20, ['X'] = 73, ['C'] = 26, ['V'] = 0, ['B'] = 29, ['N'] = 249, ['M'] = 244, [','] = 82, ['.'] = 81,
	['LEFTCTRL'] = 36, ['LEFTALT'] = 19, ['SPACE'] = 22, ['RIGHTCTRL'] = 70, 
	['HOME'] = 213, ['PAGEUP'] = 10, ['PAGEDOWN'] = 11, ['DELETE'] = 178,
	['LEFT'] = 174, ['RIGHT'] = 175, ['TOP'] = 27, ['DOWN'] = 173,
	['NENTER'] = 201, ['N4'] = 108, ['N5'] = 60, ['N6'] = 107, ['N+'] = 96, ['N-'] = 97, ['N7'] = 117, ['N8'] = 61, ['N9'] = 118
}

CreateThread(function()
	while not Config.Multichar do
		Wait(0)
		if NetworkIsPlayerActive(PlayerId()) then
			exports.spawnmanager:setAutoSpawn(false)
			DoScreenFadeOut(0)
			Wait(500)
			TriggerServerEvent('esx:onPlayerJoined')
			break
		end
	end
end)

RegisterNetEvent('esx:requestModel', function(model)
    ESX.Streaming.RequestModel(model)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer, isNew, skin)
	ESX.PlayerData = xPlayer

	if Config.Multichar then
		Wait(3000)
	else
		exports.spawnmanager:spawnPlayer({
			x = ESX.PlayerData.coords.x,
			y = ESX.PlayerData.coords.y,
			z = ESX.PlayerData.coords.z + 0.25,
			heading = ESX.PlayerData.coords.heading,
			model = `mp_m_freemode_01`,
			skipFade = false
		}, function()
			TriggerServerEvent('esx:onPlayerSpawn')
			TriggerEvent('esx:onPlayerSpawn')

			if isNew then
				TriggerEvent('esx:showNotification', 'Znajdź spoczko miejsce, aby stworzyć postać!')
				Wait(5000)
				
				for i = 5, 1, -1 do
					TriggerEvent('esx:showNotification', 'Menu skina otworzy się za ' .. i)
					Wait(1000)
				end
				ExecuteCommand('propfix')
				TriggerEvent('esx_skin:openSaveableMenu', skin)
			elseif skin then
				TriggerEvent('skinchanger:loadSkin', skin)
			end
			
			TriggerEvent('esx:loadingScreenOff')
			ShutdownLoadingScreen()
			ShutdownLoadingScreenNui()	
		end)
	end

	ESX.PlayerLoaded = true

	while ESX.PlayerData.ped == nil do Wait(20) end

	SetCanAttackFriendly(ESX.PlayerData.ped, true, false)
	NetworkSetFriendlyFireOption(true)

	StartServerSyncLoops()
end)

RegisterNetEvent('esx:onPlayerLogout')
AddEventHandler('esx:onPlayerLogout', function()
	ESX.PlayerLoaded = false
end)

RegisterNetEvent('esx:setMaxWeight')
AddEventHandler('esx:setMaxWeight', function(newMaxWeight) ESX.SetPlayerData('maxWeight', newMaxWeight) end)

local function onPlayerSpawn()
	ESX.SetPlayerData('ped', PlayerPedId())
	ESX.SetPlayerData('dead', false)
end

AddEventHandler('playerSpawned', onPlayerSpawn)
AddEventHandler('esx:onPlayerSpawn', onPlayerSpawn)

AddEventHandler('skam$death', function()
	ESX.SetPlayerData('ped', PlayerPedId())
	--ESX.SetPlayerData('dead', true)
end)

AddEventHandler('esx:restoreLoadout', function()
	ESX.SetPlayerData('ped', PlayerPedId())

	if not Config.OxInventory then
		local ammoTypes = {}
		RemoveAllPedWeapons(ESX.PlayerData.ped, true)

		for k,v in ipairs(ESX.PlayerData.loadout) do
			local weaponName = v.name
			local weaponHash = joaat(weaponName)

			GiveWeaponToPed(ESX.PlayerData.ped, weaponHash, 0, false, false)
			SetPedWeaponTintIndex(ESX.PlayerData.ped, weaponHash, v.tintIndex)

			local ammoType = GetPedAmmoTypeFromWeapon(ESX.PlayerData.ped, weaponHash)

			for k2,v2 in ipairs(v.components) do
				local componentHash = ESX.GetWeaponComponent(weaponName, v2).hash
				GiveWeaponComponentToPed(ESX.PlayerData.ped, weaponHash, componentHash)
			end

			if not ammoTypes[ammoType] then
				AddAmmoToPed(ESX.PlayerData.ped, weaponHash, v.ammo)
				ammoTypes[ammoType] = true
			end
		end
	end
end)

AddStateBagChangeHandler('VehicleProperties', nil, function(bagName, key, value)
    if not value then return end
    
    Wait(50)
    local netId = value.NetId
    if not netId or netId == 0 then return end
    
    local timeout = 0
    while not NetworkDoesNetworkIdExist(netId) and timeout < 20 do 
        Wait(10) 
        timeout = timeout + 1
    end
    
    if not NetworkDoesNetworkIdExist(netId) then return end
    
    local vehicle = NetworkGetEntityFromNetworkId(netId)
    local tries = 0
    
    while not DoesEntityExist(vehicle) and tries < 20 do
        if NetworkDoesEntityExistWithNetworkId(netId) then
            vehicle = NetworkGetEntityFromNetworkId(netId)
        else
            return
        end
        Wait(300)
        tries = tries + 1
    end
    
    if DoesEntityExist(vehicle) and NetworkGetEntityOwner(vehicle) == PlayerId() then
        ESX.Game.SetVehicleProperties(vehicle, value)
    end
end)

RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)
	for i=1, #(ESX.PlayerData.accounts) do
		if ESX.PlayerData.accounts[i].name == account.name then
			ESX.PlayerData.accounts[i] = account
			break
		end
	end

	ESX.SetPlayerData('accounts', ESX.PlayerData.accounts)
end)

RegisterNetEvent('esx:addInventoryItem')
AddEventHandler('esx:addInventoryItem', function(item, count, showNotification)
	for k,v in ipairs(ESX.PlayerData.inventory) do
		if v.name == item then
			ESX.UI.ShowInventoryItemNotification(true, v.label, count - v.count)
			ESX.PlayerData.inventory[k].count = count
			break
		end
	end

	if showNotification then
		ESX.UI.ShowInventoryItemNotification(true, item, count)
	end

	if ESX.UI.Menu.IsOpen('default', 'es_extended', 'inventory') then
		ESX.ShowInventory()
	end
end)

RegisterNetEvent('esx:removeInventoryItem')
AddEventHandler('esx:removeInventoryItem', function(item, count, hideNotification)
	for k,v in ipairs(ESX.PlayerData.inventory) do
		if v.name == item then
			if not hideNotification then
				ESX.UI.ShowInventoryItemNotification(false, v.label, v.count - count)
			end
			ESX.PlayerData.inventory[k].count = count
			break
		end
	end

	if ESX.UI.Menu.IsOpen('default', 'es_extended', 'inventory') then
		ESX.ShowInventory()
	end
end)

RegisterNetEvent('esx:addWeapon')
AddEventHandler('esx:addWeapon', function(weapon, ammo)
	print("[WARNING] event 'esx:addWeapon' is deprecated. Please use xPlayer.addWeapon Instead!")
end)

RegisterNetEvent('esx:addWeaponComponent')
AddEventHandler('esx:addWeaponComponent', function(weapon, weaponComponent)
	print("[WARNING] event 'esx:addWeaponComponent' is deprecated. Please use xPlayer.addWeaponComponent Instead!")
end)

RegisterNetEvent('esx:setWeaponAmmo')
AddEventHandler('esx:setWeaponAmmo', function(weapon, weaponAmmo)
	print("[WARNING] event 'esx:setWeaponAmmo' is deprecated. Please use xPlayer.addWeaponComponent Instead!")
end)

RegisterNetEvent('esx:setWeaponTint')
AddEventHandler('esx:setWeaponTint', function(weapon, weaponTintIndex)
	SetPedWeaponTintIndex(ESX.PlayerData.ped, joaat(weapon), weaponTintIndex)
end)

RegisterNetEvent('esx:removeWeapon')
AddEventHandler('esx:removeWeapon', function(weapon)
	RemoveWeaponFromPed(ESX.PlayerData.ped, joaat(weapon))
	SetPedAmmo(ESX.PlayerData.ped, joaat(weapon), 0)
end)

RegisterNetEvent('esx:removeWeaponComponent')
AddEventHandler('esx:removeWeaponComponent', function(weapon, weaponComponent)
	local componentHash = ESX.GetWeaponComponent(weapon, weaponComponent).hash
	RemoveWeaponComponentFromPed(ESX.PlayerData.ped, joaat(weapon), componentHash)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(Job)
	ESX.SetPlayerData('job', Job)
end)

RegisterNetEvent('esx:setDualJob')
AddEventHandler('esx:setDualJob', function(DualJob)
	ESX.SetPlayerData('dualjob', DualJob)
end)

if not Config.OxInventory then
	RegisterNetEvent('esx:createPickup')
	AddEventHandler('esx:createPickup', function(pickupId, label, coords, type, name, components, tintIndex)
		local function setObjectProperties(object)
			SetEntityAsMissionEntity(object, true, false)
			PlaceObjectOnGroundProperly(object)
			FreezeEntityPosition(object, true)
			SetEntityCollision(object, false, true)

			pickups[pickupId] = {
				obj = object,
				label = label,
				inRange = false,
				coords = vector3(coords.x, coords.y, coords.z)
			}
		end

		if type == 'item_weapon' then
			local weaponHash = joaat(name)
			ESX.Streaming.RequestWeaponAsset(weaponHash)
			local pickupObject = CreateWeaponObject(weaponHash, 50, coords.x, coords.y, coords.z, true, 1.0, 0)
			SetWeaponObjectTintIndex(pickupObject, tintIndex)

			for k,v in ipairs(components) do
				local component = ESX.GetWeaponComponent(name, v)
				GiveWeaponComponentToWeaponObject(pickupObject, component.hash)
			end

			setObjectProperties(pickupObject)
		else
			ESX.Game.SpawnLocalObject('prop_money_bag_01', coords, setObjectProperties)
		end
	end)

	RegisterNetEvent('esx:createMissingPickups')
	AddEventHandler('esx:createMissingPickups', function(missingPickups)
		for pickupId, pickup in pairs(missingPickups) do
			TriggerEvent('esx:createPickup', pickupId, pickup.label, pickup.coords - vector3(0,0, 1.0), pickup.type, pickup.name, pickup.components, pickup.tintIndex)
		end
	end)
end

RegisterNetEvent('esx:registerSuggestions')
AddEventHandler('esx:registerSuggestions', function(registeredCommands)
	for name,command in pairs(registeredCommands) do
		if command.suggestion then
			TriggerEvent('chat:addSuggestion', ('%s'):format(name), command.suggestion.help, command.suggestion.arguments)
		end
	end
end)

RegisterNetEvent('esx:removePickup')
AddEventHandler('esx:removePickup', function(pickupId)
	if pickups[pickupId] and pickups[pickupId].obj then
		ESX.Game.DeleteObject(pickups[pickupId].obj)
		pickups[pickupId] = nil
	end
end)

function StartServerSyncLoops()
	CreateThread(function()
		local currentWeapon = {Ammo = 0}
		while ESX.PlayerLoaded do
			local sleep = 1500
			if GetSelectedPedWeapon(ESX.PlayerData.ped) ~= -1569615261 then
				sleep = 1000
				local _,weaponHash = GetCurrentPedWeapon(ESX.PlayerData.ped, true)
				local weapon = ESX.GetWeaponFromHash(weaponHash) 
				if weapon then
					local ammoCount = GetAmmoInPedWeapon(ESX.PlayerData.ped, weaponHash)
					if weapon.name ~= currentWeapon.name then 
						currentWeapon.Ammo = ammoCount
						currentWeapon.name = weapon.name
					else
						if ammoCount ~= currentWeapon.Ammo then
							currentWeapon.Ammo = ammoCount
							TriggerServerEvent('esx:updateWeaponAmmo', weapon.name, ammoCount)
						end 
					end   
				end
			end    
		Wait(sleep)
		end
	end)

	CreateThread(function()
		local previousCoords = vector3(ESX.PlayerData.coords.x, ESX.PlayerData.coords.y, ESX.PlayerData.coords.z)

		while ESX.PlayerLoaded do
			local playerPed = PlayerPedId()
			if ESX.PlayerData.ped ~= playerPed then ESX.SetPlayerData('ped', playerPed) end

			if DoesEntityExist(ESX.PlayerData.ped) then
				local playerCoords = GetEntityCoords(ESX.PlayerData.ped)
				local distance = #(playerCoords - previousCoords)

				if distance > 1 then
					previousCoords = playerCoords
					TriggerServerEvent('esx:updateCoords')
				end
			end
			Wait(1500)
		end
	end)
end

RegisterCommand('$ekwipunek', function()
	if not ESX.PlayerData.dead and not ESX.UI.Menu.IsOpen('default', 'es_extended', 'inventory') then
		ESX.ShowInventory()
	end
end, false)

RegisterKeyMapping('$ekwipunek', 'Pokaż Ekwipunek', 'keyboard', 'F2')

local cweljebankurwa = 0

CreateThread(function()
	while true do
		if ESX.UI.Menu.IsOpen('default', 'es_extended', 'inventory') then
			cweljebankurwa = 0
			if IsControlPressed(0, Keys['LEFTALT']) then
				local bind = nil
				for i, key in ipairs({157, 158, 160, 164, 165}) do
					DisableControlAction(0, key, true)
						if IsDisabledControlJustPressed(0, key) then
							bind = i
						break
					end
				end

				if bind then
					local menu = ESX.UI.Menu.GetOpened('default', 'es_extended', 'inventory')
					local elements = menu.data.elements
					
					for i=1, #elements, 1 do
						if elements[i].selected then
							if elements[i].usable or ESX.IsItemAWeapon(elements[i].value) or not ESX.IsItemBinded(elements[i].value) then
								-- ESX.ShowNotification('Zbindowano ~y~'..elements[i].label..'~s~ na pozycję ~o~'..bind)
								-- ESX.SetSlot(elements[i].value, bind, true)	
								ESX.BindItem(elements[i].value, elements[i].type, bind)			
								ESX.SaveBinds()
								ESX.ShowInventory()
							elseif ESX.IsItemBinded(elements[i].value) then
								ESX.UnBindItem(bind)
								ESX.SaveBinds()
								-- ESX.ShowNotification('Przebindowano ~y~'..elements[i].label..'~s~ na pozycję ~o~'..bind)
							else
								ESX.ShowNotification('Nie możesz ustawić ~y~'..elements[i].label)
							end
						end
					end
				end
			end	
		else
			cweljebankurwa = 250
		end
		Citizen.Wait(cweljebankurwa)
	end
end)

if not Config.OxInventory then
	CreateThread(function()
		while true do
			local Sleep = 1500
			local playerCoords = GetEntityCoords(ESX.PlayerData.ped)
			local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer(playerCoords)

			for pickupId,pickup in pairs(pickups) do
				local distance = #(playerCoords - pickup.coords)

				if distance < 5 then
					Sleep = 0
					local label = pickup.label

					if distance < 1 then
						if IsControlJustReleased(0, 38) then
							if IsPedOnFoot(ESX.PlayerData.ped) and (closestDistance == -1 or closestDistance > 3) and not pickup.inRange then
								pickup.inRange = true

								local dict, anim = 'weapons@first_person@aim_rng@generic@projectile@sticky_bomb@', 'plant_floor'
								ESX.Streaming.RequestAnimDict(dict)
								TaskPlayAnim(ESX.PlayerData.ped, dict, anim, 8.0, 1.0, 1000, 16, 0.0, false, false, false)
								RemoveAnimDict(dict)
								Wait(1000)

								TriggerServerEvent('esx:onPickup', pickupId)
								PlaySoundFrontend(-1, 'PICK_UP', 'HUD_FRONTEND_DEFAULT_SOUNDSET', false)
							end
						end

						label = ('%s~n~%s'):format(label, _U('threw_pickup_prompt'))
					end

					ESX.Game.Utils.DrawText3D({
						x = pickup.coords.x,
						y = pickup.coords.y,
						z = pickup.coords.z + 0.25
					}, label, 1.2, 1)
				elseif pickup.inRange then
					pickup.inRange = false
				end
			end
			Wait(Sleep)
		end
	end)
end

RegisterNetEvent('esx:tpm')
AddEventHandler('esx:tpm', function()
	local GetEntityCoords = GetEntityCoords
	local GetGroundZFor_3dCoord = GetGroundZFor_3dCoord
	local GetFirstBlipInfoId = GetFirstBlipInfoId
	local DoesBlipExist = DoesBlipExist
	local DoScreenFadeOut = DoScreenFadeOut
	local GetBlipInfoIdCoord = GetBlipInfoIdCoord
	local GetVehiclePedIsIn = GetVehiclePedIsIn

	ESX.TriggerServerCallback('esx:isUserAdmin', function(admin)
		if admin then
			local blipMarker = GetFirstBlipInfoId(8)
			if not DoesBlipExist(blipMarker) then
				ESX.ShowNotification('Nie ustawiono punktu.', true, false)
				return 'marker'
			end
	
			DoScreenFadeOut(650)
			while not IsScreenFadedOut() do
				Wait(0)
			end
	
			local ped, coords = ESX.PlayerData.ped, GetBlipInfoIdCoord(blipMarker)
			local vehicle = GetVehiclePedIsIn(ped, false)
			local oldCoords = GetEntityCoords(ped)
			local x, y, groundZ, Z_START = coords['x'], coords['y'], 850.0, 950.0
			local found = false
			if vehicle > 0 then
				FreezeEntityPosition(vehicle, true)
			else
				FreezeEntityPosition(ped, true)
			end
	
			for i = Z_START, 0, -25.0 do
				local z = i
				if (i % 2) ~= 0 then
						z = Z_START - i
				end

				NewLoadSceneStart(x, y, z, x, y, z, 50.0, 0)
				local curTime = GetGameTimer()
				while IsNetworkLoadingScene() do
						if GetGameTimer() - curTime > 1000 then
								break
						end
						Wait(0)
				end
				NewLoadSceneStop()
				SetPedCoordsKeepVehicle(ped, x, y, z)

				while not HasCollisionLoadedAroundEntity(ped) do
						RequestCollisionAtCoord(x, y, z)
						if GetGameTimer() - curTime > 1000 then
								break
						end
						Wait(0)
				end

				found, groundZ = GetGroundZFor_3dCoord(x, y, z, false)
				if found then
						Wait(0)
						SetPedCoordsKeepVehicle(ped, x, y, groundZ)
						break
				end
				Wait(0)
			end
	
			DoScreenFadeIn(650)
			if vehicle > 0 then
				FreezeEntityPosition(vehicle, false)
			else
				FreezeEntityPosition(ped, false)
			end
	
			if not found then
				SetPedCoordsKeepVehicle(ped, oldCoords['x'], oldCoords['y'], oldCoords['z'] - 1.0)
				ESX.ShowNotification('Pomyślnie przeteleportowano.', true, false)
			end
	
			SetPedCoordsKeepVehicle(ped, x, y, groundZ)
			ESX.ShowNotification('Pomyślnie przeteleportowano.', true, false)
		end
	end)
end)

RegisterNetEvent('esx:GetVehicleType', function(Model, Request)
	local Model = Model
	local VehicleType = GetVehicleClassFromName(Model)
	local type = 'automobile'
	if VehicleType == 15 then
		type = 'heli'
	elseif VehicleType == 16 then
		type = 'plane'
	elseif VehicleType == 14 then
		type = 'boat'
	elseif VehicleType == 11 then
		type = 'trailer'
	elseif VehicleType == 21 then
		type = 'train'
	elseif VehicleType == 13 or VehicleType == 8 then
		type = 'bike'
	end
	if Model == `submersible` or Model == `submersible2` then
		type = 'submarine'
	end
	TriggerServerEvent('esx:ReturnVehicleType', type, Request)
end)