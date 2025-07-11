ESX.RegisterCommand('clearmap', 'mod', function(xPlayer, args, showError)
    local countCars, countObjects, countPeds = 0, 0, 0
    for index,vehicle in ipairs(GetAllVehicles()) do
        if DoesEntityExist(vehicle) and GetPedInVehicleSeat(vehicle, -1) == 0 and GetPedInVehicleSeat(vehicle, 0) == 0 and GetPedInVehicleSeat(vehicle, 1) == 0 and GetPedInVehicleSeat(vehicle, 2) == 0 then
            DeleteEntity(vehicle)
            countCars += 1
        end
    end
    for index,object in ipairs(GetAllObjects()) do
        if DoesEntityExist(object) then
            DeleteEntity(object)
            countObjects += 1
        end
    end
    for index,ped in ipairs(GetAllPeds()) do
        if DoesEntityExist(ped) and not IsPedAPlayer(ped) then
            DeleteEntity(ped)
            countPeds += 1
        end
    end
    if xPlayer then
        xPlayer.showNotification('Wyczyszczono mapę z ('..countCars..' pojazdów, '..countObjects..' obiektów, '..countPeds..' pedów)')
		--exports['skam']:SendLog(xPlayer, 'Wyczyszczono mapę z ('..countCars..' pojazdów, '..countObjects..' obiektów, '..countPeds..' pedów)', 'commands')
    else
        print('[skam.club] Wyczyszczono mapę z ('..countCars..' pojazdów, '..countObjects..' obiektów, '..countPeds..' pedów)')
    end
end, true)

ESX.RegisterCommand('clearcars', 'mod', function(xPlayer, args, showError)
    local countCars = 0
    for index,vehicle in ipairs(GetAllVehicles()) do
        if DoesEntityExist(vehicle) and GetPedInVehicleSeat(vehicle, -1) == 0 and GetPedInVehicleSeat(vehicle, 0) == 0 and GetPedInVehicleSeat(vehicle, 1) == 0 and GetPedInVehicleSeat(vehicle, 2) == 0 then
            DeleteEntity(vehicle)
            countCars += 1
        end
    end
    if xPlayer then
        xPlayer.showNotification('Wyczyszczono mapę z ('..countCars..' pojazdów)')
		--exports['skam']:SendLog(xPlayer, 'Wyczyszczono mapę z ('..countCars..' pojazdów)', 'commands')
    else
        print('[skam.club] Wyczyszczono mapę z ('..countCars..' pojazdów)')
    end
end, true)

local cooldown = {
    time = 60,
    flip = {},
    fix = {}
}

local allowedGroups = {  
    trialsupport = true,         
    support = true,
    mod = true,
    smod = true,
    admin = true,
    headadmin = true,
    zarzad = true,
    prezeszarzadu = true,
    eventmanager = true,
    opiekunadm = true,
    mediamanagment = true,
    managment = true,
    developer = true,
    txmanager = true, 
    ceo = true,
    owner = true
}

local function hasPermission(xPlayer)
    local group = xPlayer.getGroup and xPlayer:getGroup() or nil
    if allowedGroups[group] then return true end
    if exports['skam']:premiumRank(xPlayer) then return true end

    return false
end

local function handleCooldown(xPlayer, cmdName, eventName)
    local now = os.time()
    local lastUsed = cooldown[cmdName][xPlayer.source]

    if not lastUsed or (now - lastUsed) >= cooldown.time then
        xPlayer.triggerEvent(eventName)
        --exports['skam']:SendLog(xPlayer.source, 'Użył komendy /'..cmdName, 'admin_commands')
        cooldown[cmdName][xPlayer.source] = now
    else
        local timeLeft = cooldown.time - (now - lastUsed)
        xPlayer.showNotification(("Musisz odczekać jeszcze %d sekund przed ponownym użyciem tej komendy."):format(timeLeft))
    end
end

ESX.RegisterCommand('flip', 'user', function(xPlayer, args, showError)
    if hasPermission(xPlayer) then
        handleCooldown(xPlayer, 'flip', 'skam$flip')
    else
        xPlayer.showNotification("Nie posiadasz uprawnień do używania tej komendy.")
    end
end, true)

ESX.RegisterCommand('fix', 'user', function(xPlayer, args, showError)
    if hasPermission(xPlayer) then
        handleCooldown(xPlayer, 'fix', 'skam$fix')
    else
        xPlayer.showNotification("Nie posiadasz uprawnień do używania tej komendy.")
    end
end, false)

local allowedGiveItems = {
	['handcuffs'] = true,
} 

ESX.RegisterCommand('giveallitem', 'txmanager', function(xPlayer, args, showError)
	if allowedGiveItems[args.item] then
		local xPlayers = ESX.GetExtendedPlayers()
		for i=1, #(xPlayers) do 
			local xPlayer = xPlayers[i]
			xPlayer.addInventoryItem(args.item, args.count)
		end
		--exports['skam']:SendLog(xPlayer, string.format('Użyto komendę /giveallitem %s %s', args.item, args.count), 'commands')
	else
		xPlayer.showNotification('Ten przedmiot nie jest na liście dozwolonych przedmiotów')
	end
end, false, {help = 'Daj przedmiot dla wszystkich graczy', validate = true, arguments = {
	{name = 'item', help = 'Przedmiot', type = 'string'},
	{name = 'count', help = 'Ilość', type = 'number'}
}})

local function wezwij(source, playerId, powod)
    local xPlayer = ESX.GetPlayerFromId(source)
    local targetPlayer = ESX.GetPlayerFromId(playerId)

    if not targetPlayer then
        return false, "Gracz o podanym ID nie został znaleziony."
    end

    TriggerClientEvent("txcl:showWarning", targetPlayer.source, GetPlayerName(xPlayer.source), "Zostałeś wezwany na poczekalnie")

    local discordMention = GetSpecificIdentifier(targetPlayer.source, 'discord'):gsub('discord:', '')
    local adminDiscordMention = xPlayer and GetSpecificIdentifier(xPlayer.source, 'discord'):gsub('discord:', '') or 'CONSOLE'

    PerformHttpRequest(function(err, text, headers) end, 'POST', json.encode({
        content = '<@' .. discordMention .. '>', 
        embeds = {{
        title = "Wezwanie Gracza",
        description = '```Zapraszam na poczekalnię, masz 3 minuty.```',
        fields = {
            {
                name = "Wezwany Przez",
                value = '<@' .. adminDiscordMention .. '>',
                inline = true
            }
        },
		color = 10181046
	}}}), { ['Content-Type'] = 'application/json' })

	--exports['skam']:SendLog(xPlayer, string.format('Użyto komendę /wezwij %s', targetPlayer.source), 'commands')

    return true, nil
end

exports('wezwij', wezwij)


ESX.RegisterCommand('wezwij', 'support', function(xPlayer, args, showError)
    local success, errorMessage = exports['skam']:wezwij(xPlayer.source, args.playerId.source)

    if not success then
        showError(errorMessage)
    end
end, true, {
    help = 'Wezwij gracza', 
    validate = true, 
    arguments = {
        {name = 'playerId', help = 'ID gracza', type = 'player'},
    }
})


RegisterNetEvent("skam:wezwijGracza", function(playerId, powod)
    local source = source
    local success, errorMessage = exports['skam']:wezwij(source, playerId, powod)

    if not success then
        print("Błąd podczas wywoływania funkcji wezwij: " .. (errorMessage or "nieznany błąd"))
        return
    end

    TriggerClientEvent("csskrouble:rzadowyCalled", playerId, GetPlayerName(source))
end)


ESX.RegisterCommand('sprawdzanie', 'support', function(xPlayer, args, showError)
	TriggerClientEvent("txcl:showWarning", args.playerId.source, GetPlayerName(xPlayer.source), "Zapraszam na sprawdzanie | QUIT = PERM | 1 MIN")
	SetEntityCoords(GetPlayerPed(args.playerId.source), 1121.897, -3195.338, -40.402)
	
	local discordMention = GetSpecificIdentifier(args.playerId.source, 'discord'):gsub('discord:', '')
	local adminDiscordMention = xPlayer and GetSpecificIdentifier(xPlayer.source, 'discord'):gsub('discord:', '') or 'CONSOLE'

	PerformHttpRequest(
    function(err, text, headers) 
    end, 
    'POST', 
    json.encode({
        content = '<@' .. discordMention .. '>',
        embeds = {{
            title = "Wezwanie Cheatera",
            description = '```Zapraszam na sprawdzanie | QUIT = PERM | 1 MIN.```',
            fields = {
                {
                    name = "Wezwany Przez",
                    value = '<@' .. adminDiscordMention .. '>',
                    inline = true
                }
            },
            color = 10181046
        }}
    }), 
    { ['Content-Type'] = 'application/json' })

	

	LogCommands('sprawdzanie', xPlayer, {
		playerId = args.playerId.source
	})
end, true, {
	help = 'Wezwij gracza na sprawdzanie', 
	validate = true, 
	arguments = {
		{name = 'playerId', help = 'ID gracza', type = 'player'},
	}
})

ESX.RegisterCommand('skonczsprawdzanie', 'support', function(xPlayer, args, showError)
    local targetPlayer = args.playerId.source
    local targetPed = GetPlayerPed(targetPlayer)
    local checkCoords = vector3(1121.897, -3195.338, -40.402)
    local targetCoords = GetEntityCoords(targetPed)
    local distance = #(targetCoords - checkCoords)
    if distance <= 50.0 then
        TriggerClientEvent('txcl:showDirectMessage', targetPlayer, "Twoje sprawdzanie zostało zakończone sukcesem! Przepraszamy za nieudogodnienia.", GetPlayerName(xPlayer.source))
        SetEntityCoords(targetPed, 973.0303, -2514.8979, 28.4503)
    else
		TriggerClientEvent('txcl:showDirectMessage', xPlayer.source, "Debilu nie jestem w trakcie trzepki.", GetPlayerName(targetPlayer))
        return
    end
end, true, {
    help = 'Skoncz Trzepke', 
    validate = true, 
    arguments = {
        {name = 'playerId', help = 'ID gracza', type = 'player'},
    }
})

ESX.RegisterCommand('kick', 'support', function(xPlayer, args, showError)
	DropPlayer(args.playerId.source, xPlayer.name..' wyrzucił Cię z serwera! Powód: '..args.reason)
	LogCommands('kick', xPlayer, {
		playerId = args.playerId.source,
		reason = args.reason
	})
end, false, {help = 'Wyrzuć gracza', validate = true, arguments = {
    {name = 'playerId', help = 'ID gracza', type = 'player'},
	{name = 'reason', help = 'Powód -> użyj cudzysłowia', type = 'string'},
}})

-- ESX.RegisterCommand('setped', {'admin', 'superadmin', 'trialzarzad', 'zarzad', 'glownyzarzad', 'managment'}, function(xPlayer, args, showError)
-- 	args.playerId.triggerEvent('skam:onSetpedCommand', args.ped)
-- 	LogCommands('setped', xPlayer, {
-- 		playerId = args.playerId.source,
-- 		ped = args.ped
-- 	})
-- end, true, {help = 'Nadaj peda dla gracza', validate = true, arguments = {
--     {name = 'playerId', help = 'ID gracza', type = 'player'},
-- 	{name = 'ped', help = 'Nazwa modelu', type = 'string'},
-- }})

ESX.RegisterCommand('jobinfo', 'trialsupport', function(xPlayer, args, showError)
    MySQL.query('SELECT job, job_grade FROM users WHERE identifier = @identifier', {
		['@identifier'] = args.license
	}, function(data)
		if data and data[1] then
            if xPlayer then
                xPlayer.showNotification(args.license..' | job: '..data[1].job..' | grade: '..data[1].job_grade, 'info')
            else
                print(args.license..' | job: '..data[1].job..' | grade: '..data[1].job_grade)
            end
        else
            if xPlayer then
                xPlayer.showNotification('Nie znaleziono gracza z taką licencją', 'error')
            else
                print('Nie znaleziono gracza z taką licencją')
            end
		end
	end)
end, true, {help = 'Sprawdź nazwę joba po licencji', validate = true, arguments = {
	{name = 'license', help = 'Licencja (z char:)', type = 'string'}
}})

ESX.RegisterServerCallback('skam:requestPlayerStatus', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.query('SELECT status FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(data)
		if data and data[1] then
			cb(json.decode(data[1].status))
		end
	end)
end)

-- AddEventHandler('esx:playerLoaded', function(source, xPlayer)
-- 	local steam = GetSpecificIdentifier(xPlayer.source, 'steam')
-- 	local discord = GetSpecificIdentifier(xPlayer.source, 'discord')
-- 	local xbl = GetSpecificIdentifier(xPlayer.source, 'xbl')
-- 	local live = GetSpecificIdentifier(xPlayer.source, 'live')
-- 	local discordmention = discord:gsub('discord:', '')
-- 	SendLog('Connect', xPlayer.name..' wchodzi na serwer\nID: '..xPlayer.source..'\nLicencja: '..xPlayer.identifier..'\nHex: '..steam..'\nDiscord: <@'..discordmention..'> - '..discord..'\nXbl: '..xbl..'\nLive: '..live, 5763719)
-- end)

AddEventHandler('esx:playerDropped', function(playerId, reason)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	local steam = GetSpecificIdentifier(xPlayer.source, 'steam')
	local discord = GetSpecificIdentifier(xPlayer.source, 'discord')
	local xbl = GetSpecificIdentifier(xPlayer.source, 'xbl')
	local live = GetSpecificIdentifier(xPlayer.source, 'live')
	local discordmention = discord:gsub('discord:', '')
	local character = xPlayer.get('name')
	--SendLog('Disconnect', xPlayer.name..' wychodzi z serwera\nID: '..xPlayer.source..'\nLicencja: '..xPlayer.identifier..'\nHex: '..steam..'\nDiscord: <@'..discordmention..'> - '..discord..'\nXbl: '..xbl..'\nLive: '..live..'\nPowód: '..reason, 15548997)

	local data = {
		health = Player(xPlayer.source).state.health,
		armor = Player(xPlayer.source).state.armor
	}

	MySQL.update.await('UPDATE users SET status = ? WHERE identifier = ?', {json.encode(data), xPlayer.identifier})
end)

RegisterNetEvent('skam$death')
AddEventHandler('skam$death', function(data)
    local xPlayer = ESX.GetPlayerFromId(source)

    if data.killedByPlayer then
		local xTarget = ESX.GetPlayerFromId(data.killerid)
        --SendLog('Nowa śmierć', xTarget.name .. '\n(ID: '..xTarget.source..', Licencja: '..xTarget.identifier..')\n**ZABIŁ**\n' .. xPlayer.name .. '\n(ID: '..xPlayer.source..', Licencja: '..xPlayer.identifier..')\nDystans: ' .. data.distance .. 'm\nBroń: ' .. Weapon, 15548997)
		--SendLog('Nowa śmierć', xTarget.name .. '\n(ID: '..xTarget.source..', Licencja: '..xTarget.identifier..')\n**ZABIŁ**\n' .. xPlayer.name .. '\n(ID: '..xPlayer.source..', Licencja: '..xPlayer.identifier..')\nDystans: ' .. data.distance .. 'm\nBroń: ' .. Weapon, 15548997)
		if data.distance > 107 then
			--SendLog('Nowa śmierć', xTarget.name .. '\n(ID: '..xTarget.source..', Licencja: '..xTarget.identifier..')\n**ZABIŁ**\n' .. xPlayer.name .. '\n(ID: '..xPlayer.source..', Licencja: '..xPlayer.identifier..')\nDystans: ' .. data.distance .. 'm\nBroń: ' .. Weapon, 15548997)
			TriggerClientEvent('skam$sound:client:PlayOnOne', xTarget.source, 'o-kurwa', 0.2)
			TriggerClientEvent('skam$sound:client:PlayOnOne', xPlayer.source, 'koles-ma-snajpe', 0.5)
		end
    else
        --SendLog('Nowa śmierć', 'ID: '..xPlayer.source..'\nNICK: '..xPlayer.name .. '\nLicencja: '..xPlayer.identifier..'\nPowód śmierci - ['..Weapon..']', 15548997)
    end
end)

GetSpecificIdentifier = function(playerId, identifier)
	local identifiers = GetPlayerIdentifiers(playerId)
	for i=1, #identifiers do
		if identifiers[i]:match(identifier) then
			return identifiers[i]
		end
	end
	return "Nie wykryto identyfikatora: "..identifier
end

WhiteListedEntities = {}
local wlModel = {
	[`metrotrain`] = true,
	[`tankercar`] = true,
	[`freightgrain`] = true,
	[`freightcont2`] = true,
	[`freightcont1`] = true,
	[`freightcar`] = true,
	[`freight`] = true,
	[`titan`] = true
}

local function clearCars()
	CreateThread(function()
		TriggerClientEvent('skam:showNotification', -1, {
			title = 'CZYSZCZENIE POJAZDÓW',
			description = 'Puste pojazdy zostaną usunięte za minutę'
		})
		Wait(50000)
		TriggerClientEvent('skam:showNotification', -1, {
			title = 'CZYSZCZENIE POJAZDÓW',
			description = 'Puste pojazdy zostaną usunięte za 10 sekund'
		})
		Wait(10000)
		for index, vehicle in ipairs(GetAllVehicles()) do
			if DoesEntityExist(vehicle) and GetPedInVehicleSeat(vehicle, -1) == 0 and GetPedInVehicleSeat(vehicle, 0) == 0 and GetPedInVehicleSeat(vehicle, 1) == 0 and GetPedInVehicleSeat(vehicle, 2) == 0 and not WhiteListedEntities[vehicle] and not wlModel[GetEntityModel(vehicle)] then
				DeleteEntity(vehicle)
			end
		end
		for index, object in ipairs(GetAllObjects()) do
			if DoesEntityExist(object) and not WhiteListedEntities[object] then
				DeleteEntity(object)
			end
		end
		TriggerClientEvent('skam:showNotification', -1, {
			title = 'CZYSZCZENIE POJAZDÓW',
			description = 'Pomyślnie wyczyszczono puste pojazdy',
			variant = 'success'
		})
	end)
end

CreateThread(function()
	while true do
		local m = os.date('%M')
		if (m % 30 == 0) then
			clearCars()
		end
		Wait(60000)
	end
end)

ESX.RegisterServerCallback('skam:requestCarSpawn', function(source, cb, model, coords, heading)
	local vehicle = CreateVehicle(model, coords, heading, true, true)

    while not DoesEntityExist(vehicle) do
        Wait(50)
    end

	while GetVehiclePedIsIn(GetPlayerPed(source), false) ~= vehicle do
        SetPedIntoVehicle(GetPlayerPed(source), vehicle, -1)
		Wait(100)
    end

	cb(NetworkGetNetworkIdFromEntity(vehicle))
end)

local maxMonitorTime = 300

AddEventHandler('weaponDamageEvent', function(source, data)
	if data.weaponType == 911657153 then
		local xPlayer = ESX.GetPlayerFromId(source)
		if xPlayer and xPlayer.job.name ~= 'police' then
			local item = xPlayer.getInventoryItem('stungun')
			if item and item.count > 0 then
				xPlayer.removeInventoryItem('stungun', item.count)
				CancelEvent()
			end
		end
	end
end)