admins = {}
permissions = {
	ban = false,
	kick = false,
	spectate = false,
	unban = false,
	teleport = false,
	slap = false,
	freeze = false,
	immune = false,
}

CachedPlayers = {}
OnlineAdmins = {}
ChatReminders = {}

CreateThread(function()
	while true do 
		Wait(20000)
		for i, player in pairs(CachedPlayers) do 
			if player.droppedTime and (os.time() > player.droppedTime + 600) then
				CachedPlayers[i] = nil
			end
		end
	end
end)

AddEventHandler('playerDropped', function(reason)
	if CachedPlayers[source] then
		CachedPlayers[source].droppedTime = os.time()
	end
	if OnlineAdmins[source] then
		OnlineAdmins[source] = nil
	end
end)

DeleteBanSteam = function(steam)
	UnbanIdentifier(steam)
	SaveResourceFile(GetCurrentResourceName(), 'banlist.json', json.encode(blacklist, {indent = true}), -1)
	-- updateBlacklist(false,true)
end
exports('DeleteBanSteam', DeleteBanSteam)

function ExtractIdentifiers(playerId)
	local identifiers = {
		steam = '',
		discord = '',
		license = '',
		xbl = '',
		live = ''
	}

	for i = 0, GetNumPlayerIdentifiers(playerId) - 1 do
		local id = GetPlayerIdentifier(playerId, i)

		if string.find(id, 'steam') then
			identifiers.steam = id
		elseif string.find(id, 'discord') then
			identifiers.discord = id
		elseif string.find(id, 'license') then
			identifiers.license = id
		elseif string.find(id, 'xbl') then
			identifiers.xbl = id
		elseif string.find(id, 'live') then
			identifiers.live = id
		end
	end

	return identifiers
end

RegisterServerEvent('skam:exadmin:amiadmin')
AddEventHandler('skam:exadmin:amiadmin', function()
	if not CachedPlayers[source] then
		CachedPlayers[source] = {id = source, name = GetPlayerName(source), identifiers = GetPlayerIdentifiers(source), immune = DoesPlayerHavePermission(source,'exadmin.immune')}
	end
	if OnlineAdmins[source] then
		OnlineAdmins[source] = nil
	end
	local identifiers = GetPlayerIdentifiers(source)
	for perm, val in pairs(permissions) do
		local thisPerm = DoesPlayerHavePermission(source,'exadmin.'..perm)
		if thisPerm == true then
			OnlineAdmins[source] = true 
		end
		TriggerClientEvent('skam:exadmin:adminresponse', source, perm, thisPerm)
	end
end)

RegisterServerEvent('skam:exadmin:getplayerlist')
AddEventHandler('skam:exadmin:getplayerlist', function()
	if IsPlayerAdmin(source) then
		local l = {}
		local players = ESX.GetPlayers()
		for i, player in pairs(players) do
			if CachedPlayers[player] then
				table.insert(l, CachedPlayers[player])
			end
		end
		TriggerClientEvent('skam:exadmin:getplayerlist', source, l) 
	end
end)

RegisterServerEvent('skam:exadmin:getinfinityplayerlist')
AddEventHandler('skam:exadmin:getinfinityplayerlist', function()
	if IsPlayerAdmin(source) then
		local l = {}
		local players = ESX.GetPlayers()

		for i, player in pairs(players) do
			local player = tonumber(player)
			for i, cached in pairs(CachedPlayers) do
				if (cached.id == player) then
					table.insert(l, CachedPlayers[i])
				end
			end
		end
		TriggerClientEvent('skam:exadmin:getinfinityplayerlist', source, l) 
	end
end)

RegisterServerEvent('skam:exadmin:requestcachedplayers')
AddEventHandler('skam:exadmin:requestcachedplayers', function(playerId)
	local src = source
	if DoesPlayerHavePermission(source,'exadmin.ban') then
		TriggerClientEvent('skam:exadmin:fillcachedplayers', src, CachedPlayers)
	end
end)

function GetOnlineAdmins()
	return OnlineAdmins
end

function IsPlayerAdmin(playerId)
	return OnlineAdmins[playerId]
end

function DoesPlayerHavePermission(player, object)
	local haspermission = false
	if (player == 0 or player == '') then
		return true
	end
	if IsPlayerAceAllowed(player,object) then
		haspermission = true
	else
		haspermission = false
	end
	if not haspermission then
		local numIds = GetPlayerIdentifiers(player)
		for i,admin in pairs(admins) do
			for i,theId in pairs(numIds) do
				if admin == theId then
					haspermission = true
				end
			end
		end
	end
	return haspermission
end

function PlayerIdentifier(type, id)
    local identifiers = {}
    local numIdentifiers = GetNumPlayerIdentifiers(id)

    for a = 0, numIdentifiers do
        identifiers[#identifiers + 1] = GetPlayerIdentifier(id, a)
    end

    for b = 1, #identifiers do
        if string.find(identifiers[b], type, 1) then
            return identifiers[b]
        end
    end
    return false
end

RegisterServerEvent('skam:exadmin:kickplayer')
AddEventHandler('skam:exadmin:kickplayer', function(playerId,reason)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
    if DoesPlayerHavePermission(xPlayer.source,'exadmin.kick') and not DoesPlayerHavePermission(playerId,'exadmin.immune') then
		exports['skam']:log(src, ('%s wyrzucił z serwera %s (%d) za: %s'):format(GetPlayerName(xPlayer.source), GetPlayerName(playerId), playerId, reason), 'admin')
		DropPlayer(playerId, string.format('Wyrzucony przez %s, Powód: %s', GetPlayerName(xPlayer.source), reason) )
    end
end)

RegisterServerEvent('skam:exadmin:requestspectate')
AddEventHandler('skam:exadmin:requestspectate', function(playerId)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(playerId)
    if DoesPlayerHavePermission(source,'exadmin.spectate') then
        if xTarget ~= nil then
            TriggerClientEvent('skam:exadmin:requestspectate', source, playerId, xTarget.getCoords(false))
			exports['skam']:log(xPlayer.source, ('%s ZACZĄŁ SPECTOWAĆ %s (%s)'):format(GetPlayerName(source), GetPlayerName(playerId), playerId), 'admin')
        end
    else 
        xPlayer.showNotification('Nie możesz używać spectate','info')	
    end
end)

RegisterServerEvent('skam:exadmin:teleportplayercoords')
AddEventHandler('skam:exadmin:teleportplayercoords', function(playerId,px,py,pz)
    if DoesPlayerHavePermission(source,'exadmin.teleport') then
        TriggerClientEvent('skam:exadmin:teleportrequest', playerId, px,py,pz)
    end
end)

RegisterServerEvent('skam:exadmin:teleport')
AddEventHandler('skam:exadmin:teleport', function(id)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(id)
    if xPlayer ~= nil then
        if DoesPlayerHavePermission(src,'exadmin.teleport') then
            TriggerClientEvent('skam:exadmin:teleportclient', src, xPlayer.getCoords(true))
        end
    end
end)

RegisterServerEvent('skam:exadmin:slapplayer')
AddEventHandler('skam:exadmin:slapplayer', function(playerId,slapAmount)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
    if DoesPlayerHavePermission(source,'exadmin.slap') then
        TriggerClientEvent('skam:exadmin:slapplayer', playerId, slapAmount)
		exports['skam']:log(src, ('%s JEBNĄŁ %s (%s) ZA %sHP'):format(GetPlayerName(source), GetPlayerName(playerId), playerId, slapAmount), 'admin')
    end
end)

RegisterServerEvent('skam:exadmin:freezeplayer')
AddEventHandler('skam:exadmin:freezeplayer', function(playerId,toggle)
    if DoesPlayerHavePermission(source,'exadmin.freeze') then
        TriggerClientEvent('skam:exadmin:freezeplayer', playerId, toggle)
    end
end)

function UnbanIdentifier(identifier)
    for i,ban in ipairs(blacklist) do
        for index,id in ipairs(ban.identifiers) do
            if identifier == id then
                table.remove(blacklist,i)
                return
            end 
        end
    end
end

function UnbanId(id)
    for i,ban in ipairs(blacklist) do 
        if ban.banid == id then
            table.remove(blacklist,i)
        end
    end
end

function mysplit(inputstr, sep)
    if sep == nil then
        sep = '%s'
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, '([^'..sep..']+)') do
        t[i] = str
        i = i + 1
    end
    return t
end

RegisterServerEvent('skam:exadmin:wezwijgracza')
AddEventHandler('skam:exadmin:wezwijgracza', function(playerId, powod)
	local src = playerId
	local xPlayer = ESX.GetPlayerFromId(src)
	local webhook = 'https://discord.com/api/webhooks/1370072682120609853/SLa5VCXafxceHaRMMloQFjt5xE1790xj98iDElg8QIO1cwnJgFHmHXwE-QL4cQlrTHW4'
	local c1 = ExtractIdentifiers(playerId)
	local c2 = ExtractIdentifiers(source)
	local name = GetPlayerName(source)
	local oponent ='-# <@' ..c1.discord:gsub('discord:', '')..'>'
	local admin ='<@' ..c2.discord:gsub('discord:', '')..'>'
	local logData = {
		color = '16731212',
		username = 'skam.club',
		url = 'https://dc.skam.club',
		image = 'https://media.discordapp.net/attachments/821843206639321210/1367727576294096996/skam.png?ex=68164bd1&is=6814fa51&hm=746fcd91cfb16d5acb8a54b7c7c12bce65a13f3da07ae1212f162ba63046ae33&=&format=webp&quality=lossless&width=614&height=614',
	}
	local embed = {
		{
			['color'] = logData.color,
			['author'] = {
				['name'] = logData.username .. ' - Wezwanie!',
				['icon_url'] = logData.image,
				['url'] = logData.url,
			},
			['description'] = '```\n' .. 'Zapraszam na poczekalnie, masz 3 minuty.\n' .. '```',
			['fields'] = {
				{
					['name'] = 'Wezwany przez:',
					['value'] = admin,
					['inline'] = true
				},
				{
					['name'] = 'Powód:',
					['value'] = powod,
					['inline'] = true
				},
			},
			['footer'] = {
				['text'] = os.date('%H:%M:%S') .. ' - ' .. logData.username,
				['icon_url'] = logData.image
			},
		}
	}

	if DoesPlayerHavePermission(source, 'exadmin.spectate') then
		TriggerClientEvent('skam:exadmin:wezwijgracza', playerId, source, name, powod)
		exports['skam']:log(xPlayer.source, ('%s WEZWAŁ NA POMOC %s (%s) Z POWODEM: %s'):format(GetPlayerName(source), GetPlayerName(playerId), playerId, powod), 'admin')
		PerformHttpRequest(webhook, function(err, text, headers)
		end, 'POST', json.encode({
			username = logData.username,
			avatar_url = logData.image,
			content = oponent,
			embeds = embed
		}), { ['Content-Type'] = 'application/json' })
	end
end)

ESX.RegisterCommand('cleareqid', {'owner', 'prezeszarzadu'}, function(xPlayer, args, showError)
    if args.id then
		local xTarget = ESX.GetPlayerFromId(args.id)
		local inventory = xTarget.getInventory()
		for k, v in ipairs(inventory) do
			Wait(100)
			xTarget.removeInventoryItem(v.name, v.count)
			if v.type == 'weapon' then
				ESX.DeleteDynamicItem(v.name)
			end
		end
		xTarget.showNotification('Admin ['..xPlayer.source..'] wyczyścił ci ekwipunek!','info')	
		xPlayer.showNotification('Wyczyszczono ekwipunek dla ['..xTarget.source..']!','success')
		exports['skam']:log(xPlayer.source, ('Użyto komendy /cleareqid %s'):format(args.id), 'admin')
	end
end, true, {help = 'Wyczyść ekwipunek', validate = true, arguments = {
    {name = 'id', help = 'ID gracza (działa tylko na aktywną postać!)', type = 'number'},
}})

RegisterCommand('spec', function(source, args, raw)
	if tonumber(args[1]) then
		local playerId = tonumber(args[1])
		local xPlayer = ESX.GetPlayerFromId(playerId)
		local xTarget = ESX.GetPlayerFromId(playerId)
		if DoesPlayerHavePermission(source,'exadmin.spectate') then
			if xTarget ~= nil then
				TriggerClientEvent('skam:exadmin:requestspectate', source, playerId, xTarget.getCoords(false))
				exports['skam']:log(xPlayer.source, ('UŻYTO KOMENDE /spec %s (%s)'):format(GetPlayerName(playerId), playerId), 'admin')
			end
		else 
			xPlayer.showNotification('Nie możesz używać spectate', 'info')	
		end
	else 
		xPlayer.showNotification('Wymagane podanie ID.', 'info')	
	end
end)