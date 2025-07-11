-- local playerOptimize = {}

-- ESX.RegisterCommand('opti', 'user', function(xPlayer, args, showError)
--     local src = xPlayer.source
--     playerOptimize[src] = not playerOptimize[src]

--     xPlayer.showNotification('Optymalizacja: ' .. (playerOptimize[src] and '~g~Włączona' or '~r~Wyłączona'))
--     xPlayer.triggerEvent('skam:optimize', playerOptimize[src])

--     local radius = playerOptimize[src] and 10.0 or 0.0
--     SetPlayerCullingRadius(src, radius)
-- end, false)

-- AddEventHandler('playerDropped', function(reason)
--     local src = source
--     if playerOptimize[src] ~= nil then
--         playerOptimize[src] = nil
--     end
-- end)