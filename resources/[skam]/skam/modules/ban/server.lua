BanList            = {}
BanListLoad        = false
BanListHistory     = {}
BanListHistoryLoad = false

Config['bansystem'] = {}
Config['bansystem'].ForceSteam = true

CreateThread(function()
	while true do
		Wait(1000)
        if BanListLoad == false then
			loadBanList()
			if BanList ~= {} then
				print("^0[SKAM.CLUB^0] Lista banów załadowana poprawnie.")
				BanListLoad = true
			else
				print("^0[SKAM.CLUB^0] ERROR: Nie udało się załadować listy banów.")
			end
		end
		if BanListHistoryLoad == false then
			loadBanListHistory()
            if BanListHistory ~= {} then
				print("^0[SKAM.CLUB^0] Historia banów załadowana poprawnie.")
				BanListHistoryLoad = true
			else
				print("^0[SKAM.CLUB^0] ERROR: Nie udało się załadować listy banów.")
			end
		end
	end
end)

MySQL.ready(function()
	MySQL.Async.fetchAll('SELECT * FROM banlist', {}, function(data)
		if #data ~= #BanList then
			BanList = {}

			for i=1, #data, 1 do
				local expiration = tonumber(data[i].expiration)
				if expiration then
					expiration = expiration / 1000
				else
					expiration = 0
				end

				table.insert(BanList, {
					license    = data[i].license,
					steam      = data[i].steam,
					hwid 	   = data[i].hwid,
					liveid     = data[i].liveid,
					xblid      = data[i].xblid,
					discord    = data[i].discord,
					playerip   = data[i].playerip,
					reason     = data[i].reason,
					added      = data[i].added,
					expiration = expiration,
					permanent  = data[i].permanent
				})
			end
		loadBanListHistory()
		--TriggerClientEvent('skam$bans:respond', -1)
		end
	end)
end)

ESX.RegisterCommand('ban', 'mod', function(source, args, user)
	cmdban(source, args)
end, true)

ESX.RegisterCommand('unban', 'mod', function(source, args, user)
	cmdunban(source, args)
end, true)

ESX.RegisterCommand('banoffline', 'mod', function(source, args, user)
	cmdbanoffline(source, args)
end, true)

ESX.RegisterCommand('banhistory', 'mod', function(source, args, user)
	cmdbanhistory(source, args)
end, true)

ESX.RegisterCommand('banreload', 'prezeszarzadu', function(source, args, user)
	BanListLoad        = false
	BanListHistoryLoad = false
	Wait(5000)
	if BanListLoad == true then
		print('^0[SKAM.CLUB] Lista banów załadowana poprawnie.')
		if BanListHistoryLoad == true then
			print('^0[SKAM.CLUB] Historia banów załadowana poprawnie.')
		end
	else
		print('^0[SKAM.CLUB] Nie udało się załadować listy banów.')
	end
end, true)

RegisterServerEvent('skam$bans:ICheat')
AddEventHandler('skam$bans:ICheat', function(reason,servertarget)
	local license,steam,liveid,xblid,discord,playerip,target
	local duree     = 0
	local reason    = reason

	if not reason then reason = 'WYJEBA TYPU BLIK?' end

	if tostring(source) == '' then
		target = tonumber(servertarget)
	else
		target = source
	end

	if target and target > 0 then
		local ping = GetPlayerPing(target)
	
		if ping and ping > 0 then
			if duree and duree < 365 then
				local sourceplayername = 'Anti-Cheat-System'
				local targetplayername = GetPlayerName(target)
					for k,v in ipairs(GetPlayerIdentifiers(target))do
						if string.sub(v, 1, string.len('license:')) == 'license:' then
							license = v
						elseif string.sub(v, 1, string.len('steam:')) == 'steam:' then
							steam = v
						elseif string.sub(v, 1, string.len('live:')) == 'live:' then
							liveid = v
						elseif string.sub(v, 1, string.len('xbl:')) == 'xbl:' then
							xblid  = v
						elseif string.sub(v, 1, string.len('discord:')) == 'discord:' then
							discord = v
						-- elseif string.sub(v, 1, string.len('ip:')) == 'ip:' then
						-- 	playerip = v
						end
					end
			
				if duree > 0 then
					ban(target,license,steam,liveid,xblid,discord,playerip,targetplayername,sourceplayername,duree,reason,0) --Timed ban here
					DropPlayer(target, 'Zostałeś zbanowany za: ' .. reason)
				else
					ban(target,license,steam,liveid,xblid,discord,playerip,targetplayername,sourceplayername,duree,reason,1) --Perm ban here
					DropPlayer(target, 'Zostałeś zbanowany permanentnie za: ' .. reason)
				end
			
			else
				print('skam$bans error : Auto-Cheat-Ban time invalid.')
			end	
		else
			print('skam$bans error : Auto-Cheat-Ban target are not online.')
		end
	else
		print('skam$bans error : Auto-Cheat-Ban have recive invalid id.')
	end
end)

-- RegisterServerEvent('skam$bans:checking')
-- AddEventHandler('skam$bans:checking', function()
-- 	doublecheck(source)
-- end)

AddEventHandler('playerConnecting', function (playerName,setKickReason)
	local license,steam,liveid,xblid,discord,playerip = '?','?','?','?','?','?'

	for k,v in ipairs(GetPlayerIdentifiers(source))do
		if string.sub(v, 1, string.len('license:')) == 'license:' then
			license = v
		elseif string.sub(v, 1, string.len('steam:')) == 'steam:' then
			steam = v
		elseif string.sub(v, 1, string.len('live:')) == 'live:' then
			liveid = v
		elseif string.sub(v, 1, string.len('xbl:')) == 'xbl:' then
			xblid  = v
		elseif string.sub(v, 1, string.len('discord:')) == 'discord:' then
			discord = v
		elseif string.sub(v, 1, string.len('ip:')) == 'ip:' then
			playerip = v
		end
	end

	if (Banlist == {}) then
		Citizen.Wait(1000)
	end

    if steam == 'n/a' and Config['bansystem'].ForceSteam then
		setKickReason('Uruchom aplikacje Steam i spróbuj ponownie.')
		CancelEvent()
    end

	for i = 1, #BanList, 1 do
		if 
			  ((tostring(BanList[i].license)) == tostring(license) 
			or (tostring(BanList[i].steam)) == tostring(steam) 
			or (tostring(BanList[i].liveid)) == tostring(liveid) 
			or (tostring(BanList[i].xblid)) == tostring(xblid) 
			or (tostring(BanList[i].discord)) == tostring(discord) 
			or (tostring(BanList[i].playerip)) == tostring(playerip)) 
		then

			if (tonumber(BanList[i].permanent)) == 1 then
				setKickReason("Zostałeś zbanowany permanentnie za: " .. BanList[i].reason)
				CancelEvent()
				break
			elseif (tonumber(BanList[i].expiration)) > os.time() then
				local tempsrestant     = (((tonumber(BanList[i].expiration)) - os.time())/60)
				if tempsrestant >= 1440 then
					local day        = (tempsrestant / 60) / 24
					local hrs        = (day - math.floor(day)) * 24
					local minutes    = (hrs - math.floor(hrs)) * 60
					local txtday     = math.floor(day)
					local txthrs     = math.floor(hrs)
					local txtminutes = math.ceil(minutes)
						setKickReason("Zostałeś zbanowany za: " .. BanList[i].reason .. ". Pozostało: " .. txtday .. " dni " ..txthrs .. " godzin " ..txtminutes .. " minut ")
						CancelEvent()
						break
				elseif tempsrestant >= 60 and tempsrestant < 1440 then
					local day        = (tempsrestant / 60) / 24
					local hrs        = tempsrestant / 60
					local minutes    = (hrs - math.floor(hrs)) * 60
					local txtday     = math.floor(day)
					local txthrs     = math.floor(hrs)
					local txtminutes = math.ceil(minutes)
						setKickReason("Zostałeś zbanowany za: " .. BanList[i].reason .. ". Pozostało: " .. txtday .. " dni " .. txthrs .. " godzin " .. txtminutes .. " minut ")
						CancelEvent()
						break
				elseif tempsrestant < 60 then
					local txtday     = 0
					local txthrs     = 0
					local txtminutes = math.ceil(tempsrestant)
						setKickReason("Zostałeś zbanowany za: " .. BanList[i].reason .. ". Pozostało: " .. txtday .. " dni " .. txthrs .. " godzin " .. txtminutes .. " minut ")
						CancelEvent()
						break
				end
			elseif (tonumber(BanList[i].expiration)) < os.time() and (tonumber(BanList[i].permanent)) == 0 then
				deletebanned(license)
				break
			end
		end
	end
end)

AddEventHandler('esx:playerLoaded', function(xPlayer)
	CreateThread(function()
	Wait(5000)
		local license,steam,liveid,xblid,discord,playerip
		local playername = GetPlayerName(xPlayer)

		for k,v in ipairs(GetPlayerIdentifiers(xPlayer))do
			if string.sub(v, 1, string.len("license:")) == "license:" then
				license = v
			elseif string.sub(v, 1, string.len("steam:")) == "steam:" then
				steam = v
			elseif string.sub(v, 1, string.len("live:")) == "live:" then
				liveid = v
			elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
				xblid  = v
			elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
				discord = v
			elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
				playerip = v
			end
		end

		MySQL.Async.fetchAll('SELECT * FROM `baninfo` WHERE `license` = @license', {
			['@license'] = license
		}, function(data)
		local found = false
			for i=1, #data, 1 do
				if data[i].license == license then
					found = true
				end
			end
			if not found then
				MySQL.Async.execute('INSERT INTO baninfo (license,steam,liveid,xblid,discord,playerip,playername) VALUES (@license,@steam,@liveid,@xblid,@discord,@playerip,@playername)', 
					{ 
					['@license']    = license,
					['@steam']      = steam,
					['@liveid']     = liveid,
					['@xblid']      = xblid,
					['@discord']    = discord,
					['@playerip']   = playerip,
					['@playername'] = playername
					},
					function ()
				end)
			else
				MySQL.Async.execute('UPDATE `baninfo` SET `steam` = @steam, `liveid` = @liveid, `xblid` = @xblid, `discord` = @discord, `playerip` = @playerip, `playername` = @playername WHERE `license` = @license', 
					{ 
						['@license']    = license,
						['@steam']      = steam,
						['@liveid']     = liveid,
						['@xblid']      = xblid,
						['@discord']    = discord,
						['@playerip']   = playerip,
						['@playername'] = playername
					},
					function ()
				end)
			end
		end)
	end)
end)

exports('revokeBanSteam', function(steamHex)
	MySQL.update('DELETE FROM banlist WHERE steam = @steam', {
        ['@steam']  = steamHex
    },function()
        for i=1, #BanList, 1 do
            if BanList[i] and BanList[i].steam and tostring(BanList[i].steam) == tostring(steamHex) then
                table.remove(BanList, i)
                break
            end
        end
    end)
end)

exports('subtractBanSteam', function(steamHex, newTimestamp)
	for i=1, #BanList, 1 do
        if BanList[i] and BanList[i].steam and tostring(BanList[i].steam) == tostring(steamHex) then
            BanList[i].expiration = newTimestamp
            break
        end
    end
end)