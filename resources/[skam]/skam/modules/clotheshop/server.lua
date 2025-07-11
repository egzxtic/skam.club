ESX.RegisterServerCallback('skam-clotheshop:buyClothes', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getMoney() >= Config['clotheshop'].Price then
		xPlayer.removeMoney(Config['clotheshop'].Price, "Outfit Purchase")
		xPlayer.showNotification('Zapłacono '..Config['clotheshop'].Price..'$', 'info')
		cb(true)
	elseif xPlayer.getAccount('bank').money >= Config['clotheshop'].Price then
		xPlayer.removeAccountMoney('bank', Config['clotheshop'].Price)
		xPlayer.showNotification('Zapłacono '..Config['clotheshop'].Price..'$ (konto bankowe)', 'info')
		cb(true)
	else
		cb(false)
	end
end)