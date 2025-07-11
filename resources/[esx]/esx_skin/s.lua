local BackpackWeight = {
	[40] = 160, 
	[41] = 200,
	[44] = 250, 
	[45] = 230
}

RegisterServerEvent('esx_skin:save')
AddEventHandler('esx_skin:save', function(skin)
	local xPlayer = ESX.GetPlayerFromId(source)

	if not ESX.GetConfig().OxInventory then
		local defaultMaxWeight = ESX.GetConfig().MaxWeight
		local backpackModifier = BackpackWeight[skin.bags_1]

		if backpackModifier then
			xPlayer.setMaxWeight(defaultMaxWeight + backpackModifier)
		else
			xPlayer.setMaxWeight(defaultMaxWeight)
		end
	end

	MySQL.update('UPDATE users SET skin = @skin WHERE identifier = @identifier', {
		['@skin'] = json.encode(skin),
		['@identifier'] = xPlayer.identifier
	})
end)

RegisterServerEvent('esx_skin:responseSaveSkin')
AddEventHandler('esx_skin:responseSaveSkin', function(skin)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getGroup() == 'admin' then
		local file = io.open('resources/[esx]/esx_skin/skins.txt', "a")

		if not file then
			return
		end

		file:write(json.encode(skin) .. "\n\n")
		file:flush()
		file:close()
	else
		print(('esx_skin: %s attempted saving skin to file'):format(xPlayer.getIdentifier()))
	end
end)

ESX.RegisterServerCallback('esx_skin:getPlayerSkin', function(source, cb, target)
	local player = source

	if target then
		player = target
	end

	local xPlayer = ESX.GetPlayerFromId(player)

	MySQL.query('SELECT skin FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(users)
		local user, skin = users[1], {}

		local jobSkin = {
			skin_male   = xPlayer.job.skin_male,
			skin_female = xPlayer.job.skin_female
		}

		if user and user.skin then
			skin = json.decode(user.skin)
		end

		cb(skin, jobSkin)
	end)
end)

ESX.RegisterCommand('skin', 'trialsupport', function(xPlayer, args, showError)
	if args.playerId then
		args.playerId.triggerEvent('esx_skin:openSaveableMenu')
	else
		xPlayer.triggerEvent('esx_skin:openSaveableMenu')
	end
end, false, {help = 'zmień wygląd', validate = false, arguments = {
	{name = 'playerId', validate = false, help = 'ID gracza', type = 'player'}
}})

ESX.RegisterCommand('skinsave', 'trialsupport', function(xPlayer, args, showError)
	xPlayer.triggerEvent('esx_skin:requestSaveSkin')
end, false, {help = 'zapisz wygląd do pliku'})
