cache.player = {}
local functions = {}
-- var to check if the handler is already running
local handlerRunning = false
-- var to stop the handler from running (org->unemployed job update)
local forceHandlerStop = false

cache.player.updateState = function(key, val, bag)
    if (bag) then
        LocalPlayer.state:set(key, val, true)
    end
    cache.player[key] = val
end

startPlayerStateHandler = function(skipWait, justJoined)
    if handlerRunning then
        return
    end

    if (justJoined) then
        Wait(8000)
    end

    if not (skipWait) then
        Wait(3000)
    end
    Wait(2000)
    --FreezeEntityPosition(PlayerPedId(), false)
    local customOrgBucket = false
    if (cache.player.customOrgBucket == nil) then
        if not (checkJob()) then
            return
        end
    else
        customOrgBucket = true
    end

    if (ESX.IsPlayerLoaded()) then
        cache.player.loaded = true
    end

    repeat Wait(1)
    until cache.player.loaded

    forceHandlerStop = false
    handlerRunning = true
    cache.player.ped = PlayerPedId()
    cache.player.clientId = PlayerId()
    cache.player.inOrgBucket = false
    cache.player.canSeeBucket = false
    local orgBucketConfig = config.orgBucket
    local sleep = 500

    SetTimeout(5000, function()
        cache.player.coords = GetEntityCoords(cache.player.ped)
        local isPreInBucket = #(cache.player.coords - orgBucketConfig.coords)
        if (isPreInBucket <= orgBucketConfig.radius) then
            SetEntityCoords(PlayerPedId(), config.battleActions.gotKicked.teleportPos)
        end
    end)
    while true do
        cache.player.coords = GetEntityCoords(cache.player.ped)
        if (cache.player.ped ~= PlayerPedId()) then
            cache.player.ped = PlayerPedId()
        end

        if (forceHandlerStop) then
            handlerRunning = false
            forceHandlerStop = false
            cache.player.inOrgBucket = false
            break
        end

        if (LocalPlayer.state.inBattle) then
            cache.player.updateState('canSeeBucket', false, false)
            cache.player.inOrgBucket = false
            sleep = 500
        else

            sleep = 500
            -- orgBucket --
            local orgBucketDist = #(cache.player.coords - orgBucketConfig.coords)
            if (orgBucketDist < orgBucketConfig.drawDist) then
                if not (cache.player.canSeeBucket) and not (forceHandlerStop) then
                    TriggerEvent('zykem_battles:bucketSeen')
                end
                if (orgBucketDist <= orgBucketConfig.radius and not cache.player.inOrgBucket) then
                    if (IsPedInAnyVehicle(cache.player.ped, true)) then
                        if (isVehicleDriver(GetVehiclePedIsIn(cache.player.ped, false))) then
                            cache.player.inOrgBucket = true
                            TriggerEvent('zykem_battles:bucketEnterred')
                        end
                    else
                        cache.player.inOrgBucket = true
                        TriggerEvent('zykem_battles:bucketEnterred')
                    end
                elseif (orgBucketDist > orgBucketConfig.radius and cache.player.inOrgBucket) then
                    if (IsPedInAnyVehicle(cache.player.ped, true)) then
                        if (isVehicleDriver(GetVehiclePedIsIn(cache.player.ped, false))) then
                            TriggerEvent('zykem_battles:bucketExitted')
                            cache.player.inOrgBucket = false
                        end
                    else
                        TriggerEvent('zykem_battles:bucketExitted')
                        cache.player.inOrgBucket = false
                    end
                end
            else
                if (cache.player.canSeeBucket) then
                    TriggerEvent('zykem_battles:bucketUnseen')
                end
                if (cache.player.inOrgBucket) then
                    if (IsPedInAnyVehicle(cache.player.ped, true)) then
                        if (isVehicleDriver(GetVehiclePedIsIn(cache.player.ped, false))) then
                            TriggerEvent('zykem_battles:bucketExitted')
                            cache.player.inOrgBucket = false
                        end
                    else
                        TriggerEvent('zykem_battles:bucketExitted')
                        cache.player.inOrgBucket = false
                    end
                end
            end
        end
        Wait(sleep)
    end
end

functions.playerSpawned = function()
    cache.player.ped = PlayerPedId()
end

functions.playerLoaded = function()
    cache.player.loaded = true
end

-- RE-Initialize the player state handler
functions.jobUpdate = function(newjob)
    if (newjob.name ~= 'unemployed') then
        CreateThread(startPlayerStateHandler)
    else
            forceHandlerStop = true
            if (cache.player.canSeeBucket) then
                cache.player.canSeeBucket = false
            end
            if (LocalPlayer.state.inOrgBucket) then
                SetEntityCoords(cache.player.ped, 1017.42, -2364.06, 30.51)
            end
    end
end

CreateThread(function()
    startPlayerStateHandler(true, true)
end)
AddEventHandler('playerSpawned', functions.playerSpawned)
RegisterNetEvent('esx:playerLoaded', functions.playerLoaded)
RegisterNetEvent('esx:setjob', functions.jobUpdate)