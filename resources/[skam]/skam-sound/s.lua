local allowedSounds = {
  ['co-kurwa.ogg'] = true,
  ['cuff.ogg'] = true,
  ['czarnymedyk.ogg'] = true,
  ['dobra-nie-wnikam.ogg'] = true,
  ['fight.ogg'] = true,
  ['first.ogg'] = true,
  ['gramy.ogg'] = true,
  ['jasperdiscord.ogg'] = true,
  ['knocked.ogg'] = true,
  ['koles-ma-snajpe.ogg'] = true,
  ['kurwa-co-za-debil-jebany.ogg'] = true,
  ['listwa.ogg'] = true,
  ['lock.ogg'] = true,
  ['mic_click_off.ogg'] = true,
  ['mic_click_on.ogg'] = true,
  ['o-kurwa.ogg'] = true,
  ['revive.ogg'] = true,
  ['stonoga.ogg'] = true,
  ['ta-napewno-mordo.ogg'] = true,
  ['uncuff.ogg'] = true,
  ['unstop.ogg'] = true,
}

RegisterNetEvent('skam$sound:server:play')
AddEventHandler('skam$sound:server:play', function(soundFile, soundVolume)
    local src = source
    if not allowedSounds[soundFile] then
        print(('[WARNING] %s próbował odtworzyć nieautoryzowany dźwięk: %s'):format(GetPlayerName(src), tostring(soundFile)))
        return
    end
    if type(soundVolume) ~= 'number' or soundVolume < 0 or soundVolume > 1.0 then
        print(('[WARNING] %s podał nieprawidłową głośność: %s'):format(GetPlayerName(src), tostring(soundVolume)))
        return
    end
    TriggerClientEvent('skam$sound:client:play', src, soundFile, soundVolume)
end)

RegisterNetEvent('skam$sound:server:playdist')
AddEventHandler('skam$sound:server:playdist', function(maxDistance, soundFile, soundVolume)
    local src = source
    local DistanceLimit = 40
    if not allowedSounds[soundFile] then
        print(('[WARNING] %s próbował odtworzyć nieautoryzowany dźwięk: %s'):format(GetPlayerName(src), tostring(soundFile)))
        return
    end
    if type(soundVolume) ~= 'number' or soundVolume < 0 or soundVolume > 1.0 then
        print(('[WARNING] %s podał nieprawidłową głośność: %s'):format(GetPlayerName(src), tostring(soundVolume)))
        return
    end
    if type(maxDistance) ~= 'number' or maxDistance < 1 or maxDistance > DistanceLimit then
        print(('[WARNING] %s próbował ustawić nieprawidłowy dystans: %s'):format(GetPlayerName(src), tostring(maxDistance)))
        return
    end
    local ped = GetPlayerPed(src)
    if not ped then return end
    local coords = GetEntityCoords(ped)
    TriggerClientEvent('skam$sound:client:playdist', -1, coords, maxDistance, soundFile, soundVolume)
end)