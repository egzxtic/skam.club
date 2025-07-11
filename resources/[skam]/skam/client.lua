local scenario = {
    ai = {
        `AMBIENT_GANG_HILLBILLY`, `AMBIENT_GANG_BALLAS`, `AMBIENT_GANG_MEXICAN`,
        `AMBIENT_GANG_FAMILY`, `AMBIENT_GANG_MARABUNTE`, `AMBIENT_GANG_SALVA`,
        `AMBIENT_GANG_LOST`, `AMBIENT_GANG_CULT`, `AMBIENT_GANG_WEICHENG`,
        `GANG_1`, `GANG_2`, `GANG_9`, `GANG_10`,
        `FIREMAN`, `MEDIC`, `COP`, `PRISONER`, `SECURITY_GUARD`,
    },
    types = {
        'WORLD_VEHICLE_ATTRACTOR', 'WORLD_VEHICLE_AMBULANCE', 'WORLD_VEHICLE_BOAT_IDLE',
        'WORLD_VEHICLE_BOAT_IDLE_ALAMO', 'WORLD_VEHICLE_BOAT_IDLE_MARQUIS', 'WORLD_VEHICLE_BOAT_IDLE_MARQUIS',
        'WORLD_VEHICLE_BROKEN_DOWN', 'WORLD_VEHICLE_BUSINESSMEN', 'WORLD_VEHICLE_HELI_LIFEGUARD',
        'WORLD_VEHICLE_CLUCKIN_BELL_TRAILER', 'WORLD_VEHICLE_CONSTRUCTION_SOLO', 'WORLD_VEHICLE_CONSTRUCTION_PASSENGERS',
        'WORLD_VEHICLE_DRIVE_PASSENGERS', 'WORLD_VEHICLE_DRIVE_PASSENGERS_LIMITED', 'WORLD_VEHICLE_DRIVE_SOLO',
        'WORLD_VEHICLE_FARM_WORKER', 'WORLD_VEHICLE_FIRE_TRUCK', 'WORLD_VEHICLE_EMPTY',
        'WORLD_VEHICLE_MARIACHI', 'WORLD_VEHICLE_MECHANIC', 'WORLD_VEHICLE_MILITARY_PLANES_BIG',
        'WORLD_VEHICLE_MILITARY_PLANES_SMALL', 'WORLD_VEHICLE_PARK_PARALLEL', 'WORLD_VEHICLE_PARK_PERPENDICULAR_NOSE_IN',
        'WORLD_VEHICLE_PASSENGER_EXIT', 'WORLD_VEHICLE_POLICE_BIKE', 'WORLD_VEHICLE_POLICE_CAR',
        'WORLD_VEHICLE_POLICE', 'WORLD_VEHICLE_POLICE_NEXT_TO_CAR', 'WORLD_VEHICLE_QUARRY',
        'WORLD_VEHICLE_SALTON', 'WORLD_VEHICLE_SALTON_DIRT_BIKE', 'WORLD_VEHICLE_SECURITY_CAR',
        'WORLD_VEHICLE_STREETRACE', 'WORLD_VEHICLE_TOURBUS', 'WORLD_VEHICLE_TOURIST',
        'WORLD_VEHICLE_TANDL', 'WORLD_VEHICLE_TRACTOR',  'WORLD_VEHICLE_TRACTOR_BEACH',
        'WORLD_VEHICLE_TRUCK_LOGS', 'WORLD_VEHICLE_TRUCKS_TRAILERS', 'WORLD_VEHICLE_DISTANT_EMPTY_GROUND'
    },
    groups = {
        2017590552, -- LSIA planes
        2141866469, -- Sandy Shores planes
        1409640232, -- Grapeseed planes
        'ng_planes' -- Far up in the skies jets
    },
    models = {
        'SHAMAL', 'LUXOR', 'LUXOR2', 'JET', 'LAZER', 'TITAN', 'BARRACKS',
        'BARRACKS2', 'CRUSADER', 'RHINO', 'AIRTUG', 'RIPLEY', 'FROGGER',
        'MAVERICK', 'SWIFT', 'SWIFT2',
    }
}

local weaponsData = {
    damage = {
        [`WEAPON_PISTOL`] = 0.55,
        [`WEAPON_COMBATPISTOL`] = 0.55,
        [`WEAPON_SNSPISTOL`] = 0.45,
        [`WEAPON_PISTOL_MK2`] = 0.55,
        [`WEAPON_SNSPISTOL_MK2`] = 0.435,
        [`WEAPON_HEAVYPISTOL`] = 0.55,
        [`WEAPON_VINTAGEPISTOL`] = 0.55,
        [`WEAPON_BERETTA`] = 0.55,
        [`WEAPON_GLOCK20`] = 0.55,
        [`WEAPON_CERAMICPISTOL`] = 0.65,
        [`WEAPON_RAMMED_BY_CAR`] = 0.0,
        [`WEAPON_RUN_OVER_BY_CAR`] = 0.0,
    },
    recoil = {
        pitch = {
            [`WEAPON_STUNGUN`] = {0.1, 1.1},
            [`WEAPON_FLAREGUN`] = {0.9, 1.9},
            [`WEAPON_SNSPISTOL`] = {3.2, 4.2},
            [`WEAPON_SNSPISTOL_MK2`] = {2.7, 3.7},
            [`WEAPON_BERETTA`] = {3.0, 4.0},
            [`WEAPON_GLOCK20`] = {3.0, 4.0},
            [`WEAPON_VINTAGEPISTOL`] = {3.0, 4.0},
            [`WEAPON_PISTOL`] = {3.0, 4.0},
            [`WEAPON_PISTOL_MK2`] = {3.0, 4.0},
            [`WEAPON_DOUBLEACTION`] = {3.0, 3.5},
            [`WEAPON_COMBATPISTOL`] = {3.5, 4.0},
            [`WEAPON_HEAVYPISTOL`] = {2.6, 3.1},
            [`WEAPON_PISTOL50`] = {2.9, 3.4},
            [`WEAPON_CERAMICPISTOL`] = {2.9, 3.1},
        },
        shake = {
            [`WEAPON_STUNGUN`] = {0.01, 0.02},
            [`WEAPON_FLAREGUN`] = {0.01, 0.02},
            [`WEAPON_SNSPISTOL`] = {0.08, 0.16},
            [`WEAPON_SNSPISTOL_MK2`] = {0.07, 0.14},
            [`WEAPON_BERETTA`] = {0.08, 0.16},
            [`WEAPON_GLOCK20`] = {0.08, 0.16},
            [`WEAPON_VINTAGEPISTOL`] = {0.08, 0.16},
            [`WEAPON_PISTOL`] = {0.10, 0.20},
            [`WEAPON_PISTOL_MK2`] = {0.11, 0.22},
            [`WEAPON_DOUBLEACTION`] = {0.1, 0.2},
            [`WEAPON_COMBATPISTOL`] = {0.1, 0.2},
            [`WEAPON_HEAVYPISTOL`] = {0.1, 0.2},
            [`WEAPON_PISTOL50`] = {0.1, 0.2},
            [`WEAPON_CERAMICPISTOL`] = {0.11, 0.22},
        }
    }
}

-- playerData = {
--     Id = PlayerId(),
--     entityId = PlayerPedId(),
--     inVehicle = IsPedInAnyVehicle(PlayerPedId(), false)
-- }
local onAim = false
local lastPov = 1
local wait = 100
local keysBlock = {59,21,24,25,47,58,71,72,63,64,263,264,257,140,141,142,143,75}
local handsUp = false
local crouchValue = 0
local firstSpawn = true

Citizen.CreateThread(function()
    for i = 1, 15 do
        EnableDispatchService(i, false)
    end
    SetMaxWantedLevel(0)

    for k, v in pairs(weaponsData.damage) do
        SetWeaponDamageModifier(k, v)
    end

    DisableIdleCamera(true)

    for _, sctyp in ipairs(scenario.types) do
        SetScenarioTypeEnabled(sctyp, false)
    end

    for _, scgrp in ipairs(scenario.groups) do
        SetScenarioGroupEnabled(scgrp, false)
    end

    for _, model in ipairs(scenario.models) do
        SetVehicleModelIsSuppressed(GetHashKey(model), true)
    end

    for i = 1, #scenario.ai do
        SetRelationshipBetweenGroups(1, scenario.ai[i], `PLAYER`)
    end

    SetMapZoomDataLevel(0, 0.96, 0.9, 0.08, 0.0, 0.0)
    SetMapZoomDataLevel(1, 1.6, 0.9, 0.08, 0.0, 0.0)
    SetMapZoomDataLevel(2, 8.6, 0.9, 0.08, 0.0, 0.0)
    SetMapZoomDataLevel(3, 12.3, 0.9, 0.08, 0.0, 0.0)
    SetMapZoomDataLevel(4, 22.3, 0.9, 0.08, 0.0, 0.0)

    SetPlayerCanDoDriveBy(PlayerId(), false)
    AddTextEntry('FE_THDR_GTAO', '~w~s~m~k~w~a~m~m~w~.~m~c~w~l~m~u~w~b')
    ReplaceHudColourWithRgba(0, 255, 255, 255, 255)

    Citizen.CreateThread(function()
        while true do
            if IsPedInAnyVehicle(PlayerPedId(), false) then
                local veh = GetVehiclePedIsIn(PlayerPedId(), false)
                if veh and veh ~= 0 then
                    SetVehicleRadioEnabled(veh, false)
                    SetVehRadioStation(veh, 'OFF')
                end
                DisableControlAction(0, 85, true)
                DisableControlAction(0, 86, true)
                DisableControlAction(0, 81, true)
                DisableControlAction(0, 82, true)
            end

            SetVehicleDensityMultiplierThisFrame(0.0)
            SetPedDensityMultiplierThisFrame(0.0)
            SetRandomVehicleDensityMultiplierThisFrame(0.0)
            SetParkedVehicleDensityMultiplierThisFrame(0.0)
            SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)

            if not IsControlPressed(0, 25) then
                DisableControlAction(0, 24, true)   -- Blokuje główny atak/strzał (LPM)
                --DisableControlAction(0, 140, true)  -- Uderzenie z kolby (melee lekki)
                --DisableControlAction(0, 141, true)  -- Melee ciężki
                --DisableControlAction(0, 142, true)  -- Melee alternatywny
                DisableControlAction(0, 257, true)  -- LPM
                DisableControlAction(0, 263, true)  -- PPM
                DisableControlAction(0, 264, true)  -- PPM (celowanie)
            end

            -- HideHudAndRadarThisFrame()

            local enumCntrlId = {37,45,199,140,141,157,158,159,160,161,162,163,164,165,261,262}
            for _, cntrlId in pairs(enumCntrlId) do
                DisableControlAction(0, cntrlId, true)
            end

            local enumCompId = {1,2,3,4,5,6,7,8,9,13,14,15,16,17,18,19,20,21,22}
            for _, componentId in pairs(enumCompId) do
                if componentId == 14 and exports['skam']:thirdZone() then
                else
                    HideHudComponentThisFrame(componentId)
                end
            end

            Citizen.Wait(0)
        end
    end)
end)

local G = {
	'MP0_STAMINA',
	'MP0_STRENGTH',
	'MP0_LUNG_CAPACITY',
	'MP0_WHEELIE_ABILITY',
	'MP0_FLYING_ABILITY',
	'MP0_SHOOTING_ABILITY',
	'MP0_STEALTH_ABILITY'
}
for k,v in ipairs(G) do
	StatSetInt(v, 110, true)
end

CreateThread(function()
    local lastHealth = GetEntityHealth(PlayerPedId())
    local lastArmour = GetPedArmour(PlayerPedId())

    while true do
        if not LocalPlayer.state.dead then
            local health = GetEntityHealth(PlayerPedId())
            local armour = GetPedArmour(PlayerPedId())

            if lastHealth ~= health then
                if IsPedInAnyVehicle(PlayerPedId(), false) and HasEntityBeenDamagedByWeapon(PlayerPedId(), `WEAPON_RAMMED_BY_CAR`, 0) then
                    ClearEntityLastDamageEntity(PlayerPedId())
                    LocalPlayer.state:set('health', lastHealth, true)
                    SetEntityHealth(PlayerPedId(), lastHealth)
                else
                    LocalPlayer.state:set('health', health, true)
                    lastHealth = health
                end
            end

            if lastArmour ~= armour then
                if IsPedInAnyVehicle(PlayerPedId(), false) and HasEntityBeenDamagedByWeapon(PlayerPedId(), `WEAPON_RAMMED_BY_CAR`, 0) then
                    ClearEntityLastDamageEntity(PlayerPedId())
                    LocalPlayer.state:set('armor', lastArmour, true)
                    SetPedArmour(PlayerPedId(), lastArmour)
                else
                    LocalPlayer.state:set('armor', armour, true)
                    lastArmour = armour
                end
            end
        end

        Wait(1000)
    end
end)

CreateThread(function()
	while ESX.PlayerData == nil or ESX.PlayerData.job == nil or ESX.PlayerData.job.name == nil do
        Wait(1000)
    end

    while true do
        if ESX.PlayerData.job.name == 'police' then
            SetPedConfigFlag(PlayerPedId(), 149, false)
            SetPedConfigFlag(PlayerPedId(), 438, false)
        else
            SetPedConfigFlag(PlayerPedId(), 149, true)
            SetPedConfigFlag(PlayerPedId(), 438, true)
        end

        SetBlipAlpha(GetNorthRadarBlip(), 0)

        Wait(10000)
    end
end)

CreateThread(function()
    while true do
        local weapon = GetSelectedPedWeapon(PlayerPedId())
        local shoot = IsPedShooting(PlayerPedId())
        local aim = IsControlPressed(0, 25)

        if weapon ~= `WEAPON_UNARMED` then
            if not exports['skam']:thirdZone() then
                if aim then
                    wait = 0
                    if not onAim then
                        lastPov = GetFollowPedCamViewMode()
                        if lastPov ~= 4 then
                            SetFollowPedCamViewMode(4)
                        end
                        onAim = true
                    end
                    if GetFollowPedCamViewMode() ~= 4 then
                        SetFollowPedCamViewMode(4)
                    end
                else
                    wait = 50
                    if onAim then
                        if lastPov ~= 4 then
                            SetFollowPedCamViewMode(lastPov)
                        end
                        onAim = false
                    end
                end
            
                if shoot then
                    wait = 0
                    local recoil = weaponsData.recoil.pitch[weapon]
                    local shake = weaponsData.recoil.shake[weapon]
                    if recoil and type(recoil) == 'table' and #recoil > 0 then
                        local i, tv = 1, 0
                        repeat
                            local random = GetRandomFloatInRange(0.1, recoil[i])
                            SetGameplayCamRelativePitch(GetGameplayCamRelativePitch() + random, (recoil[i] > 0.1 and 1.2 or 0.333))
                            tv = tv + random
                        until tv >= recoil[i]
                    end
                    if shake and type(shake) == 'table' and #shake == 2 then
                        ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', shake[2])
                    end
                end
            end

            DisableControlAction(0, 142, true)

            if IsPedReloading(PlayerPedId()) then
                ClearPedTasks(PlayerPedId())
            end
        else
            wait = 300
            onAim = false
        end

        Citizen.Wait(wait)
    end
end)

CreateThread(function()
    while true do
        if not IsPedArmed(PlayerPedId(), 1) and GetSelectedPedWeapon(PlayerPedId()) ~= `WEAPON_UNARMED` then
			SetPlayerLockon(PlayerId(), false)
		else
			SetPlayerLockon(PlayerId(), true)
		end

        if GetPlayerWantedLevel(PlayerId()) > 0 then
            ClearPlayerWantedLevel(PlayerId())
        end

        Wait(500)
    end
end)

function isPedAble(ped)
    if
        not LocalPlayer.state.dead and
        not IsPedFalling(ped) and
        not IsPedDiving(ped) and
        not IsPedInCover(ped, false) and
        not IsPedCuffed(ped) and
        not IsPedBeingStunned(ped) and
        not IsEntityInAir(ped)
    then
        return true
    end
    return false
end
exports('isPedAble', isPedAble)

local function requestAnim(dict, opt)
    if opt == 1 then
        RequestAnimSet(dict)
        while not HasAnimSetLoaded(dict) do Wait(0) end
    elseif opt == 2 then
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do Wait(0) end
    end
end

local function disableControls()
    while handsUp do
        for i = 1, #keysBlock do
            DisableControlAction(0, keysBlock[i])
        end
        Wait(0)
    end
end

SKAM.addKeybind({
    key = 'GRAVE',
    description = 'Podnieś ręce do góry',
    onPressed = function()
        if IsPedInAnyVehicle(PlayerPedId(), false) then
            return
        end
    
        if isPedAble(PlayerPedId()) then
            handsUp = not handsUp

            local dict = 'missminuteman_1ig_2'
            requestAnim(dict, 2)
    
            if handsUp then
                IsControlPressed(0, 25)
            end
    
            if handsUp then
                TaskPlayAnim(PlayerPedId(), dict, 'handsup_enter', 8.0, 8.0, -1, 50, 0, false, false, false)
            else
                ClearPedTasks(PlayerPedId())
            end
    
            disableControls()
        end
    end
})

local function disableHands()
    if handsUp then
        handsUp = false
    end
end
exports('disableHands', disableHands)

local crouched = false

SKAM.addKeybind({
    key = 'LCONTROL',
    description = 'Kucanie',
    onPressed = function()
        if DoesEntityExist(PlayerPedId()) and not IsEntityDead(PlayerPedId()) then 
            DisableControlAction(0,36,true)

            if not IsPauseMenuActive() then 
                if IsDisabledControlJustPressed(0,36) then 
                    RequestAnimSet("move_ped_crouched")

                    while not HasAnimSetLoaded("move_ped_crouched") do 
                        Citizen.Wait(100)
                    end 

                    if crouched == true then 
                        ResetPedMovementClipset(PlayerPedId(), 0)
                        crouched = false 
                    elseif crouched == false then
                        SetPedMovementClipset(PlayerPedId(), "move_ped_crouched", 0.25)
                        crouched = true 
                    end 
                end
            end 
        end 
    end
})

local propfix = {
    used = false,
    time = GetGameTimer(),
    health = GetEntityHealth(PlayerPedId()),
    armor = GetPedArmour(PlayerPedId()),
}

RegisterCommand('propfix', function()
    if not propfix.used and isPedAble(PlayerPedId()) and not IsPedInAnyVehicle(PlayerPedId(), false) then
        if propfix.time < GetGameTimer() then
			propfix.time = GetGameTimer() + 30000
            TriggerEvent('skinchanger:getSkin', function(skin)
				if skin.sex == 0 then
					TriggerEvent('skinchanger:loadSkin', {sex=1})
					Wait(500)
					TriggerEvent('skinchanger:loadSkin', {sex=0})
				elseif skin.sex == 1 then
					TriggerEvent('skinchanger:loadSkin', {sex=0})
					Wait(500)
					TriggerEvent('skinchanger:loadSkin', {sex=1})
				end
            end)
			Wait(2000)
			SetEntityHealth(PlayerPedId(), propfix.health)
			SetPedArmour(PlayerPedId(), propfix.armor)
        else
            ESX.ShowNotification('Nie możesz używac tej komendy tak często', 'error')
        end
	else
		ESX.ShowNotification('Nie możesz aktualnie użyć tej komendy', 'error')
    end
end, false)

AddEventHandler('esx:onPlayerSpawn', function()
    LocalPlayer.state:set('health', GetEntityHealth(PlayerPedId()), true)
    LocalPlayer.state:set('armor', GetPedArmour(PlayerPedId()), true)

    if firstSpawn then
        SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
        ESX.TriggerServerCallback('skam:requestPlayerStatus', function(data)
            if data then
                if data.health then
                    SetEntityHealth(PlayerPedId(), data.health)
                end
                if data.armor then
                    SetPedArmour(PlayerPedId(), data.armor)
                end
            end
        end)
        firstSpawn = false
    end

	propfix.used = true
	ESX.SetTimeout(2000, function()
        propfix.used = false
    end)
end)

AddEventHandler('skam$death', function()
    LocalPlayer.state:set('health', GetEntityHealth(PlayerPedId()), true)
    LocalPlayer.state:set('armor', GetPedArmour(PlayerPedId()), true)
    disableHands()
end)

RegisterNetEvent('skam$flip')
AddEventHandler('skam$flip', function()
    if IsPedDeadOrDying(PlayerPedId()) or IsEntityPlayingAnim(PlayerPedId(), 'dead', 'dead_a', 3) then
        ESX.ShowNotification('Nie możesz użyć tej komendy będąc martwy.', 'error')
        return
    end

    if not IsPedInAnyVehicle(PlayerPedId()) then
        ESX.ShowNotification('Aby użyć tej komendy musisz znajdować się w pojeździe.', 'error')
        return
    end

    if IsEntityInAir(GetVehiclePedIsIn(PlayerPedId())) then
        ESX.ShowNotification('Nie możesz użyć tej komendy, gdy pojazd jest w trakcie latania.', 'error')
    else
        SetVehicleOnGroundProperly(GetVehiclePedIsIn(PlayerPedId()))
        ESX.ShowNotification('Pomyślnie przewrócono pojazd.', 'success')
    end
end)


RegisterNetEvent('skam$fix')
AddEventHandler('skam$fix', function()
	if IsPedInAnyVehicle(PlayerPedId(), false) then
		local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		SetVehicleEngineHealth(vehicle, 1000)
		SetVehicleEngineOn(vehicle, true, true)
		SetVehicleFixed(vehicle)
		ESX.ShowNotification('Naprawiono pojazd', 'success')
	else
		ESX.ShowNotification('Musisz znajdować się w pojeździe', 'error')
	end
end)

RegisterNetEvent('skam:onVanishCommand')
AddEventHandler('skam:onVanishCommand', function()
    SetEntityVisible(PlayerPedId(), not IsEntityVisible(PlayerPedId()))
end)

local function switchSeat(_, args)
    if tonumber(args[1]) then
        local seatIndex = args[1] - 1
        if seatIndex < -1 or seatIndex >= 3 then
            ESX.ShowNotification('Wybierz siedzenie (0-3)', 'error')
        else
            local veh = GetVehiclePedIsIn(PlayerPedId(), false)
            if veh ~= nil and veh > 0 then
                if IsVehicleSeatFree(veh, seatIndex) then
                    SetPedIntoVehicle(PlayerPedId(), veh, seatIndex)
                end
            else
                ESX.ShowNotification('Musisz być w pojeździe', 'error')
            end
        end
    end
end
RegisterCommand('seat', switchSeat)

CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/seat', 'Zmień miejsce w aktualnym pojeździe', {
        {name = 'seat', help = 'Zmień miejsce w aktualnym pojeździe. 0 = kierowca, 1 = pasażer, 2-3 = tylne siedzenia'} 
    })
end)

AddEventHandler('gameEventTriggered', function(name, args)
    if name == 'CEventNetworkPlayerEnteredVehicle' then
        local v = GetVehiclePedIsIn(PlayerPedId(), 0)
        for i = 1, 5 do
            if (not GetPedConfigFlag(PlayerPedId(), 184, 1)) then
                SetPedConfigFlag(PlayerPedId(), 184, true)
            end
            if (GetIsTaskActive(PlayerPedId(), 165)) then
                if (GetSeatPedIsTryingToEnter(PlayerPedId()) == -1) then
                    if (GetPedConfigFlag(PlayerPedId(), 184, 1)) then
                        SetPedIntoVehicle(PlayerPedId(), v, 0)
                        SetVehicleCloseDoorDeferedAction(v, 0)
                        SetVehicleDoorShut(v, 1, false)
                    end
                end
            end
            Wait(400)
        end
    end
end)

function ChoosePlayerMenu(dist)
    local promise = promise.new()
    local currentPlayer, menuActive = nil, true
    dist = dist or 3.0

    CreateThread(function()
        while menuActive do
            if currentPlayer then
                local ped = GetPlayerPed(currentPlayer)
                local coords = GetWorldPositionOfEntityBone(ped, GetPedBoneIndex(ped, 0x796E))
                DrawMarker(0, coords.x, coords.y, coords.z + 0.6, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.5, 0.5, 0.25, 255, 0, 0, 100, false, true, 2, false, false, false, false)
                Wait(0)
            else
                Wait(100)
            end
        end
    end)

    local menu = ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'choose_player_menu', {
		title    = 'Wybierz gracza',
		align    = 'right',
		elements = {}
	}, function(data, menu)
        if not data.current.nonSelectable then
            promise:resolve(data.current.value)
        end
	end, function(data, menu)
		menu.close()
    end, function(data, menu)
        currentPlayer = GetPlayerFromServerId(data.current.value)
	end, function ()
        promise:resolve(nil)
    end)

    CreateThread(function()
        while menuActive do
            local playersInArea = ESX.Game.GetPlayersInArea(GetEntityCoords(cachePed), dist)
            if #playersInArea > 0 then
                local elements = {}
                local foundSelected = false

                for i, player in ipairs(playersInArea) do
                    if player == currentPlayer then
                        foundSelected = true
                    end
                end

                if not foundSelected then
                    currentPlayer = playersInArea[1]
                end

                for i, player in ipairs(playersInArea) do
                    elements[i] = {
                        label = '['..GetPlayerServerId(player)..'] '..GetPlayerName(player),
                        value = GetPlayerServerId(player),
                        selected = player == currentPlayer and true or nil
                    }
                end

                menu.setElements(elements)
                menu.refresh()
            else
                currentPlayer = nil
                menu.setElements({label = 'Brak graczy w pobliżu', nonSelectable = true})
                menu.refresh()
            end
            Wait(400)
        end
    end)

    local choosedPlayer = Citizen.Await(promise)

    menuActive = false
    if menu then
        menu.close()
    end
    return choosedPlayer
end

exports('ChoosePlayerMenu', ChoosePlayerMenu)

RegisterNUICallback('skam:setNuiFocus', function(data, cb)
    SetNuiFocus(false, false)
    cb()
end)

CreateThread(function()
    while true do
		Wait(500)
		if IsPedOnFoot(PlayerPedId()) then
			SetRadarZoom(1100)
		elseif IsPedInAnyVehicle(PlayerPedId(), true) then
			SetRadarZoom(1100)
		end
    end
end)

-- RegisterNetEvent('skam:onSetpedCommand')
-- AddEventHandler('skam:onSetpedCommand', function(pedModel)
--     CreateThread(function()
--         ESX.Streaming.RequestModel(pedModel)

--         if IsModelInCdimage(pedModel) and IsModelValid(pedModel) then
--             SetPlayerModel(PlayerId(), pedModel)
--             SetPedDefaultComponentVariation(PlayerPedId())
--         end

--         SetModelAsNoLongerNeeded(pedModel)
--         Wait(1000)
--         TriggerEvent('reload:weaponsync')
--     end)
-- end)