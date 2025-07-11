local mutedPlayers = {}
local lastMuteToggle = {}
local volumes = {
	['radio'] = GetConvarInt('voice_defaultRadioVolume', 30) / 100,
	['phone'] = GetConvarInt('voice_defaultPhoneVolume', 60) / 100,
}

radioEnabled, radioPressed, mode = true, false, GetConvarInt('voice_defaultVoiceMode', 2)
radioData = {}
callData = {}
local radioeffect = true

function setVolume(volume, volumeType)
	type_check({volume, "number"})
	local volume = volume / 100
	
	if volumeType then
		local volumeTbl = volumes[volumeType]
		if volumeTbl then
			LocalPlayer.state:set(volumeType, volume, true)
			volumes[volumeType] = volume
		else
			error(('setVolume got a invalid volume type %s'):format(volumeType))
		end
	else
		for _type, vol in pairs(volumes) do
			volumes[_type] = volume
			LocalPlayer.state:set(_type, volume, true)
		end
	end
end

RegisterCommand('radioeffect', function(_, args)
	if LocalPlayer.state.radioChannel == 0 then
		radioeffect = not radioeffect
		if radioeffect then
			TriggerEvent("FeedM:showNotification", '~g~Włączyłeś efekt radia')
		else
			TriggerEvent("FeedM:showNotification", '~r~Wyłączyłeś efekt radia')
		end
	else
		TriggerEvent("FeedM:showNotification", '~r~Wyłącz radio, aby użyć tej komendy')
	end
end)

exports('setRadioVolume', function(vol)
	setVolume(vol, 'radio')
end)
exports('getRadioVolume', function()
	return volumes['radio']
end)
exports("setCallVolume", function(vol)
	setVolume(vol, 'phone')
end)
exports('getCallVolume', function()
	return volumes['phone']
end)

if gameVersion == 'fivem' then
	radioEffectId = CreateAudioSubmix('Radio')
	SetAudioSubmixEffectRadioFx(radioEffectId, 0)
	SetAudioSubmixEffectParamInt(radioEffectId, 0, `default`, 1)
	AddAudioSubmixOutput(radioEffectId, 0)

	phoneEffectId = CreateAudioSubmix('Phone')
	SetAudioSubmixEffectRadioFx(phoneEffectId, 1)
	SetAudioSubmixEffectParamInt(phoneEffectId, 1, `default`, 1)
	SetAudioSubmixEffectParamFloat(phoneEffectId, 1, `freq_low`, 300.0)
	SetAudioSubmixEffectParamFloat(phoneEffectId, 1, `freq_hi`, 6000.0)
	AddAudioSubmixOutput(phoneEffectId, 1)
end

local submixFunctions = {
	['radio'] = function(plySource)
		MumbleSetSubmixForServerId(plySource, radioEffectId)
	end,
	['phone'] = function(plySource)
		MumbleSetSubmixForServerId(plySource, phoneEffectId)
	end
}

local disableSubmixReset = {}
function toggleVoice(plySource, enabled, moduleType)
	if mutedPlayers[plySource] then return end
	logger.verbose('[main] Updating %s to talking: %s with submix %s', plySource, enabled, moduleType)
	if enabled then
		MumbleSetVolumeOverrideByServerId(plySource, enabled and volumes[moduleType])
		if radioeffect then
			if GetConvarInt('voice_enableSubmix', 1) == 1 and gameVersion == 'fivem' then
				if moduleType then
					disableSubmixReset[plySource] = true
					submixFunctions[moduleType](plySource)
				else
					MumbleSetSubmixForServerId(plySource, -1)
				end
			end
		end
	else
		if radioeffect then
			if GetConvarInt('voice_enableSubmix', 1) == 1 and gameVersion == 'fivem' then
				disableSubmixReset[plySource] = nil
				SetTimeout(250, function()
					if not disableSubmixReset[plySource] then
						MumbleSetSubmixForServerId(plySource, -1)
					end
				end)
			end
		end
		MumbleSetVolumeOverrideByServerId(plySource, -1.0)
	end
end

function playerTargets(...)
	local targets = {...}
	local addedPlayers = {
		[playerServerId] = true
	}

	for i = 1, #targets do
		for id, _ in pairs(targets[i]) do
			if addedPlayers[id] and id ~= playerServerId then
				logger.verbose('[main] %s is already target don\'t re-add', id)
				goto skip_loop
			end
			if not addedPlayers[id] then
				logger.verbose('[main] Adding %s as a voice target', id)
				addedPlayers[id] = true
				MumbleAddVoiceTargetPlayerByServerId(voiceTarget, id)
			end
			::skip_loop::
		end
	end
end

function playMicClicks(clickType)
	if micClicks ~= 'true' then return logger.verbose("Not playing mic clicks because client has them disabled") end
	sendUIMessage({
		sound = (clickType and "audio_on" or "audio_off"),
		volume = (clickType and volumes["radio"] or 0.05)
	})
end

function toggleMutePlayer(source)
    local now = GetGameTimer()
    if lastMuteToggle[source] and now - lastMuteToggle[source] < 500 then return end
    lastMuteToggle[source] = now

    if mutedPlayers[source] then
        mutedPlayers[source] = nil
        MumbleSetVolumeOverrideByServerId(source, -1.0)
    else
        mutedPlayers[source] = true
        MumbleSetVolumeOverrideByServerId(source, 0.0)
    end
end

exports('toggleMutePlayer', toggleMutePlayer)
RegisterNetEvent('skam-voice:toggleMute', function(source)
    toggleMutePlayer(source)
end)

function setVoiceProperty(type, value)
	if type == "radioEnabled" then
		radioEnabled = value
		sendUIMessage({
			radioEnabled = value
		})
	elseif type == "micClicks" then
		local val = tostring(value)
		micClicks = val
		SetResourceKvp('skam-voice_enableMicClicks', val)
	end
end
exports('setVoiceProperty', setVoiceProperty)
exports('SetMumbleProperty', setVoiceProperty)
exports('SetTokoProperty', setVoiceProperty)