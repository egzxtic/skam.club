players = {}
banlist = {}
cachedplayers = {}

RegisterNetEvent('skam:exadmin:adminresponse')
AddEventHandler('skam:exadmin:adminresponse', function(response, permission)
	permissions[response] = permission
	if permission == true then
		isAdmin = true
	end
end)

RegisterNetEvent('skam:exadmin:refreshpermission')
AddEventHandler('skam:exadmin:refreshpermission', function()
	Citizen.Wait(2500)
	TriggerServerEvent('skam:exadmin:amiadmin')
end)

RegisterNetEvent('skam:exadmin:fillBanlist')
AddEventHandler('skam:exadmin:fillBanlist', function(thebanlist)
	banlist = thebanlist
end)

RegisterNetEvent('skam:exadmin:fillcachedplayers')
AddEventHandler('skam:exadmin:fillcachedplayers', function(thecached)
	cachedplayers = thecached
end)

RegisterNetEvent('skam:exadmin:getplayerlist')
AddEventHandler('skam:exadmin:getplayerlist', function(players)
	playerlist = players
end)

RegisterNetEvent('skam:exadmin:getinfinityplayerlist')
AddEventHandler('skam:exadmin:getinfinityplayerlist', function(players)
	playerlist = players
end)

RegisterNetEvent('skam:exadmin:wezwijgracza')
AddEventHandler('skam:exadmin:wezwijgracza', function(ktowezwal, nick, powod)
	ESX.Scaleform.ShowFreemodeMessage('~w~s~m~k~w~a~m~m~w~.~m~c~w~l~m~u~w~b', '~s~'..nick..' ~s~wzywa cię na kanał ~m~pomoc ~s~z powodem: ~m~'..powod, 10)
end)

RegisterNetEvent('skam:exadmin:freezeplayer')
AddEventHandler('skam:exadmin:freezeplayer', function(toggle)
	frozen = toggle
	FreezeEntityPosition(PlayerPedId(), frozen)
	if IsPedInAnyVehicle(PlayerPedId(), false) then
		FreezeEntityPosition(GetVehiclePedIsIn(PlayerPedId(), false), frozen)
	end 
end)

RegisterCommand('kick', function(source, args, rawCommand)
	local source = source
	local reason = ''
	for i,theArg in pairs(args) do
		if i ~= 1 then
			reason = reason..' '..theArg
		end
	end
	if args[1] and tonumber(args[1]) then
		TriggerServerEvent('skam:exadmin:kickplayer', tonumber(args[1]), reason)
	end
end, false)

-- RegisterCommand('ban', function(source, args, rawCommand)
-- 	if args[1] and tonumber(args[1]) then
-- 		local reason = ''
-- 		for i,theArg in pairs(args) do
-- 			if i ~= 1 then
-- 				reason = reason..' '..theArg
-- 			end
-- 		end
-- 		if args[1] and tonumber(args[1]) then
-- 			TriggerServerEvent('skam:exadmin:banPlayer', tonumber(args[1]), reason, false, GetPlayerName(args[1]))
-- 		end
-- 	end
-- end, false)

RegisterNetEvent('skam:exadmin:requestspectate')
AddEventHandler('skam:exadmin:requestspectate', function(targetId, playerCoords)
	local playerPed = PlayerPedId()
	local targetPed
	local target = GetPlayerFromServerId(targetId)
	if target and target ~= -1 then
		targetPed = GetPlayerPed(target)
	end
	local data
	if not targetPed or not DoesEntityExist(targetPed) then
		data = {
			coords = GetEntityCoords(playerPed, false),
			invisible = IsEntityVisible(playerPed)
		}
		data.coords = vec3(data.coords.x, data.coords.y, data.coords.z - 0.95)
		if IsPedInAnyVehicle(playerPed, false) then
			data.vehicle = VehToNet(GetVehiclePedIsIn(playerPed, false))
		end
	elseif targetPed == playerPed then
		return
	end

	if data then
		FreezeEntityPosition(playerPed, true)
		if data.invisible then
			SetEntityVisible(playerPed, false)
		end
		RequestCollisionAtCoord(playerCoords.x, playerCoords.y, playerCoords.z)
		SetEntityCoords(playerPed, playerCoords.x, playerCoords.y, playerCoords.z - 10.0, 0, 0, GetEntityHeading(playerPed), false)
		Citizen.CreateThreadNow(function()
			local tick = 0
			repeat
				Citizen.Wait(100)
				tick = tick + 1

				local target = GetPlayerFromServerId(targetId)
				if target and target ~= -1 then
					targetPed = GetPlayerPed(target)
				end
			until DoesEntityExist(targetPed) or tick == 30

			if tick ~= 10 then
				local coords = GetEntityCoords(targetPed, false)
				RequestCollisionAtCoord(coords.x, coords.y, coords.z)
				NetworkSetInSpectatorMode(true, targetPed)
				DrawPlayerInfo(targetId, data)
			else
				RequestCollisionAtCoord(data.coords.x, data.coords.y, data.coords.z)

				SetEntityCoords(playerPed, data.coords.x, data.coords.y, data.coords.z, 0, 0, GetEntityHeading(playerPed), false)
				if data.invisible then
					SetEntityVisible(playerPed, true)
				end

				if data.vehicle and data.vehicle ~= 0 then
					local id, timeout = nil, 30
					repeat
						Citizen.Wait(100)
						id = NetToVeh(drawCustom.vehicle)
						timeout = timeout - 1
					until DoesEntityExist(id) or timeout == 0

					if DoesEntityExist(id) and AreAnyVehicleSeatsFree(id) then
						local tick = 20
						repeat
							TaskWarpPedIntoVehicle(playerPed, id, -2)
							tick = tick - 1
							Citizen.Wait(50)
						until IsPedInAnyVehicle(playerPed, false) or tick == 0
					end
				end
			end
		end)
	else
		local coords = GetEntityCoords(targetPed, false)
		RequestCollisionAtCoord(coords.x, coords.y, coords.z)
		NetworkSetInSpectatorMode(true, targetPed)
		DrawPlayerInfo(targetId)
	end
end)

RegisterNetEvent('skam:exadmin:teleportrequest')
AddEventHandler('skam:exadmin:teleportrequest', function(px,py,pz)
	SetEntityCoords(PlayerPedId(), px, py, pz, 0, 0, 0, false)
end)

RegisterNetEvent('skam:exadmin:slapplayer')
AddEventHandler('skam:exadmin:slapplayer', function(slapAmount)
	if slapAmount > GetEntityHealth(PlayerPedId()) then
		SetEntityHealth(PlayerPedId(), 0)
	else
		SetEntityHealth(PlayerPedId(), GetEntityHealth(PlayerPedId()) - slapAmount)
	end
end)

CreateThread(function()
  	while true do
    	Citizen.Wait(2)
		if frozen then
			FreezeEntityPosition(PlayerPedId(), frozen)
			if IsPedInAnyVehicle(PlayerPedId(), true) then
				FreezeEntityPosition(GetVehiclePedIsIn(PlayerPedId(), false), frozen)
			else
				Citizen.Wait(1000)
			end
		else
			Citizen.Wait(1000)
		end
  	end
end)
