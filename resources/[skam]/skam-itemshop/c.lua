local Client = {
    Data = {
        coins = 0,
        points = 0,
        name = 'SKAM',
        inventory = {},
    },
    loaded = false,
    Opened = false
}

Client.PlayerLoaded = function(playerData)
    for k, v in pairs(playerData) do
        if Client.Data[k] then
            Client.Data[k] = v
        end
    end
    Client.loaded = true
end

Client.UpdatePlayerData = function(playerData)
    for k, v in pairs(playerData) do
        if Client.Data[k] then
            Client.Data[k] = v
        end
    end
    Client.UpdateCoins()
end

Client.OpenShop = function()
    if Client.Opened then return end
    TriggerServerEvent('skam-itemshop:UpdatePlayer')
    SetNuiFocus(true, true)
    Client.Opened = true
    Client.UpdateCoins()
    SendNUIMessage({
        action = 'open',
        cases = Config.CaseCategory,
        name = Client.Data.name,
        pfp = Client.Data.avatar
    })
end

Client.UpdateCoins = function()
    SendNUIMessage({
        action = 'updateCoins',
        coins = Client.Data.coins,
        points = Client.Data.points,
        name = Client.Data.name,
        pfp = Client.Data.avatar,
        avatar = Client.Data.avatar,
    })
end

Client.UpdateLivedrop = function(item)
    SendNUIMessage({
        action = 'liveDrop',
        item = item
    })
end

Client.CloseNuiCallback = function()
    Client.Opened = false
    SetNuiFocus(false, false)
end

Client.GetInfoNuiCallback = function(data, cb)
    ESX.TriggerServerCallback('skam-itemshop:callback:getSteamPhotoUrl', function(callback)
        local InfoCb = Config.Info
        if callback then
            InfoCb['userPfp'] = callback
        end
        cb(Config.Info)
    end)
end

Client.GetEventNuiCallback = function(data, cb)
    cb(Config.Events)
end

Client.GetCasesNuiCallback = function(data, cb)
    cb(Config.CaseCategory)
end

Client.GetCaseInfoNuiCallback = function(data, cb)
    cb(Config.Cases[data.id])
end

Client.GetFreeCaseTimeNuiCallback = function(data, cb)
    ESX.TriggerServerCallback('skam-itemshop:callback:getFreeCaseTime', function(callback)
        cb(callback)
    end)
end

Client.OpenCaseNuiCallback = function(data, cb)
    ESX.TriggerServerCallback('skam-itemshop:callback:openCase', function(callback)
        print(json.encode(callback))
        if not callback then
            cb({
                success = false,
                error = 'Wystąpił nieoczekiwany błąd'
            })
            return
        end
        if callback.success then
            Client.Data.coins = callback.coins
            Client.Data.points = callback.points
            Client.UpdateCoins()
        end
        cb(callback)
    end, data.id)
end

Client.SellItemNuiCallback = function(data, cb)
    ESX.TriggerServerCallback('skam-itemshop:callback:sellItem', function(callback)
        cb(callback.status)
        if callback.status then
            Client.UpdatePlayerData(callback.data)
        end
    end, data.item)
end

Client.KeepItemNuiCallback = function(data)
    TriggerServerEvent('skam-itemshop:server:keepItem', data.item)
end

Client.UpgradeItemNuiCallback = function(data, cb)
    ESX.TriggerServerCallback('skam-itemshop:callback:upgradeItem', function(callback)
        cb({
            canUpgrade = callback.canUpgrade,
            upgraded = callback.upgraded
        })

        Client.UpdatePlayerData(callback.data)
    end, data)
end

Client.GetInventoryNuiCallback = function(data, cb)
    cb(Client.Data.inventory)
end

Client.GetAllItemsNuiCallback = function(data, cb)
    cb(Config.AllItems)
end

Client.GetCoinsNuiCallback = function(data, cb)
    cb({
        coins = Client.Data.coins,
        points = Client.Data.points,
        name = Client.Data.name
    })
end

Client.BuyItemNuiCallback = function(data, cb)
    ESX.TriggerServerCallback('skam-itemshop:callback:buyItem', function(callback)
        cb(callback.status)
        Client.UpdatePlayerData(callback.data)
    end, data)
end

Client.WithdrawItemNuiCallback = function(data, cb)
    ESX.TriggerServerCallback('skam-itemshop:callback:withdrawItem', function(callback)
        cb(callback.status)
        if callback.status then
            Client.UpdatePlayerData(callback.data)
        end
    end, data)
end

Client.DiscountNuiCallback = function(data, cb)
    ESX.TriggerServerCallback('skam-itemshop:callback:discount', function(callback)
        cb(callback.status)
        Client.UpdatePlayerData(callback.data)
    end, data)
end

Client.GetShopItemsNuiCallback = function(data, cb)
    cb(Config.ShopItems)
end

RegisterNUICallback('close', Client.CloseNuiCallback)
RegisterNUICallback('getInfo', Client.GetInfoNuiCallback)
RegisterNUICallback('getEvent', Client.GetEventNuiCallback)
RegisterNUICallback('getCases', Client.GetCasesNuiCallback)
RegisterNUICallback('getCaseInfo', Client.GetCaseInfoNuiCallback)
RegisterNUICallback('getFreeCaseTime', Client.GetFreeCaseTimeNuiCallback)
RegisterNUICallback('openCase', Client.OpenCaseNuiCallback)
RegisterNUICallback('sellItem', Client.SellItemNuiCallback)
RegisterNUICallback('keepItem', Client.KeepItemNuiCallback)
RegisterNUICallback('upgradeItem', Client.UpgradeItemNuiCallback)
RegisterNUICallback('getInventory', Client.GetInventoryNuiCallback)
RegisterNUICallback('getAllItems', Client.GetAllItemsNuiCallback)
RegisterNUICallback('getCoins', Client.GetCoinsNuiCallback)
RegisterNUICallback('buyItem', Client.BuyItemNuiCallback)
RegisterNUICallback('withdrawItem', Client.WithdrawItemNuiCallback)
RegisterNUICallback('discount', Client.DiscountNuiCallback)
RegisterNUICallback('getShopItems', Client.GetShopItemsNuiCallback)

RegisterCommand("skrzynki", Client.OpenShop)
RegisterNetEvent('skam-itemshop:client:playerLoaded', Client.PlayerLoaded)
RegisterNetEvent('skam-itemshop:client:updatePlayerData', Client.UpdatePlayerData)
RegisterNetEvent('skam-itemshop:client:updateLiveDrop', Client.UpdateLivedrop)