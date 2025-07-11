for k, v in pairs(Config['healer'].Healers) do
    SKAM.RegisterPlace({
		coords = v,
		Marker = {size = vector3(2.0,2.0,0.3)},
		txt3d = "skorzystać z pomocy",
        pedModel = {
            model = "s_m_m_doctor_01",
            scenario = "WORLD_HUMAN_CLIPBOARD",
            heading = 90.0
        },
		onPress = function()
            if not IsPedInAnyVehicle(PlayerPedId(), false) then
                ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'healer_confirm',
                {
                    title = 'Chcesz skorzystać z pomocy?',
                    align = 'center',
                    elements = {
                        {label = 'Tak', value = true},
                        {label = 'Nie', value = false}
                    }
                }, function(data, menu)
                    menu.close()
                    if data.current.value then
                        TriggerServerEvent('skam:useHealer')
                    end
                end, function(data, menu)
                    menu.close()
                end)
            end
		end,
		onExit = function()
			ESX.UI.Menu.CloseAll()
		end
	})
end