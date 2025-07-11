for i, v in ipairs(Config['deposit'].Zones) do
	SKAM.RegisterPlace({
		coords = v,
		Marker = {size = vector3(2.0,2.0,0.3)},
		txt3d = "otworzyć schowek",
		pedModel = {
            model = "mp_m_exarmy_01",
            scenario = "WORLD_HUMAN_GUARD_STAND",
            heading = 90.0
        },
		onPress = function()
			if not IsPedInAnyVehicle(PlayerPedId(), false) then
				depositOptions()
			end
		end,
		onExit = function()
			ESX.UI.Menu.CloseAll()
		end
	})
end

function depositOptions()
    local elements = {
        {label = 'Wyjmij przedmioty',  value = 'deposit_inventory'},
        {label = 'Włóż przedmioty', value = 'player_inventory'},
        {label = 'Zestawy', value = 'zestaw'},
        {label = 'Ubrania', value = 'clothes'},
		{label = 'Kup ubrania', value = 'buy_clothes'},
    }

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'deposit', {
		title    = 'Schowek',
		align    = 'center',
		elements = elements
    }, function(data, menu)
        menu.close()
		if data.current.value == 'deposit_inventory' then
			OpenDepositInventoryMenu()
		elseif data.current.value == 'player_inventory' then
            OpenPlayerInventoryMenu()
		elseif data.current.value == 'zestaw' then
            OpenDepositsKitsMenu()
        elseif data.current.value == 'clothes' then
            PlayerDressings()
		elseif data.current.value == 'buy_clothes' then
			exports['skam']:OpenShopMenuClothes()
        end
    end, function(data, menu)
		menu.close()
	end)
end

function OpenDepositInventoryMenu()
	ESX.UI.Menu.CloseAll()
	ESX.TriggerServerCallback('skam$deposit:getDepositInventory', function(inventory)
        local foundDepositItems = false

        if (inventory.items and #inventory.items > 0) or (inventory.money and inventory.money > 0) then
            foundDepositItems = true
        end

        if foundDepositItems then

			local elements = {}

            if inventory.money > 0 then
                table.insert(elements, {
                    label = 'Pieniądze ' .. ESX.Math.GroupDigits(inventory.money) .. '$',
                    type = 'item_account',
                    value = 'money'
                })
            end

            for i=1, #inventory.items, 1 do
                local item = inventory.items[i]

                if item.count > 0 then
                    table.insert(elements, {
                        label = item.label .. ' x' .. item.count,
                        type = 'item_standard',
                        value = item.item
                    })
                end
            end

            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'deposit_inventory', {
                title    = 'Schowek',
                align    = 'center',
                elements = elements
            }, function(data, menu)
                ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'deposit_get_item_count', {
                    title = 'Ilość'
                }, function(data2, menu2)
                    local quantity = tonumber(data2.value)
                    if not quantity then
                        ESX.ShowNotification('Nieprawidłowa ilość', 'error')
                    else
                        TriggerServerEvent('skam$deposit:getItem', data.current.type, data.current.value, quantity)
                        menu2.close()
                        ESX.SetTimeout(300, function()
                            OpenDepositInventoryMenu()
                        end)
                    end
                end, function(data2, menu2)
                    menu2.close()
                end)
            end, function(data, menu)
                menu.close()
                depositOptions()
            end)
        else
            ESX.ShowNotification('Nie posiadasz przedmiotów w schowku', 'error')
        end
	end)
end

function OpenPlayerInventoryMenu()
	ESX.TriggerServerCallback('skam$deposit:getPlayerInventory', function(inventory)
		local elements = {}

		if inventory.money > 0 then
			table.insert(elements, {
				label = 'Pieniądze: ' .. ESX.Math.GroupDigits(inventory.money) .. '$',
				type  = 'item_account',
				value = 'money'
			})
		end

		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {
					label = item.label .. ' x' .. item.count,
					type  = 'item_standard',
					value = item.name
				})
			end
		end

		ESX.UI.Menu.CloseAll()
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'deposit_player_inventory', {
			title    = 'Schowek',
			align    = 'center',
			elements = elements
		}, function(data, menu)
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'deposit_put_item_count', {
				title = 'Ilość'
			}, function(data2, menu2)
				local quantity = tonumber(data2.value)

				if not quantity then
					ESX.ShowNotification('Nieprawidłowa ilość', 'error')
				else
					menu2.close()

                    TriggerServerEvent('skam$deposit:putItem', data.current.type, data.current.value, quantity)

					ESX.SetTimeout(300, function()
						OpenPlayerInventoryMenu()
					end)
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
			depositOptions()
		end)
	end)
end

function PlayerDressings()
	ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'dress_menu',
	{
		title    = 'Twoja Garderoba',
		align    = 'center',
		elements = {
            {label = "Ubrania", value = 'player_dressing'},
	        {label = "Usuń ubranie", value = 'remove_cloth'}
        }
	}, function(data, menu)

		if data.current.value == 'player_dressing' then 
			ESX.TriggerServerCallback('skam-dressings:getPlayerDressing', function(dressing)
				local elements = {}
				for k, v in pairs(dressing) do
				  table.insert(elements, {label = v, value = k})
				end

				if #elements > 0 then
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'player_dressing', {
						title    = 'Ubrania',
						align    = 'center',
						elements = elements,
					}, function(data2, menu2)
						TriggerEvent('skinchanger:getSkin', function(skin)
							ESX.TriggerServerCallback('skam-dressings:getPlayerOutfit', function(clothes)
								TriggerEvent('skinchanger:loadClothes', skin, clothes)
								TriggerEvent('esx_skin:setLastSkin', skin)

								TriggerEvent('skinchanger:getSkin', function(skin)
								TriggerServerEvent('esx_skin:save', skin)
								end)
							end, data2.current.value)
						end)
					end, function(data2, menu2)
						menu2.close()
					end)
				else
					ESX.ShowNotification('Brak zapisanych strojów', 'error')
				end
			end)
		elseif data.current.value == 'remove_cloth' then
			ESX.TriggerServerCallback('skam-dressings:getPlayerDressing', function(dressing)
				local elements = {}
				for k, v in pairs(dressing) do
					table.insert(elements, {label = v, value = k})
				end

				if #elements > 0 then
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'remove_cloth',
					{
						title    = 'Usuń ubrania',
						align    = 'center',
						elements = elements,
					},
					function(data2, menu2)
						menu2.close()
						TriggerServerEvent('skam-dressings:removeOutfit', data2.current.value)
						ESX.ShowNotification('Ubranie zostało usunięte z twojej garderoby', 'success')
					end,
					function(data2, menu2)
						menu2.close()
					end)
				else
					ESX.ShowNotification('Brak zapisanych strojów', 'error')
				end
			end)
		end
	end, function(data, menu)
        menu.close()
	end)
end

exports('PlayerDressings', PlayerDressings)

function OpenDepositsKitsMenu()
	local elements = {}

	elements[#elements+1] = {label = 'Zestawy', value = 'kits'}
	elements[#elements+1] = {label = 'Stwórz zestaw (twój ekwipunek)', value = 'createkit'}

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'organisations_kits', {
		title    = 'Zestawy',
		align    = 'center',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'createkit' then
			menu.close()
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'organisations_kits_name', {
				title = 'Nazwa zestawu'
			}, function(data2, menu2)
				ESX.TriggerServerCallback('skam$deposit:CreateKit', function(bool, data3)
					menu2.close()
					if bool then
						OpenDepositsKitsSubMenu(data3)
					else
						OpenDepositsKitsMenu()
					end
				end, data2.value)
			end, function(data2, menu2)
				menu2.close()
				OpenDepositsKitsMenu()
			end)
		elseif data.current.value == 'kits' then
			ESX.TriggerServerCallback('skam$deposit:GetKits', function(data2)
				menu.close()
				OpenDepositsKitsSubMenu(data2)
			end)
		end
	end, function(data, menu)
		menu.close()
		depositOptions()
	end)
end

function OpenDepositsKitsSubMenu(kits)
	local elements = {}

	for i = 1, #kits do
		elements[#elements+1] = {label = kits[i].label, iteration = i}
	end

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'deposits_saved_kits', {
		title    = 'Zestawy',
		align    = 'center',
		elements = elements
	}, function(data, menu)
		menu.close()
		OpenDepositsSpecifiedKitsMenu(data.current)
	end, function(data, menu)
		menu.close()
		OpenDepositsKitsMenu()
	end)
end

function OpenDepositsSpecifiedKitsMenu(currentKit)
	local options = {
		{label = 'Wybierz zestaw', value = 'choose'},
	}
	options[#options+1] = {label = '<span style="color:red;"><b>Usuń zestaw</b></span>', value = 'delete'}
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'deposits_saved_kits2', {
		title    = 'Zestaw: '..currentKit.label,
		align    = 'center',
		elements = options
	}, function(data, menu)
		if data.current.value == 'choose' then
			ESX.TriggerServerCallback('skam$deposit:EquipKit', function()
				ESX.UI.Menu.CloseAll()
			end, currentKit.iteration)
		elseif data.current.value == 'delete' then
			ESX.TriggerServerCallback('skam$deposit:DeleteKit', function(data2)
				menu.close()
				OpenDepositsKitsSubMenu(data2)
			end, currentKit.iteration)
		end
	end, function(data, menu)
		ESX.TriggerServerCallback('skam$deposit:GetKits', function(data2)
			menu.close()
			OpenDepositsKitsSubMenu(data2)
		end)
	end)
end

RegisterNetEvent('schowek:open',function()
	OpenDepositInventoryMenu()
end)