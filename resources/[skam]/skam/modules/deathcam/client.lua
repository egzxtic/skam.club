local isDead = false
local canRespawn = false
local respawnMenuOpen = false
local cam = nil

local WeaponNames = {
    ['WEAPON_UNARMED'] = 'bez broni',
    ['WEAPON_KNIFE'] = 'noz',
    ['WEAPON_NIGHTSTICK'] = 'palka policyjna',
    ['WEAPON_HAMMER'] = 'mlotek',
    ['WEAPON_BAT'] = 'kij do baseballa',
    ['WEAPON_GOLFCLUB'] = 'kij golfowy',
    ['WEAPON_CROWBAR'] = 'lom',
    ['WEAPON_PISTOL'] = 'pistolet',
    ['WEAPON_PISTOL_MK2'] = 'pistolet mk2',
    ['WEAPON_COMBATPISTOL'] = 'pistolet bojowy',
    ['WEAPON_APPISTOL'] = 'Pistolet przeciwpancerny',
    ['WEAPON_PISTOL50'] = 'Pistolet .50',
    ['WEAPON_MICROSMG'] = 'Micro SMG',
    ['WEAPON_SMG'] = 'SMG',
    ['WEAPON_ASSAULTSMG'] = 'Szturmowe SMG',
    ['WEAPON_MILITARYRIFLE'] = 'Karabin Militarny',
    ['WEAPON_ASSAULTRIFLE'] = 'AK-47',
    ['WEAPON_CARBINERIFLE'] = 'm4',
    ['WEAPON_ADVANCEDRIFLE'] = 'Zaawansowany karabin',
    ['WEAPON_MG'] = 'Karabin maszynowy',
    ['WEAPON_COMBATMG'] = 'Bojowy karabin maszynowy',
    ['WEAPON_PUMPSHOTGUN'] = 'strzelba pompowa',
    ['WEAPON_SAWNOFFSHOTGUN'] = 'obrzym',
    ['WEAPON_ASSAULTSHOTGUN'] = 'strzelba szturmowa',
    ['WEAPON_BULLPUPSHOTGUN'] = 'Strzelba bezkolbowa',
    ['WEAPON_STUNGUN'] = 'Paralizator',
    ['WEAPON_SNIPERRIFLE'] = 'Karabin Snajperski',
    ['WEAPON_HEAVYSNIPER'] = 'Ciężki karabin snajperski',
    ['WEAPON_HEAVYSNIPER_MK2'] = 'Ciężki karabin snajperski v2',
    ['WEAPON_HEAVYRIFLE'] = 'Ciężki Karabin Szturmowy',
    ['WEAPON_REMOTESNIPER'] = 'Remote Sniper',
    ['WEAPON_GRENADELAUNCHER'] = 'Granatnik',
    ['WEAPON_GRENADELAUNCHER_SMOKE'] = 'Granatnik',
    ['WEAPON_RPG'] = 'RPG',
    ['WEAPON_PASSENGER_ROCKET'] = 'Passenger Rocket',
    ['WEAPON_AIRSTRIKE_ROCKET'] = 'Nalot rakietowy',
    ['WEAPON_STINGER'] = 'Stinger [Vehicle]',
    ['WEAPON_MINIGUN'] = 'Minigun',
    ['WEAPON_GRENADE'] = 'Granat',
    ['WEAPON_STICKYBOMB'] = 'Bomba przylepna',
    ['WEAPON_SMOKEGRENADE'] = 'Gaz lzawiacy',
    ['WEAPON_BZGAS'] = 'Gaz bojowy',
    ['WEAPON_MOLOTOV'] = 'Molotov',
    ['WEAPON_FIREEXTINGUISHER'] = 'Gasnica',
    ['WEAPON_PETROLCAN'] = 'Jerry Can',
    ['OBJECT'] = 'Obiekt',
    ['WEAPON_BALL'] = 'Pilka',
    ['WEAPON_FLARE'] = 'Flara',
    ['VEHICLE_WEAPON_TANK'] = 'Czolg',
    ['VEHICLE_WEAPON_SPACE_ROCKET'] = 'Rakieta Kosmiczna',
    ['VEHICLE_WEAPON_PLAYER_LASER'] = 'Laser',
    ['AMMO_RPG'] = 'Rakieta',
    ['AMMO_TANK'] = 'Czolg',
    ['AMMO_SPACE_ROCKET'] = 'Rakieta Kosmiczna',
    ['AMMO_PLAYER_LASER'] = 'Laser',
    ['AMMO_ENEMY_LASER'] = 'Laser',
    ['WEAPON_RAMMED_BY_CAR'] = 'Staranowany przez samochód',
    ['WEAPON_BOTTLE'] = 'Butelka',
    ['WEAPON_GUSENBERG'] = 'Gusenberg',
    ['WEAPON_SNSPISTOL'] = 'Pukawka',
    ['WEAPON_SNSPISTOL_MK2'] = 'Pukawka MK2',
    ['WEAPON_CERAMICPISTOL'] = 'Pistolet Ceramiczny',
    ['WEAPON_BERETTA'] = 'Pistolet Vintage',
    ['WEAPON_GLOCK20'] = 'Pistolet Glock 20',
    ['WEAPON_M9'] = 'Pistolet M9',
    ['WEAPON_POLICESW'] = 'Pistolet Provint',
    ['WEAPON_VINTAGEPISTOL'] = 'Pistolet Vintage',
    ['WEAPON_DAGGER'] = 'Zabytkowy sztylet',
    ['WEAPON_FLAREGUN'] = 'Pistolet sygnałowy',
    ['WEAPON_HEAVYPISTOL'] = 'Ciezki pistolet',
    ['WEAPON_SPECIALCARBINE'] = 'Karabinek specjalny',
    ['WEAPON_MUSKET'] = 'Muszkiet',
    ['WEAPON_FIREWORK'] = 'Wyrzutnia fajerwerkow',
    ['WEAPON_MARKSMANRIFLE'] = 'Karabin wyborowy',
    ['WEAPON_HEAVYSHOTGUN'] = 'Ciezka strzelba',
    ['WEAPON_PROXMINE'] = 'Mina zbliżeniowa',
    ['WEAPON_HOMINGLAUNCHER'] = 'Wyrzutnia namierzająca',
    ['WEAPON_HATCHET'] = 'Topor',
    ['WEAPON_COMBATPDW'] = 'PDW',
    ['WEAPON_KNUCKLE'] = 'Kastety',
    ['WEAPON_MARKSMANPISTOL'] = 'Pistolet wyborowy',
    ['WEAPON_MACHETE'] = 'Maczeta',
    ['WEAPON_MACHINEPISTOL'] = 'Pistolet maszynowy',
    ['WEAPON_FLASHLIGHT'] = 'Latarka',
    ['WEAPON_DBSHOTGUN'] = 'Dwururka',
    ['WEAPON_COMPACTRIFLE'] = 'Karabin kompaktowy',
    ['WEAPON_SWITCHBLADE'] = 'Noz sprezynowy',
    ['WEAPON_REVOLVER'] = 'Ciężki rewolwer',
    ['WEAPON_FIRE'] = 'Ogien',
    ['WEAPON_HELI_CRASH'] = 'Helikopter',
    ['WEAPON_RUN_OVER_BY_CAR'] = 'Przejechany przez samochod',
    ['WEAPON_HIT_BY_WATER_CANNON'] = 'Trafiony armatka wodna',
    ['WEAPON_EXHAUSTION'] = 'wyczerpanie',
    ['WEAPON_EXPLOSION'] = 'wybuch',
    ['WEAPON_ELECTRIC_FENCE'] = 'Elektryczne ogrodzenie',
    ['WEAPON_BLEEDING'] = 'wykrwawienie',
    ['WEAPON_DROWNING_IN_VEHICLE'] = 'Utoniecie w pojezdzie',
    ['WEAPON_DROWNING'] = 'Utoniecie',
    ['WEAPON_BARBED_WIRE'] = 'Drut kolczasty',
    ['WEAPON_VEHICLE_ROCKET'] = 'Rakieta z samochodu',
    ['WEAPON_BULLPUPRIFLE'] = 'Karabin bezkolbowy',
    ['WEAPON_ASSAULTSNIPER'] = 'Assault Sniper',
    ['VEHICLE_WEAPON_ROTORS'] = 'Rotors',
    ['WEAPON_RAILGUN'] = 'Railgun',
    ['WEAPON_AIR_DEFENCE_GUN'] = 'Air Defence Gun',
    ['WEAPON_AUTOSHOTGUN'] = 'Strzelba automatyczna',
    ['WEAPON_BATTLEAXE'] = 'topor',
    ['WEAPON_COMPACTLAUNCHER'] = 'Granatnik kompaktowy',
    ['WEAPON_MINISMG'] = 'Mini SMG',
    ['WEAPON_PIPEBOMB'] = 'Rurobomba',
    ['WEAPON_POOLCUE'] = 'Kij bilardowy',
    ['WEAPON_WRENCH'] = 'Klucz francuski',
    ['WEAPON_SNOWBALL'] = 'Sniezka',
    ['WEAPON_ANIMAL'] = 'Zwierze',
    ['WEAPON_COUGAR'] = 'Puma'
}

local WeaponHashes = {}
for weaponName, label in pairs(WeaponNames) do
    WeaponHashes[GetHashKey(weaponName)] = label
end

function GetWeaponLabel(hash)
    if WeaponHashes[hash] then
        return WeaponHashes[hash]
    else
        return 'Nieznana broń'
    end
end

local angleY, angleZ = 0.0, 0.0
local function StartDeathCam()
    if cam then return end
    ClearFocus()
    local playerPed = PlayerPedId()
    angleY, angleZ = 0.0, 0.0
    cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    local coords = GetEntityCoords(playerPed)
    SetCamCoord(cam, coords.x, coords.y, coords.z + 2.0)
    SetCamRot(cam, -30.0, 0.0, GetEntityHeading(playerPed), 2)
    SetCamActive(cam, true)
    RenderScriptCams(true, true, 1000, true, false)
end
local function EndDeathCam()
    if not cam then return end
    ClearFocus()
    RenderScriptCams(false, false, 0, true, false)
    DestroyCam(cam, false)
    cam = nil
end
local function ProcessCamControls()
    if not cam or not isDead then return end
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    DisableFirstPersonCamThisFrame()
    local newPos = ProcessNewPosition()
    SetFocusArea(newPos.x, newPos.y, newPos.z, 0.0, 0.0, 0.0)
    SetCamCoord(cam, newPos.x, newPos.y, newPos.z)
    PointCamAtCoord(cam, playerCoords.x, playerCoords.y, playerCoords.z + 0.5)
end
function ProcessNewPosition()
    local mouseX = GetDisabledControlNormal(1, 1) * 8.0
    local mouseY = GetDisabledControlNormal(1, 2) * 8.0
    angleZ = angleZ - mouseX
    angleY = math.max(-50.0, math.min(50.0, angleY + mouseY))
    local pCoords = GetEntityCoords(PlayerPedId())
    local radius = 3.0
    local offset = vector3(
        pCoords.x + radius * math.sin(math.rad(angleZ)) * math.cos(math.rad(angleY)),
        pCoords.y - radius * math.cos(math.rad(angleZ)) * math.cos(math.rad(angleY)),
        pCoords.z + radius * math.sin(math.rad(angleY)) + 1.0
    )
    return offset
end

function OpenRespawnMenu()
    if respawnMenuOpen then return end
    respawnMenuOpen = true

    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local temp = {}

    for i, v in ipairs(Config['respawns'].select) do
        local dist = #(playerCoords - vector3(v.crds.x, v.crds.y, v.crds.z))
        table.insert(temp, {
            name = v.name,
            coords = v.crds,
            dist = dist
        })
    end

    table.sort(temp, function(a, b) return a.dist < b.dist end)

    local elements = {}
    for _, v in ipairs(temp) do
        local distTxt = v.dist >= 1000 and string.format("%.1fkm", v.dist / 1000) or string.format("%dm", math.floor(v.dist))
        table.insert(elements, {
            label = string.format("%s - <span style='color:gray;'>(%s)</span>", v.name, distTxt),
            value = v.coords
        })
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'respawn_select', {
        title    = "Wybierz miejsce odrodzenia",
        align    = 'center',
        elements = elements
    }, function(data, menu)
        local coords = data.current.value
        menu.close()
        respawnMenuOpen = false
        RespawnPlayer(coords)
    end, function(data, menu)
        menu.close()
        respawnMenuOpen = false
    end)
end

function RespawnPlayer(coords)
    local playerPed = PlayerPedId()

    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do Wait(50) end

    exports['skam-ui']:hideDeathscreen()

    SetEntityCoordsNoOffset(playerPed, coords.x, coords.y, coords.z, false, false, false, true)
    NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, coords.w or 0.0, true, false)
    SetPlayerInvincible(playerPed, false)
    ClearPedTasksImmediately(playerPed)
    ClearPedBloodDamage(playerPed)
    SetEntityHealth(playerPed, 200)

    LocalPlayer.state:set('dead', false, true)
    ESX.UI.Menu.CloseAll()

    if ESX and ESX.PlayerData then
        ESX.PlayerData.dead = false
    end

    EndDeathCam()
    isDead, canRespawn = false, false
    TriggerEvent('esx_policejob:unrestrain')

    DoScreenFadeIn(500)
end

SKAM.addKeybind({
    key = "E",
    description = "Otwórz menu respawnu",
    onPressed = function()
        if isDead and canRespawn and not respawnMenuOpen then
            OpenRespawnMenu()
        end
    end
})

-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(0)
--         if isDead and canRespawn and not respawnMenuOpen and IsControlJustPressed(0, 38) then -- 38 = E
--             OpenRespawnMenu()
--         end
--     end
-- end)

CreateThread(function()
    while true do
        local sleep = 1500
        local player = PlayerId()
        if NetworkIsPlayerActive(player) then
            local playerPed = PlayerPedId()
            local dead = IsPedFatallyInjured(playerPed)
            if dead and not isDead then
                sleep, isDead, canRespawn = 0, true, false

                StartDeathCam()
                ShakeGameplayCam('DEATH_FAIL_IN_EFFECT_SHAKE', 2.0)

                if IsPedInAnyVehicle(playerPed, false) then
                    local vehicle = GetVehiclePedIsIn(playerPed, false)
                    if GetPedInVehicleSeat(vehicle, -1) == playerPed then
                        SetVehicleEngineOn(vehicle, false, true, true)
                    end
                end

                Citizen.CreateThread(function()
                    RequestAnimDict('dead')
                    while not HasAnimDictLoaded('dead') do
                        Citizen.Wait(0)
                    end

                    LocalPlayer.state:set('dead', true, true)

                    if IsPedInAnyVehicle(playerPed, false) then
                        while IsPedInAnyVehicle(playerPed, true) do
                            Citizen.Wait(0)
                        end
                    else
                        if GetEntitySpeed(playerPed) > 0.2 then
                            while GetEntitySpeed(playerPed) > 0.2 do
                                Citizen.Wait(0)
                            end
                        end
                    end

                    NetworkResurrectLocalPlayer(GetEntityCoords(playerPed), 0.0, false, false)
                    SetPlayerInvincible(PlayerId(), true)
                    SetPlayerCanUseCover(PlayerId(), false)

                    while LocalPlayer.state.dead do
                        if not IsPedInAnyVehicle(playerPed, false) then
                            if not IsEntityPlayingAnim(playerPed, 'dead', 'dead_a', 3) then
                                -- SetPedCanRagdoll(playerPed, false)
                                TaskPlayAnim(playerPed, 'dead', 'dead_a', 1.0, 1.0, -1, 2, 0, 0, 0, 0)
                            end
                        end
                        Citizen.Wait(0)
                    end
                    
                     -- SetPedCanRagdoll(playerPed, true)
                    SetPlayerInvincible(PlayerId(), false)
                    SetPlayerCanUseCover(PlayerId(), true)
                    StopAnimTask(PlayerPedId(), 'dead', 'dead_a', 4.0)
                    RemoveAnimDict('dead')
                end)

                local deathCause = GetPedCauseOfDeath(playerPed)
                local killerEntity = GetPedSourceOfDeath(playerPed)
                local killerClientId = NetworkGetPlayerIndexFromPed(killerEntity)
                local killedByPlayer = false
                local killerId, killerCoords, distance, killerServerId, killerName, killerWeapon = nil, nil, nil, nil, nil, nil
                local victimId = GetPlayerServerId(player)
                local victimName = GetPlayerName(player)
                local victimCoords = GetEntityCoords(playerPed)
                if killerEntity ~= playerPed and killerClientId and NetworkIsPlayerActive(killerClientId) then
                    killedByPlayer = true
                    killerId = killerClientId
                    killerServerId = GetPlayerServerId(killerClientId)
                    killerName = GetPlayerName(killerClientId)
                    killerCoords = GetEntityCoords(GetPlayerPed(killerClientId))
                    distance = #(victimCoords - killerCoords)
                    killerWeapon = GetSelectedPedWeapon(GetPlayerPed(killerClientId))
                end
                if not killerName and killerEntity > 0 and IsEntityAPed(killerEntity) then
                    killerName = 'NPC'
                end
                if not killerWeapon then killerWeapon = deathCause end
                local data = {
                    playername = victimName,
                    victimid = victimId,
                    victimCoords = string.format('%.2f, %.2f, %.2f', victimCoords.x, victimCoords.y, victimCoords.z) or nil,
                    killername = killerName,
                    killerid = killerServerId,
                    killerweapon = GetWeaponLabel(killerWeapon),
                    distance = distance,
                    killedByPlayer = killedByPlayer,
                    weaponLabel = GetWeaponLabel(deathCause),
                    killerCoords = killerCoords and string.format('%.2f, %.2f, %.2f', killerCoords.x, killerCoords.y, killerCoords.z) or nil,
                }

                TriggerEvent('skam$death', data)
                TriggerServerEvent('skam$death', data)
                local formatDistance = distance and string.format('%.1f', distance) or nil
                print(string.format(
                    '[SKAM.CLUB] ^2%s^7 (ID: %s) ZABITY PRZEZ: ^1%s^7 (ID: %s) BROŃ: ^1%s^7, ^1%s^7 METRÓW.',
                    victimName, victimId, killerName or 'BRAK', killerServerId or 'BRAK', GetWeaponLabel(killerWeapon), formatDistance or 'BRAK'
                ))
                canRespawn = false
                exports['skam-ui']:showDeathscreen(30, killerName, GetWeaponLabel(deathCause), formatDistance)
                
                Citizen.CreateThread(function()
                    Wait(30000)
                    canRespawn = true
                end)
            end
            if isDead then
                sleep = 0
                DisableAllControlActions(0)
                EnableControlAction(0, 47, true)   -- G 
                EnableControlAction(0, 245, true)  -- T
                EnableControlAction(0, 38, true)   -- E
                EnableControlAction(0, 249, true)  -- VOICE
                EnableControlAction(0, 322, true)  -- ESC/menu
                ProcessCamControls()
            end
        end
        Wait(sleep)
    end
end)

AddEventHandler('skam:onPlayerSpawn', function()
    isDead = false
    canRespawn = false
    ClearTimecycleModifier()
    SetPedMotionBlur(PlayerPedId(), false)
    ClearExtraTimecycleModifier()
    EndDeathCam()
    if firstSpawn then
        firstSpawn = false
    end
end)

RegisterNetEvent('skam$death:revive')
AddEventHandler('skam$death:revive', function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local heading = GetEntityHeading(playerPed)

    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do Wait(50) end

    exports['skam-ui']:hideDeathscreen()

    SetEntityCoordsNoOffset(playerPed, coords.x, coords.y, coords.z, false, false, false, true)
    NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
    SetPlayerInvincible(playerPed, false)
    ClearPedTasksImmediately(playerPed)
    ClearPedBloodDamage(playerPed)
    SetEntityHealth(playerPed, 200)

    LocalPlayer.state:set('dead', false, true)
    ESX.UI.Menu.CloseAll()

    if ESX and ESX.PlayerData then
        ESX.PlayerData.dead = false
    end

    EndDeathCam()
    isDead, canRespawn = false, false
    TriggerEvent('esx_policejob:unrestrain')

    DoScreenFadeIn(500)
end)

RegisterNetEvent('skam$death:heal')
AddEventHandler('skam$death:heal', function()
    local playerPed = PlayerPedId()
    SetEntityHealth(playerPed, 200)
    ClearPedBloodDamage(playerPed)
    ESX.ShowNotification('Zostałeś uleczony!', 'info')
end)