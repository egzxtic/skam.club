ESX.RegisterServerCallback('skam-sellvehicle:requestPlayerCars', function(source, cb, plate)

	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll(
		'SELECT * FROM owned_vehicles WHERE identifier = @identifier AND owner_type = 1',
		{
			['@identifier'] = xPlayer.identifier
		},
		function(result)

			local found = false

			for i=1, #result, 1 do

				local vehicleProps = json.decode(result[i].vehicle)

				if ESX.Math.Trim(vehicleProps.plate) == ESX.Math.Trim(plate) then
					found = true
					break
				end

			end

			if found then
				cb(true)
			else
				cb(false)
			end

		end
	)
end)

RegisterServerEvent('skam-sellvehicle:denysell')
AddEventHandler('skam-sellvehicle:denysell', function (seller)
	TriggerClientEvent('esx:showNotification', seller, '~r~Obywatel odrzucił twoją ofertę sprzedaży')
	TriggerClientEvent('esx:showNotification', source, '~r~Odrzuciłeś ofertę sprzedaży')
end)

RegisterServerEvent('skam-sellvehicle:acceptsell')
AddEventHandler('skam-sellvehicle:acceptsell', function(playerId, vehicleProps, price)
	newsource = source
	local xPlayer = ESX.GetPlayerFromId(newsource)
	local xPlayerplayerId = ESX.GetPlayerFromId(playerId)
	local account = xPlayer.getAccount('bank')

	if account.money >= price then
		MySQL.Async.execute('UPDATE owned_vehicles SET identifier = @identifier WHERE plate = @plate AND owner_type = 1',
		{
			['@identifier']   = xPlayer.identifier,
			['@plate']   = vehicleProps.plate
		},
		function(rowsChanged)
			MySQL.Async.fetchAll('SELECT id FROM owned_vehicles WHERE plate = @plate AND owner_type = 0', {['@plate'] = vehicleProps.plate}, function(result)
				for k,v in ipairs(result) do
					MySQL.Sync.execute('DELETE FROM owned_vehicles WHERE id = @id', {['@id'] = v.id})
				end
			end)
			TriggerClientEvent('esx:showNotification', playerId, '~g~Gratulacje, sprzedałeś pojazd')
			TriggerClientEvent('skam-sellvehicle:finish', playerId, newsource)
			TriggerClientEvent('esx:showNotification', newsource, '~g~Gratulacje, kupiłeś ten pojazd')
			xPlayerplayerId.addAccountMoney('bank', price)
			xPlayer.removeAccountMoney('bank', price)
			--SendLog('Sprzedany pojazd', 'ID: '.. xPlayerplayerId.source ..'\nNick: ' .. xPlayerplayerId.name .. '\nLicencja: ' .. xPlayerplayerId.identifier .. '\n**Sprzedał pojazd dla**\nID: '.. xPlayer.source ..'\nNick: ' .. xPlayer.name .. '\nLicencja: ' .. xPlayer.identifier..'\nza kwotę: '..price..'$\nRejestracja: '..vehicleProps.plate)
		end)
	else
		TriggerClientEvent('esx:showNotification', newsource, '~r~Nie masz wystarczająco pieniędzy aby zakupić ten pojazd!')
		TriggerClientEvent('esx:showNotification', playerId, '~r~Obywatel nie miał wystarczająco pieniędzy aby zakupić twój pojazd!')
	end
end)

RegisterServerEvent('skam-sellvehicle:requestserver')
AddEventHandler('skam-sellvehicle:requestserver', function (playerId, vehicleProps, money)
	local _source = source
	TriggerClientEvent('skam-sellvehicle:requestclient', playerId, vehicleProps, money, _source)
	TriggerClientEvent('esx:showNotification', _source, '~g~Wysłano ofertę sprzedaży pojazdu')
end)

RegisterServerEvent('skam-sellvehicle:menuinput')
AddEventHandler('skam-sellvehicle:menuinput', function (price)
	TriggerClientEvent('skam-sellvehicle:begin', source, price)
end)

ESX.RegisterCommand('sprzedajpojazd', 'user', function(xPlayer, args, showError)
	xPlayer.triggerEvent('skam-sellvehicle:menuinput')
end, false)