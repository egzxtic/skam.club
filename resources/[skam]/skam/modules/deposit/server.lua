AddEventHandler('esx:playerLoaded', function(_, xPlayer)
    local result = MySQL.query.await('SELECT items, money FROM deposits WHERE identifier = ?', {xPlayer.identifier})
    if not result[1] then
        MySQL.insert.await('INSERT INTO deposits (identifier) VALUES (?)', {xPlayer.identifier})
    end
end)

ESX.RegisterServerCallback('skam$deposit:getDepositInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	local result = MySQL.query.await('SELECT items, money FROM deposits WHERE identifier = ?', {xPlayer.identifier})

    moneyCallback = result[1].money
    itemsCallback = json.decode(result[1].items)

    cb({
        money      = moneyCallback,
        items      = itemsCallback,
    })
end)

ESX.RegisterServerCallback('skam$deposit:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local money = xPlayer.getAccount('money').money

	cb({
		money = money,
		items = xPlayer.inventory
	})
end)

RegisterServerEvent('skam$deposit:putItem')
AddEventHandler('skam$deposit:putItem', function(type, item, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	if type == 'item_standard' then
		local playerItem = xPlayer.getInventoryItem(item)

		if playerItem.count >= count and count > 0 then
			MySQL.query('SELECT items FROM deposits WHERE identifier = @identifier', {
				['@identifier'] = xPlayer.identifier
			}, function(result)
				local InsertItems = {}
				local founditem = false

				if result[1].items then
					InsertItems = json.decode(result[1].items)
				end

				for k, v in pairs(InsertItems) do
					if v.item == item then
						v.count = v.count + count
						founditem = true
						break
					end
				end

				if not founditem then
					table.insert(InsertItems, {item = item, label = playerItem.label, count = count})
				end

                MySQL.update('UPDATE deposits SET items = @items WHERE identifier = @identifier', {
                    ['@items'] = json.encode(InsertItems),
                    ['@identifier'] = xPlayer.identifier
                }, function(rowsChanged)
                    xPlayer.removeInventoryItem(item, count)
                    xPlayer.showNotification('~y~Schowano: ' .. count .. 'x ' .. playerItem.label)
					exports['skam']:log(xPlayer.source, ('Schowano przedmiot\nPrzedmiot: %s (%s)'):format(playerItem.label, count), 'deposit')
                end)
			end)
		else
			xPlayer.showNotification('~r~Nieprawidłowa ilość')
		end
	elseif type == 'item_account' then
		if xPlayer.getAccount(item).money >= count and count > 0 then
			MySQL.query('SELECT money FROM deposits WHERE identifier = @identifier', {
				['@identifier'] = xPlayer.identifier
			}, function(result)
				local money = 0

				if result[1] and result[1].money then
					money = result[1].money + count
				end

                MySQL.Async.execute('UPDATE deposits SET money = @money WHERE identifier = @identifier', {
                    ['@money'] = money,
                    ['@identifier'] = xPlayer.identifier
                }, function(rowsChanged)
                    xPlayer.removeAccountMoney('money', count)
                    xPlayer.showNotification('~g~Schowano '..count..'$ pieniędzy')
					exports['skam']:log(xPlayer.source, ('Schowano pieniądze\nIlość: %s$'):format(count), 'deposit')
                end)
			end)
		else
			xPlayer.showNotification('~r~Nieprawidłowa ilość')
		end
	end
end)

RegisterServerEvent('skam$deposit:getItem')
AddEventHandler('skam$deposit:getItem', function(type, item, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	if type == 'item_standard' then
		MySQL.Async.fetchAll('SELECT items FROM deposits WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.identifier
		}, function(result)
			local InsertItems = {}
			local itemlabel = nil
			local cangetitem = false
			if result[1] and result[1].items then
				InsertItems = json.decode(result[1].items)
				for k, v in pairs(InsertItems) do
					if v.item == item then
						if count > 0 and v.count >= count then
							if xPlayer.canCarryItem(item, count) then
								v.count = v.count - count
								itemlabel = v.label
								if v.count == 0 then
									table.remove(InsertItems, k)
								end
								cangetitem = true
								break
							else
								xPlayer.showNotification('~r~Nie dasz rady tyle unieść')
								break
							end
						else
							xPlayer.showNotification('~r~Nie ma wystarczającej ilości tego przedmiotu w schowku')
							break
						end
					end
				end
				if cangetitem then
					MySQL.Async.execute('UPDATE deposits SET items = @items WHERE identifier = @identifier', {
						['@items'] = json.encode(InsertItems),
						['@identifier'] = xPlayer.identifier
					}, function(rowsChanged)
						xPlayer.addInventoryItem(item, count)
						xPlayer.showNotification('~y~Wyjęto: ' .. count .. 'x ' .. itemlabel)
						exports['skam']:log(xPlayer.source, ('Wyjęto przedmiot\nPrzedmiot: %s (%s)'):format(itemlabel, count), 'deposit')
					end)
				end
			end
		end)
	elseif type == 'item_account' then
		MySQL.Async.fetchAll('SELECT money FROM deposits WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.identifier
		}, function(result)
			if result[1] and result[1].money then
				if result[1].money >= count then
					money = result[1].money - count
					MySQL.Async.execute('UPDATE deposits SET money = @money WHERE identifier = @identifier', {
						['@money'] = money,
						['@identifier'] = xPlayer.identifier
					}, function(rowsChanged)
						xPlayer.addAccountMoney(item, count)
						xPlayer.showNotification('~y~Wyjęto: '..count..'$')
						exports['skam']:log(xPlayer.source, ('Wyjęto pieniądze\nIlość: %s$'):format(count), 'deposit')
					end)
				else
					xPlayer.showNotification('~r~Nieprawidłowa ilość')
				end
			end
		end)
	end
end)

local Kitss = {}

MySQL.ready(function()
    MySQL.query('SELECT kits, identifier FROM deposits', {}, function(data)
        if data then
            for i = 1, #data do
                if data[i].kits then
                    Kitss[data[i].identifier] = json.decode(data[i].kits)
                end
            end
        end
	end)
end)

ESX.RegisterServerCallback('skam$deposit:GetKits', function(src, cb)
    local xPlayer = ESX.GetPlayerFromId(src)
	cb(Kitss[xPlayer.identifier])
end)

ESX.RegisterServerCallback('skam$deposit:CreateKit', function(src, cb, kitName)
    local xPlayer = ESX.GetPlayerFromId(src)
    local Inventory = xPlayer.getInventory(true)
    local itemsList = ""
    local Items = {}

    for item, count in pairs(Inventory) do
        Items[#Items+1] = {item = item, count = count}
        itemsList = itemsList..xPlayer.getInventoryItem(item).label.." x"..count.."\n"
    end

    if not Kitss[xPlayer.identifier] then
        Kitss[xPlayer.identifier] = {}
    end

    if #Kitss[xPlayer.identifier] <= 5 then
        Kitss[xPlayer.identifier][#Kitss[xPlayer.identifier]+1] = {label = kitName, items = Items}
        MySQL.update.await('UPDATE deposits SET kits = ? WHERE identifier = ? ', {json.encode(Kitss[xPlayer.identifier]), xPlayer.identifier})
        xPlayer.showNotification('Zapisano zestaw: '..kitName, 'success')

        cb(true, Kitss[xPlayer.identifier])
    else
        xPlayer.showNotification('Twoja organizacja posiada już maksymalną ilość zestawów', 'error')
        cb(false)
    end
end)

ESX.RegisterServerCallback('skam$deposit:DeleteKit', function(src, cb, iteration)
    local xPlayer = ESX.GetPlayerFromId(src)

    if Kitss[xPlayer.identifier][iteration] then
        table.remove(Kitss[xPlayer.identifier], iteration)
        MySQL.update.await('UPDATE deposits SET kits = ? WHERE identifier = ? ', {json.encode(Kitss[xPlayer.identifier]), xPlayer.identifier})
    end

    cb(Kitss[xPlayer.identifier])
end)

ESX.RegisterServerCallback('skam$deposit:EquipKit', function(src, cb, iteration)
    local xPlayer = ESX.GetPlayerFromId(src)

    if Kitss[xPlayer.identifier][iteration] then
        local kitItems = Kitss[xPlayer.identifier][iteration].items
		
		MySQL.Async.fetchAll('SELECT items FROM deposits WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.identifier
		}, function(result)
			if result[1] and result[1].items then
				local InsertItems = {}
				InsertItems = json.decode(result[1].items)
				print(json.encode(InsertItems))

				
				for i = 1, #kitItems do
					local foundIteration
					for j = 1, #InsertItems do
						if (kitItems[i].item == InsertItems[j].item) then
							foundIteration = j
							break
						end
					end

					if foundIteration and InsertItems[foundIteration].count >= kitItems[i].count then
						skip = false
						if xPlayer.canCarryItem(kitItems[i].item, kitItems[i].count) then
							if kitItems[i].count > 0 and InsertItems[foundIteration].count >= kitItems[i].count then
								InsertItems[foundIteration].count = InsertItems[foundIteration].count - kitItems[i].count
								itemlabel = InsertItems[foundIteration].label
								if InsertItems[foundIteration].count == 0 then
									table.remove(InsertItems, foundIteration)
								end
							else
								skip = true
							end

							if not skip then
								xPlayer.addInventoryItem(kitItems[i].item, kitItems[i].count)

								MySQL.Async.execute('UPDATE deposits SET items = @items WHERE identifier = @identifier', {
									['@items'] = json.encode(InsertItems),
									['@identifier'] = xPlayer.identifier
								}, function(rowsChanged)
									xPlayer.addInventoryItem(item, count)
									xPlayer.showNotification('~y~Wyjęto: ' .. count .. 'x ' .. itemlabel)
								end)
							end
						else
							xPlayer.showNotification("Brak miejsca w ekwipunku", "error")
						end
					else
						xPlayer.showNotification('W szafce nie ma wystarczająco '..kitItems[i].item, 'error')
					end
				end
			end

		end)
    end

    cb()
end)