RegisterNetEvent('skam:amulet', function()
    exports['skam-ui']:showProgress('Zakładasz Amulet', 3000, function(isFinished)
        if isFinished then
            SetRunSprintMultiplierForPlayer(PlayerId(), 1.50)
            Wait(120*60*1000)
            SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
        end
    end)
end)