function handleInitialState()
	local voiceModeData = Cfg.voiceModes[mode]
	MumbleSetTalkerProximity(voiceModeData[1] + 0.0)
	MumbleClearVoiceTarget(voiceTarget)
	MumbleSetVoiceTarget(voiceTarget)
	MumbleSetVoiceChannel(playerServerId)
	while MumbleGetVoiceChannelFromServerId(playerServerId) ~= playerServerId do
		Wait(250)
	end
	MumbleAddVoiceTargetChannel(voiceTarget, playerServerId)
	addNearbyPlayers()
end

AddEventHandler('mumbleConnected', function(address, isReconnecting)
	local voiceModeData = Cfg.voiceModes[mode]
	LocalPlayer.state:set('proximity', {
		index = mode,
		distance =  voiceModeData[1],
		mode = voiceModeData[2],
	}, true)
	handleInitialState()
end)

AddEventHandler('mumbleDisconnected', function(address)
	logger.info('Disconnected from mumble server with address of %s', GetConvarInt('voice_hideEndpoints', 1) == 1 and 'HIDDEN' or address)
end)

AddEventHandler('skam-voice:settingsCallback', function(cb)
	cb(Cfg)
end)