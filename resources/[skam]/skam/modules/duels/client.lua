local isInKolejka = false
local isDuelInProgress = false
local enemyPlayer = nil
local isTeleporting = false
local teleportRetries = 0
local MAX_TELEPORT_RETRIES = 3

Citizen.CreateThread(function()
    SKAM.RegisterPlace({
		coords = vec3(1008.9351, -2531.2434, 27.3020),
		Marker = {size = vector3(5.0,5.0,0.3)},
		txt3d = "zawalczyć z randomem",
        pedModel = {
            model = "g_f_y_families_01",
            heading = 0.0,
            weapon = "WEAPON_CARBINERIFLE",
        },
		onPress = function()
            if not IsPedInAnyVehicle(PlayerPedId(), false) and not isDuelInProgress and not isTeleporting then
                TriggerServerEvent("skam-duel:join")
                isInKolejka = true
            end
		end,
		onExit = function()
			if isInKolejka then
                TriggerServerEvent("skam-duel:quit")
                isInKolejka = false
            end
		end,
	})
end)

function totadeveloperkaxd(player1Coords, player2Coords)
    Citizen.Wait(2000)
    DrawLine(player1Coords.x, player1Coords.y, player1Coords.z, player2Coords.x, player2Coords.y, player2Coords.z, 255, 0, 0, 255)
    Citizen.Wait(2000)
end

local function startujetenjebanycyrk(enemy)
    local enemyName = GetPlayerName(GetPlayerFromServerId(enemy))
    local enemyStr = ('%s'):format(enemyName or "Nieznany przeciwnik")

    FreezeEntityPosition(PlayerPedId(), true)

    for i = 5, 1, -1 do
        PlaySoundFrontend(-1, 'CONFIRM_BEEP', 'HUD_MINI_GAME_SOUNDSET')
        ESX.Scaleform.ShowFreemodeMessage(tostring(i), '', 0.5)
        Wait(500)
    end

    PlaySoundFrontend(-1, 'Beep_Green', 'DLC_HEIST_HACKING_SNAKE_SOUNDS')
    exports['skam-ui']:hideHelpNotify()
    ESX.Scaleform.ShowFreemodeMessage('~r~Duel rozpoczęty', '~s~Przeciwnik: ' .. enemyStr, 2.0)

    FreezeEntityPosition(PlayerPedId(), false)

    isDuelInProgress = true
    enemyPlayer = enemy
end

function VerifyTeleportation(targetCoords)
    local playerCoords = GetEntityCoords(PlayerPedId())
    local distance = #(playerCoords - targetCoords)
    
    if distance > 10.0 then
        teleportRetries = teleportRetries + 1
        
        if teleportRetries < MAX_TELEPORT_RETRIES then
            SetEntityCoords(PlayerPedId(), targetCoords.x, targetCoords.y, targetCoords.z, false, false, false, false)
            Citizen.SetTimeout(500, function() 
                VerifyTeleportation(targetCoords)
            end)
        else
            TriggerServerEvent('skam-duel:teleportVerify', false)
            teleportRetries = 0
            isTeleporting = false
        end
    else
        TriggerServerEvent('skam-duel:teleportVerify', true)
        teleportRetries = 0
        isTeleporting = false
    end
end

RegisterNetEvent('skam-duel:start')
AddEventHandler('skam-duel:start', function(coords, enemy)
    isTeleporting = true
    isInKolejka = false
    
    if IsEntityDead(PlayerPedId()) then
        TriggerEvent('skam$death:revive')
        Wait(500)
    end
    
    SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z, false, false, false, false)
    SetEntityHeading(PlayerPedId(), coords.w)
    
    Citizen.SetTimeout(1000, function()
        VerifyTeleportation(vector3(coords.x, coords.y, coords.z))
    end)
    
    totadeveloperkaxd(GetEntityCoords(PlayerPedId()), coords)
end)

RegisterNetEvent('skam-duel:startCountdown')
AddEventHandler('skam-duel:startCountdown', function(enemy)
    if isDuelInProgress then return end
    
    startujetenjebanycyrk(enemy)
    
    Citizen.CreateThread(checkIfPlayerLeftDuel)
end)

RegisterNetEvent('skam-duel:showDuelResult')
AddEventHandler('skam-duel:showDuelResult', function(isWinner)
    local title = isWinner and 'Wygrałeś!' or 'Przegrałeś!'
    local message = isWinner and 'Gratulacje, wygrałeś w pojedynku!' or 'Niestety, przegrałeś pojedynek.'
    local color = isWinner and '~g~' or '~r~'

    ESX.Scaleform.ShowFreemodeMessage(color .. title, message, 2.0)
    
    isDuelInProgress = false
    enemyPlayer = nil
end)

RegisterNetEvent('skam-duel:teleportPlayer')
AddEventHandler('skam-duel:teleportPlayer', function(coords)
    isTeleporting = true
    
    SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z, false, false, false, false)
    
    Citizen.SetTimeout(1000, function()
        VerifyTeleportation(vector3(coords.x, coords.y, coords.z))
    end)
    
    isDuelInProgress = false
    isInKolejka = false
end)

RegisterNetEvent('skam-duel:playerLeft')
AddEventHandler('skam-duel:playerLeft', function()
    if isDuelInProgress then
        isDuelInProgress = false
        enemyPlayer = nil
        ESX.Scaleform.ShowFreemodeMessage('~r~Pojedynek zakończony', 'Twój przeciwnik opuścił pojedynek.', 2.0)
    end
end)

local function checkIfPlayerLeftDuel()
    local checksFailed = 0
    
    while isDuelInProgress do
        Citizen.Wait(1000)
        
        if not enemyPlayer then
            isDuelInProgress = false
            break
        end
        
        local enemyId = GetPlayerFromServerId(enemyPlayer)
        if enemyId == -1 or not NetworkIsPlayerActive(enemyId) then
            checksFailed = checksFailed + 1
            
            if checksFailed >= 3 then
                TriggerServerEvent('skam-duel:playerLeftDuel', enemyPlayer)
                isDuelInProgress = false
                enemyPlayer = nil
                break
            end
        else
            checksFailed = 0
        end
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        
        if isDuelInProgress and enemyPlayer then
            local playerPed = PlayerPedId()
            local enemyServerId = enemyPlayer
            local enemyId = GetPlayerFromServerId(enemyServerId)
            
            if enemyId ~= -1 and NetworkIsPlayerActive(enemyId) then
                local enemyPed = GetPlayerPed(enemyId)
                
                if IsEntityDead(playerPed) then
                    TriggerServerEvent('skam-duel:win', enemyServerId, GetPlayerServerId(PlayerId()))
                    isDuelInProgress = false
                    enemyPlayer = nil
                    Citizen.SetTimeout(3000, function()
                        isTeleporting = false
                    end)
                    
                elseif DoesEntityExist(enemyPed) and IsEntityDead(enemyPed) then
                    TriggerServerEvent('skam-duel:win', GetPlayerServerId(PlayerId()), enemyServerId)
                    isDuelInProgress = false
                    enemyPlayer = nil
                    Citizen.SetTimeout(3000, function()
                        isTeleporting = false
                    end)
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if isInKolejka and IsEntityDead(PlayerPedId()) then
            TriggerServerEvent("skam-duel:quit")
            isInKolejka = false
            TriggerEvent('skam:showNotification', {
                title = 'Teparki',
                description = 'Opuszczono kolejkę z powodu śmierci.',
                variant = 'error'
            })
        end
    end
end)