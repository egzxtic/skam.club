cache.battle = {}
local functions = {}
local events = {}
local route = 'battleEvent/'
local eventRoute = GetCurrentResourceName() .. ':' .. route

--[[
    battleId : number,
    team1: table,
    team2: table,
    map: 'lotnia',
    enemy: table
]]

-- functions.showCountdown = function(enemy)
--     local enemyStr = ('%s (%s)'):format(enemy.org.label, #enemy.battleMembers)
--     SendNUIMessage({
--         action = 'opencountdown',
--         name = "Hostowane Bitki",
--         enemy = enemyStr
--     })
--     ESX.UI.Menu.CloseAll()
--     Wait(5000)
--     ESX.UI.Menu.CloseAll()
-- end


functions.showCountdown = function(enemy)
    local enemyStr = ('%s (%s)'):format(enemy.org.label, #enemy.battleMembers)
    
    for i = 5, 1, -1 do
        PlaySoundFrontend(-1, 'CONFIRM_BEEP', 'HUD_MINI_GAME_SOUNDSET')
        ESX.Scaleform.ShowFreemodeMessage(tostring(i), '', 0.5)
        Wait(500)
    end

    PlaySoundFrontend(-1, 'Beep_Green', 'DLC_HEIST_HACKING_SNAKE_SOUNDS')
    exports['skam-ui']:hideHelpNotify()
    ESX.Scaleform.ShowFreemodeMessage('~r~Bitka rozpoczęta', '~s~Przeciwnik: ' .. enemyStr, 2.0)
end


functions.showCwelCountdown = function(enemy, name, type, title, text)
    if type == "count" then
        SendNUIMessage({
            action = 'opencountdown',
            name = name,
            enemy = enemy
        })
    elseif type == "win" then
        SendNUIMessage({
            action = 'openwinner',
            enemy = enemy,
            title = title,
            text = text,
        })
    end
    ESX.UI.Menu.CloseAll()
    Wait(5000)
    ESX.UI.Menu.CloseAll()
end



exports('showCountdown', functions.showCwelCountdown)

functions.showScoreboard = function(data)
    SendNUIMessage({
        action = 'openScoreboard',
        data = data
    })
end

functions.updateScoreboard = function(team, value)
    SendNUIMessage({
        action = 'updateScoreboard',
        team = team,
        newValue = value
    })
end

RegisterNetEvent(eventRoute .. 'updateScoreboard', functions.updateScoreboard)

local borderDist = 0
functions.beginDistanceBorderCheck = function(map)
    local battleBorder = map.mapCenter
    CreateThread(function()
        while cache.player.inBattle do
            borderDist = #(battleBorder - cache.player.coords) 
            cache.player.coords = GetEntityCoords(cache.player.ped)

            if (borderDist > map.radius) then
                SetEntityHealth(cache.player.ped, GetEntityHealth(cache.player.ped) - 2)
                ESX.ShowNotification('Jesteś pozą strefą bitki! Wejdź do strefy spowrotem, inaczej umrzesz.')
            end

            Wait(200)
        end
        borderDist = 0
    end)
end

functions.beginAntiVDM = function()
    Wait(1000)
    while cache.player.inBattle do
        local vehPool = GetGamePool('CVehicle')
        for k,vehicle in pairs(vehPool) do
            SetEntityNoCollisionEntity(vehicle, cache.player.ped, true)
            SetEntityNoCollisionEntity(cache.player.ped, vehicle, true)
        end
        Wait(1)
    end
end

functions.beginAntiWeaponThread = function()
    Wait (1000)
    local weaponsBlacklisted = GlobalState.battleBigWeapons
    local blacklistedWeapons = config.inBattleConfig.blacklistedWeapons
    while cache.player.inBattle do
        local currentWeapon = GetSelectedPedWeapon(cache.player.ped)
        local weaponBlacklisted = table.concat(blacklistedWeapons, ','):match(currentWeapon)
        
        if (weaponBlacklisted and not weaponsBlacklisted) then
            SetCurrentPedWeapon(cache.player.ped, `WEAPON_UNARMED`, true)
            ESX.ShowNotification('Tej broni nie możesz mieć przy sobie podczas bitki.')
        end
        Wait(300)
    end
end

functions.drawBorder = function(map)
    functions.beginDistanceBorderCheck(map)
    local battleBorder = map.mapCenter
    CreateThread(function()
        while cache.player.inBattle do
            if (borderDist > map.radius - 20 and borderDist < map.radius + 50) then
                DrawSphere(battleBorder.x, battleBorder.y, battleBorder.z, map.radius, 255, 0, 0, 0.4)
            else
                Wait(600)
            end
            Wait(1)
        end
    end)
end

functions.convertKmhToMps = function(kmh)
    return kmh * (1000 / 3600)
end

functions.handleBattleVehicle = function(vehicle)
    SetVehicleFixed(vehicle)
    SetVehicleDirtLevel(vehicle, 0.0)
    SetVehicleDoorsLocked(vehicle, 1)
    local isSportVeh = (tonumber(GetVehicleHandlingInt(vehicle, 'CHandlingData', 'fMass'))) < 4000
    SetVehicleMaxSpeed(vehicle, functions.convertKmhToMps(config.inBattleConfig.vehicleMaxSpeed[(isSportVeh == true) and 'sport' or 'offroad']))
end

local originalPreBattleSkin = nil
functions.handlePlayerBattleStart = function()
    TriggerEvent('skinchanger:getSkin', function(playerSkin)
        originalPreBattleSkin = playerSkin
        local valuesToChange = {}
        if (playerSkin.helmet_1 ~= -1) then
            valuesToChange['helmet_1'] = -1
        end
        if (playerSkin.sex == 0 and playerSkin.glasses_1 ~= 0) or (playerSkin.sex == 1 and playerSkin.glasses_1 ~= 5) then
            valuesToChange['glasses_1'] = (playerSkin.sex == 0) and 0 or 5
        end
        if ( playerSkin.mask_1 ~= 0) then
            valuesToChange['mask_1'] = 0
        end
        -- print(playerSkin.mask_1, playerSkin.helmet_1, playerSkin.glasses_1)
        for key,value in pairs(valuesToChange) do
            -- print(key, value, 'do zmiany')
            TriggerEvent('skinchanger:change', key, value)
        end
    end)
end

local admin = exports['admin']
events.battleStarted = function(battleData)
    ESX.UI.Menu.CloseAll()
    cache.player.inBattle = true
    local ped = cache.player.ped
    if not (IsEntityVisible(ped)) then
        SetEntityVisible(ped, true, 0)
    end

    SetTimeout(1500, function()
        if (IsPedInAnyVehicle(PlayerPedId(), false)) then
            local veh = GetVehiclePedIsIn(PlayerPedId(), false)
            if (GetPedInVehicleSeat(veh, -1) == PlayerPedId()) then
                FreezeEntityPosition(veh, true)
            end
        end
    end)

    local playerVehicle = GetVehiclePedIsIn(ped, false)
    SetVehicleDoorsLocked(playerVehicle, 4)
    -- local teamOutfit = config.outfits[battleData.enemy]
    -- print(config.outfits[battleData.enemy],battleData.enemy,"cwel1")
    battleData.enemy = battleData[battleData.enemy]

    functions.showCountdown(battleData.enemy)
    functions.drawBorder(battleData.map)
    CreateThread(functions.beginAntiVDM)
    CreateThread(functions.beginAntiWeaponThread)
    functions.showScoreboard(battleData)
    -- clearPedFromProps()

    -- print('battle has started')

    -- POZNIEJ DODAC
    -- if (teamOutfit) then
    --     TriggerEvent('skinchanger:getSkin', function(playerSkin)
    --         if (playerSkin.sex == 0) then
    --             TriggerEvent('skinchanger:loadClothes', playerSkin, teamOutfit.male)
    --             ESX.ShowNotification('Załadowano outfit organizacyjny')
    --         else
    --             TriggerEvent('skinchanger:loadClothes', playerSkin, teamOutfit.female)
    --             ESX.ShowNotification('Załadowano outfit organizacyjny dla kobiet')
    --         end
    --     end)
    -- end

    if (playerVehicle ~= 0 and GetPedInVehicleSeat(playerVehicle, -1) == ped) then
        functions.handleBattleVehicle(playerVehicle)
    end
    ESX.UI.Menu.CloseAll()
    Wait(2000)
    functions.handlePlayerBattleStart()
end



functions.loadScaleform = function(title, subTitle)
    local handle = RequestScaleformMovie("mp_big_message_freemode")
    
    repeat 
        debug.print('BATTLEEVENT', 'awaiting scaleform load')
        Wait(1)
    until HasScaleformMovieLoaded(handle)

    PushScaleformMovieFunction(handle, "SHOW_SHARD_WASTED_MP_MESSAGE")
	PushScaleformMovieFunctionParameterString(title)
    PushScaleformMovieFunctionParameterString(subTitle)
    PopScaleformMovieFunctionVoid()
    return handle
end

functions.getTableLen = function(table)
    local count = 0
    for _ in pairs(table) do
        count += 1
    end
    return count
end

local red, white, pink = '<font color="red">', '<font color="white">', '<font color="pink">'

functions.formTeamStats = function(team)
    local teamKillers = {}
    for killerId, kills in pairs(team.teamKillers) do
        teamKillers[killerId] = {
            kills = kills.kills,
            org = kills.org
        }
    end

    for impostorId, impostorData in pairs(team.impostors) do
        if not (teamKillers[impostorId]) then
            teamKillers[impostorId] = {org = impostorData.org}
        end
        teamKillers[impostorId].impostors = impostorData.kills
    end

    return teamKillers
end

functions.formStatsString = function(teamKillers)
    local statsString = ''
    for killerName, killerData in pairs(teamKillers) do
        local killStr = killerName .. ' - ' .. red .. tostring(killerData.kills or 0) .. white
        local orgStr = killerData.org ~= nil and ' (' .. pink .. killerData.org .. white .. ') <br>' or ''
        local impostorStr = (killerData.impostors) and (' (+%s impostorów)'):format(tostring(killerData.impostors)) or ''
        statsString = statsString .. killStr .. impostorStr .. orgStr .. '<br>'
    end

    if (#statsString < 5) then
        statsString = 'Brak zabójstw.'
    end

    return statsString
end

functions.spawnAfterBattleVehicle = function(vehicleData)
    local props = vehicleData.vehProps
    local spawnPos = vehicleData.vehSpawnPos
    local ped = cache.player.ped

    ESX.Game.SpawnVehicle(props.model, vec3(spawnPos.x, spawnPos.y, spawnPos.z), spawnPos.w, function(vehicle)
        ESX.Game.SetVehicleProperties(vehicle, props)
        SetVehicleFixed(vehicle)
        
        if vehicleData.fromGarage then
            SetEntityAsMissionEntity(vehicle, true, true)
            local plate = props.plate
            if plate then
                SetVehicleNumberPlateText(vehicle, plate)
            end
        end
        
        TaskWarpPedIntoVehicle(ped, vehicle, -1)
        Wait(100)
        TriggerServerEvent(eventRoute .. 'handlePassengersAfterBattle', NetworkGetNetworkIdFromEntity(vehicle), vehicleData.passengers, vehicleData.vehSpawnPos)
    end)
end

events.handleVehicleAfterBattle = function(vehicleData)
    functions.spawnAfterBattleVehicle(vehicleData)
end

events.battleEnded = function(data, vehicleData)
    cache.player.inBattle = false
    if (exports['test']:isdead()) then
        TriggerEvent('skam$death:revive')
        Wait(1000)
    end
    SendNUIMessage({
        action = 'hideScoreboard'
    })
    local afterPartyCoords = config.inBattleConfig.afterBattleSpawn
    local ped = PlayerPedId()
    LocalPlayer.state.inBattle = false
    SetEntityCoords(ped, afterPartyCoords)
    SetEntityHealth(ped, GetEntityMaxHealth(ped))
    Wait(1000)
    local winner = data.winner
    local loser = data.loser

    local winnerKillers = functions.formTeamStats(winner)
    local loserKillers = functions.formTeamStats(loser)

    local winnersKills = functions.formStatsString(winnerKillers)
    local losersKills = functions.formStatsString(loserKillers)

    ESX.ShowNotification('STATYSTYKI BITKI - ~g~' .. winner.org.label.. "<br>" ..winnersKills)
    ESX.ShowNotification('STATYSTYKI BITKI - ~r~' .. loser.org.label.. "<br>" ..losersKills)


    -- wypierdalam to 
    -- SendNUIMessage({
    --     action = 'openwinner',
    --     enemy = winner.org.label,
    --     title = "Hostowane Bitki",
    --     text = "Bitke wygrala organizacja:",
    -- })

    ESX.Scaleform.ShowFreemodeMessage('WYGRALA BITKE ORG: ' .. winner.org.label, '', 3.0)

    exports['skam-ui']:hideHelpNotify()
    

-- POZNIEJ ZROBIC
    -- if (originalPreBattleSkin) then
    --     TriggerEvent('skinchanger:loadSkin', originalPreBattleSkin, function()
    --         ESX.ShowNotification('Załadowano outfit sprzed bitki')
    --         originalPreBattleSkin = nil
    --     end)
    -- end

    if (ped ~= PlayerPedId()) then
        ped = PlayerPedId()
    end

    cache.player.updateState('canSeeBucket', true, false)
    cache.player.inOrgBucket = true
end

events.getVehProperties = function(cb, vehNetId)
    local vehEntity = NetToVeh(vehNetId)
    local vehProperties = ESX.Game.GetVehicleProperties(vehEntity)
    cb(vehProperties)
end

RegisterNetEvent(eventRoute .. 'battleStarted', events.battleStarted)
RegisterNetEvent(eventRoute .. 'handleVehicleAfterBattle', events.handleVehicleAfterBattle)
RegisterNetEvent(eventRoute .. 'battleEnded', events.battleEnded)
Wait(1000)
ESX.RegisterClientCallback('zykem_battles:getVehProperties', events.getVehProperties)