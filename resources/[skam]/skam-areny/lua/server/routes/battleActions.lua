local route = 'battleActions/'
local eventRoute = GetCurrentResourceName() .. ':' .. route
local events = {}
local functions = {}
searchingForSlot = {}

for i = 10000, 25000 do
    SetRoutingBucketEntityLockdownMode(i, 'strict')
end

--[[
    @param source Number The source ID of the player
    @param customCoords table<string, number> A table containing custom coordinates
]]
functions.gotKicked = function(source, customCoords)
    local ped = GetPlayerPed(source)
    local kickedConfig = config.battleActions.gotKicked
    local tpPos = kickedConfig.teleportPos
    tpPos = (customCoords ~= nil) and customCoords or tpPos
    SetEntityCoords(ped, tpPos.x, tpPos.y, tpPos.z)
    SetPlayerRoutingBucket(source, 0)
    TriggerClientEvent('esx:showNotification', source,
                       kickedConfig.kickedMessage)
    local pState = Player(source).state
    pState:set('inOrgBucket', false, true)
    local playerCustomBucket = pState.customOrgBucket
    if (playerCustomBucket) then
        TriggerClientEvent('skam-radio:toggleThirdPartyAccess', source,
                           playerCustomBucket, false)
        pState:set('customOrgBucket', nil, true)
        TriggerClientEvent('zykem_battles:setCustomOrgBucket', source, nil)
        local playerisSearchingForSlot = pState.inSearchingSlotBucket
        if (playerisSearchingForSlot) then
            pState:set('inSearchingSlotBucket', nil, true)
            TriggerClientEvent('zykem_battles:setSearchingForSlot', source, nil)
        end
    end
end

--[[
    @param target Number The target player's ID
    @param teamObj table The team object
    @param customCoords string 'offline' or a table with custom coordinates
]]
functions.kickMember = function(target, teamObj, customCoords)
    local playerTeam = cache.teams[teamObj.org.name]
    if (playerTeam) then
        if (customCoords == 'offline') then
            for _, member in ipairs(playerTeam.members) do
                if (tonumber(member) == tonumber(target)) then
                    table.remove(playerTeam.members, _)
                end
            end
            if (#playerTeam.battleMembers > 0) then
                for _, member in ipairs(playerTeam.battleMembers) do
                    if (tonumber(member) == tonumber(target)) then
                        table.remove(playerTeam.battleMembers, _)
                    end
                end
            end
        else
            for _, member in ipairs(playerTeam.members) do
                if (tonumber(member) == tonumber(target)) then
                    table.remove(playerTeam.members, _)
                end
            end
            if (#playerTeam.battleMembers > 0) then
                for _, member in ipairs(playerTeam.battleMembers) do
                    if (tonumber(member) == tonumber(target)) then
                        table.remove(playerTeam.battleMembers, _)
                    end
                end
            end
            functions.gotKicked(target, customCoords)
        end
    end
end
AddEventHandler('zykem_battles:kick', functions.kickMember)

events.getKicked = function()
    local src = source
    local playerState = Player(src).state

    if not (playerState.customOrgBucket) then
        return
    end

    local playerTeam = cache.teams[playerState.customOrgBucket]
    for _, member in ipairs(playerTeam.members) do
        if (tostring(member) == tostring(src)) then
            table.remove(playerTeam.members, _)
        end
    end

    if (#playerTeam.battleMembers == 0) then
        for _, member in ipairs(playerTeam.battleMembers) do
            if (tostring(member) == tostring(src)) then
                table.remove(playerTeam.battleMembers, _)
            end
        end
    end

    playerState:set('customOrgBucket', nil, true)
    playerState:set('inOrgBucket', nil, true)
    TriggerClientEvent('zykem_battles:setCustomOrgBucket', src, nil)
    TriggerClientEvent('zykem_battles:setSearchingForSlot', src, nil)
    local xPlayer = ESX.GetPlayerFromId(src)
    xPlayer.showNotification('Zostałeś wyrzucony z bucketu ponieważ byłeś dłużej niż 5 minut poza bucketem')
end
RegisterNetEvent('zykem_battles:getKicked', events.getKicked)

events.kickMember = function(target)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local playerState = Player(src).state

    if (tonumber(src) == tonumber(target)) then
        return xPlayer.showNotification('Nie możesz wyrzucić samego siebie.')
    end

    if not (jobCheck(xPlayer)) or not (playerState.inOrgBucket) then return end

    local playerOrg = xPlayer.job
    local teams = cache.teams
    local playerTeam = teams[playerOrg.name]
    local targetState = Player(target).state

    if (playerTeam) then
        for _, member in ipairs(playerTeam.members) do
            if (tonumber(member) == tonumber(target)) then
                table.remove(playerTeam.members, _)
                if (targetState.customOrgBucket) then
                    playerTeam.kickedMembers[#playerTeam.kickedMembers + 1] =
                        member
                    functions.gotKicked(member)
                end
            end
        end
        if (#playerTeam.battleMembers > 0) then
            for _, member in ipairs(playerTeam.battleMembers) do
                if (tonumber(member) == tonumber(target)) then
                    table.remove(playerTeam.battleMembers, _)
                end
            end
        end
        if (targetState.customOrgBucket) then
            SetTimeout(config.battleActions.kickBlockCooldown, function()
                for _, kickedMember in ipairs(playerTeam.kickedMembers) do
                    if (kickedMember == target) then
                        table.remove(playerTeam.kickedMembers, _)
                        local xTarget = ESX.GetPlayerFromId(target)
                        local tState = Player(target).state
                        if (xTarget) then
                            if not (tState.customOrgBucket) and
                                not (tState.inBattle) then
                                local ped = GetPlayerPed(target)
                                SetEntityCoords(ped, config.battleActions
                                                    .leaveSlotKickPosition)
                            end
                            xTarget.showNotification(
                                'Twoja blokada mineła, możesz już grać z swoją organizacją.')
                        end
                    end
                end
            end)
        end
    end
end

events.sendJoinInvite = function(target)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if (src == target) then
        return xPlayer.showNotification(
                   'Nie możesz zaprosić do teamu samego siebie!')
    end

    if not (jobCheck(xPlayer)) or not (Player(src).state.inOrgBucket) then
        return
    end

    local targetName = GetPlayerName(target)
    if not (targetName) then
        return xPlayer.showNotification(('Gracz o ID %s jest offline'):format(
                                            target))
    end

    local xTarget = ESX.GetPlayerFromId(target)
    if (xTarget.job.name == 'unemployed') then
        return xPlayer.showNotification('Ten gracz nie jest w żadnej Organizacji!')
    end

    local playerOrg = xPlayer.job
    local teams = cache.teams
    local playerTeam = teams[playerOrg.name]
    if (table.concat(playerTeam.members, ','):match(target)) then
        return xPlayer.showNotification('Ten gracz jest już w twoim teamie.')
    end

    local targetTeam = teams[xTarget.job.name]

    if (targetTeam and targetTeam.searching) then
        return xPlayer.showNotification('Organizacja w której jest ten gracz już szuka bitki!')
    end

    if (Player(xTarget.source).state.inBattle) then
        return xPlayer.showNotification('Ten gracz gra aktualnie bitkę!')
    end

    TriggerClientEvent(eventRoute .. 'receiveJoinInvite', target,
                       {adder = src, org = playerOrg.name})
    Player(target).state:set('pendingJoinInvite',
                             {adder = src, org = playerOrg.name}, true)
    xPlayer.showNotification(
        ('Zaprosiłeś gracza %s [ID: %s] do swojego bucketa.'):format(
            targetName, target))
end

events.acceptInvite = function(org)
    local src = source
    local playerState = Player(src).state

    if (playerState.pendingJoinInvite and playerState.pendingJoinInvite.org ~=
        org.org) then return end

    local xPlayer = ESX.GetPlayerFromId(src)

    playerState:set('pendingJoinInvite', nil, true)
    xPlayer.showNotification(
        ('Zaakceptowałeś zaproszenie do bucketu organizacji %s'):format(
            org.org))

    local teams = cache.teams
    local oldTeam = teams[xPlayer.job.name]

    if (oldTeam) then
        for _, member in ipairs(oldTeam.members) do
            if (member == xPlayer.source) then
                table.remove(oldTeam.members, _)
            end
        end
    end

    local orgTeam = teams[org.org]
    orgTeam.members[#orgTeam.members + 1] = src
    local tpPos = config.battleActions.gotRevoked.teleportPos
    SetEntityCoords(GetPlayerPed(src), tpPos.x, tpPos.y, tpPos.z)
    SetPlayerRoutingBucket(src, 1000 + tonumber(orgTeam.org.bucket))
    playerState:set('customOrgBucket', org.org, true)
    TriggerClientEvent('zykem_battles:inviteAccepted', src, org.org)
    TriggerClientEvent('skam-radio:toggleThirdPartyAccess', src,
                       orgTeam.org.name, true)
    local playerAdder = ESX.GetPlayerFromId(org.adder)
    if (playerAdder) then
        playerAdder.showNotification(
            ('Gracz %s dołączył do bucketu twojej organizacji'):format(src))
    end
end

events.rejectInvite = function(org)
    local src = source
    local playerState = Player(src).state

    if (playerState.pendingJoinInvite ~= org.org) then return end

    local xPlayer = ESX.GetPlayerFromId(src)

    playerState:set('pendingJoinInvite', nil, true)
    xPlayer.showNotification(
        ('Odrzuciłeś zaproszenie do bucketu organizacji %s'):format(org.org))
    local playerAdder = ESX.GetPlayerFromId(org.adder)
    if (playerAdder) then
        playerAdder.showNotification(
            ('Gracz %s odrzucił twoje zaproszenie do bucketu'):format(src))
    end
end

events.toggleSetting = function(setting)
    local src = source
    local playerState = Player(src).state
    local xPlayer = ESX.GetPlayerFromId(src)

    if not (jobCheck(xPlayer)) or not (playerState.inOrgBucket) then return end

    local teams = cache.teams
    local orgTeam = teams[xPlayer.job.name]

    if not (orgTeam) then return end

    orgTeam.battleSettings[setting] = not orgTeam.battleSettings[setting]

    xPlayer.showNotification(('Zmieniłeś wartość %s na %s'):format(setting,
                                                                       orgTeam.battleSettings[setting]))
    MySQL.update('UPDATE jobs SET settings = ? WHERE name = ?', {
        json.encode(orgTeam.battleSettings), orgTeam.org.name
    })
end

events.setSetting = function(setting, newValue)
    local src = source
    local playerState = Player(src).state
    local xPlayer = ESX.GetPlayerFromId(src)

    if not (jobCheck(xPlayer)) or not (playerState.inOrgBucket) then return end

    local orgTeam = cache.teams[xPlayer.job.name]

    if not (orgTeam) then
        return debug.print('tried retireving team in setSetting but is nil')
    end

    orgTeam.battleSettings[setting] = newValue
    orgTeam.logs[setting] = (newValue == nil) and '' or
                                ('%s Id: %s'):format(GetPlayerName(src), src)
    xPlayer.showNotification(('Ustawiłeś wartość %s'):format(setting))
    MySQL.update('UPDATE jobs SET settings = ? WHERE name = ?', {
        json.encode(orgTeam.battleSettings), orgTeam.org.name
    })
end

functions.notifyMembers = function(members,msg)
    for _, member in ipairs(members) do
        TriggerClientEvent('esx:showNotification', member, msg)
    end
end

events.playerQuit = function(source)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local playerState = Player(src).state
    local customBucket = playerState.customOrgBucket

    if (searchingForSlot[src]) then searchingForSlot[src] = nil end
    if (playerState.inOrgBucket) then
        local playerTeam = (customBucket) and cache.teams[customBucket] or cache.teams[xPlayer.job.name]
        functions.kickMember(src, playerTeam, 'offline')
        if (playerTeam.searching) then
            playerTeam.searching = false
            for _, queueTeam in ipairs(cache.queue) do
                if (queueTeam.org.name == playerTeam.org.name) then
                    table.remove(cache.queue, _)
                end
            end
            functions.notifyMembers(playerTeam.members, ('Anulowano szukanie bitki, ponieważ gracz %s wyszedł z serwera.'):format(xPlayer.name))
        end
    end
end

events.leaveSlot = function(source)
    local pState = Player(source).state
    local xPlayer = ESX.GetPlayerFromId(source)

    if (pState.inBattle) then
        return xPlayer.showNotification('Nie użyjesz tego podczas bitki.')
    end

    if not (pState.inOrgBucket) or not (pState.customOrgBucket) then
        return xPlayer.showNotification('Nie jesteś w żadnym buckecie organizacyjnym!')
    end

    functions.kickMember(source, cache.teams[pState.customOrgBucket],
               config.battleActions.leaveSlotKickPosition)
    if (pState.inSearchingSlotBucket) then
        pState:set('inSearchingSlotBucket', false, true)
        TriggerClientEvent('zykem_battles:setSearchingForSlot', source, nil)
    end
end

events.enterSearchingMode = function(source)
    local pState = Player(source).state
    local xPlayer = ESX.GetPlayerFromId(source)

    if (pState.inBattle) then
        return xPlayer.showNotification('Nie użyjesz tego podczas bitki.')
    end

    if (xPlayer.job.name == 'unemployed') then
        return xPlayer.showNotification('Nie masz joba organizacji')
    end

    if (searchingForSlot[source]) then
        searchingForSlot[source] = nil
        xPlayer.showNotification('Wyszedłeś z listy oczekujących na slota')
        pState:set('inSearchingSlotBucket', false, true)
        local playerTeam = cache.teams[xPlayer.job.name]
        local orgBucket = getOrgBucket(playerTeam.org.name)
        SetPlayerRoutingBucket(source, 1000 + tonumber(orgBucket))
        pState:set('inOrgBucket', true, true)
        if (playerTeam) then
            playerTeam.members[#playerTeam.members + 1] = source
        end
    elseif not (pState.customOrgBucket) then
        searchingForSlot[source] = {
            name = xPlayer.name,
            org = xPlayer.job.label
        }
        xPlayer.showNotification(
            'Dołączyłeś do listy oczekujących na slota')
        local playerTeam = cache.teams[pState.customOrgBucket or xPlayer.job.name]
        if (playerTeam) then
            SetPlayerRoutingBucket(source, 6932)
            for _, member in ipairs(playerTeam.members) do
                if (tonumber(member) == tonumber(source)) then
                    table.remove(playerTeam.members, _)
                end
            end
            pState:set('inSearchingSlotBucket', true, true)
            TriggerClientEvent('zykem_battles:setSearchingForSlot', source, true)
        end
    else
        xPlayer.showNotification(
            'Jeżeli chcesz opuscić obeny team, wpisz komendę /leaveslot')
    end
end

events.getSearchingPlayers = function(source, cb)
    local pState = Player(source).state

    if not (pState.inOrgBucket) then
        cb(false)
        return
    end

    cb(searchingForSlot)
end

events.acceptSearchingPlayer = function(target)
    local src = source
    local pState = Player(src).state

    if not (pState.inOrgBucket) then return end

    local xPlayer = ESX.GetPlayerFromId(src)
    local xTarget = ESX.GetPlayerFromId(target)

    if not (xTarget) then
        return xPlayer.showNotification('Podanego gracza nie ma na serwerze')
    end

    searchingForSlot[target] = nil
    local teams = cache.teams
    local orgTeam = teams[xPlayer.job.name]
    orgTeam.members[#orgTeam.members + 1] = target
    local tpPos = config.battleActions.gotRevoked.teleportPos
    SetEntityCoords(GetPlayerPed(target), tpPos.x, tpPos.y, tpPos.z)
    local targetState = Player(target).state
    targetState:set('customOrgBucket', orgTeam.org.name, true)
    TriggerClientEvent('zykem_battles:setCustomOrgBucket', target, orgTeam.org.name)
    targetState:set('inOrgBucket', true, true)
    targetState:set('inSearchingSlotBucket', nil, true)
    TriggerClientEvent('skam-radio:toggleThirdPartyAccess', target,
                       orgTeam.org.name, true)
    SetPlayerRoutingBucket(target, 1000 + tonumber(orgTeam.org.bucket))
    xPlayer.showNotification(('%s dołączył do twojego bucketu'):format(
                                 xTarget.name))
    xTarget.showNotification(
        ('Dołączyłeś do bucketu organizacji %s'):format(orgTeam.org.name))
end

events.jobUpdate = function(source, job, lastjob)
    local pState = Player(source).state

    if (pState.inOrgBucket) then
        local playerTeam = (pState.customOrgBucket) and cache.teams[pState.customOrgBucket] or cache.teams[lastjob.name]
        functions.kickMember(source, playerTeam)
        pState:set('customOrgBucket', nil, true)
        pState:set('inSearchingSlotBucket', nil, true)
        TriggerClientEvent('zykem_battles:setCustomOrgBucket', target, nil)
        TriggerClientEvent('zykem_battles:setSearchingForSlot', target, nil)
    end
end


RegisterNetEvent(eventRoute .. 'kickMember', events.kickMember)
RegisterNetEvent(eventRoute .. 'sendJoinInvite', events.sendJoinInvite)
RegisterNetEvent(eventRoute .. 'acceptInvite', events.acceptInvite)
RegisterNetEvent(eventRoute .. 'rejectInvite', events.rejectInvite)
RegisterNetEvent(eventRoute .. 'toggleSetting', events.toggleSetting)
RegisterNetEvent(eventRoute .. 'setSetting', events.setSetting)
RegisterNetEvent('esx:playerDropped', events.playerQuit)
RegisterCommand('leaveslot', events.leaveSlot, false)
RegisterCommand('slot', events.enterSearchingMode, false)
ESX.RegisterServerCallback(eventRoute .. 'getSearchingPlayers', events.getSearchingPlayers)
RegisterNetEvent(eventRoute .. 'acceptSearchingPlayer', events.acceptSearchingPlayer)
RegisterNetEvent('esx:setjob', events.jobUpdate)