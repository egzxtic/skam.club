local DrawRadioText = true

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	
	InitRestrictedFrequencies()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job

	RefreshRestrictedFrequenciesAccess()
end)

local Radio = {
	Has = false,
	Open = false,
	On = false,
	Enabled = true,
	Handle = nil,
	Prop = GetHashKey('prop_cs_hand_radio'),
	Bone = 28422,
	Offset = vector3(0.0, 0.0, 0.0),
	Rotation = vector3(0.0, 0.0, 0.0),
	Dictionary = {
		"cellphone@",
		"cellphone@in_car@ds",
		"cellphone@str",
		"random@arrests",
	},
	Animation = {
		"cellphone_text_in",
		"cellphone_text_out",
		"cellphone_call_listen_a",
		"generic_radio_chatter",
	},
	Players = 0,
	Clicks = true,
}
Radio.Labels = {
	{ "FRZL_RADIO_HELP", "~s~" .. (radioConfig.Controls.Secondary.Enabled and "~" .. radioConfig.Controls.Secondary.Name .. "~ + ~" .. radioConfig.Controls.Activator.Name .. "~" or "~" .. radioConfig.Controls.Activator.Name .. "~") .. " to hide.~n~~" .. radioConfig.Controls.Toggle.Name .. "~ to turn radio ~g~on~s~.~n~~" .. radioConfig.Controls.Decrease.Name .. "~ or ~" .. radioConfig.Controls.Increase.Name .. "~ to switch frequency~n~~" .. radioConfig.Controls.Input.Name .. "~ to choose frequency~n~~" .. radioConfig.Controls.ToggleClicks.Name .. "~ to ~a~ mic clicks~n~Frequency: ~1~ MHz" },
	{ "FRZL_RADIO_HELP2", "~s~" .. (radioConfig.Controls.Secondary.Enabled and "~" .. radioConfig.Controls.Secondary.Name .. "~ + ~" .. radioConfig.Controls.Activator.Name .. "~" or "~" .. radioConfig.Controls.Activator.Name .. "~") .. " to hide.~n~~" .. radioConfig.Controls.Toggle.Name .. "~ to turn radio ~r~off~s~.~n~~" .. radioConfig.Controls.Broadcast.Name .. "~ to broadcast.~n~Frequency: ~1~ MHz" },
	{ "FRZL_RADIO_INPUT", "Enter Frequency" },
}
local unarmed = GetHashKey('weapon_unarmed')
Radio.Commands = {
	{
		Enabled = false,
		Name = "radio",
		Help = "Toggle hand radio",
		Params = {},
		Handler = function(src, args, raw)
			local playerPed = PlayerPedId()
			local isFalling = IsPedFalling(playerPed)
			local isDead = LocalPlayer.state.dead

			if not isFalling and Radio.Enabled and Radio.Has and not isDead then
				Radio:Toggle(not Radio.Open)
			elseif (Radio.Open or Radio.On) and ((not Radio.Enabled) or (not Radio.Has) or isDead) then
				Radio:Toggle(false)
				Radio.On = false
				Radio:Remove()
				exports["skam-voice"]:setVoiceProperty("radioEnabled", false)
			elseif Radio.Open and isFalling then
				Radio:Toggle(false)
			end
		end,
	},
	{
		Enabled = false,
		Name = "frequency",
		Help = "Change radio frequency",
		Params = {
			{name = "number", "Enter frequency"}
		},
		Handler = function(src, args, raw)
			if Radio.Has then
				if args[1] then
					local newFrequency = tonumber(args[1])
					if newFrequency then
						local minFrequency = radioConfig.Frequency.List[1]
						if newFrequency >= minFrequency and newFrequency <= radioConfig.Frequency.List[#radioConfig.Frequency.List] and newFrequency == math.floor(newFrequency) then
							if not radioConfig.Frequency.Private[newFrequency] or radioConfig.Frequency.Access[newFrequency] then
								local idx = nil

								for i = 1, #radioConfig.Frequency.List do
									if radioConfig.Frequency.List[i] == newFrequency then
										idx = i
										break
									end
								end

								if idx ~= nil then
									if Radio.Enabled then
										Radio:Remove()
									end

									radioConfig.Frequency.CurrentIndex = idx
									radioConfig.Frequency.Current = newFrequency

									if Radio.On then
										Radio:Add(radioConfig.Frequency.Current)
									end
								end
							end
						end
					end
				end
			end
		end,
	},
}

for i = 1, #Radio.Commands do
	if Radio.Commands[i].Enabled then
		RegisterCommand(Radio.Commands[i].Name, Radio.Commands[i].Handler, false)
		TriggerEvent("chat:addSuggestion", Radio.Commands[i].Name, Radio.Commands[i].Help, Radio.Commands[i].Params)
	end
end

function Radio:Add(id)
	TriggerServerEvent("skam-radiolist:registerChannel", id)
	exports["skam-voice"]:setRadioChannel(id)
end

function Radio:Remove()
	TriggerServerEvent("skam-radiolist:unregisterChannel")
	exports["skam-voice"]:setRadioChannel(0)
end

function Radio:Decrease()
	if self.On then
		if radioConfig.Frequency.CurrentIndex - 1 < 1 and radioConfig.Frequency.List[radioConfig.Frequency.CurrentIndex] == radioConfig.Frequency.Current then
			self:Remove()
			radioConfig.Frequency.CurrentIndex = #radioConfig.Frequency.List
			radioConfig.Frequency.Current = radioConfig.Frequency.List[radioConfig.Frequency.CurrentIndex]
			self:Add(radioConfig.Frequency.Current)
		elseif radioConfig.Frequency.CurrentIndex - 1 < 1 and radioConfig.Frequency.List[radioConfig.Frequency.CurrentIndex] ~= radioConfig.Frequency.Current then
			self:Remove()
			radioConfig.Frequency.Current = radioConfig.Frequency.List[radioConfig.Frequency.CurrentIndex]
			self:Add(radioConfig.Frequency.Current)
		else
			self:Remove()
			radioConfig.Frequency.CurrentIndex = radioConfig.Frequency.CurrentIndex - 1
			radioConfig.Frequency.Current = radioConfig.Frequency.List[radioConfig.Frequency.CurrentIndex]
			self:Add(radioConfig.Frequency.Current)
		end
	else
		if radioConfig.Frequency.CurrentIndex - 1 < 1 and radioConfig.Frequency.List[radioConfig.Frequency.CurrentIndex] == radioConfig.Frequency.Current then
			radioConfig.Frequency.CurrentIndex = #radioConfig.Frequency.List
			radioConfig.Frequency.Current = radioConfig.Frequency.List[radioConfig.Frequency.CurrentIndex]
		elseif radioConfig.Frequency.CurrentIndex - 1 < 1 and radioConfig.Frequency.List[radioConfig.Frequency.CurrentIndex] ~= radioConfig.Frequency.Current then
			radioConfig.Frequency.Current = radioConfig.Frequency.List[radioConfig.Frequency.CurrentIndex]
		else
			radioConfig.Frequency.CurrentIndex = radioConfig.Frequency.CurrentIndex - 1

			if radioConfig.Frequency.List[radioConfig.Frequency.CurrentIndex] == radioConfig.Frequency.Current then
				radioConfig.Frequency.CurrentIndex = radioConfig.Frequency.CurrentIndex - 1
			end

			radioConfig.Frequency.Current = radioConfig.Frequency.List[radioConfig.Frequency.CurrentIndex]
		end
	end
end

function Radio:Increase()
	if self.On then
		if radioConfig.Frequency.CurrentIndex + 1 > #radioConfig.Frequency.List then
			self:Remove()
			radioConfig.Frequency.CurrentIndex = 1
			radioConfig.Frequency.Current = radioConfig.Frequency.List[radioConfig.Frequency.CurrentIndex]
			self:Add(radioConfig.Frequency.Current)
		else
			self:Remove()
			radioConfig.Frequency.CurrentIndex = radioConfig.Frequency.CurrentIndex + 1
			radioConfig.Frequency.Current = radioConfig.Frequency.List[radioConfig.Frequency.CurrentIndex]
			self:Add(radioConfig.Frequency.Current)
		end
	else
		if #radioConfig.Frequency.List == radioConfig.Frequency.CurrentIndex + 1 then
			if radioConfig.Frequency.List[radioConfig.Frequency.CurrentIndex + 1] == radioConfig.Frequency.Current then
				radioConfig.Frequency.CurrentIndex = radioConfig.Frequency.CurrentIndex + 1
			end
		end

		if radioConfig.Frequency.CurrentIndex + 1 > #radioConfig.Frequency.List then
			radioConfig.Frequency.CurrentIndex = 1
			radioConfig.Frequency.Current = radioConfig.Frequency.List[radioConfig.Frequency.CurrentIndex]
		else
			radioConfig.Frequency.CurrentIndex = radioConfig.Frequency.CurrentIndex + 1
			radioConfig.Frequency.Current = radioConfig.Frequency.List[radioConfig.Frequency.CurrentIndex]
		end
	end
end

function Radio:IncreaseRestricted()
	local nextFrequency = nil

	for i=(radioConfig.Frequency.CurrentIndex + 1), #radioConfig.Frequency.List do
		local frequency = radioConfig.Frequency.List[i]
		if radioConfig.Frequency.Access[frequency] then
			nextFrequency = i

			break
		end
	end

	if nextFrequency then
		if self.On then
			self:Remove()
			radioConfig.Frequency.CurrentIndex = nextFrequency
			radioConfig.Frequency.Current = radioConfig.Frequency.List[radioConfig.Frequency.CurrentIndex]
			self:Add(radioConfig.Frequency.Current)
		else
			radioConfig.Frequency.CurrentIndex = nextFrequency
			radioConfig.Frequency.Current = radioConfig.Frequency.List[radioConfig.Frequency.CurrentIndex]
		end
	end
end

function Radio:DecreaseRestricted()
    local nextFrequency = nil

    for i=(radioConfig.Frequency.Current - 1), 0, -1 do
        if radioConfig.Frequency.Access[i] then
            nextFrequency = i

            break
        end
    end

    if nextFrequency then
        local frequencyIndex = nil

        for i = 1, #radioConfig.Frequency.List do
            if radioConfig.Frequency.List[i] == nextFrequency then
                frequencyIndex = i

                break
            end
        end

        if frequencyIndex then
            if self.On then
                self:Remove()
                radioConfig.Frequency.CurrentIndex = frequencyIndex
                radioConfig.Frequency.Current = radioConfig.Frequency.List[radioConfig.Frequency.CurrentIndex]
                self:Add(radioConfig.Frequency.Current)
            else
                radioConfig.Frequency.CurrentIndex = frequencyIndex
                radioConfig.Frequency.Current = radioConfig.Frequency.List[radioConfig.Frequency.CurrentIndex]
            end
        end
    end
end

function GenerateFrequencyList()
	radioConfig.Frequency.List = {}

	for i = radioConfig.Frequency.Min, radioConfig.Frequency.Max do
		if not radioConfig.Frequency.Private[i] or radioConfig.Frequency.Access[i] then
			radioConfig.Frequency.List[#radioConfig.Frequency.List + 1] = i
		end
	end
end

function IsRadioOpen()
	return Radio.Open
end

function IsRadioOn()
	return Radio.On
end

function IsRadioAvailable()
	return Radio.Has
end

function IsRadioEnabled()
	return not Radio.Enabled
end

function CanRadioBeUsed()
	return Radio.Has and Radio.On and Radio.Enabled
end

function SetRadioEnabled(value)
	if type(value) == "string" then
		value = value == "true"
	elseif type(value) == "number" then
		value = value == 1
	end

	Radio.Enabled = value and true or false
end

function SetRadio(value)
	if type(value) == "string" then
		value = value == "true"
	elseif type(value) == "number" then
		value = value == 1
	end

	Radio.Has = value and true or false
end

function SetAllowRadioWhenClosed(value)
	radioConfig.AllowRadioWhenClosed = value

	if Radio.On and not Radio.Open and radioConfig.AllowRadioWhenClosed then
		exports["skam-voice"]:setVoiceProperty("radioEnabled", true)
	end
end

function HasPrivateFrequencyExist(value)
	local frequency = tonumber(value)

	if frequency ~= nil then
		return radioConfig.Frequency.Private[frequency] ~= nil
	end
end

function AddPrivateFrequency(value)
	local frequency = tonumber(value)

	if frequency ~= nil then
		if not radioConfig.Frequency.Private[frequency] then
			radioConfig.Frequency.Private[frequency] = true

			GenerateFrequencyList()
		end
	end
end

function RemovePrivateFrequency(value)
	local frequency = tonumber(value)

	if frequency ~= nil then
		if radioConfig.Frequency.Private[frequency] then
			radioConfig.Frequency.Private[frequency] = nil

			GenerateFrequencyList()
		end
	end
end

-- Give access to a frequency
function GivePlayerAccessToFrequency(value)
	local frequency = tonumber(value)

	if frequency ~= nil then
		if radioConfig.Frequency.Private[frequency] then
			if not radioConfig.Frequency.Access[frequency] then
				radioConfig.Frequency.Access[frequency] = true

				GenerateFrequencyList()
			end
		end
	end
end

function RemovePlayerAccessToFrequency(value)
	local frequency = tonumber(value)

	if frequency ~= nil then
		if radioConfig.Frequency.Access[frequency] then
			radioConfig.Frequency.Access[frequency] = nil

			GenerateFrequencyList()
		end
	end
end

function GivePlayerAccessToFrequencies(...)
	local frequencies = { ... }
	local newFrequencies = {}

	for i = 1, #frequencies do
		local frequency = tonumber(frequencies[i])

		if frequency ~= nil then
			if radioConfig.Frequency.Private[frequency] then
				if not radioConfig.Frequency.Access[frequency] then
					newFrequencies[#newFrequencies + 1] = frequency
				end
			end
		end
	end

	if #newFrequencies > 0 then
		for i = 1, #newFrequencies do
			radioConfig.Frequency.Access[newFrequencies[i]] = true
		end

		GenerateFrequencyList()
	end
end

function RemovePlayerAccessToFrequencies(...)
	local frequencies = { ... }
	local removedFrequencies = {}

	for i = 1, #frequencies do
		local frequency = tonumber(frequencies[i])

		if frequency ~= nil then
			if radioConfig.Frequency.Access[frequency] then
				removedFrequencies[#removedFrequencies + 1] = frequency
			end
		end
	end

	if #removedFrequencies > 0 then
		for i = 1, #removedFrequencies do
			radioConfig.Frequency.Access[removedFrequencies[i]] = nil
		end

		GenerateFrequencyList()
	end
end

exports("IsRadioOpen", IsRadioOpen)
exports("IsRadioOn", IsRadioOn)
exports("IsRadioAvailable", IsRadioAvailable)
exports("IsRadioEnabled", IsRadioEnabled)
exports("CanRadioBeUsed", CanRadioBeUsed)
exports("SetRadioEnabled", SetRadioEnabled)
exports("SetRadio", SetRadio)
exports("SetAllowRadioWhenClosed", SetAllowRadioWhenClosed)
exports("AddPrivateFrequency", AddPrivateFrequency)
exports("RemovePrivateFrequency", RemovePrivateFrequency)
exports("GivePlayerAccessToFrequency", GivePlayerAccessToFrequency)
exports("RemovePlayerAccessToFrequency", RemovePlayerAccessToFrequency)
exports("GivePlayerAccessToFrequencies", GivePlayerAccessToFrequencies)
exports("RemovePlayerAccessToFrequencies", RemovePlayerAccessToFrequencies)

local isBroadcasting = false

AddEventHandler('skam-voice:radioActive', function(broadCasting)
	isBroadcasting = broadCasting
end)

Citizen.CreateThread(function()
	GenerateFrequencyList()

	while true do
		if IsRadioOn() then
			Citizen.Wait(0)
		else
			Citizen.Wait(250)
		end
		local minFrequency = radioConfig.Frequency.List[100]

		if not radioConfig.Frequency.Access[radioConfig.Frequency.Current] and radioConfig.Frequency.Private[radioConfig.Frequency.Current] then
			if Radio.On then
				Radio:Remove()
			end

			radioConfig.Frequency.CurrentIndex = 100
			radioConfig.Frequency.Current = minFrequency

			if Radio.On then
				Radio:Add(radioConfig.Frequency.Current)
			end
		end

		if Radio.Has then
			if IsControlPressed(0, 21) and IsControlJustPressed(0, 174) then
				Radio:DecreaseRestricted()
			end

			if IsControlPressed(0, 21) and IsControlJustPressed(0, 175) then
				Radio:IncreaseRestricted()
			end
		end
	end
end)

AddEventHandler("onClientResourceStart", function(resName)
	if GetCurrentResourceName() ~= resName and "skam-voice" ~= resName then
		return
	end

	exports["skam-voice"]:setVoiceProperty("radioEnabled", false)
	Radio.On = false
end)

RegisterNetEvent("Radio.Toggle")
AddEventHandler("Radio.Toggle", function()
	local playerPed = PlayerPedId()
	local isFalling = IsPedFalling(playerPed)
	local isDead = LocalPlayer.state.dead

	if not isFalling and not isDead and Radio.Enabled and Radio.Has then
		Radio:Toggle(not Radio.Open)
	end
end)

RegisterNetEvent("Radio.Set")
AddEventHandler("Radio.Set", function(value)
	if type(value) == "string" then
		value = value == "true"
	elseif type(value) == "number" then
		value = value == 1
	end

	Radio.Has = value and true or false
end)

RegisterNetEvent("skam-radiolist:item")
AddEventHandler("skam-radiolist:item", function()
	Radio.Has = not Radio.Has
	if Radio.Has then
		Radio.On = true
		exports["skam-voice"]:setVoiceProperty("radioEnabled", true)
		Radio:Add(radioConfig.Frequency.Current)
		ESX.ShowNotification('~g~Włączyłeś/aś radio')
		SendNUIMessage({
			eventName = "nui:radio:update",
			show = true,
		})
	else
		Radio.On = false
		exports["skam-voice"]:setVoiceProperty("radioEnabled", false)
		Radio:Remove()
		SendNUIMessage({
			eventName = "nui:radio:update",
			show = false,
		})
		ESX.ShowNotification('~r~Wyłączyłeś/aś radio')
	end
end)

RegisterCommand('frequency', function()
	if Radio.On then
		if not radioConfig.Controls.Input.Pressed then
			radioConfig.Controls.Input.Pressed = true
			Citizen.CreateThread(function()
				AddTextEntry('skam-radiolist_HELP', "Wprowadź częstotliwość")
				DisplayOnscreenKeyboard(1, 'skam-radiolist_HELP', "", radioConfig.Frequency.Current, "", "", "", 3)

				while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
					Citizen.Wait(150)
				end

				local input = nil

				if UpdateOnscreenKeyboard() ~= 2 then
					input = GetOnscreenKeyboardResult()
				end

				Citizen.Wait(500)

				input = tonumber(input)

				if input ~= nil then
					if input >= 1 and input <= radioConfig.Frequency.List[#radioConfig.Frequency.List] and input == math.floor(input) then
						if not radioConfig.Frequency.Private[input] or radioConfig.Frequency.Access[input] then
							local idx = nil

							for i = 1, #radioConfig.Frequency.List do
								if radioConfig.Frequency.List[i] == input then
									idx = i
									break
								end
							end

							if idx ~= nil then
								if Radio.Enabled then
									Radio:Remove()
								end

								radioConfig.Frequency.CurrentIndex = idx
								radioConfig.Frequency.Current = input

								if Radio.On then
									Radio:Add(radioConfig.Frequency.Current)
									ESX.ShowNotification('~y~Ustawiono częstotliwość na '..radioConfig.Frequency.Current)
								end
							end
						else
							ESX.ShowNotification('~y~Ta częstotliwość jest szyfrowana')
						end
					end
				end

				radioConfig.Controls.Input.Pressed = false
			end)
		end
	end
end, false)

RegisterKeyMapping('frequency', 'Wybór częstotliwości (radio)', 'keyboard', 'EQUALS')

RegisterNetEvent('esx:removeInventoryItem')
AddEventHandler('esx:removeInventoryItem', function(item, count)
	if item == 'radiocrime' or item == 'radio' then
		if count == 0 then
			Radio.Has = false
			Radio.On = false
			exports["skam-voice"]:setVoiceProperty("radioEnabled", false)
			Radio:Remove()
		end
	end
end)

function drawTxt(x, y, width, height, scale, text, r, g, b, a)
	SetTextFont(0);
	SetTextScale(scale, scale);
	SetTextColour(r, g, b, a);
	SetTextOutline();
	SetTextEntry("STRING");
	AddTextComponentString(text);
	DrawText(x - width / 2, y - height / 2 + 0.005);
end

RegisterNetEvent("skam-voice:syncRadioData")
AddEventHandler("skam-voice:syncRadioData", function()
	Citizen.SetTimeout(1000, function ()
		local players = exports["skam-voice"]:getRadioData()
		if not players or type(players) ~= "table" then
			return
		end

		local count = 0
		for id in pairs(players) do
			count = count+1
		end

		Radio.Players = count
	end)
end)

RegisterNetEvent("skam-voice:addPlayerToRadio")
AddEventHandler("skam-voice:addPlayerToRadio", function()
	Citizen.SetTimeout(1000, function ()
		local players = exports["skam-voice"]:getRadioData()
		if not players or type(players) ~= "table" then
			return
		end

		local count = 0
		for id in pairs(players) do
			count = count+1
		end

		Radio.Players = count
	end)
end)

RegisterNetEvent("skam-voice:removePlayerFromRadio")
AddEventHandler("skam-voice:removePlayerFromRadio", function()
	Citizen.SetTimeout(1000, function ()
		local players = exports["skam-voice"]:getRadioData()
		if not players or type(players) ~= "table" then
			return
		end

		local count = 0
		for id in pairs(players) do
			count = count+1
		end

		Radio.Players = count
	end)
end)

InitRestrictedFrequencies = function ()
	local offset = radioConfig.RestrictedOffset

	for _,frequencies in pairs(radioConfig.RestrictedFrequencies) do
		for _,frequency in ipairs(frequencies) do
			frequency = (offset + frequency)

			if not HasPrivateFrequencyExist(frequency) then
				AddPrivateFrequency(frequency)
			end
		end
	end

	RefreshRestrictedFrequenciesAccess()
end

RefreshRestrictedFrequenciesAccess = function ()
	local offset = radioConfig.RestrictedOffset
	local job = ESX.PlayerData.job.name

	radioConfig.Frequency.Access = {}
	GenerateFrequencyList()

	if radioConfig.RestrictedFrequencies[job] then
		for _,frequency in ipairs(radioConfig.RestrictedFrequencies[job]) do
			frequency = (offset + frequency)

			if HasPrivateFrequencyExist(frequency) then
				GivePlayerAccessToFrequency(frequency)
			end
		end
	end
end

RegisterNetEvent("skam-radiolist:hideradiotext")
AddEventHandler("skam-radiolist:hideradiotext", function()
	DrawRadioText = not DrawRadioText
	if DrawRadioText then
		ESX.ShowNotification('~g~Włączono pokazywanie numeru radia')
	else
		ESX.ShowNotification('~r~Wyłączono pokazywanie numeru radia')
	end
end)

RegisterCommand('radiolist', function()
	if Radio.On then
		local players = exports["skam-voice"]:getRadioData()
		local elements = {}
		ESX.TriggerServerCallback('skam-radiolist:crimeRadioList', function(result)
			for k, v in pairs(result) do
				table.insert(elements, {label = '['..v.playerid..'] '..v.names})
			end
			table.insert(elements, {label = 'Łączna liczba osób: '..Radio.Players})
			ESX.UI.Menu.CloseAll()
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'bojowka_radiolist', {
				title = 'Lista osób na radiu: '..radioConfig.Frequency.Current,
				align = 'center',
				elements = elements
			}, function(data, menu)
			end, function(data, menu)
				menu.close()
			end)
		end, players)
	end
end)

RegisterNetEvent("skam-radiolist:addTalking", function(channel, radioinfo)
    SendNUIMessage({
        eventName = "nui:radio:update",
		data = {
			name = channel,
			members = radioinfo,
		}
    })
end)

RegisterNetEvent("skam-radiolist:addTalking2", function(channel, radioinfo)
    SendNUIMessage({
        eventName = "nui:radio:update",
		data = {
			name = channel,
			members = radioinfo,
		}
    })
end)

RegisterNetEvent("skam-radiolist:stopTalking", function(channel, radioinfo)
    SendNUIMessage({
        eventName = "nui:radio:update",
		data = {
			name = channel,
			members = radioinfo,
		}
    })
end)

RegisterNetEvent("skam-radiolist:stopTalking2", function()
    SendNUIMessage({
        eventName = "nui:radio:update",
    })
end)

RegisterNetEvent("skam-radiolist:setTalking", function(playerid)
    SendNUIMessage({
        eventName = "setTalking",
        id = playerid,
    })
end)

RegisterNetEvent("skam-radiolist:setNotTalking", function(playerid)
    SendNUIMessage({
        eventName = "nui:radio:update",
        id = playerid,
    })
end)

RegisterNetEvent("skam-radiolist:setPlayerDead", function(channel, radioinfo)
	SendNUIMessage({
        eventName = "nui:radio:update",
		data = {
			name = channel,
			members = radioinfo,
		}
    })
end)

RegisterNetEvent("skam-radiolist:setTalking", function(channel, radioinfo)
	SendNUIMessage({
        eventName = "nui:radio:update",
		data = {
			name = channel,
			members = radioinfo,
		}
    })
end)

RegisterNetEvent("skam-radiolist:setNotTalking", function(channel, radioinfo)
	SendNUIMessage({
        eventName = "nui:radio:update",
		data = {
			name = channel,
			members = radioinfo,
		}
    })
end)