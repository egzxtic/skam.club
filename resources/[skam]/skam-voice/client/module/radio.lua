local radioChannel = 0
local radioNames = {}

function syncRadioData(radioTable, localPlyRadioName)
	radioData = radioTable
	logger.info('[radio] Syncing radio table.')
	if GetConvarInt('voice_debugMode', 0) >= 4 then
		print('-------- RADIO TABLE --------')
		tPrint(radioData)
		print('-----------------------------')
	end
	for tgt, enabled in pairs(radioTable) do
		if tgt ~= playerServerId then
			toggleVoice(tgt, enabled, 'radio')
		end
	end
	if GetConvarInt("voice_syncPlayerNames", 0) == 1 then
		radioNames[playerServerId] = localPlyRadioName
	end
end
RegisterNetEvent('skam-voice:syncRadioData', syncRadioData)

Display = {}
DisplayStr = nil

function setTalkingOnRadio(plySource, enabled)
	if enabled then
		table.insert(Display, plySource)
	else
		for k,v in pairs(Display) do
			if v == plySource then
				table.remove(Display, k)
				break
			end
		end
	end
	toggleVoice(plySource, enabled, 'radio')
	radioData[plySource] = enabled
	--playMicClicks(enabled)
end

Citizen.CreateThread(function()
	local wait = 0
	while true do
		if DisplayStr then
			wait = 0
		else 
			wait = 500
		end
		Citizen.Wait(wait)
	end
end)

DrawTick = function()
	SetTextScale(0.45, 0.45)
	SetTextFont(4)
	SetTextColour(0, 255, 200, 200)
	SetTextDropshadow(0, 0, 0, 0, 200)
	SetTextDropShadow()
	SetTextOutline()

	BeginTextCommandDisplayText('STRING')
	AddTextComponentSubstringPlayerName(DisplayStr)
	if LocalPlayer.state.oldhud then
		if IsRadarHidden() then
			EndTextCommandDisplayText(0.165, (1.015-(0.0295*(#Display+1))))
		else
			EndTextCommandDisplayText(0.165, (1.015-(0.0295*(#Display+1))))
		end
	else
		if IsRadarHidden() then
			EndTextCommandDisplayText(0.165, (1.015-(0.0295*(#Display+1))))
		else
			EndTextCommandDisplayText(0.01, (0.995-(0.0295*(#Display+1))))
		end
	end
end

UpdateDisplay = function()

	table.sort(Display, function(a,b) return a < b end)

	if #Display > 0 then
		DisplayStr = table.concat(Display, "\n")
	else DisplayStr = nil end

	Citizen.SetTimeout(100, UpdateDisplay)
end
Citizen.SetTimeout(0, UpdateDisplay)

RegisterNetEvent('skam-voice:setTalkingOnRadio', setTalkingOnRadio)

function addPlayerToRadio(plySource, plyRadioName)
	radioData[plySource] = false
	if GetConvarInt("voice_syncPlayerNames", 0) == 1 then
		radioNames[plySource] = plyRadioName
	end
	if radioPressed then
		playerTargets(radioData, MumbleIsPlayerTalking(PlayerId()) and callData or {})
	end
end
RegisterNetEvent('skam-voice:addPlayerToRadio', addPlayerToRadio)

function removePlayerFromRadio(plySource)
	if plySource == playerServerId then
		for tgt, _ in pairs(radioData) do
			if tgt ~= playerServerId then
				toggleVoice(tgt, false, 'radio')
			end
		end
		radioNames = {}
		radioData = {}
		Display = {}
		playerTargets(MumbleIsPlayerTalking(PlayerId()) and callData or {})
	else
		toggleVoice(plySource, false)
		if radioPressed then
			playerTargets(radioData, MumbleIsPlayerTalking(PlayerId()) and callData or {})
		end
		radioData[plySource] = nil
		if GetConvarInt("voice_syncPlayerNames", 0) == 1 then
			radioNames[plySource] = nil
		end
	end
end
RegisterNetEvent('skam-voice:removePlayerFromRadio', removePlayerFromRadio)

function setRadioChannel(channel)
	if GetConvarInt('voice_enableRadios', 1) ~= 1 then return end
	type_check({channel, "number"})
	TriggerServerEvent('skam-voice:setPlayerRadio', channel)
	radioChannel = channel
	sendUIMessage({
		radioChannel = channel,
		radioEnabled = radioEnabled
	})
	TriggerEvent('skam-ui:updateHud', {
		radioChannel = channel
	})
end

exports('setRadioChannel', setRadioChannel)
exports('SetRadioChannel', setRadioChannel)

exports('removePlayerFromRadio', function()
	setRadioChannel(0)
end)

exports('addPlayerToRadio', function(_radio)
	local radio = tonumber(_radio)
	if radio then
		setRadioChannel(radio)
	end
end)

exports('getRadioData', function()
	return radioData
end)

function isDead()
	if GetResourceState("pma-ambulance") ~= "missing" then
		if LocalPlayer.state.isDead then
			return true
		end
	elseif LocalPlayer.state.dead then
		return true
	end
end

RegisterCommand('+radiotalk', function()
	if GetConvarInt('voice_enableRadios', 1) ~= 1 then return end
	if isDead() then return end
	if IsPedCuffed(PlayerPedId()) then return end

	if not radioPressed and radioEnabled then
		if radioChannel > 0 then
			logger.info('[radio] Start broadcasting, update targets and notify server.')
			playerTargets(radioData, MumbleIsPlayerTalking(PlayerId()) and callData or {})
			TriggerServerEvent('skam-voice:setTalkingOnRadio', true)
			radioPressed = true
			playMicClicks(true)
			if GetConvarInt('voice_enableRadioAnim', 0) == 1 and not (GetConvarInt('voice_disableVehicleRadioAnim', 0) == 1 and IsPedInAnyVehicle(PlayerPedId(), false)) then
				if radioChannel > 13 then
					RequestAnimDict('random@arrests')
					while not HasAnimDictLoaded('random@arrests') do
						Citizen.Wait(100)
					end
					TaskPlayAnim(PlayerPedId(), "random@arrests", "generic_radio_enter", 8.0, 2.0, -1, 50, 1.0, 0, 0, 0)
				else
					RequestAnimDict('amb@code_human_police_investigate@idle_a')
					while not HasAnimDictLoaded('amb@code_human_police_investigate@idle_a') do
						Citizen.Wait(100)
					end
					TaskPlayAnim(PlayerPedId(), "amb@code_human_police_investigate@idle_a","idle_b", 8.0, 2.0, -1, 49, 1.0, 0, 0, 0)
				end
			end
			Citizen.CreateThread(function()
				TriggerEvent("skam-voicee:radioActive", true)
				while radioPressed do
					Wait(50)
					SetControlNormal(0, 249, 1.0)
					SetControlNormal(1, 249, 1.0)
					SetControlNormal(2, 249, 1.0)
					if LocalPlayer.state.dead then
						ExecuteCommand('-radiotalk')
					end
				end
			end)
		end
	end
end, false)

RegisterCommand('-radiotalk', function()
	if radioChannel > 0 and radioEnabled and radioPressed then
		radioPressed = false
		MumbleClearVoiceTargetPlayers(voiceTarget)
		playerTargets(MumbleIsPlayerTalking(PlayerId()) and callData or {})
		TriggerEvent("skam-voice:radioActive", false)
		playMicClicks(false)
		if GetConvarInt('voice_enableRadioAnim', 0) == 1 then
			if radioChannel > 13 then
				StopAnimTask(PlayerPedId(), "random@arrests", "generic_radio_enter", -4.0)
			else
				StopAnimTask(PlayerPedId(), "amb@code_human_police_investigate@idle_a", "idle_b", -4.0)
			end
		end
		TriggerServerEvent('skam-voice:setTalkingOnRadio', false)
	end
end, false)
if gameVersion == 'fivem' then
	RegisterKeyMapping('+radiotalk', 'Rozmowa przez radio', 'keyboard', GetConvar('voice_defaultRadio', 'LMENU'))
end

function syncRadio(_radioChannel)
	if GetConvarInt('voice_enableRadios', 1) ~= 1 then return end
	logger.info('[radio] radio set serverside update to radio %s', radioChannel)
	radioChannel = _radioChannel
end
RegisterNetEvent('skam-voice:clSetPlayerRadio', syncRadio)
