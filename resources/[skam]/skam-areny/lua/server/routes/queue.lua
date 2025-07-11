local functions = {}
local events = {}
local route = 'queue/'
local eventRoute = GetCurrentResourceName() .. ':' .. route
cache.queue = {}
vehicleColors = {}

cleanTeam = function(team, cancelSearch)
    if (cancelSearch) then
        team.searching = false
    end
    for _, member in ipairs(team.members) do
        local memberPed = GetPlayerPed(member)
        if (memberPed == 0 or GetPlayerRoutingBucket(member) ~= 1000 + tonumber(team.org.bucket)) then
            -- Check if member is kicked before cancelling search
            if not functions.isMemberKicked(member, team) then
                table.remove(team.members, _)
                if cancelSearch then
                    events.cancelSearch('bucket', GetPlayerName(member))
                end
            else
                table.remove(team.members, _)
            end
        end
    end
end

functions.resetTeamPosition = function(team)
    for vehicle, vehicleData in pairs(team.vehicles) do
        for _, passenger in ipairs(vehicleData.passengers) do
            if (DoesEntityExist(passenger.handle) and DoesEntityExist(vehicle) and GetVehiclePedIsIn(passenger.handle, false) ~= vehicle) then
                local isSeatUsed = GetPedInVehicleSeat(vehicle, passenger.seatIndex)
                if (isSeatUsed) then
                    local freeSeat = getVehicleFreeSeat(vehicle)
                    SetPedIntoVehicle(passenger.handle, vehicle, freeSeat)
                else
                    SetPedIntoVehicle(passenger.handle, vehicle, passenger.seatIndex)
                end
            end
        end
    end
end

functions.getBattleMap = function()
    math.randomseed(os.time() + math.random(1111,99999999999))

    local totalPercent = 0
    for _, mapData in ipairs(config.battleMaps) do
        totalPercent += mapData.percent
    end

    local randomPercent = math.random() * totalPercent

    local cumPercent = 0
    for _, mapData in pairs(config.battleMaps) do
        cumPercent += mapData.percent
        if (randomPercent <= cumPercent) then
            return mapData
        end
    end
end

removeFromQueue = function(org)
    local queue = cache.queue
    for _, queueTeam in ipairs(queue) do
        if (queueTeam.org.name == org) then
            -- print(queueTeam.org.name, 'removed this team because it was twice in queue')
            table.remove(queue, _)
        end
    end
end

functions.formNewBattle = function(team1, team2)
    removeFromQueue(team1.org.name)
    removeFromQueue(team2.org.name)
    team1.deaths = 0
    team2.deaths = 0
    team1.teamKillers = {}
    team2.teamKillers = {}
    team1.impostors = {}
    team2.impostors = {}
    team1.deadPlayers = {}
    team2.deadPlayers = {}
    
    team1.colors = vehicleColors[team1.org.name] or {255,0,0}
    team2.colors = vehicleColors[team2.org.name] or {0,153,255}
    team1.memberCount = #team1.battleMembers
    team2.memberCount = #team2.battleMembers
    math.randomseed(os.time() + math.random(111,9999999))
    local battle = {
        id = 10000 + math.random(1,10000),
        team1 = team1,
        team2 = team2,
        map = functions.getBattleMap()
    }
    battle.mapWithVehicles = (battle.map.vehicles == false) and false or true
    SetTimeout(3000, function()
        removeFromQueue(team1.org.name)
        removeFromQueue(team2.org.name)
    end)
    CreateThread(function()
        functions.resetTeamPosition(team1)
        functions.resetTeamPosition(team2)
        cleanTeam(team1, true)
        cleanTeam(team2, true)
        Wait(500)
        startBattle(battle)
    end)
end

functions.parseRgb = function(str)
    local rgbTable = {}
    for num in str:gmatch('%d+') do
        rgbTable[#rgbTable + 1] = tonumber(num)
    end

    return rgbTable
end

functions.insertOrgColor = function(org, rgbString)
    vehicleColors['org' .. org] = functions.parseRgb(rgbString)
end

functions.getOrgColor = function(org)
    return vehicleColors[org] or {255,165,0}
end
exports('getOrgColor', functions.getOrgColor)

functions.initializeVehicleColors = function()
    local vehColors = {}
    local endpoint = "'Barwy'!D1:J54"
    -- tu tak samo, kolory sa ale usuanelm klucz api z only wiec nei wiem jak chcesz kolory zrobic aut (pisz na dc)
    PerformHttpRequest('https://sheets.googleapis.com/v4/spreadsheets/apiKey/values/' .. endpoint .. '?majorDimension=COLUMNS&key=key', 
    function(err,res,head)
        local decodedRes = json.decode(res)
        decodedRes = decodedRes.values
        local colors = decodedRes[3]
        local orgs = decodedRes[7]
        for _, org in ipairs(orgs) do
            if (string.find(org, '#')) then
                org = org:match("%d+")
                functions.insertOrgColor(org, colors[_])
            end
        end
    end, 'GET')
end
--CreateThread(functions.initializeVehicleColors)

functions.createSearchThread = function(initiatorTeam)
    while true do
        if (#cache.queue >= 2) then
            local team1, team2 = cache.queue[1], cache.queue[2]
            if (team1.org.name == team2.org.name) then
                table.remove(cache.queue, 1)
                Wait(50)
                table.remove(cache.queue, 1)
                cleanTeam(team1, true)
                cleanTeam(team2, true)
                -- print('same team tried search so cancelled search of battle')
            else
                cleanTeam(team1, true)
                cleanTeam(team2, true)
                functions.formNewBattle(ESX.Table.Clone(team1), ESX.Table.Clone(team2))
                table.remove(cache.queue, 1)
                Wait(50)
                table.remove(cache.queue, 1)
            end
        end
        Wait(3500)
    end
end
CreateThread(functions.createSearchThread)

functions.getTeamPositionData = function(team)
    local vehicles = {}
    local count = 0
    local total = 0

    for _, member in ipairs(team.battleMembers) do
        local ped = GetPlayerPed(member)
        local pedVehicle = GetVehiclePedIsIn(ped, false)

        if (ped and pedVehicle and GetPedInVehicleSeat(pedVehicle, -1) == ped) then
            total = total + 1

            local passengers = getVehiclePassengers(pedVehicle)
            local ogR, ogG = GetVehicleColours(pedVehicle)
            vehicles[pedVehicle] = {
                passengers = passengers,
                originalColor = {ogR, ogG},
                startPosition = GetEntityCoords(pedVehicle),
                driver = NetworkGetEntityOwner(ped)
            }
            local done = false
            ESX.TriggerClientCallback(member, 'zykem_battles:getVehProperties', function(props)
                vehicles[pedVehicle].properties = props
                done = true
            end, NetworkGetNetworkIdFromEntity(pedVehicle))
            SetVehicleDoorsLocked(pedVehicle, 4)
            repeat Wait(1)
            until done
        end
    end

    return vehicles
end

functions.isInQueue = function(org)
    for k,v in pairs(cache.queue) do
        if (v.org.name == org) then
            return true
        end 
    end
    return false
end

functions.notifyMembers = function(members,msg)
    for _, member in ipairs(members) do
        TriggerClientEvent('esx:showNotification', member, msg)
    end
end

functions.generateBattleMemberList = function(battleMembers)
    local list = ''
    for _, member in ipairs(battleMembers) do
        list = list .. ' ' .. GetPlayerName(member) .. (' [%s]'):format(member)  .. '<br>'
    end
    return list
end

functions.getTableLen = function(table)
    local count = 0
    for _ in pairs(table) do
        count += 1
    end
    return count
end

functions.isMemberKicked = function(member, team)
    if (#team.kickedMembers < 1) then
        return false
    end
    for _, kickedMember in ipairs(team.kickedMembers) do
        if (member == kickedMember) then
            return true
        end
    end
    return false
end

events.startSearch = function(source,cb)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local orgTeam = cache.teams[xPlayer.job.name]
    
    if not (orgTeam) then
        return
    end

    local hasKickedMembers = false
    for _, member in ipairs(orgTeam.members) do
        if functions.isMemberKicked(member, orgTeam) then
            hasKickedMembers = true
            break
        end
    end

    if hasKickedMembers then
        xPlayer.showNotification('Nie można rozpocząć szukania - w buckecie są wyrzuceni gracze.')
        return
    end

    local isInQueue = functions.isInQueue(xPlayer.job.name)

    if (isInQueue or orgTeam.searching) then
        if ((isInQueue and not orgTeam.searching) or (not isInQueue and orgTeam.searching)) then
            orgTeam.searching = false
            for _, queueTeam in ipairs(cache.queue) do
                if (queueTeam.org.name == orgTeam.org.name) then
                    table.remove(cache.queue, _)
                end
            end
        end
        return functions.notifyMembers(orgTeam.members, 'Usunięto wasz team z kolejki, ponieważ już byliście w kolejce (cos sie zbugowalo.)')
    end

    local memberCount = #orgTeam.members
    if (memberCount < config.queueSettings.minMembers or memberCount > config.queueSettings.maxMembers) then
        return xPlayer.showNotification('Twoja organizacja nie spełnia limitu 3-10 członków.')
    end

    if (Player(src).state.inBattle) then
        return xPlayer.showNotification('Nie mozesz wystartowac szukania bedac w bitce')
    end

    orgTeam.battleMembers = {}
    for _, member in ipairs(orgTeam.members) do
        if not functions.isMemberKicked(member, orgTeam) then
            table.insert(orgTeam.battleMembers, member)
        end
    end

    if (#orgTeam.battleMembers < config.queueSettings.minMembers) then
        return xPlayer.showNotification('Twoja organizacja nie spełnia limitu 3-10 członków po usunięciu wyrzuconych członków.')
    end

    -- print(('Starting serach in queue for %s [sender: %s]'):format(orgTeam.org.name, src))
    orgTeam.searching = true
    CreateThread(function()
        orgTeam.vehicles = {}
        local teamPositionData = functions.getTeamPositionData(orgTeam)
        orgTeam.vehicles = teamPositionData
        functions.notifyMembers(orgTeam.members, 'Twoja ekipa została dodana do kolejki przez: <b>' .. xPlayer.name .. '</b>. <br><br>Osoby dodane do kolejki:<br>' .. functions.generateBattleMemberList(orgTeam.battleMembers))
        cleanTeam(orgTeam)

        table.insert(cache.queue, orgTeam)
    end)
    cb(orgTeam.battleMembers)
end

local messages = {
    vehicle = 'Gracz %s wyszedł z pojazdu, anuluje szukanie bitki.',
    bucket = 'Gracz %s wyszedł z bucketu, anuluje szukanie bitki.',
}

events.cancelSearch = function(issue, issuer)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local orgTeam = cache.teams[xPlayer.job.name]
    
    if not (orgTeam) then
        return
    end

    orgTeam.searching = false
    if (orgTeam.vehicles) then
        for vehHandle, vehData in pairs(orgTeam.vehicles) do
            if (DoesEntityExist(vehHandle)) then
                SetVehicleDoorsLocked(vehHandle, 1)
            end
        end
    end
    orgTeam.vehicles = false
    orgTeam.battleMembers = {}
    -- debug.print(('Cancelling search in queue for %s [sender: %s issue: %s]'):format(xPlayer.job.name, src, issue))

    for _, queueTeam in ipairs(cache.queue) do
        if (queueTeam.org.name == orgTeam.org.name) then
            table.remove(cache.queue, _)
        end
    end

    if not (issue) then
        functions.notifyMembers(orgTeam.members, 'Szukanie zostało anulowane przez ' .. xPlayer.name)
    else
        functions.notifyMembers(orgTeam.members, messages[issue]:format(issuer))
    end
end

ESX.RegisterServerCallback(eventRoute .. 'startSearch', events.startSearch)
RegisterNetEvent(eventRoute .. 'cancelSearch', events.cancelSearch)
exports('cancelSearch', events.cancelSearch)


