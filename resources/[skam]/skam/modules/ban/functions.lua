Config['bansystem'] = {}
Config['bansystem'].EnableDiscordLink = true
Config['bansystem'].data = {
	serverColor = 2829617,
	serverName  = "skam.club",
	serverLogo  = "https://r2.fivemanage.com/dUkDYgTeTOjaw8RLwNEAV/skam.png",
	serverUrl   = "https://skam.club",
	discordLink = "https://dc.skam.club",
	webhook = {
		banroom = "https://discord.com/api/webhooks/1370077959993561088/J6CgZ6noU-V3e3boT7gonX0fdgEZm6x3jFAzW14ZeB2WyhJzx9Zrp1FrtJHg-CFbuCVe",
		fgbanroom = "https://discord.com/api/webhooks/1370077959993561088/J6CgZ6noU-V3e3boT7gonX0fdgEZm6x3jFAzW14ZeB2WyhJzx9Zrp1FrtJHg-CFbuCVe",
		unban = "https://discord.com/api/webhooks/1384264545673154715/7qSrdoxJbZokbuXNcOPvO8L6-aKAFnZAuPQL5pH18-YecoEZiVoTnMRbp21kLtJnUdDL"
	}
}

local function formatTargetIds(targetIds)
    if not targetIds or targetIds == "N/A" then
        return nil
    end

    local formattedIds = {}

    for _, id in ipairs(targetIds) do
        if id:find("discord:") then
            table.insert(formattedIds, "<@" .. id:gsub("discord:", "") .. ">")
        end
    end

    return table.concat(formattedIds, ", ")
end

function txAdminBanWebhook(author, reason, actionId, expiration, targetIds, targetName)
    local data = {
		avatar_url = Config['bansystem'].data.serverLogo,
		username = Config['bansystem'].data.serverName,
        content = formatTargetIds(targetIds) or 'N/A',
        embeds = {{
            title = 'Zbanowano gracza (txAdmin)',
            color = tonumber(Config['bansystem'].data.serverColor),
            description = string.format(
				'```Gracz: %s\nPowód: %s\nBanId: %s\nCzas bana: %s\nZbanowany przez: %s```\n-# **Masz możliwość wykupu na: [%s](%s)**',
				targetName or 'Nieznany',
				reason or 'Nie podano',
				tostring(actionId) or 'N/D',
				expiration and os.date('%Y-%m-%d %H:%M:%S', expiration) or 'Permanentny',
				author or 'Nieznany',
				Config['bansystem'].data.serverName,
				Config['bansystem'].data.serverUrl
			),
            footer = { text = os.date('%Y-%m-%d %H:%M:%S', os.time()) .. ' - ' .. Config['bansystem'].data.serverName, icon_url = Config['bansystem'].data.serverLogo },
			avatar_url = Config['bansystem'].data.serverLogo
        }}
    }

    PerformHttpRequest(Config['bansystem'].data.webhook.banroom, function(err, text, headers)
	end, 'POST', json.encode(data), { ['Content-Type'] = 'application/json' })
end

AddEventHandler('txAdmin:events:playerBanned', function(eventData)
    txAdminBanWebhook(
        eventData.author,
        eventData.reason,
        eventData.actionId,
        eventData.expiration,
        eventData.targetIds,
        eventData.targetName
    )
end)

function FGBanWebhook(discord, author, reason, actionId, screenshot_url)
    local data = {
        avatar_url = Config['bansystem'].data.serverLogo,
        username = Config['bansystem'].data.serverName,
        content = discord and ('<@' .. discord .. '>') or 'N/A',
        embeds = {{
            title = 'Zbanowano gracza (FiveGuard)',
            color = tonumber(Config['bansystem'].data.serverColor),
            description = string.format(
                '```Gracz: %s\nPowód: %s\nBanId: %s```\n-# **Masz możliwość wykupu na: [%s](%s)**',
                author or 'Nieznany',
                reason or 'Nie podano',
                actionId or 'N/D',
                Config['bansystem'].data.serverName,
                Config['bansystem'].data.serverUrl
            ),
            footer = {
                text = os.date('%Y-%m-%d %H:%M:%S', os.time()) .. ' - ' .. Config['bansystem'].data.serverName,
                icon_url = Config['bansystem'].data.serverLogo
            },
            thumbnail = {
                url = screenshot_url
            }
        }}
    }

    PerformHttpRequest(Config['bansystem'].data.webhook.fgbanroom, function(err, text, headers)
        if err ~= 200 then
            --print("Błąd wysyłania webhooka: " .. (err or "Nieznany błąd"))
        else
            --print("Webhook wysłany pomyślnie")
        end
    end, 'POST', json.encode(data), { ['Content-Type'] = 'application/json' })
end

WaitTimeToUnbanAfterBan = 3

OnlyKickReason = {
    'Explosive Ammo',
}

OnlyKickKeyword = {
    ['anti_internal_eulen'] = {
        Keyword = {
            'Detected Internal Cheat: Eulen'
        }
    },
    ['spawn_vehicles_too_fast'] = {
        Keyword = {
            'Spawned:', 'vehicles in', 'seconds',
        }
    },
    ['anti_mass_same_entity'] = {
        Keyword = {
            'Anti Mass Same Entities:', 'entities in', 'seconds'
        }
    },
}

AddEventHandler('fg:BanHandler', function(BanId, data, additional_info, screenshot_url)
	for _, v in pairs(OnlyKickReason) do
        if data.reason == v then
            Wait(WaitTimeToUnbanAfterBan * 1000)
            exports["JakJaCieRucham"]:UnbanId(BanId)
            break
        end
    end

    for k, v in pairs(OnlyKickKeyword) do
        local conform = 0
        for _, v2 in pairs(v.Keyword) do
            if string.find(data.reason, v2, 1) then
                conform = conform + 1
                if conform >= #v.Keyword then
                    Wait(WaitTimeToUnbanAfterBan * 1000)
					exports["JakJaCieRucham"]:UnbanId(BanId)
                    break
                end
            end
        end
    end

	FGBanWebhook(
		data.discord,
        data.name,
        data.reason,
        tostring(BanId),
		screenshot_url
    )
end)

function txAdminUnbanWebhook(actionId, actionReason, playerName, targetIds, revokedBy)
    local data = {
		avatar_url = Config['bansystem'].data.serverLogo,
		username = Config['bansystem'].data.serverName,
        embeds = {{
            title = 'Gracz odblokowany (txAdmin)',
            color = tonumber(Config['bansystem'].data.serverColor),
            description = string.format(
				'```Gracz: %s\nPowód: %s\nBanId: %s\nOdblokowany przez: %s```',
				tostring(playerName) or 'Nieznany',
				tostring(actionReason) or 'Nie podano',
				tostring(actionId) or 'N/A',
				tostring(revokedBy) or 'Nieznany'
			),
            footer = { text = os.date('%Y-%m-%d %H:%M:%S', os.time()) .. ' - ' .. Config['bansystem'].data.serverName, icon_url = Config['bansystem'].data.serverLogo },
			avatar_url = Config['bansystem'].data.serverLogo
        }}
    }

    PerformHttpRequest(Config['bansystem'].data.webhook.unban, function(err, text, headers)
	end, 'POST', json.encode(data), { ['Content-Type'] = 'application/json' })
end

AddEventHandler('txAdmin:events:actionRevoked', function(eventData)
    txAdminUnbanWebhook(
        eventData.actionId,
        eventData.actionReason,
        eventData.playerName,
        eventData.targetIds,
        eventData.revokedBy
    )
end)

function cmdban(source, args)
	local license,steam,liveid,xblid,discord,playerip
	local target    = tonumber(args[1])
	local duree     = tonumber(args[2])
	local reason    = table.concat(args, " ",3)

	if args[1] then		
		if reason == "" then
			reason = "Nie podano powodu."
		end
		if target and target > 0 then
			local ping = GetPlayerPing(target)

			if ping and ping > 0 then
				if duree and duree < 365 then
					local targetplayername = GetPlayerName(target)
					local sourceplayername = ""
					if source == false then
						sourceplayername = "Console"
					else
						sourceplayername = source.name
					end

					for k,v in ipairs(GetPlayerIdentifiers(target))do
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
				
					if duree > 0 then
						ban(source,license,steam,liveid,xblid,discord,playerip,targetplayername,sourceplayername,duree,reason,0) --Timed ban here
						DropPlayer(target, "Zostałeś zbanowany za: " .. reason)
					else
						ban(source,license,steam,liveid,xblid,discord,playerip,targetplayername,sourceplayername,duree,reason,1) --Perm ban here
						DropPlayer(target, "Zostałeś zbanowany permanentnie za: " .. reason)
					end
				
				else
					TriggerEvent('skam$bans:sendMessage', source, "Zły czas bana")
				end	
			else
				TriggerEvent('skam$bans:sendMessage', source, "Nie znaleziono gracza o takim ID")
			end
		else
			TriggerEvent('skam$bans:sendMessage', source, "Nie znaleziono gracza o takim ID")
		end
	else
		TriggerEvent('skam$bans:sendMessage', source, "/ban (ID) (Ilość Dni) (Powód Bana)")
	end
end

function cmdunban(source, args)
	if args[1] then
		local target = table.concat(args, " ")

		MySQL.Async.fetchAll('SELECT * FROM banlist WHERE license LIKE @playername', {
			['@playername'] = ("%" .. target .. "%")
		}, function(data)
			if data[1] then
				if #data > 1 then
					TriggerEvent('skam$bans:sendMessage', source, "Za dużo wyników, podaj konkretniejsze informacje.")
					for i = 1, #data, 1 do
						TriggerEvent('skam$bans:sendMessage', source, data[i].license)
					end
				else
					MySQL.Async.execute('DELETE FROM banlist WHERE license = @name', {
						['@name'] = data[1].license
					}, function()
						loadBanList()
						local sourceplayername = source and source.name or "Console"

						local description = string.format(
							"**Anulowano Ban!**\n```\nGracza: %s\nOdbanowany przez: %s\n```",
							tostring(target),
							tostring(sourceplayername)
						)

						local serverColorInt = tonumber(Config['bansystem'].data.serverColor)

						local embeds = {{
							["color"] = serverColorInt,
							['author'] = {
								['name'] = Config['bansystem'].data.serverName .. ' - UNBAN',
								['icon_url'] = Config['bansystem'].data.serverLogo,
								['url'] = Config['bansystem'].data.serverUrl,
							},
							["title"] = "- System Banów",
							["description"] = description,
							["footer"] = {
								["text"] = os.date('%Y-%m-%d %H:%M:%S', os.time()) .. " - " .. Config['bansystem'].data.serverName,
								['icon_url'] = Config['bansystem'].data.serverLogo
							},
						}}

						local content = (discord1 and discord1 ~= "N/A" and "<@" .. (discord1:gsub("discord:", "")) .. ">" or nil)

						PerformHttpRequest(Config['bansystem'].data.webhook.unban, function(err, text, headers) end, 'POST', json.encode({
							content = content,
							username = Config['bansystem'].data.serverName,
							embeds = embeds,
							avatar_url = Config['bansystem'].data.serverLogo
						}), { ['Content-Type'] = 'application/json' })

						TriggerEvent('skam$bans:sendMessage', source, data[1].license .. " został odbanowany")
					end)
				end
			else
				TriggerEvent('skam$bans:sendMessage', source, "Podana nazwa nie jest poprawna")
			end
		end)
	else
		TriggerEvent('skam$bans:sendMessage', source, "Podana nazwa nie jest poprawna")
	end
end

function cmdbanoffline(source, args)
	if args ~= "" then
		local target           = args[1]
		local duree            = tonumber(args[2])
		local reason           = table.concat(args, " ",3)
		local sourceplayername = ""
		print(target)
		if source == false then
			sourceplayername = "Console"
		else
			sourceplayername = source.name
		end

		if duree ~= "" then
			if target ~= "" then
				MySQL.Async.fetchAll('SELECT * FROM baninfo WHERE license = @license', 
				{
					['@license'] = "license:"..target
				}, function(data)
					if data[1] then
						if duree and duree < 365 then
							if reason == "" then
								reason = "Nie podano powodu."
							end
							if duree > 0 then
								ban(source,data[1].license,data[1].steam,data[1].liveid,data[1].xblid,data[1].discord,data[1].playerip,data[1].playername,sourceplayername,duree,reason,0) --Timed ban here
							else
								ban(source,data[1].license,data[1].steam,data[1].liveid,data[1].xblid,data[1].discord,data[1].playerip,data[1].playername,sourceplayername,duree,reason,1) --Perm ban here
							end
						else
							TriggerEvent('skam$bans:sendMessage', source, "Zły czas bana")
						end
					else
						TriggerEvent('skam$bans:sendMessage', source, "Nie znaleziono gracza o takim ID")
					end
				end)
			else
				TriggerEvent('skam$bans:sendMessage', source, "Podana nazwa nie jest poprawna")
			end
		else
			TriggerEvent('skam$bans:sendMessage', source, "Zły czas bana")
			TriggerEvent('skam$bans:sendMessage', source, "/banoffline (Permid) (Okres w dniach) (Nick steam)")
		end
	else
		TriggerEvent('skam$bans:sendMessage', source, "/banoffline (Permid) (Okres w dniach) (Nick steam)")
	end
end

function cmdbanhistory(source, args)
	if args[1] and BanListHistory then
	local nombre = (tonumber(args[1]))
	local name   = table.concat(args, " ",1)
		if name ~= "" then
			if nombre and nombre > 0 then
				local expiration = BanListHistory[nombre].expiration
				local timeat     = BanListHistory[nombre].timeat
				local calcul1    = expiration - timeat
				local calcul2    = calcul1 / 86400
				local calcul2 	 = math.ceil(calcul2)
				local resultat   = tostring(BanListHistory[nombre].targetplayername.." , "..BanListHistory[nombre].sourceplayername.." , "..BanListHistory[nombre].reason.." , "..calcul2.." dni ".." , "..BanListHistory[nombre].added)

				TriggerEvent('skam$bans:sendMessage', source, (nombre .." : ".. resultat))
			else
				for i = 1, #BanListHistory, 1 do
					if (tostring(BanListHistory[i].targetplayername)) == tostring(name) then
						local expiration = BanListHistory[i].expiration
						local timeat     = BanListHistory[i].timeat
						local calcul1    = expiration - timeat
						local calcul2    = calcul1 / 86400
						local calcul2 	 = math.ceil(calcul2)					
						local resultat   = tostring(BanListHistory[i].targetplayername.." , "..BanListHistory[i].sourceplayername.." , "..BanListHistory[i].reason.." , "..calcul2.." dni ".." , "..BanListHistory[i].added)

						TriggerEvent('skam$bans:sendMessage', source, (i .." : ".. resultat))
					end
				end
			end
		else
			TriggerEvent('skam$bans:sendMessage', source, "Podana nazwa nie jest poprawna")
		end
	else
		TriggerEvent('skam$bans:sendMessage', source, "/banhistory (Nick Steam) or /banhistory 1,2,2,4......")
	end
end

function ExtractIdentifiers(playerId)
    local identifiers = {
		steam = "",
		discord = "",
		license = "",
		xbl = "",
		live = ""
	}

	for i = 0, GetNumPlayerIdentifiers(playerId) - 1 do
		local id = GetPlayerIdentifier(playerId, i)

		if string.find(id, "steam") then
			identifiers.steam = id
		elseif string.find(id, "discord") then
			identifiers.discord = id
		elseif string.find(id, "license") then
			identifiers.license = id
		elseif string.find(id, "xbl") then
			identifiers.xbl = id
		elseif string.find(id, "live") then
			identifiers.live = id
		end
	end

	return identifiers
end

function ban(source, license, steam, liveid, xblid, discord, playerip, targetplayername, sourceplayername, duree, reason, permanent)
	MySQL.Async.fetchAll('SELECT * FROM banlist WHERE targetplayername LIKE @playername',
	{
		['@playername'] = ("%" .. targetplayername .. "%")
	}, function(data)
		if not data[1] then
			local expiration = duree * 3600
			local timeat = os.time()
			local added = os.date()

			if expiration < os.time() then
				expiration = os.time() + expiration
			end

			table.insert(BanList, {
				license = license,
				steam = steam,
				liveid = liveid,
				xblid = xblid,
				discord = discord,
				playerip = playerip,
				reason = reason,
				expiration = expiration,
				permanent = permanent
			})

			MySQL.Async.execute(
				'INSERT INTO banlist (license,steam,liveid,xblid,discord,playerip,targetplayername,sourceplayername,reason,expiration,timeat,permanent) VALUES (@license,@steam,@liveid,@xblid,@discord,@playerip,@targetplayername,@sourceplayername,@reason,@expiration,@timeat,@permanent)',
				{
					['@license'] = license,
					['@steam'] = steam,
					['@liveid'] = liveid,
					['@xblid'] = xblid,
					['@discord'] = discord,
					['@playerip'] = playerip,
					['@targetplayername'] = targetplayername,
					['@sourceplayername'] = sourceplayername,
					['@reason'] = reason,
					['@expiration'] = expiration,
					['@timeat'] = timeat,
					['@permanent'] = permanent,
				},
				function ()
				end
			)

			if permanent == 0 then
				TriggerEvent('skam$bans:sendMessage', source, ("Zostałeś zbanowany za: " .. targetplayername .. " trwa do: " .. duree .. " dni. Za: " .. reason))
			else
				TriggerEvent('skam$bans:sendMessage', source, ("Zostałeś zbanowany za: " .. targetplayername .. " permanentnie za: " .. reason))
			end

			if Config['bansystem'].EnableDiscordLink then
				local license1, steam1, liveid1, xblid1, discord1, playerip1, targetplayername1, sourceplayername1
				local message
				if not license then license1 = "N/A" else license1 = license end
				if not steam then steam1 = "N/A" else steam1 = steam end
				if not liveid then liveid1 = "N/A" else liveid1 = liveid end
				if not xblid then xblid1 = "N/A" else xblid1 = xblid end
				if not discord then discord1 = "N/A" else discord1 = discord end
				if not playerip then playerip1 = "N/A" else playerip1 = playerip end
				if not targetplayername then targetplayername1 = "N/A" else targetplayername1 = targetplayername end
				if not sourceplayername then sourceplayername1 = "Joueur Inconnu" else sourceplayername1 = sourceplayername end

				local description = string.format(
					"**Kogo:** %s\n**Powód:** %s\n**Kończy się:** %s\n**Zbanowany przez:** %s\n-# **Masz możliwość wykupu na: [%s](%s)**",
					tostring(targetplayername1),
					tostring(reason),
					(permanent == 0 and ("<t:" .. tostring(expiration) .. ":R>") or "Nigdy"),
					tostring(sourceplayername1),
					Config['bansystem'].data.serverName,
					Config['bansystem'].data.serverUrl
				)

				local serverColorInt = tonumber(Config['bansystem'].data.serverColor)

				local embeds = {{
					["color"] = serverColorInt,
					["title"] = "Zbanowano gracza!",
					["description"] = description,
					["footer"] = {
						["text"] = os.date('%Y-%m-%d %H:%M:%S', os.time()) .. " - " .. Config['bansystem'].data.serverName,
						['icon_url'] = Config['bansystem'].data.serverLogo
					},
					["thumbnail"] = {
						["url"] = Config['bansystem'].data.serverLogo
					}
				}}

				local content = (discord1 and discord1 ~= "N/A" and "<@" .. (discord1:gsub("discord:", "")) .. ">" or nil)

				PerformHttpRequest(Config['bansystem'].data.webhook.banroom, function(err, text, headers) end, 'POST', json.encode({ 
					content = content,
					username = Config['bansystem'].data.serverName,
					embeds = embeds,
					avatar_url = Config['bansystem'].data.serverLogo
				}), { ['Content-Type'] = 'application/json' })
			end

			MySQL.Async.execute(
				'INSERT INTO banlisthistory (license,steam,liveid,xblid,discord,playerip,targetplayername,sourceplayername,reason,added,expiration,timeat,permanent) VALUES (@license,@steam,@liveid,@xblid,@discord,@playerip,@targetplayername,@sourceplayername,@reason,@added,@expiration,@timeat,@permanent)',
				{
					['@license'] = license,
					['@steam'] = steam,
					['@liveid'] = liveid,
					['@xblid'] = xblid,
					['@discord'] = discord,
					['@playerip'] = playerip,
					['@targetplayername'] = targetplayername,
					['@sourceplayername'] = sourceplayername,
					['@reason'] = reason,
					['@added'] = added,
					['@expiration'] = expiration,
					['@timeat'] = timeat,
					['@permanent'] = permanent,
				},
				function ()
				end
			)

			BanListHistoryLoad = false
		else
			TriggerEvent('skam$bans:sendMessage', source, (targetplayername .. " jest już zbanowany za: " .. reason))
		end
	end)
end

exports('ban', ban)

function loadBanList()
	MySQL.Async.fetchAll('SELECT * FROM banlist', {}, function (data)
		BanList = {}

		for i=1, #data, 1 do
		table.insert(BanList, {
			license    = data[i].license,
			steam = data[i].steam,
			liveid     = data[i].liveid,
			xblid      = data[i].xblid,
			discord    = data[i].discord,
			playerip   = data[i].playerip,
			reason     = data[i].reason,
			expiration = data[i].expiration,
			permanent  = data[i].permanent
			})
		end
    end)
end
BanListHistory = {}

function loadBanListHistory()
    local offset = 0
    local limit = 500
    local finished = false
    local totalAdded = 0

    while not finished do
        MySQL.Async.fetchAll('SELECT * FROM banlisthistory LIMIT @limit OFFSET @offset', {
			['@limit'] = limit, ['@offset'] = offset
		}, function (data)
			if #data > 0 then
				for i = 1, #data do
					table.insert(BanListHistory, {
						license          = data[i].license,
						steam            = data[i].steam,
						liveid           = data[i].liveid,
						xblid            = data[i].xblid,
						discord          = data[i].discord,
						playerip         = data[i].playerip,
						targetplayername = data[i].targetplayername,
						sourceplayername = data[i].sourceplayername,
						reason           = data[i].reason,
						added            = data[i].added,
						expiration       = data[i].expiration,
						permanent        = data[i].permanent,
						timeat           = data[i].timeat
					})
					totalAdded = totalAdded + 1
				end
				offset = offset + limit
			else
				finished = true
			end
		end)
        Citizen.Wait(500)
    end

	print('[SKAM.CLUB] Optimized banlisthistory ' .. totalAdded)
end

function deletebanned(license) 
	MySQL.Async.execute('DELETE FROM banlist WHERE license=@license', {
		['@license']  = license
	}, function ()
		loadBanList()
	end)
end

exports('revokeBanned', function(steam)
	MySQL.Async.execute('DELETE FROM banlist WHERE steam=@steam', {
		['@steam']  = steam
	}, function()
		loadBanList()
	end)
end)