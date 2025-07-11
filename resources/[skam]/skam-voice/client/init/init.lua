AddEventHandler('onClientResourceStart', function(resource)
    if resource ~= GetCurrentResourceName() then
        return
    end

    local success = pcall(function()
        local micClicksKvp = GetResourceKvpString('skam-voice_enableMicClicks')
        if not micClicksKvp then
            SetResourceKvp('skam-voice_enableMicClicks', tostring(true))
        else
            if micClicksKvp ~= 'true' and micClicksKvp ~= 'false' then
                error('Invalid Kvp, throwing error for automatic cleaning')
            end
            micClicks = micClicksKvp
        end
    end)

    if not success then
        logger.warn('Failed to load resource Kvp, likely was inappropriately modified by another server, resetting the Kvp.')
        SetResourceKvp('skam-voice_enableMicClicks', tostring(true))
        micClicks = 'true'
    end
    
    sendUIMessage({
        uiEnabled = GetConvarInt("voice_enableUi", 1) == 1,
        voiceModes = json.encode(Cfg.voiceModes),
        voiceMode = mode - 1
    })

    if LocalPlayer.state.radioChannel ~= 0 then
        setRadioChannel(LocalPlayer.state.radioChannel)
    end

    if LocalPlayer.state.callChannel ~= 0 then
        setCallChannel(LocalPlayer.state.callChannel)
    end
end)