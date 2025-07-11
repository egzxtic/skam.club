RegisterNetEvent('esx_weaponsync:removeAmmo', function(item, count)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if count < 0 then
        exports['okokok']:fg_BanPlayer(_source, 'dostajesz bana z kodem rabatowym s7 drzemka', true)

        return
    end
    if xPlayer then
        xPlayer.removeInventoryItem(item, count, false, false, true)
    end
end)

ESX.RegisterUsableItem('pistol_ammo_box', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('pistol_ammo_box', 1)
	xPlayer.addInventoryItem('pistol_ammo', 24)
end)

ESX.RegisterUsableItem('smg_ammo_box', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('smg_ammo_box', 1)
	xPlayer.addInventoryItem('smg_ammo', 30)
end)

ESX.RegisterUsableItem('rifle_ammo_box', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('rifle_ammo_box', 1)
	xPlayer.addInventoryItem('rifle_ammo', 30)
end)

ESX.RegisterUsableItem('shotgun_ammo_box', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('shotgun_ammo_box', 1)
	xPlayer.addInventoryItem('shotgun_ammo', 16)
end)