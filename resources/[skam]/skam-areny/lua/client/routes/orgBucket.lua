local functions = {}
local route = 'orgBucket/'
local eventRoute = GetCurrentResourceName() .. ':' .. route

functions.antiVdmThread = function()
    Wait(1000)
    while cache.player.inOrgBucket do
        local vehPool = GetGamePool('CVehicle')
        for k,vehicle in pairs(vehPool) do
            SetEntityNoCollisionEntity(vehicle, cache.player.ped, true)
            SetEntityNoCollisionEntity(cache.player.ped, vehicle, true)
        end
        Wait(1)
    end
end

functions.beginInOrgBucketLoop = function()
    if string.find(ESX.GetPlayerData().job.name, "org") then
        debug.print('orgBucket', 'starting inOrgBucket loop')
        Wait(1000)
        while cache.player.inOrgBucket do
            if not (cache.player.inSearchingSlotBucket) and not (cache.player.inBattle) then
                if not (cache.player.customOrgBucket) then
                    exports['skam-ui']:helpNotify({ title = 'Hostowane', desc = 'Aby rozpocząć hostowaną Bitkę, kliknij ~F4~ lub wpisz komendę /hosted'})
                end
                DisablePlayerFiring(cache.player.clientId, true)
            end
            Wait(1)
        end
    end
end

local red = 0
CreateThread(function()
    while true do
        for i = 0, 255, 5 do
            red = i
            Wait(0)
        end
        Wait(600)
        for i = 0, 239, 5 do
            red = 255 - i
            Wait(0)
        end
        Wait(1000)
    end
end)

functions.beginBucketDrawing = function()
    if string.find(ESX.GetPlayerData().job.name, "org") then
        local orgBucket = config.orgBucket
        debug.print('orgBucket', 'starting drawing process')

        while true do
            DrawSphere(orgBucket.coords.x, orgBucket.coords.y, orgBucket.coords.z, orgBucket.radius, red, 0, 0, 0.4)
            if not (cache.player.canSeeBucket) then
                debug.print('orgBucket', 'breaking because cant see bucket.')
                break
            end
            Wait(1)
        end
    end
end

local kickTimeoutId = 0

functions.bucketEnterred = function()
    if string.find(ESX.GetPlayerData().job.name, "org") then
        TriggerEvent('enterredBucketHandler')
        debug.print('orgBucket', 'enterred bucket')
        TriggerServerEvent(eventRoute .. 'bucketEnterred')
        CreateThread(functions.beginInOrgBucketLoop)
        CreateThread(functions.antiVdmThread)
        if (cache.player.customOrgBucket and kickTimeoutId ~= 0) then
            ESX.ClearTimeout(kickTimeoutId)
        end
    end
end

functions.bucketSeen = function()
    if string.find(ESX.GetPlayerData().job.name, "org") then
        cache.player.updateState('canSeeBucket', true, false)
        CreateThread(functions.beginBucketDrawing)
        debug.print('orgBucket', 'can see bucket')
    end
end

functions.bucketExitted = function()
    ESX.UI.Menu.CloseAll()
    TriggerServerEvent(eventRoute .. 'bucketExitted')
    TriggerEvent('leavedBucketHandler')
    exports['skam-ui']:hideHelpNotify()
    if (cache.player.customOrgBucket) then
        kickTimeoutId = ESX.SetTimeout(config.orgBucket.kickAfterExit, function()
            TriggerServerEvent('zykem_battles:getKicked')
        end)
    end
end

functions.bucketUnseen = function()
    cache.player.updateState('canSeeBucket', false, false)
end

RegisterNetEvent('zykem_battles:bucketEnterred', functions.bucketEnterred)
RegisterNetEvent('zykem_battles:bucketSeen', functions.bucketSeen)
RegisterNetEvent('zykem_battles:bucketExitted', functions.bucketExitted)
RegisterNetEvent('zykem_battles:bucketUnseen', functions.bucketUnseen)