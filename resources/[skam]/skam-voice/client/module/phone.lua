local callChannel = 0

local function createPhoneThread()
	Citizen.CreateThread(function()
		local changed = false
		while callChannel ~= 0 do
			if MumbleIsPlayerTalking(PlayerId()) and not changed then
				changed = true
				playerTargets(radioPressed and radioData or {}, callData)
				TriggerServerEvent('skam-voice:setTalkingOnCall', true)
			elseif changed and MumbleIsPlayerTalking(PlayerId()) ~= 1 then
				changed = false
				MumbleClearVoiceTargetPlayers(voiceTarget)
				TriggerServerEvent('skam-voice:setTalkingOnCall', false)
			end
			Wait(200)
		end
	end)
end

RegisterNetEvent('skam-voice:syncCallData', function(callTable, channel)
	callData = callTable
	for tgt, enabled in pairs(callTable) do
		if tgt ~= playerServerId then
			toggleVoice(tgt, enabled, 'phone')
		end
	end
end)

RegisterNetEvent('skam-voice:setTalkingOnCall', function(tgt, enabled)
	if tgt ~= playerServerId then
		callData[tgt] = enabled
		toggleVoice(tgt, enabled, 'phone')
	end
end)

RegisterNetEvent('skam-voice:addPlayerToCall', function(plySource)
	callData[plySource] = false
end)

RegisterNetEvent('skam-voice:removePlayerFromCall', function(plySource)
	if plySource == playerServerId then
		for tgt, _ in pairs(callData) do
			if tgt ~= playerServerId then
				toggleVoice(tgt, false, 'phone')
			end
		end
		callData = {}
		MumbleClearVoiceTargetPlayers(voiceTarget)
		playerTargets(radioPressed and radioData or {}, callData)
	else
		callData[plySource] = nil
		toggleVoice(plySource, false, 'phone')
		if MumbleIsPlayerTalking(PlayerId()) then
			MumbleClearVoiceTargetPlayers(voiceTarget)
			playerTargets(radioPressed and radioData or {}, callData)
		end
	end
end)

function setCallChannel(channel)
	if GetConvarInt('voice_enablePhones', 1) ~= 1 then return end
	TriggerServerEvent('skam-voice:setPlayerCall', channel)
	callChannel = channel
	sendUIMessage({
		callInfo = channel
	})
	createPhoneThread()
end

exports('setCallChannel', setCallChannel)
exports('SetCallChannel', setCallChannel)

exports('addPlayerToCall', function(_call)
	local call = tonumber(_call)
	if call then
		setCallChannel(call)
	end
end)
exports('removePlayerFromCall', function()
	setCallChannel(0)
end)

RegisterNetEvent('skam-voice:clSetPlayerCall', function(_callChannel)
	if GetConvarInt('voice_enablePhones', 1) ~= 1 then return end
	callChannel = _callChannel
	createPhoneThread()
end)
