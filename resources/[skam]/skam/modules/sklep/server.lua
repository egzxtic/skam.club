local transactionLimit = 500

local ItemPriceMap = {}
if Config['shops'] and Config['shops'].ShopConfig and Config['shops'].ShopConfig.items then
    for i = 1, #Config['shops'].ShopConfig.items do
        local itm = Config['shops'].ShopConfig.items[i]
        ItemPriceMap[itm.item] = itm.price
    end
end

ESX.RegisterServerCallback('skam$shop:getLabels', function(source, cb, itemNames)
    local labels = {}
    for _, itemName in ipairs(itemNames) do
        local label = ESX.GetItemLabel and ESX.GetItemLabel(itemName) or itemName
        labels[itemName] = label or '*error.item'
    end
    cb(labels)
end)

ESX.RegisterServerCallback('skam$shop:getPlayerItems', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local items = {}

    for i = 1, #Config['shops'].ShopConfig.items do
        local itemName = Config['shops'].ShopConfig.items[i].item
        local inv = xPlayer.getInventoryItem(itemName)
        if inv and inv.count and inv.count > 0 then
            table.insert(items, {
                name = itemName,
                count = inv.count
            })
        end
    end

    cb(items)
end)

RegisterNetEvent('skam$shop:buyItem', function(item, amount)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    amount = tonumber(amount)
    if not amount or amount <= 0 or amount > transactionLimit then
        xPlayer.showNotification(('Nieprawidłowa ilość (max %d)!'):format(transactionLimit))
        return
    end

    local price = ItemPriceMap[item]
    if not price then
        xPlayer.showNotification('Nieprawidłowy przedmiot!')
        return
    end

    local total = price * amount
    if xPlayer.getMoney() >= total then
        xPlayer.removeMoney(total)
        xPlayer.addInventoryItem(item, amount)
        local label = ESX.GetItemLabel and ESX.GetItemLabel(item) or item
        xPlayer.showNotification(('Zakupiono %sx %s za $%s'):format(amount, label, total))
    else
        xPlayer.showNotification('Nie masz wystarczająco pieniędzy!')
    end
end)

RegisterNetEvent('skam$shop:sellItem', function(item, amount)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    amount = tonumber(amount)
    if not amount or amount <= 0 or amount > transactionLimit then
        xPlayer.showNotification(('Nieprawidłowa ilość (max %d)!'):format(transactionLimit))
        return
    end

    local price = ItemPriceMap[item]
    if not price then
        xPlayer.showNotification('Nieprawidłowy przedmiot!')
        return
    end

    local owned = xPlayer.getInventoryItem(item).count
    if owned >= amount then
        local sellprice = math.floor(price * 0.1) * amount
        xPlayer.removeInventoryItem(item, amount)
        xPlayer.addMoney(sellprice)
        local label = ESX.GetItemLabel and ESX.GetItemLabel(item) or item
        xPlayer.showNotification(('Sprzedano %sx %s za $%s'):format(amount, label, sellprice))
    else
        xPlayer.showNotification('Nie masz tyle przedmiotów!')
    end
end)