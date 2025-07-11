local drawBlip = function(zone)
    if zone.blip.addBlip then
        local blip = AddBlipForCoord(zone.crds.x, zone.crds.y, zone.crds.z)
        SetBlipSprite(blip, zone.blip.sprite)
        SetBlipColour(blip, zone.blip.color)
        SetBlipScale(blip, (zone.blip.scale or 0.8))
        SetBlipAlpha(blip, 255)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(zone.blip.name)
        EndTextCommandSetBlipName(blip)
    end
    
    if zone.blip.addRadius then
        local blipRadius = AddBlipForRadius(zone.crds.x, zone.crds.y, zone.crds.z, zone.radius)
        SetBlipColour(blipRadius, zone.blip.color)
        SetBlipAlpha(blipRadius, 100)
    end
end

enterZone = function()
    TriggerEvent('skam:showNotification', {
        variant = 'success',
        title = 'Greenzone',
        description = 'Wszedłeś do greenzone!'
    })
    --TriggerServerEvent('skam$changeBucket', 777)
    SetLocalPlayerAsGhost(true)
end

leftZone = function()
    TriggerEvent('skam:showNotification', {
        variant = 'error',
        title = 'Greenzone',
        description = 'Wyszedłeś z greenzone!'
    })
    --TriggerServerEvent('skam$changeBucket', 0)
    exports['skam-ui']:showProgress('Ochrona', 3000, function(isFinished)
        if isFinished then
            SetLocalPlayerAsGhost(false)
        end
    end)
end

local inGZ = false

CreateThread(function()
    while true do
        local inBckt = false
        local dist = GetEntityCoords(PlayerPedId())

        for _, z in pairs(Config['greenzone']) do
            if #(dist - z.crds) <= z.radius then
                inBckt = true
                break
            end
        end

        if inBckt and not inGZ then
            enterZone()
            inGZ = true
        end

        local canLeave = true

        if not inBckt and inGZ then
            leftZone()
            inGZ = false
        end

        Wait(200)
    end
end)

exports('inGreenzone', function()
    return inGZ
end)

-- RegisterCommand('bucket', function()
--     local buckets = {
--         { label = 'Bucket 1', value = 777 },
--         { label = 'Bucket 2', value = 112 },
--         { label = 'Bucket 3', value = 997 },
--     }

--     local elements = {}
--     for _, b in ipairs(buckets) do
--         table.insert(elements, {
--             label = b.label,
--             value = b.value
--         })
--     end

--     ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'bucket_menu', {
--         title    = 'Wybierz bucket',
--         align    = 'top-left',
--         elements = elements
--     }, function(data, menu)
--         local selected = data.current.value
--         menu.close()
--         TriggerServerEvent('skam$changeBucket', selected)
--     end, function(data, menu)
--         menu.close()
--     end)
-- end)

CreateThread(function()
    for _, zone in pairs(Config['greenzone']) do
        drawBlip(zone)
    end

    while true do
        local waitTime = 200

        for _, zone in pairs(Config['greenzone']) do
            local dist = #(GetEntityCoords(PlayerPedId()) - zone.crds)
            
            if dist <= zone.radius + 50 then
                DrawSphere(zone.crds.x, zone.crds.y, zone.crds.z, zone.radius, zone.color.r, zone.color.g, zone.color.b, zone.color.a)
                waitTime = 0
            elseif dist <= zone.radius + 100 then
                waitTime = math.min(waitTime, 500)
            end
        end

        Wait(waitTime)
    end
end)

RegisterCommand('tpmenu', function()
    if LocalPlayer.state.dead then
        ESX.ShowNotification('Nie możesz użyć tej komendy będąc martwym!')
        return
    end

    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local temp = {}

    for k,v in pairs(Config['respawns'].select) do
        local pointCoords = v.crds
        local dist = #(playerCoords - vector3(pointCoords.x, pointCoords.y, pointCoords.z))
        table.insert(temp, {
            name = v.name,
            coords = pointCoords,
            dist = dist,
            idx = k
        })
    end

    table.sort(temp, function(a, b) return a.dist < b.dist end)

    local elements = {}
    for _,v in ipairs(temp) do
        local distTxt = v.dist >= 1000 and string.format("%.1fkm", v.dist / 1000) or string.format("%dm", math.floor(v.dist))
        table.insert(elements, {label = ("%s - <span style='color:gray;'>(%s)</span>"):format(v.name, distTxt), value = v.idx})
    end

    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'tp_menu', {
        title    = 'Wybierz miejsce teleportacji',
        align    = 'center',
        elements = elements
    }, function(data, menu)
        local idx = data.current.value
        local coords = Config['respawns'].select[idx].crds
        local startPos = GetEntityCoords(playerPed)
        local wasCancelled = false

        Citizen.CreateThread(function()
            local timer = 0
            while timer < 3000 do
                Citizen.Wait(50)
                local currentPos = GetEntityCoords(playerPed)
                if #(currentPos - startPos) > 3.0 then
                    wasCancelled = true
                    exports['skam-ui']:hideProgress()
                    ESX.ShowNotification('Teleportacja anulowana przez ruch!')
                    break
                end
                timer = timer + 50
            end
        end)

        DoScreenFadeOut(10*1000)
        exports['skam-ui']:showProgress('Teleportowanie..', 10*1000, function(done)
            if wasCancelled then
                DoScreenFadeIn(500)
                return
            end

            if done then
                SetEntityCoords(playerPed, coords.x, coords.y, coords.z)
                SetEntityHeading(playerPed, coords.w)
                DoScreenFadeIn(500)
            else
                exports['skam-ui']:hideProgress()
                ESX.ShowNotification('Teleportacja anulowana!')
            end
        end)
        menu.close()
    end, function(data, menu)
        menu.close()
    end)
end)