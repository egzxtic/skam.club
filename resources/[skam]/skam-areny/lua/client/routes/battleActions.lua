local route = 'battleActions/'
local queueRoute = GetCurrentResourceName() .. ':' .. 'queue/'
local eventRoute = GetCurrentResourceName() .. ':' .. route
local functions = {}
local events = {}

local getOrgCache 
functions.getOrgTeam = function()
    Wait(100)
    local promise = promise:new()
    
    ESX.TriggerServerCallback(eventRoute .. 'getOrgTeam', function(team)
        promise:resolve(team)
    end)
    
    getOrgCache = promise
    return Citizen.Await(promise)
end

local cwelwbucket = 0

CreateThread(function()
    local blip = AddBlipForCoord(config.orgBucket.coords.x, config.orgBucket.coords.y, config.orgBucket.coords.z)
    SetBlipSprite(blip, 107)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 1.0)
    SetBlipColour(blip, 1)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("HOSTOWANE (0)")
    EndTextCommandSetBlipName(blip)

    local radius = AddBlipForRadius(config.orgBucket.coords.x, config.orgBucket.coords.y, config.orgBucket.coords.z, config.orgBucket.radius)
    SetBlipColour(radius, 1)
    SetBlipAlpha(radius, 128)

    while true do
        Wait(5000)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("HOSTOWANE (" .. cwelwbucket .. " GRACZY)")
        EndTextCommandSetBlipName(blip)
    end
end)

enterredBucket = function()
    cwelwbucket = cwelwbucket + 1
    local orgTeam = functions.getOrgTeam()
    local notifyCoords = vector3(1728.0568, 3317.9128, 41.2235+5)
    CreateThread(function()
        local keepShowing = true
        SetTimeout(5000, function()
            keepShowing = false
        end)
        while keepShowing do
            SKAM.drawText('Nie zapomnij ustawić stroju organizacji przed bitką!', notifyCoords)
            Wait(1)
        end
    end)
end

AddEventHandler('enterredBucketHandler', enterredBucket)

leaveBucket = function()
    if cwelwbucket > 0 then
        cwelwbucket = cwelwbucket - 1
    end
end

AddEventHandler('leavedBucketHandler', leaveBucket)

functions.getSearchingPlayers = function()
    local promise = promise:new()

    ESX.TriggerServerCallback(eventRoute .. 'getSearchingPlayers', function(searchingPlayers)
        promise:resolve(searchingPlayers)
    end)

    return Citizen.Await(promise)
end

functions.formOrgTeamMembers = function(orgTeam)
    local members = {}
    for _, member in ipairs(orgTeam.members) do
        local memberClientId = GetPlayerFromServerId(member)
        local memberName = GetPlayerName(memberClientId)
        local isAddedById = Player(member).state.customOrgBucket
        local playerjob = Player(member).state.job
        members[#members + 1] = {
            label = ('%s Id: %s %s %s'):format(memberName, member, (memberName):find('**Invalid') and '(POZA BUCKETEM)' or '',
                                             (isAddedById and playerjob) and ('(%s)'):format(Player(member).state?.job.label) or ''),
            value = member
        }
    end
    return members
end


functions.openKickMemberMenu = function()
    local orgTeam = functions.getOrgTeam()
    local orgTeamMembers = functions.formOrgTeamMembers(orgTeam)

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'battles_kickmember', {
        title = 'Wyrzuć Członka',
        align = 'center',
        elements = orgTeamMembers
    }, function(data,menu)
        if (data.current.value) then
            TriggerServerEvent(eventRoute .. 'kickMember', data.current.value)
        end
    end, function(x, menu)
        menu.close()
    end)
end


functions.openAddMemberMenu = function()
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'shop_Waluty',
    {   
        align    = 'center',
        title    = 'Wpisz ID gracza',
        elements = {}
    }, function(data, menu)
        menu.close()
        local target = data.value
        if (target) then
            TriggerServerEvent(eventRoute .. 'sendJoinInvite', tonumber(target))
        end
    end, function(d,menu)
        menu.close()
    end)
end

events.receiveJoinInvite = function(org)
    Wait(10)
    local responded = false
    SetTimeout(10000, function()
        if not (responded) then
            ESX.UI.Menu.CloseAll()
        end
    end)

    ESX.ShowNotification('Masz 10 sek. na odpowiedź.')
    local elements = {
        {label = 'Akceptuję', value = 'accept'},
        {label = 'Odrzucam', value = 'reject'},
    }
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'battles_joinInvite', {
		title = "Akceptujesz dołączenie do Bucketu Org: " .. org.org,
		align = 'center',
		elements = elements
	}, function(data, menu)
        local currentValue = data.current.value
		if (currentValue == 'accept') then
            TriggerServerEvent(eventRoute .. 'acceptInvite', org)
        elseif (currentValue == 'reject') then
            TriggerServerEvent(eventRoute .. 'rejectInvite', org)
        end
        responded = true
        ESX.UI.Menu.CloseAll()
	end, function(data, menu)
		menu.close()
	end)
end

--[[
❌
✅
]]

functions.formSettingsMenu = function(orgTeam)
    local orgTeamSettings = orgTeam.battleSettings
    local elements = {
        {label = '--- AutoRefill ---', value = 'x'}
    }

    local autorefillToggled = orgTeamSettings.autorefill
    elements[#elements + 1] = {
        label = ('Włączony: %s'):format((autorefillToggled) and '✅' or '❌'),
        value = 'toggleRefill'
    }

    return elements
end

-- functions.toggleBattleOutfit = function(action)
--     if not (hasPermission('outfit')) then
--         return ESX.ShowNotification('Nie posiadasz do tego permisji.')
--     end
    
--     if (action == 'setBattleOutfit') then
--         TriggerEvent('skinchanger:getSaveable', function(skin)
--             TriggerServerEvent(eventRoute .. 'setSetting', 'battleOutfit', skin)
--         end)
--     elseif (action == 'removeBattleOutfit') then
--         TriggerServerEvent(eventRoute .. 'setSetting', 'battleOutfit', nil)
--     end
-- end

functions.getVehiclePassengers = function(vehicle)
    local passengers = {}
    local seats = 12
    
    for seatIdx = -1, seats do
        local pedAtSeat = GetPedInVehicleSeat(vehicle, seatIdx)
        if (pedAtSeat and IsPedAPlayer(pedAtSeat)) then
            local isDriver = seatIdx == -1
            local pedSource = NetworkGetEntityOwner(pedAtSeat)

            passengers[#passengers + 1] = {seatIndex = seatIdx,source = pedSource, handle = pedAtSeat, isDriver = (seatIdx == -1)}
        end
    end
    passengers.driver = NetworkGetEntityOwner(GetPedInVehicleSeat(vehicle, -1))
    return passengers
end

functions.toggleAutorefill = function()
    if not (hasPermission('autorefill')) then
        return ESX.ShowNotification('Nie posiadasz do tego permisji.')
    end
    TriggerServerEvent(eventRoute .. 'toggleSetting', 'autorefill')  
end

functions.formBattleVehs = function(vehs)
    local battleVehs = {}
    for _, veh in ipairs(vehs) do
        local ogR, ogG = GetVehicleColours(pedVehicle)
        local passengers = functions.getVehiclePassengers(veh)
        battleVehs[NetworkGetNetworkIdFromEntity(veh)] = {
            passengers = passengers,
            originalColor = {ogR, ogG},
            startPosition = GetEntityCoords(veh),
            driver = passengers.driver,
            properties = ESX.Game.GetVehicleProperties(veh)
        }
    end
    return battleVehs
end

functions.checkBattleVehs = function(battleVehs)
    if (#battleVehs > 5) then
        return false, 'Bitkę możesz wystartować z max 5 autami.'
    end

    local sportVehs = 0
    for _, battleVeh in ipairs(battleVehs) do
        local vehType = GetVehicleClass(battleVeh.vehicle)
        if (vehType == 14 or vehType == 15 or vehType == 16) then
            return false, 'Pojazdy bitkowe nie mogą być łodzią, helikopterem, samolotem lub statkiem.'
        end

        local vehMass = battleVeh.vehicleMass
        if (tonumber(vehMass) < 4000) then
            sportVehs += 1
        end
    end

    if (sportVehs > 3) then
        return false, 'Twoja organizacja możę mieć maksymalnie 3 sportowe auta na bitkę!'
    end

    return true
end

functions.isMemberKicked = function(memberId, team)
    if not team or not team.kickedMembers then return false end
    
    for _, kickedMember in ipairs(team.kickedMembers) do
        if tonumber(memberId) == tonumber(kickedMember) then
            return true
        end
    end
    return false
end

functions.canStartBattle = function()
    local orgTeam = functions.getOrgTeam()
    if not orgTeam then return false, 'Nie można znaleźć drużyny.' end
    
    local notInVehiclePlayers = {}
    local activeMembers = {}
    
    for _, member in ipairs(orgTeam.members) do
        if not functions.isMemberKicked(member, orgTeam) then
            activeMembers[member] = true
        end
    end

    for k,v in pairs(GetActivePlayers()) do
        local playerServerId = GetPlayerServerId(v)
        if activeMembers[playerServerId] then
            local ped = GetPlayerPed(v)
            if not (IsPedInAnyVehicle(ped, false)) then
                notInVehiclePlayers[#notInVehiclePlayers+1] = GetPlayerName(v)
            end
            if (IsVehicleSeatFree(GetVehiclePedIsIn(ped, false), -1)) then
                return false, 'W którymś aucie nie ma kierowcy!'
            end
        end
    end

    if (#notInVehiclePlayers > 0) then
        return false, 'Ktoś w buckecie nie jest w pojeździe! \n' .. json.encode(notInVehiclePlayers)
    end

    local vehicles = GetGamePool('CVehicle')
    local battleVehs = {}

    for _, vehicle in ipairs(vehicles) do
        local hasValidPassengers = false
        local passengers = functions.getVehiclePassengers(vehicle)
        
        -- Check if any passenger is an active member
        for _, passengerData in ipairs(passengers) do
            if passengerData and passengerData.source and activeMembers[passengerData.source] then
                hasValidPassengers = true
                break
            end
        end

        if hasValidPassengers then
            battleVehs[#battleVehs + 1] = {
                vehicle = vehicle,
                vehicleMass = GetVehicleHandlingInt(vehicle, 'CHandlingData', 'fMass')
            }
        end
    end 

    local areBattleVehsOkay, errorText = functions.checkBattleVehs(battleVehs)

    if not (areBattleVehsOkay) then
        return false, errorText
    end

    return true, '', battleVehs
end

functions.openConfirmMenu = function(reason)
    local elements = {
        {label = 'Tak', value = true},
        {label = 'Nie', value = false}
    }

    local returnValue = promise:new()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'confirmBattleMenu', {
        title = ('Czy na pewno chcesz %s?'):format(reason),
        align = 'center',
        elements = elements
    }, function(data,menu)
        returnValue:resolve(data.current.value)
        menu.close()
    end, function(data,menu)
        returnValue:resolve(false)
        menu.close()
    end)

    return Citizen.Await(returnValue)
end

local loopRunning = false

functions.beginCancellationLoop = function(battleMembers)
    if (loopRunning) then
        return
    end
    
    local cancelLoop = false
    loopRunning = true
    local orgTeam = functions.getOrgTeam()
    local lastFeth = GetGameTimer()

    while loopRunning do
        if (cache.player.inBattle) then
            break
        end
        local activePlayers = GetActivePlayers()
        for k,v in pairs(activePlayers) do
            local ped = GetPlayerPed(v)
            local playerServerId = GetPlayerServerId(v)
            if not (IsPedInAnyVehicle(ped)) and (IsPedAPlayer(ped)) and (table.concat(battleMembers, ','):match(playerServerId)) then
                orgTeam = functions.getOrgTeam()
                if (orgTeam.searching) then
                    TriggerServerEvent(queueRoute .. 'cancelSearch', 'vehicle', GetPlayerName(v))
                end
                cancelLoop = true
                loopRunning = false
                break
            end
        end
        if (GetGameTimer() - lastFeth) > 3000 then
            orgTeam = functions.getOrgTeam()
            if not (orgTeam.searching) then
                loopRunning = false
                cancelLoop = true
            end
        end
        if (cancelLoop) then
            break
        end
        Wait(100)
    end
end

functions.openSearchingPlayersMenu = function()
    local searchingPlayers = functions.getSearchingPlayers()
    local elements = {}

    for memberId, memberData in pairs(searchingPlayers) do
        elements[#elements+1] = {
            label = ('%s Id: %s Org: %s'):format(memberId, memberData.name, memberData.org),
            value = memberId
        }
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'searchingPlayersMenu', {
		title = "Osoby szukające drużyny",
		align = 'center',
		elements = elements
	}, function(data, menu)
        TriggerServerEvent(eventRoute .. 'acceptSearchingPlayer', data.current.value)
    end, function(data,menu)
        menu.close()
    end)
end
local cb = false
functions.openMainBattleMenu = function()
    if string.find(ESX.GetPlayerData().job.name, "org") then
        if ESX.GetPlayerData().job.grade == 1 or ESX.GetPlayerData().job.grade_permissions["bitki_menager"] then
            if not (cache.player.inOrgBucket) or (cache.player.customOrgBucket) or (cache.player.inSearchingSlotBucket) then
                return
            end

            if (cd) then
                return ESX.ShowNotification('Odczekaj chwile')
            end
            cd = true
            SetTimeout(3000, function()
                cd = false
            end)
            
            local orgTeam = functions.getOrgTeam()
            local elements = {
                {label = 'Wyrzuć Członka', value = 'kickMember'},
                {label = 'Zaproś Gracza (Spoza Organizacji)', value = 'otherOrgMember'},
                {label = 'Zaproś Gracza (Szukam Drużyny)', value = 'getSearchingPlayers'},
                {
                    label = ((orgTeam.searching) == true) and 'Anuluj wyszukiwanie' or 'Uruchom wyszukiwanie Bitki',
                    value = (orgTeam.searching == true) and 'cancelSearch' or 'startSearch'
                },
                {label = '-------------------- Członkowie ---------------------'}
            }
            local orgTeamMembers = functions.formOrgTeamMembers(orgTeam)

            for _, member in ipairs(orgTeamMembers) do
                elements[#elements + 1] = member
            end

            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'battles_main', {
                title = "Menu Bitek",
                align = 'center',
                elements = elements
            }, function(data, menu)
                local currentValue = data.current.value
                local orgTeam = functions.getOrgTeam()
                if (currentValue == 'kickMember') then
                   -- ESX.ShowNotification('Chwilowo OFF')
                    functions.openKickMemberMenu()
                elseif (currentValue == 'otherOrgMember') then
                    functions.openAddMemberMenu()
                elseif (currentValue == 'startSearch' or currentValue == 'cancelSearch') then
                    local canStartSearch, canStartError, battleVehs = functions.canStartBattle()
                    if not (canStartSearch) then
                        return ESX.ShowNotification(canStartError)
                    end
                    local confirmedSearch = functions.openConfirmMenu('rozpocząć/zakończyć szukanie Bitki')
                    ESX.UI.Menu.CloseAll()
                    if (confirmedSearch) then
                        if (currentValue == 'startSearch') then
                            if (orgTeam.searching == true) then
                                return ESX.ShowNotification('Twoja organizacja już szuka bitki')
                            end
                            CreateThread(function()
                                ESX.TriggerServerCallback(queueRoute .. currentValue, function(battleMembers)
                                    functions.beginCancellationLoop(battleMembers)
                                end)
                            end)
                        else
                            loopRunning = false
                            TriggerServerEvent(queueRoute .. currentValue, (currentValue == 'startSearch') and functions.formBattleVehs(battleVehs) or nil)
                        end
                    else
                        ESX.ShowNotification('Nie potwierdziłeś, anuluje.')
                    end
                elseif (currentValue == 'getSearchingPlayers') then
                    functions.openSearchingPlayersMenu()
                end
            end, function(data, menu)
                menu.close()
            end)
        else
            ESX.ShowNotification('Nie posiadasz permisji do zarzadzania bitkami')
        end
    else
        ESX.ShowNotification('Nie posiadasz organizacji')
    end
end


events.inviteAccepted = function(org)
    cache.player.customOrgBucket = org
    CreateThread(startPlayerStateHandler)
end

events.jobUpdate = function()
    if not (cache.player.inOrgBucket) then
        return
    end

    SetEntityCoords(cache.player.ped, config.battleActions.leaveSlotKickPosition)
end

RegisterNetEvent('zykem_battles:setSearchingForSlot', function(toggle)
    cache.player.inSearchingSlotBucket = toggle
end)

RegisterNetEvent('zykem_battles:setCustomOrgBucket', function(bucket)
    cache.player.customOrgBucket = bucket
end)

exports('getOrgTeam', functions.getOrgTeam)
exports('toggleBattleOutfit', functions.toggleBattleOutfit)
exports('toggleAutorefill', functions.toggleAutorefill)
RegisterCommand('hosted', functions.openMainBattleMenu)
RegisterKeyMapping('hosted', 'Menu Bitek', 'keyboard', 'F9')
RegisterNetEvent(eventRoute .. 'receiveJoinInvite', events.receiveJoinInvite)
RegisterNetEvent('zykem_battles:inviteAccepted', events.inviteAccepted)
RegisterNetEvent('esx:setjob', events.jobUpdate)