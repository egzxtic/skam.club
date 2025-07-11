local server = {}

server.createdBattles = {}

server.getOrgsList = function(source, cb)
    local list = {}
    for orgName, teamData in pairs(cache.teams) do
        if (#teamData.members > 0) then
            list[orgName] = {
                members = teamData.members,
                org = teamData.org
            }
        end
    end
    cb(list)
end

server.addTeamToBattle = function(team)
    local src = source
    local name = GetPlayerName(src)
    cache.teams[team.org.name].inWojna = true
    for _, member in ipairs(cache.teams[team.org.name].members) do
        TriggerClientEvent('esx:showNotification', member, 'Zostaliscie dodani do wojny przez: ' .. name)
    end
end

server.removeTeamFromBattle = function(team)
    local src = source
    local name = GetPlayerName(src)
    cache.teams[team.org.name].inWojna = nil

    for _, member in ipairs(cache.teams[team.org.name].members) do
        TriggerClientEvent('esx:showNotification', member, 'Zostaliscie dodani do wojny przez: ' .. name)
    end
end

server.checkCanStart = function(members)
    for _, member in ipairs(members) do
        if not IsPedInAnyVehicle(GetPlayerPed(member), false) then
            return false
        end
    end

    return true
end

server.startBattle = function(data)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local team1 = data.team1_manage
    local team2 = data.team2_manage
    local team1Obj = ESX.Table.Clone(cache.teams[team1.org.name])
    local team2Obj = ESX.Table.Clone(cache.teams[team2.org.name])
    
    local canStartTeam1 = server.checkCanStart(team1Obj.members)

    if not canStartTeam1 then
        return xPlayer.showNotification('Team #1 nie możę wystartować bitki, ponieważ nie każdy jest w samochodzie.')
    end

    local canStartTeam2 = server.checkCanStart(team2Obj.members)

    if not canStartTeam2 then
        return xPlayer.showNotification('Team #2 nie możę wystartować bitki, ponieważ nie każdy jest w samochodzie.')
    end
    

    CreateThread(function()
        team1Obj.battleMembers = team1Obj.members
        team2Obj.battleMembers = team2Obj.members
        team1Obj.deaths = 0
        team2Obj.deaths = 0
        team1Obj.vehicles = getTeamPositionData(team1Obj)
        team2Obj.vehicles = getTeamPositionData(team2Obj)
        -- print(json.encode(team1Obj.vehicles))
        team1Obj.teamKillers = {}
        team2Obj.teamKillers = {}
        team1Obj.deadPlayers = {}
        team2Obj.deadPlayers = {}
        team1Obj.impostors = {}
        team2Obj.impostors = {}
        team1Obj.memberCount = #team1Obj.members
        team2Obj.memberCount = #team2Obj.members
        
        math.randomseed(os.time() + team1Obj.memberCount + GetGameTimer())
        local battle = {
            id = 10000 + math.random(1, 10000),
            team1 = team1Obj,
            team2 = team2Obj,
            map = config.battleMaps[data.mapIndex],
        }
        startBattle(battle)
    end)
end

ESX.RegisterServerCallback('skam-battles:getOrgsList', server.getOrgsList)
RegisterNetEvent('skam-battleCreator:addTeamToBattle', server.addTeamToBattle)
RegisterNetEvent('skam-battleCreator:removeTeamFromBattle', server.removeTeamFromBattle)
RegisterNetEvent('skam-battleCreator:startBattle', server.startBattle)