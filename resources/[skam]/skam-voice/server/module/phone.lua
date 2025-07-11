function removePlayerFromCall(source, callChannel)
    logger.verbose('[phone] Removed %s from call %s', source, callChannel)

    callData[callChannel] = callData[callChannel] or {}
    for player, _ in pairs(callData[callChannel]) do
        TriggerClientEvent('skam-voice:removePlayerFromCall', player, source)
    end
    callData[callChannel][source] = nil
    voiceData[source] = voiceData[source] or defaultTable(source)
    voiceData[source].call = 0
end

function addPlayerToCall(source, callChannel)
    logger.verbose('[phone] Added %s to call %s', source, callChannel)
    callData[callChannel] = callData[callChannel] or {}
    for player, _ in pairs(callData[callChannel]) do
       if player ~= source then
            TriggerClientEvent('skam-voice:addPlayerToCall', player, source)
        end
    end
    callData[callChannel][source] = false
    voiceData[source] = voiceData[source] or defaultTable(source)
    voiceData[source].call = callChannel
    TriggerClientEvent('skam-voice:syncCallData', source, callData[callChannel])
end

function setPlayerCall(source, _callChannel)
	if GetConvarInt('voice_enablePhones', 1) ~= 1 then return end
    voiceData[source] = voiceData[source] or defaultTable(source)
    local isResource = GetInvokingResource()
    local plyVoice = voiceData[source]
    local callChannel = tonumber(_callChannel)
    if not callChannel then
		if isResource then
			error(("'callChannel' expected 'number', got: %s"):format(type(_callChannel)))
		else
			return logger.warn("%s sent a invalid call, 'callChannel' expected 'number', got: %s", source,type(_callChannel))
		end
	end
	if isResource then
		TriggerClientEvent('skam-voice:clSetPlayerCall', source, callChannel)
	end

    Player(source).state.callChannel = callChannel

    if callChannel ~= 0 and plyVoice.call == 0 then
        addPlayerToCall(source, callChannel)
    elseif callChannel == 0 then
        removePlayerFromCall(source, plyVoice.call)
    elseif plyVoice.call > 0 then
        removePlayerFromCall(source, plyVoice.call)
        addPlayerToCall(source, callChannel)
    end
end
exports('setPlayerCall', setPlayerCall)

RegisterNetEvent('skam-voice:setPlayerCall', function(callChannel)
    setPlayerCall(source, callChannel)
end)

function setTalkingOnCall(talking)
	if GetConvarInt('voice_enablePhones', 1) ~= 1 then return end
    local source = source
    voiceData[source] = voiceData[source] or defaultTable(source)
    local plyVoice = voiceData[source]
    local callTbl = callData[plyVoice.call]
    if callTbl then
        logger.verbose('[phone] %s %s talking in call %s', source, talking and 'started' or 'stopped', plyVoice.call)
        for player, _ in pairs(callTbl) do
            if player ~= source then
                logger.verbose('[call] Sending event to %s to tell them that %s is talking', player, source)
                TriggerClientEvent('skam-voice:setTalkingOnCall', player, source, talking)
            end
        end
    else
        logger.verbose('[phone] %s tried to talk in call %s, but it doesnt exist.', source, plyVoice.call)
    end
end
RegisterNetEvent('skam-voice:setTalkingOnCall', setTalkingOnCall)