local hasPaid = false

local function OpenShopMenuClothes()
	hasPaid = false

	TriggerEvent('esx_skin:openRestrictedMenu', function(data, menu)
		menu.close()

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm', {
			title = 'Potwierdzasz ten zakup?',
			align = 'center',
			elements = {
				{label = 'Tak', value = 'yes'},
				{label = 'Nie', value = 'no'}
		}}, function(data, menu)
			menu.close()

			if data.current.value == 'yes' then
				ESX.TriggerServerCallback('skam-clotheshop:buyClothes', function(bought)
					if bought then
						TriggerEvent('skinchanger:getSkin', function(skin)
							TriggerServerEvent('esx_skin:save', skin)
						end)

						hasPaid = true

						ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'save_dressing', {
							title = 'Czy chcesz zapisać te ubranie?',
							align = 'center',
							elements = {
								{label = 'Tak', value = 'yes'},
								{label = 'Nie',  value = 'no'}
						}}, function(data2, menu2)
							menu2.close()

							if data2.current.value == 'yes' then
								ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'outfit_name', {
									title = 'Nazwa stroju'
								}, function(data3, menu3)
									menu3.close()

									TriggerEvent('skinchanger:getSkin', function(skin)
										TriggerServerEvent('skam-dressings:saveOutfit', data3.value, skin)
										ESX.ShowNotification('Zapisano strój pod nazwą: '..data3.value)
									end)
								end, function(data3, menu3)
									menu3.close()
								end)
							end
						end)
					else
						ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
							TriggerEvent('skinchanger:loadSkin', skin)
						end)

						ESX.ShowNotification('Nie posiadasz wystarczająco pieniędzy', 'error')
					end
				end)
			elseif data.current.value == 'no' then
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
					TriggerEvent('skinchanger:loadSkin', skin)
				end)
			end
		end, function(data, menu)
			menu.close()
		end)

	end, function(data, menu)
		menu.close()
	end, {
		'tshirt_1', 'tshirt_2',
		'torso_1', 'torso_2',
		'decals_1', 'decals_2',
		'arms',
		'pants_1', 'pants_2',
		'shoes_1', 'shoes_2',
        'bags_1', 'bags_2',
		'chain_1', 'chain_2',
		'helmet_1', 'helmet_2',
		'glasses_1', 'glasses_2',
		'mask_1', 'mask_2',
		'ears_1', 'ears_2',
		'bracelets_1', 'bracelets_2',
		'watches_1', 'watches_2',
	})
end

local function OpenSelectMenu()
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open(
	'default', GetCurrentResourceName(), 'shop_select',
	{
	  title    = 'Sklep z ubraniami',
	  align    = 'center',
	  elements = {
		{label = 'Kup ubrania <span style="color:green;">'..Config['clotheshop'].Price..'$</span>', value = 'buy'},
		{label = 'Prywatna garderoba', value = 'player_dressing'},
	  }
	},
	function(data, menu)
	  	if data.current.value == 'buy' then
			OpenShopMenuClothes()
		elseif data.current.value == 'player_dressing' then
			PlayerDressings()
		end
	end,
	function(data, menu)
		menu.close()
	end
  )
end

exports('OpenShopMenuClothes', OpenShopMenuClothes)

function PlayerDressings()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'dress_menu',
	{
		title    = 'Twoja Garderoba',
		align    = 'center',
		elements = {
            {label = 'Ubrania', value = 'player_dressing'},
	        {label = 'Usuń ubranie', value = 'remove_cloth'}
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

-- CreateThread(function()
-- 	for k, v in pairs(Config['clotheshop'].Shops) do
-- 		local blip = AddBlipForCoord(v)

-- 		SetBlipSprite (blip, 73)
-- 		SetBlipColour (blip, 47)
-- 		SetBlipAsShortRange(blip, true)
-- 		SetBlipScale(blip, 0.6)

-- 		BeginTextCommandSetBlipName('STRING')
-- 		AddTextComponentSubstringPlayerName('Sklep z ubraniami')
-- 		EndTextCommandSetBlipName(blip)
-- 	end
-- end)

for k, v in pairs(Config['clotheshop'].Shops) do
	SKAM.RegisterPlace({
		coords = v,
		Marker = {size = vector3(2.0,2.0,0.3)},
		txt3d = "otworzyć sklep z ubraniami",
		onPress = function()
			OpenSelectMenu()
		end,
		onExit = function()
			ESX.UI.Menu.CloseAll()
			if not hasPaid then
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
					TriggerEvent('skinchanger:loadSkin', skin)
				end)
			end
		end,
		onEnter = function()
			ESX.UI.Menu.CloseAll()
		end
	})
end

