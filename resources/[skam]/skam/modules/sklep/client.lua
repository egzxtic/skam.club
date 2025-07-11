local ShopLabels = {}

function FetchShopLabels(cb)
    local itemNames = {}
    for i = 1, #Config['shops'].ShopConfig.items do
        table.insert(itemNames, Config['shops'].ShopConfig.items[i].item)
    end
    ESX.TriggerServerCallback('skam$item:getlabel', function(labels)
        ShopLabels = labels or {}
        if cb then cb(ShopLabels) end
    end, itemNames)
end

function OpenShopMainMenu()
    FetchShopLabels(function()
        ESX.UI.Menu.CloseAll()
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_main_menu', {
            title    = 'Sklep',
            align    = 'center',
            elements = {
                {label = 'Kup przedmiot', value = 'buy'},
                {label = 'Sprzedaj przedmiot', value = 'sell'},
            }
        }, function(data, menu)
            if data.current.value == 'buy' then
                OpenShopBuyMenu()
            elseif data.current.value == 'sell' then
                OpenShopSellMenu()
            end
        end, function(data, menu)
            menu.close()
        end)
    end)
end

function OpenShopBuyMenu()
    local elements = {}
    for i = 1, #Config['shops'].ShopConfig.items do
        local v = Config['shops'].ShopConfig.items[i]
        table.insert(elements, {
            label = ('%s - <span style="color:gray;">$%d</span>'):format(ShopLabels[v.item] or v.item, v.price),
            value = v.item,
            price = v.price
        })
    end
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_buy_menu', {
        title    = 'Kup przedmiot',
        align    = 'center',
        elements = elements
    }, function(data, menu)
        local item = data.current.value
        local price = data.current.price
        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'shop_buy_amount', {
            title = 'Ilość do kupienia'
        }, function(data2, menu2)
            local amount = tonumber(data2.value)
            if not amount or amount <= 0 then ESX.ShowNotification('Nieprawidłowa ilość!') return end
            TriggerServerEvent('skam$shop:buyItem', item, amount)
            menu2.close()
            menu.close()
        end, function(data2, menu2)
            menu2.close()
        end)
    end, function(data, menu)
        menu.close()
    end)
end

function OpenShopSellMenu()
    ESX.TriggerServerCallback('skam$shop:getPlayerItems', function(items)
        local ownedMap = {}
        for i = 1, #items do
            ownedMap[items[i].name] = items[i].count
        end

        local elements = {}
        for i = 1, #Config['shops'].ShopConfig.items do
            local v = Config['shops'].ShopConfig.items[i]
            local ownedCount = ownedMap[v.item]
            if ownedCount and ownedCount > 0 then
                table.insert(elements, {
                    label = ('%s (%dx) - <span style="color:gray;">$%d</span>'):format(ShopLabels[v.item] or v.item, ownedCount, math.floor(v.price * 0.1)),
                    value = v.item,
                    price = math.floor(v.price * 0.1),
                    count = ownedCount
                })
            end
        end

        if #elements == 0 then
            table.insert(elements, {label = 'Brak przedmiotów do sprzedania', value = nil, price = 0, count = 0, disabled = true})
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_sell_menu', {
            title    = 'Sprzedaj przedmiot',
            align    = 'center',
            elements = elements
        }, function(data, menu)
            if not data.current.value then return end
            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'shop_sell_amount', {
                title = ('Ilość do sprzedania (max: %s)'):format(data.current.count)
            }, function(data2, menu2)
                local amount = tonumber(data2.value)
                if not amount or amount <= 0 or amount > data.current.count then ESX.ShowNotification('Nieprawidłowa ilość!') return end
                TriggerServerEvent('skam$shop:sellItem', data.current.value, amount)
                menu2.close()
                menu.close()
            end, function(data2, menu2)
                menu2.close()
            end)
        end, function(data, menu)
            menu.close()
        end)
    end)
end

for i = 1, #Config['shops'].ShopConfig.coords do
    SKAM.RegisterPlace({
        coords = Config['shops'].ShopConfig.coords[i],
        Marker = {size = vector3(2.0,2.0,0.3)},
        txt3d = 'otworzyć sklep',
        pedModel = {
            model = "a_m_m_og_boss_01",
            animation = { dict = "amb@world_human_hang_out_street@male_b@idle_a", name = "idle_a" },
            heading = 90.0
        },
        onPress = function()
            if not IsPedInAnyVehicle(PlayerPedId(), false) and not LocalPlayer.state.dead then
                OpenShopMainMenu()
            end
        end,
        onExit = function()
            ESX.UI.Menu.CloseAll()
        end
    })
end

RegisterCommand('sklep', function()
    if not IsPedInAnyVehicle(PlayerPedId(), false) and not LocalPlayer.state.dead then
        exports['skam-ui']:showProgress('Otwieranie sklepu..', 3000, function(finished)
            if finished then
                OpenShopMainMenu()
            end
        end)
    end
end, false)