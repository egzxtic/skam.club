for drugType, drugData in pairs(Config['narko']) do
    for stage, info in pairs(drugData) do
        if info.coords and info.sprite and info.color then
            local blip = AddBlipForCoord(info.coords.x, info.coords.y, info.coords.z)
            SetBlipSprite(blip, info.sprite)
            SetBlipColour(blip, info.color)
            SetBlipScale(blip, 0.8)
            SetBlipAlpha(blip, 255)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString('NARKO: ' .. (info.name or drugType))
            EndTextCommandSetBlipName(blip)
        end
    end

    local rawInProgress = false
    SKAM.RegisterPlace({
        coords = drugData.zbierz.coords,
        Marker = {size = vector3(5.0,5.0,0.3)},
        txt3d = ('zebrać: %s'):format(drugData.zbierz.name),
        onPress = function()
            ESX.TriggerServerCallback('skam$cpun:check', function(result, reason)
                if result then
                    rawInProgress = true
                    exports['skam-ui']:showProgress('Zbieranie...', 60 * 1000, function(success)
                        if success then
                            TriggerServerEvent('skam$cpun:raw', drugType)
                        else
                            ESX.ShowNotification('Zbieranie przerwane!')
                        end
                    end)
                else
                    ESX.ShowNotification(reason or 'Nie możesz teraz zbierać!')
                end
            end, drugType, "raw")
        end,
        onExit = function()
            if rawInProgress then
                exports['skam-ui']:hideProgress()
            end
            rawInProgress = false
        end
    })

    local processInProgress = false
    SKAM.RegisterPlace({
        coords = drugData.przerob.coords,
        Marker = {size = vector3(5.0,5.0,0.3)},
        txt3d = ('przerobić: %s'):format(drugData.przerob.name),
        onPress = function()
            ESX.TriggerServerCallback('skam$cpun:check', function(result, reason)
                if result then
                    processInProgress = true
                    exports['skam-ui']:showProgress('Przerabianie...', 120 * 1000, function(success)
                        if success then
                            TriggerServerEvent('skam$cpun:process', drugType)
                        else
                            ESX.ShowNotification('Przerabianie przerwane!')
                        end
                    end)
                else
                    ESX.ShowNotification(reason or 'Nie możesz teraz przerabiać!')
                end
            end, drugType, "process")
        end,
        onExit = function()
            if processInProgress then
                exports['skam-ui']:hideProgress()
            end
            processInProgress = false
        end
    })
end