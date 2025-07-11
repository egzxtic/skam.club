local functions = {}
local events = {}
local route = 'orgBucket/'
local eventRoute = GetCurrentResourceName() .. ':' .. route
local battle = 'battleActions/'
local battleRoute = GetCurrentResourceName() .. ':' .. battle
cache.teams = {}

getOrgBucket = function(org)
    return (string.match(org, '%d+'))
end

functions.getOrgTeam = function(src)
    local playerState = Player(src).state
    local playerTeam = {}

    if (playerState.customOrgBucket) then
        playerTeam = cache.teams[playerState.customOrgBucket]
    else
        local xPlayer = ESX.GetPlayerFromId(src)
        playerTeam = cache.teams[xPlayer.job.name]
    end

    return playerTeam
end

functions.isInTeam = function(player, team)
    return table.concat(team.members, ','):match(player)
end

functions.movePlayerToBucket = function(source)
    local customBucket = Player(source).state.customOrgBucket
    local xPlayer = ESX.GetPlayerFromId(source)
    if (customBucket ~= nil) then
        SetPlayerRoutingBucket(source, (1000 + tonumber(getOrgBucket(customBucket))))
        local playerTeam = cache.teams[customBucket]
        if not (functions.isInTeam(xPlayer.source, playerTeam)) then
            playerTeam.members[#playerTeam.members + 1] = xPlayer.source
        end
    elseif (xPlayer.job.name ~= 'unemployed') then
        SetPlayerRoutingBucket(source, (1000 + tonumber(getOrgBucket(xPlayer.job.name))))
        local playerTeam = cache.teams[xPlayer.job.name]
        if not (functions.isInTeam(xPlayer.source, playerTeam)) then
            playerTeam.members[#playerTeam.members + 1] = xPlayer.source
        end
    end
end

createTeam = function(org, creator)
    local orgData = MySQL.single.await('SELECT webhooks, settings FROM jobs WHERE name = ?', {org.name})
    if not orgData then return end
    cache.teams[org.name] = {
        members = {},
        battleMembers = {},
        webhook = orgData.webhookbitki or '',
        kickedMembers = {},
        searching = false,
        creator = creator,
        battleSettings = json.decode(orgData.settings),
        logs = {},
        org = {name = org.name, bucket = getOrgBucket(org.name), label = org.label}
    }
end

MySQL.ready(function()
    local orgs = MySQL.query.await('SELECT * from jobs')

    for _, job in ipairs(orgs) do
        if ((job.name):find('org')) then
            createTeam({
                name = job.name,
                label = job.label,
            }, 0)
        end
    end
    --print('done')
end)

functions.updateWebhook = function(org, webhook)
    local team = cache.teams[org]
    team.webhook = webhook
end
exports('updateWebhook', functions.updateWebhook)

functions.deleteTeam = function(teamName)
    for teamTargetName, team in pairs(cache.teams) do
        if (teamTargetName == teamName) then
            -- print('nulling team', teamName)
            cache.teams[teamTargetName] = nil
        end
    end
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

functions.notifyMembers = function(members, msg)
    for _, member in ipairs(members) do
        TriggerClientEvent('esx:showNotification', member, msg)
    end
end

functions.kickMember = function(memberId)
    local xPlayer = ESX.GetPlayerFromId(memberId)
    local playerState = Player(memberId).state
    local customOrgBucket = playerState.customOrgBucket
    local playerOrg = (customOrgBucket ~= nil) and cache.teams[customOrgBucket].org or xPlayer.job
    local orgTeam = cache.teams[playerOrg.name]

    if not (orgTeam) then
        return
    end

    table.insert(orgTeam.kickedMembers, memberId)

    for i, member in ipairs(orgTeam.members) do
        if (member == memberId) then
            table.remove(orgTeam.members, i)
            break
        end
    end

    if (orgTeam.battleMembers) then
        for i, battleMember in ipairs(orgTeam.battleMembers) do
            if (battleMember == memberId) then
                table.remove(orgTeam.battleMembers, i)
                break
            end
        end
    end

    for i, queueTeam in ipairs(cache.queue) do
        if (queueTeam.org.name == orgTeam.org.name) then
            for j, queueMember in ipairs(queueTeam.members) do
                if (queueMember == memberId) then
                    table.remove(queueTeam.members, j)
                    break
                end
            end
        end
    end

    Player(memberId).state:set('inOrgBucket', false, true)
    SetPlayerRoutingBucket(memberId, 0)
    xPlayer.showNotification('Zostałeś wyrzucony z bucketu organizacyjnego.')

    functions.notifyMembers(orgTeam.members, 'Gracz ' .. GetPlayerName(memberId) .. ' został wyrzucony z bucketu.')
end

RegisterNetEvent(eventRoute .. 'kickMember', function(memberId)
    functions.kickMember(memberId)
end)

events.bucketEnterred = function()
    local src = source
    Wait(math.random(200, 800))
    local xPlayer = ESX.GetPlayerFromId(src)
    local playerState = Player(src).state

    if not (jobCheck(xPlayer)) then
        return
    end

    if (searchingForSlot[src]) then
        searchingForSlot[src] = nil
    end

    local customOrgBucket = playerState.customOrgBucket
    local teams = cache.teams
    local playerOrg = (customOrgBucket ~= nil) and cache.teams[customOrgBucket].org or xPlayer.job
    local orgTeam = cache.teams[playerOrg.name]

    -- Prevent kicked players from entering
    if functions.isMemberKicked(src, orgTeam) then
        xPlayer.showNotification('Zostałeś wyrzucony z tego bucketu.')
        SetPlayerRoutingBucket(src, 0)
        playerState:set('inOrgBucket', false, true)
        return
    end

    local orgBucket = getOrgBucket(playerOrg.name)
    if (orgTeam)  then
        local inTeam = false
        for _, member in ipairs(orgTeam.members) do
            if (tostring(member) == tostring(xPlayer.source)) then
                inTeam = true
            end
        end
        if not (inTeam) then
            table.insert(orgTeam.members, xPlayer.source)
        end
    end

    if (orgTeam.creator == 0) then
        orgTeam.creator = src
    end
    
    local playerPed = GetPlayerPed(src)
    local playerVeh = GetVehiclePedIsIn(playerPed, false)

    -- setting bucket + statebag
    if (playerVeh ~= 0) then
        local passengers = getVehiclePassengers(playerVeh)
        for _, passenger in ipairs(passengers) do
            local xPassenger = ESX.GetPlayerFromId(passenger.source)
            local isDriver = passenger.isDriver
            local canAccessBucket = jobCheck(xPassenger, (not isDriver) and passengers.driverJob or nil)
            if (canAccessBucket and not Player(passenger.source).inOrgBucket) then
                Player(passenger.source).state:set('inOrgBucket', true, true)
                functions.movePlayerToBucket(passenger.source)
                TriggerClientEvent('esx:showNotification', passenger.source, 'Wszedłeś do bucketu organizacyjnego')
            end
        end
        SetEntityRoutingBucket(playerVeh, 1000 + tonumber(orgBucket))

        SetTimeout(800, function()
            for _, passenger in ipairs(passengers) do
                if (GetVehiclePedIsIn(passenger.handle, false) == 0) then
                    SetPedIntoVehicle(passenger.handle, playerVeh, passenger.seatIndex)
                end
            end
        end)    
    else
        SetPlayerRoutingBucket(src, 1000 + tonumber(orgBucket))
        playerState:set('inOrgBucket', true, true)
        xPlayer.showNotification('Wchodzisz do bucketu organizacyjnego.')
    end
end

events.bucketExitted = function()
    local src = source
    Wait(math.random(200, 800))
    local xPlayer = ESX.GetPlayerFromId(src)
    local playerState = Player(src).state

    if not (jobCheck(xPlayer)) or not (playerState.inOrgBucket) then
        return
    end

    local customOrgBucket = playerState.customOrgBucket
    local playerOrg = (customOrgBucket ~= nil) and cache.teams[customOrgBucket].org or xPlayer.job
    local teams = cache.teams
    local orgTeam = teams[playerOrg.name]

    local isKicked = functions.isMemberKicked(src, orgTeam)

    if isKicked then
        SetPlayerRoutingBucket(src, 0)
        playerState:set('inOrgBucket', false, true)
        return
    end

    if (orgTeam) then
        for _, member in ipairs(orgTeam.members) do
            if (member == xPlayer.source) then
                table.remove(orgTeam.members, _)
            end
        end
    end

    if (orgTeam and orgTeam.searching) then
        for _, battleMember in ipairs(orgTeam.battleMembers) do
            if (battleMember == xPlayer.source) then
                functions.notifyMembers(orgTeam.members, ('Gracz %s wyszedłeś z bucketu, anulowano szukanie bitki.'):format(GetPlayerName(src)))
                orgTeam.searching = false
                for _, queueTeam in ipairs(cache.queue) do
                    if (queueTeam.org.name == orgTeam.org.name) then
                        table.remove(cache.queue, _)
                        break
                    end
                end
                break
            end
        end
    end

    local playerPed = GetPlayerPed(src)
    local playerVeh = GetVehiclePedIsIn(playerPed)

    if (playerVeh ~= 0) then
        local passengers = getVehiclePassengers(playerVeh)
        for _, passenger in ipairs(passengers) do
            Player(passenger.source).state:set('inOrgBucket', false, true)
            SetPlayerRoutingBucket(passenger.source, 0)
            TriggerClientEvent('esx:showNotification', passenger.source, 'Wyszedłeś z bucketu organizacyjnego')
        end
        SetEntityRoutingBucket(playerVeh, 0)
    else
        SetPlayerRoutingBucket(src, 0)
        playerState:set('inOrgBucket', false, true)
        xPlayer.showNotification('Wychodzisz z bucketu organizacyjnego.')
    end
end

events.startSearch = function(source, cb)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local orgTeam = cache.teams[xPlayer.job.name]
    
    if not (orgTeam) then return end

    local activeMembers = {}
    for _, member in ipairs(orgTeam.members) do
        if not functions.isMemberKicked(member, orgTeam) and Player(member).state.inOrgBucket then
            table.insert(activeMembers, member)
        end
    end

    if (#activeMembers < config.queueSettings.minMembers) then
        return xPlayer.showNotification('Nie wystarczająca liczba aktywnych graczy do rozpoczęcia bitki.')
    end

    orgTeam.battleMembers = ESX.Table.Clone(activeMembers)
    
end

events.getOrgTeam = function(source,cb)
    local playerTeam = functions.getOrgTeam(source)
    if not (playerTeam) then
        return
    end
    
    cleanTeam(playerTeam)
    cb(playerTeam)
end

RegisterNetEvent(eventRoute .. 'bucketEnterred', events.bucketEnterred)
RegisterNetEvent(eventRoute .. 'bucketExitted', events.bucketExitted)
ESX.RegisterServerCallback(battleRoute .. 'getOrgTeam', events.getOrgTeam)

CreateThread(function()
    for _, player in ipairs(GetPlayers()) do
        Player(player).state.inOrgBucket = false
        Player(player).state.customOrgBucket = nil
        Player(player).state.inBattle = false
        SetPlayerRoutingBucket(player, 0)
    end
end)