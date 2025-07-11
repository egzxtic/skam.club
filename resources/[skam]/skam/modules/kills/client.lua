local started = false
local headBones = {
    1356,
    11174,
    12844,
    14201,
    17188,
    17719,
    18905,
    19336,
    20178,
    20279,
    20623,
    21550,
    25260,
    27474,
    29868,
    31086,
    35731,
    37193,
    39317,
    40269,
    43536,
    45750,
    46240,
    47419,
    47495,
    49979,
    58331,
    61839,
    65068,
    65245,
}

RegisterNetEvent('playerSpawned')
AddEventHandler('playerSpawned', function()
    if not started then
        CreateThread(function()
            started = true
            while true do
                Wait(1)
                local ped = GetPlayerPed(-1)
                local cv, boneIndex = GetPedLastDamageBone(ped)
                for _, headBone in ipairs(headBones) do
                    if boneIndex == headBone then
                        started = false
                        ApplyDamageToPed(ped, 500, 1)
                        break
                    end
                end
                if not started then
                    break
                end
            end
        end)
    end
end)