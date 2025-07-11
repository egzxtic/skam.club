cache.battles = {}
local functions = {}
local events = {}
local route = 'battleEvent/'
local eventRoute = GetCurrentResourceName() .. ':' .. route


functions.shuffleCoords = function(coords)
    math.randomseed(os.time() + math.random(1111,99999999))
    local baseCoords = {x = coords.x, y = coords.y, z = coords.z}
    baseCoords.x += math.random(-15.0, 15.0)
    baseCoords.y += math.random(-15.0, 15.0)
    return baseCoords
end

functions.handleDeadPlayer = function(player, vehicle)
    CreateThread(function()
        TriggerEvent('skam$death:revive')
        Wait(2000)
        local freeSeat = getVehicleFreeSeat(vehicle)
        SetPedIntoVehicle(GetPlayerPed(player), vehicle, freeSeat)
    end)
end

functions.getPlayerEnemy = function(source, team1, team2)
    local isTeam1 = false
    for _, member in pairs(team1.battleMembers) do
        if (member == source) then
            isTeam1 = true
        end
    end

    return (isTeam1) and 'team2' or 'team1'
end

functions.handlePlayer = function(player, battle)
    SetPlayerRoutingBucket(player, battle.id)
    SetPlayerRoutingBucket(player, battle.id)
    Player(player).state:set('inBattle', true, true)
    Player(player).state:set('inOrgBucket', false, true)
    battle.enemy = functions.getPlayerEnemy(player, battle.team1, battle.team2)
    TriggerClientEvent(eventRoute .. 'battleStarted', player, battle)
end

functions.hideVehiclesTemporary = function(vehicles)
    math.randomseed(os.time() + math.random(1111,9999999))
    local temporaryBucket = math.random(55555,66666)
    for vehicle, vehicleData in pairs(vehicles) do
        SetEntityRoutingBucket(vehicle, temporaryBucket)
    end
end

functions.getBattleLocationsByMapName = function(map)
    for _, mapObj in ipairs(config.battleMaps) do
        if (mapObj.name == map) then
            return mapObj
        end
    end
    return false
end

functions.assignVehicleCoords = function(vehicles, mapData, map)
    local afterBattleSpawns = config.inBattleConfig.afterBattleVehicleSpawns
    local usedLocations = {}
    local usedEndLocations = {}

    local curCarIndex = 1
    for vehicle, vehicleData in pairs(vehicles) do 
        if (map.mapWithVehicles ~= false) then
            vehicleData.startCoords = mapData.vehicleSpawns[curCarIndex]
        end
        vehicleData.afterPartyCoords = afterBattleSpawns[curCarIndex]
        curCarIndex += 1
    end
end

functions.prepareTeams = function(team1, team2, battle)
    local locations = battle.map

    if not (team1.colors) then
        team1.colors = vehicleColors[team1.org.name] or {255, 0, 0}
    end

    if not (team2.colors) then
        team2.colors = vehicleColors[team2.org.name] or {0, 153, 255}
    end
    
    battle.team1.enemy = 'team2'
    battle.team2.enemy = 'team1'
    if (battle.map.mapWithVehicles ~= false) then
        functions.assignVehicleCoords(team1.vehicles, locations.team1, locations)
        functions.assignVehicleCoords(team2.vehicles, locations.team2, locations)
        local passengersTeam1 = {}
        
        for vehicle, vehicleData in pairs(team1.vehicles) do

            if (DoesEntityExist(vehicle)) then
                Entity(vehicle).state:set('battleVeh', true, true)
                local team1Coords = vehicleData.startCoords
                SetEntityCoords(vehicle, team1Coords.x, team1Coords.y, team1Coords.z)

                SetVehicleCustomPrimaryColour(vehicle, team1.colors[1], team1.colors[2], team1.colors[3])
                SetVehicleCustomSecondaryColour(vehicle, team1.colors[1], team1.colors[2], team1.colors[3])
                FreezeEntityPosition(vehicle, true)
                SetTimeout(5000, function()
                    FreezeEntityPosition(vehicle, false)
                end)
                SetEntityHeading(vehicle, locations.team1.heading)
                SetEntityRoutingBucket(vehicle, battle.id)
                for _, passenger in ipairs(vehicleData.passengers) do
                    functions.handlePlayer(passenger.source, battle)
                    passengersTeam1[tostring(passenger.source)] = {
                        handled = true,
                        battleVeh = vehicle,
                        seatIndex = passenger.seatIndex
                    }
                    if (Player(passenger.source).state.isDead == true) then
                        functions.handleDeadPlayer(passenger.source, vehicle)
                    end
                end
            end
        end

        for _, member in ipairs(team1.battleMembers) do
            local handleObj = passengersTeam1[tostring(member)]
            local ped = GetPlayerPed(member)
            if not (handleObj) then
                SetEntityCoords(ped, locations.team1.center)
                functions.handlePlayer(member, battle)
            elseif (handleObj) and (GetVehiclePedIsIn(ped) == 0) then
                SetEntityCoords(ped, locations.team1.center)
                TaskWarpPedIntoVehicle(ped, handleObj.battleVeh, handleObj.seatIndex)
            end
        end

        local passengersTeam2 = {}
        for vehicle, vehicleData in pairs(team2.vehicles) do
            if (DoesEntityExist(vehicle)) then
                Entity(vehicle).state:set('battleVeh', true, true)
                local team2Coords = vehicleData.startCoords
                SetEntityCoords(vehicle, team2Coords.x, team2Coords.y, team2Coords.z)
                SetVehicleCustomPrimaryColour(vehicle, team2.colors[1], team2.colors[2], team2.colors[3])
                SetVehicleCustomSecondaryColour(vehicle, team2.colors[1], team2.colors[2], team2.colors[3])
                FreezeEntityPosition(vehicle, true)
                SetTimeout(5000, function()
                    FreezeEntityPosition(vehicle, false)
                end)
                SetEntityHeading(vehicle, locations.team2.heading)
                SetEntityRoutingBucket(vehicle, battle.id)
                for _, passenger in ipairs(vehicleData.passengers) do
                    functions.handlePlayer(passenger.source, battle)
                    passengersTeam2[tostring(passenger.source)] = {
                        handled = true,
                        battleVeh = vehicle,
                        seatIndex = passenger.seatIndex
                    }
                    if (Player(passenger.source).state.isDead == true) then
                        functions.handleDeadPlayer(passenger.source, locations.team2.center)
                    end
                end
            end
        end

        for _, member in ipairs(team2.battleMembers) do
            local handleObj = passengersTeam2[tostring(member)]
            local ped = GetPlayerPed(member)
            if not (handleObj) then
                SetEntityCoords(ped, locations.team2.center)
                functions.handlePlayer(member, battle)
            elseif (handleObj) and (GetVehiclePedIsIn(ped) == 0) then
                SetEntityCoords(ped, locations.team2.center)
                functions.handlePlayer(member, battle)
                TaskWarpPedIntoVehicle(ped, handleObj.battleVeh, handleObj.seatIndex)
            end
        end
    else
        functions.assignVehicleCoords(team1.vehicles, locations.team1, locations)
        functions.assignVehicleCoords(team2.vehicles, locations.team2, locations)
        for _, member in ipairs(team1.battleMembers) do
            local memberPed = GetPlayerPed(member)
            local team1Coords = locations.team1.center
            SetEntityCoords(memberPed, team1Coords.x, team1Coords.y, team1Coords.z)
            FreezeEntityPosition(memberPed, true)
            SetTimeout(5000, function()
                FreezeEntityPosition(memberPed, false)
            end)
            SetEntityHeading(memberPed, locations.team1.heading)
            SetPlayerRoutingBucket(member, battle.id)
            functions.handlePlayer(member, battle)
            if (Player(member).state.isDead == true) then
                functions.handleDeadPlayer(member, locations.team1.center)
            end
        end

        for _, member in ipairs(team2.battleMembers) do
            local memberPed = GetPlayerPed(member)
            local team2Coords = locations.team2.center
            SetEntityCoords(memberPed, team2Coords.x, team2Coords.y, team2Coords.z)
            FreezeEntityPosition(memberPed, true)
            SetTimeout(5000, function()
                FreezeEntityPosition(memberPed, false)
            end)
            SetEntityHeading(memberPed, locations.team2.heading)
            SetPlayerRoutingBucket(member, battle.id)
            functions.handlePlayer(member, battle)
            if (Player(member).state.isDead == true) then
                functions.handleDeadPlayer(member, locations.team2.center)
            end
        end

        functions.hideVehiclesTemporary(team1.vehicles)
        functions.hideVehiclesTemporary(team2.vehicles)
    end

    removeFromQueue(team1)
    removeFromQueue(team2)
end

startBattle = function(battle)
    -- print(battle.id, 'adding battle with battleid')
    table.insert(cache.battles, battle)
    CreateThread(function()
        functions.prepareTeams(battle.team1, battle.team2, battle)
    end)
end

functions.findBattle = function(source)
    local playerBattle = false
    for _, battle in pairs(cache.battles) do
        for _, member in ipairs(battle.team1.battleMembers) do
            if (member == source) then
                playerBattle = battle
                playerBattle.playersTeam = 'team1'
                playerBattle.enemyTeam = 'team2'
            end
        end

        if not (playerBattle) then
            for _, member in ipairs(battle.team2.battleMembers) do
                if (member == source) then
                    playerBattle = battle
                    playerBattle.playersTeam = 'team2'
                    playerBattle.enemyTeam = 'team1'
                end
            end
        end
    end

    return playerBattle
end

--TriggerClientEvent('okokNotify:Alert', killerId, 'Zabiłeś gracza', 'Gracz którego zabiłeś: <font color="#ff2626">' .. killedName .. ' [' .. killedPlayer .. ']</font><font color="white"><br>Odległość: <font color="green">' .. distance .. ' m</font>', 5000, 'warning', true)

--[[
local embeds = {
					{
						["avatar_url"] = "https://cdn.discordapp.com/attachments/839868781878706196/1057030392407924796/a2f85c909f4b488f2df0857e828c6504_1.png",
						["username"] = "skam.club",
						["author"] = {
							["name"] = "skam.club - Log System",
							["url"] = "https://o-rp.eu",
							["icon_url"] = "https://cdn.discordapp.com/attachments/839868781878706196/1057030392407924796/a2f85c909f4b488f2df0857e828c6504_1.png",
						},
						["color"] = 9936031,
						["title"] = "skam.club",
						["description"] = message,
						["type"]="rich",
						["footer"] = {
							["text"] = os.date() .. " | skam.club - Log System",
							["icon_url"] = "https://cdn.discordapp.com/attachments/839868781878706196/1057030392407924796/a2f85c909f4b488f2df0857e828c6504_1.png",
						},
					}
				}
				if message == nil or message == '' then return FALSE end
				
				local webhook = res[1].webhook
				PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({ username = name, avatar_url = 'https://cdn.discordapp.com/attachments/839868781878706196/1057030392407924796/a2f85c909f4b488f2df0857e828c6504_1.png', embeds = embeds}), { ['Content-Type'] = 'application/json' })		
https://cdn.discordapp.com/attachments/839868781878706196/1060630185357103294/a2f85c909f4b488f2df0857e828c6504_1.png
]]

local initialEmbed = {
    ['avatar_url'] = 'https://r2.fivemanage.com/mLT0vpmelOc22U071X5Zq/skam.png',
    ['title'] = 'Statystyki zabójstw podczas bitki',
    ['footer'] = {
        ['text'] = os.date() .. ' - skam.club',
        ['icon_url'] = 'https://r2.fivemanage.com/mLT0vpmelOc22U071X5Zq/skam.png'
    }
}

functions.generateMemberStatLine = function(member, kills, customOrg, impostors)
    local memberLine = ''
    local memberName = GetPlayerName(member)
    local discordId = GetPlayerIdentifierByType(member, 'discord') or 'brak discordid'
    discordId = "<@" .. discordId:gsub('discord:', '') .. '>' 
    memberLine = memberName .. (' (%s) - **%s** %s %s'):format(discordId, 
                                                            kills, 
                                                            (impostors[memberName]) and
                                                            ('(+%s impostorów)'):format(impostors[memberName].kills) or '',
                                                            (customOrg ~= nil) 
                                                            and ('(`%s`) \n'):format(customOrg) 
                                                            or '\n')
    return memberLine
end

functions.formTeamStats = function(stats, impostors, didWin)
    local newEmbed = {
        ['avatar_url'] = initialEmbed.avatar_url,
        ['title'] = initialEmbed.title,
        ['footer'] = initialEmbed.footer
    }

    newEmbed.color = (didWin) and 65280 or 16711680
    newEmbed.description = ''

    for killerId, kills in pairs(stats) do
        newEmbed.description = newEmbed.description .. functions.generateMemberStatLine(kills.id, tostring(kills.kills), kills.org, impostors)
    end

    if (#newEmbed.description < 1) then
        newEmbed.description = 'Brak zabójstw.'
    end

    return newEmbed
end

functions.sendEmbed = function(teamStats, teamImpostors, webhook, isWinner, enemy)
    local teamEmbed = functions.formTeamStats(teamStats, teamImpostors, isWinner)
    PerformHttpRequest(webhook, function(err,text,headers)
    
        -- print(err, 'result of sending post req to discord webhook')
    end, 'POST',
    json.encode({username = ('Bitka hostowana z %s'):format(enemy), avatar_url = teamEmbed.avatar_url, embeds = {teamEmbed}}), {['Content-Type'] = 'application/json'})
end

local orgs = exports['skam']
functions.addAutorefill = function(org, members)
    local autorefillItems = orgs:getAutorefillItems(org)
    TriggerEvent('esx_addoninventory:getSharedInventory', 'society_' .. org, function(inventory)
        for _, member in ipairs(members) do
            local notiStr = ''
            for _, autorefillItem in ipairs(autorefillItems) do
                local xPlayer = ESX.GetPlayerFromId(member)
                local invItem = inventory.getItem(autorefillItem.name)
                local playerInvItem = xPlayer.getInventoryItem(autorefillItem.name)
                local neededAmount = autorefillItem.count - playerInvItem.count
                if (neededAmount > 0 and invItem.count >= neededAmount and playerInvItem.count < tonumber(autorefillItem.count)) then
                    inventory.removeItem(autorefillItem.name, neededAmount)
                    xPlayer.addInventoryItem(autorefillItem.name, neededAmount)
                    notiStr = notiStr .. 'Oddano ' .. autorefillItem.label .. ' x' .. neededAmount .. '<br>'
                elseif (neededAmount > 0 and invItem.count < neededAmount) then
                    notiStr = notiStr .. 'Nie oddano ' .. autorefillItem.label .. ' x' .. neededAmount .. ' <font color="red">(BRAK TOWARU)<br><font color="white">'
                end
            end
            if (notiStr ~= '') then
                -- member.showNotification(notiStr)
                TriggerClientEvent('esx:showNotification', member, notiStr)
                -- TriggerClientEvent('okokNotify:Alert', member, 'AUTOREFILL', notiStr, 5000, 'success', true) 
            end
        end
    end)
end

events.handlePassengersAfterBattle = function(vehNetId,passengers, coords)
    local src = source
    local vehEntity = NetworkGetEntityFromNetworkId(vehNetId)

    --print('handlePassengersAfterBattle called')
    --print('vehNetId: ' .. tostring(vehNetId))
    --print('passengers: ' .. json.encode(passengers))
   -- print('coords: ' .. json.encode(coords))

    if (vehEntity ~= 0) then
        for _, passenger in ipairs(passengers) do
            TaskWarpPedIntoVehicle(GetPlayerPed(passenger.source), vehEntity, passenger.seatIndex)
            local tries = 0
            repeat 
                TaskWarpPedIntoVehicle(GetPlayerPed(passenger.source), vehEntity, passenger.seatIndex)
                Wait(5)
            until GetVehiclePedIsIn(GetPlayerPed(passenger.source), false) == vehEntity or tries >= 10
        end
    end
end


functions.endBattle = function(team, battleData)
    local afterPartyCoords = config.inBattleConfig.afterBattleSpawn

    -- print('endBattle called for team: ' .. team.org.name)
    -- print('battleData: ' .. json.encode(battleData))

    for _, member in ipairs(team.battleMembers) do
       -- print('Handling member: ' .. member)
        SetEntityCoords(GetPlayerPed(member), afterPartyCoords)
        Player(member).state:set('inBattle', nil, true)
        SetPlayerRoutingBucket(member, 1000 + tonumber(team.org.bucket))
        Player(member).state:set('inOrgBucket', true, true)
        TriggerClientEvent(eventRoute .. 'battleEnded', member, battleData, {skipVehicle = true})
    end
    Wait(800)
    Wait(1000)
    for vehicle, vehicleData in pairs(team.vehicles) do
        local vehExists = DoesEntityExist(vehicle)
        -- print('Handling vehicle: ' .. tostring(vehicle) .. ', exists: ' .. tostring(vehExists))
        if (vehExists) then
            local vehNetId = NetworkGetNetworkIdFromEntity(vehicle)
            local originalColor = vehicleData.originalColor
            local originalPrimaryRgb = config.vehicleColors[originalColor[1]]
            local originalSecondaryRgb = config.vehicleColors[originalColor[2]]

            for _, passenger in ipairs(vehicleData.passengers) do
                if (passenger.seatIndex == -1) then
                    -- print('Spawning vehicle for driver: ' .. passenger.source)
                    TriggerClientEvent(eventRoute .. 'handleVehicleAfterBattle', passenger.source, {
                        passengers = vehicleData.passengers,
                        vehSpawnPos = vehicleData.afterPartyCoords,
                        vehicleColors = originalColor,
                        vehProps = vehicleData.properties,
                        fromGarage = true
                    })
                    
                    Wait(1000)
                    if DoesEntityExist(vehicle) then
                        DeleteEntity(vehicle)
                        -- print('Old vehicle deleted after new one spawned')
                    end
                    break
                end
            end
        end
    end
    team.vehicles = {}
    cache.teams[team.org.name].vehicles = {}
    
    --[[ if (team.battleSettings.autorefill) then
        SetTimeout(3000, function()
            functions.addAutorefill(team.org.name, team.battleMembers)
        end)
    end ]]
end

local webhook = ''

local function sendbattlewebhook(message)
    local embed = {
        {
            ["author"] = {
              ["name"] = "skam.club - Bitki Hostowane",
              ["url"] = "http://skam.club/",
              ["icon_url"] = "https://r2.fivemanage.com/mLT0vpmelOc22U071X5Zq/skam.png",
            },
            ["color"] = "0xe91e63",
            ["title"] = "skam.club",
            ["description"] = message,
            ["footer"] = {
              ["text"] = os.date() .. " | skam.club - Bitki Hostowane",
              ["icon_url"] = "https://r2.fivemanage.com/mLT0vpmelOc22U071X5Zq/skam.png",
            }
        }
    }
  
    PerformHttpRequest(webhook,function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
end

functions.incrementOrgStatsAfterBattle = function(teams)
    -- [ winner handle ]
    local winnerTeam = teams.winner.org.name
    local sqlString = ('SELECT wins, loses FROM jobs WHERE name = ?')
    local oldWinnerStat = MySQL.query.await(sqlString, {winnerTeam})[1]
    local newWinnerWins = oldWinnerStat.wins + 1
    local winnerSqlString = ('UPDATE jobs SET wins = ? WHERE name = ?')

    -- [ loser handle ]
    local loserTeam = teams.loser.org.name
    local sqlString = ('SELECT loses, wins FROM jobs WHERE name = ?')
    local oldLoserStat = MySQL.query.await(sqlString, {loserTeam})[1]
    local newLoserLoses = oldLoserStat.loses + 1
    local loserSqlString = ('UPDATE jobs SET loses = ? WHERE name = ?')

    -- [ updating both at the same time]
    MySQL.update(winnerSqlString, {newWinnerWins,winnerTeam})
    MySQL.update(loserSqlString, {newLoserLoses,loserTeam})

    -- Webhook about winner
    local winnerTeamName = teams.winner.org.label
    local loserTeamName = teams.loser.org.label


    local winRatio = newWinnerWins / oldWinnerStat.loses
    local loseRatio = oldLoserStat.loses / newLoserLoses

    winRatio = string.format("%.2f", winRatio)
    loseRatio = string.format("%.2f", loseRatio)

    sendbattlewebhook(winnerTeamName.." (W:"..(newWinnerWins).." L:"..oldWinnerStat.loses..
    ", Razem: "..(newWinnerWins + oldWinnerStat.loses).." WR: "..winRatio..")\n** WYGRAŁA BITKE Z** \n"..loserTeamName..
    " (W:"..oldLoserStat.wins.." L:"..(newLoserLoses)..", Razem: "..(oldLoserStat.wins + newLoserLoses)..
    " WR: "..loseRatio..")")

  --  exports['skam']:ManipulateOrgCwel(winnerTeam, 5)
    local keychance = math.random(1, 100)
    if keychance < 20 then
        TriggerEvent('esx_addoninventory:getSharedInventory', 'society_' .. winnerTeam, function(account)
            account.addItem('klucz', 1)
        end)
    end
end

functions.insertTeamKill = function(xKiller, teamObject)
    if not (teamObject.teamKillers[xKiller.name]) then
        if (Player(xKiller.source).state.customOrgBucket) then
            teamObject.teamKillers[xKiller.name] = {kills = 1, id = xKiller.source, org = xKiller.job.label}
        else
            teamObject.teamKillers[xKiller.name] = {kills = 1, id = xKiller.source}
        end
    else
        if (Player(xKiller.source).state.customOrgBucket) then
            teamObject.teamKillers[xKiller.name] = {kills = teamObject.teamKillers[xKiller.name].kills + 1, id = xKiller.source, org = xKiller.job.label}
        else
            teamObject.teamKillers[xKiller.name].kills += 1
        end
    end
end

functions.insertTeamImpostor = function(xKiller, teamObject)
    if not (teamObject.impostors[xKiller.name]) then
        if (Player(xKiller.source).state.customOrgBucket) then
            teamObject.impostors[xKiller.name] = {kills = 1, id = xKiller.source, org = xKiller.job.label}
        else
            teamObject.impostors[xKiller.name] = {kills = 1, id = xKiller.source}
        end
    else
        if (Player(xKiller.source).state.customOrgBucket) then
            teamObject.impostors[xKiller.name] = {kills = teamObject.impostors[xKiller.name].kills + 1, org = xKiller.job.label}
        else
            teamObject.impostors[xKiller.name].kills += 1
        end
    end
end

--[[
    same org = same team # NO CUSTOM!
    same custom 
    
]]

-- AddEventHandler('playerDropped', function(reason)
--     local _source = source
--     if PlayersFighting[_source] then
--         Walkower("quit", _source, GetPlayerName(_source))
--     end
-- end)

functions.isKillerImpostor = function(victim, killer)
    local victimState, killerState = Player(victim.source).state, Player(killer.source).state
    local customVictimBucket, customKillerBucket = victimState.customOrgBucket, killerState.customOrgBucket
    if (not customVictimBucket and not customKillerBucket) then
        return victim.job.name == killer.job.name
    else
        if (customVictimBucket and customKillerBucket) then
            return customVictimBucket == customKillerBucket
        end

        if (customKillerBucket == victim.job.name) then
            return true
        end

        if (customVictimBucket == killer.job.name) then
            return true
        end
    end

    return false
end

events.onPlayerDeath = function(data)
    local src = source
    local playerState = Player(src).state

    if (playerState.inBattle) then
        local xPlayer = ESX.GetPlayerFromId(src)
        local playerBattle = functions.findBattle(src)

        if not (playerBattle) then
            return
        end

        local playersTeam = playerBattle[playerBattle.playersTeam]
        
        for _, deadPlayer in ipairs(playersTeam.deadPlayers) do
            if (tostring(deadPlayer) == tostring(src)) then
                return
            end
        end
        
        playersTeam.deaths += 1
        playersTeam.deadPlayers[#playersTeam.deadPlayers + 1] = src

        -- kiler data
        local killedByPlayer = data.killedByPlayer
        
        local xKiller = (killedByPlayer) and ESX.GetPlayerFromId(data.killerServerId) or {name = xPlayer.name .. ' [sam sie zabił]', source = xPlayer.source}
        local isKillerImpostor = (killedByPlayer) and functions.isKillerImpostor(xPlayer, xKiller) or false
        local killersTeam = (isKillerImpostor) and playersTeam or playerBattle[playerBattle.enemyTeam]
        
        if (not killedByPlayer) then
            killersTeam = playersTeam
        end

        if (killedByPlayer) then
            if (isKillerImpostor) then
                functions.insertTeamImpostor(xKiller, playersTeam)
                if (killersTeam.impostors[xKiller.name].kills >= config.battleActions.maxImpostors) then
                    DropPlayer(xKiller.source, 'zabiłeś ' .. killersTeam.impostors[xKiller.name].kills .. ' swoich, to ewidentnie za dużo.')
                end
            else
                functions.insertTeamKill(xKiller, killersTeam)
            end
        end

        CreateThread(function()
            local newTeamValue = playersTeam.memberCount - playersTeam.deaths
            local teamToUpdate = playerBattle.playersTeam
            for _, team1Member in ipairs(playersTeam.members) do
                TriggerClientEvent(eventRoute .. 'updateScoreboard', team1Member, teamToUpdate, newTeamValue)
            end

            for _, team2Member in ipairs(playerBattle[playerBattle.enemyTeam].members) do
                TriggerClientEvent(eventRoute .. 'updateScoreboard', team2Member, teamToUpdate, newTeamValue)
            end
        end)

        if (playersTeam.deaths >= playersTeam.memberCount) then
            local winnerTeam = playerBattle[playerBattle.enemyTeam]
            playerBattle.loser = playersTeam
            playerBattle.winner = winnerTeam
            local battleData = {
                loser = playerBattle.loser,
                winner = playerBattle.winner
            }

            -- webhook
            if (battleData.winner.webhook:find('discord')) then
                functions.sendEmbed(battleData.winner.teamKillers, battleData.winner.impostors, battleData.winner.webhook, true, battleData.loser.org.label)
            end
            if (battleData.loser.webhook:find('discord')) then
                functions.sendEmbed(battleData.loser.teamKillers, battleData.loser.impostors, battleData.loser.webhook, false, battleData.winner.org.label)
            end

            -- WINS/LOSSES update in SQL
            functions.incrementOrgStatsAfterBattle(battleData)

            CreateThread(function()
                functions.endBattle(playerBattle.team1, battleData)
            end)
            CreateThread(function()
                functions.endBattle(playerBattle.team2, battleData)
            end)
            for _, battle in ipairs(cache.battles) do
                if (battle.id == playerBattle.id) then
                    table.remove(cache.battles, _)
                end
            end
            -- print('Battle END!!!!')
        end
    end
end

events.playerQuit = function(source)
    local src = source
    local playerState = Player(src).state

    if (playerState.inBattle) then
        local playerBattle = functions.findBattle(src)
        if not(playerBattle) then
            -- return print('player ' .. src .. ' is in battle, but no battle has been found')
        end

        local playersTeam = playerBattle[playerBattle.playersTeam]
        playersTeam.deaths += 1
        TriggerEvent('zykem_battles:kick', src, playersTeam, 'offline')

        if (playersTeam.deaths >= playersTeam.memberCount) then
            local winnerTeam = playerBattle[playerBattle.enemyTeam]
            playerBattle.loser = playersTeam
            playerBattle.winner = winnerTeam
            local battleData = {
                loser = playerBattle.loser,
                winner = playerBattle.winner
            }
            CreateThread(function()
                functions.endBattle(playerBattle.team1, battleData)
            end)
            CreateThread(function()
                functions.endBattle(playerBattle.team2, battleData)
            end)
            for _, battle in ipairs(cache.battles) do
                if (battle.id == playerBattle.id) then
                    table.remove(cache.battles, _)
                end
            end
        end
    end
end

-- print(RegisterSafeEvent)
RegisterNetEvent('esx:onPlayerDeath', events.onPlayerDeath)
RegisterNetEvent('esx:playerDropped', events.playerQuit)
RegisterNetEvent(eventRoute .. 'handlePassengersAfterBattle', events.handlePassengersAfterBattle)