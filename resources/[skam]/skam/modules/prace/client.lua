local remainingWorks = 0
local jailLocations = {
    vector3(1626.6000, 2492.2981, 45.5790 - 0.9),
    vector3(1599.8596, 2553.8760, 45.5663 - 0.9),
    vector3(1636.3612, 2564.3706, 45.5649 - 0.9),
    vector3(1691.5515, 2564.5344, 45.5649 - 0.9),
    vector3(1719.5643, 2565.6541, 45.5649 - 0.9),
    vector3(1765.5985, 2564.6248, 45.5650 - 0.9),
    vector3(1753.1661, 2503.2451, 45.5692 - 0.9),
    vector3(1723.9165, 2507.8157, 45.5654 - 0.9),
    vector3(1654.7190, 2541.3433, 45.5649 - 0.9),
    vector3(1709.7092, 2526.9133, 45.5649 - 0.9),
}
local visited = {}
local currentPlace = nil
local startWorkPos = nil
local maxDistance = 120.0
local buyoutLocation = vector3(1664.0663, 2533.8523, 45.5649 - 0.9)
local freedomLocation = vector3(1008.0255, -2521.1970, 28.3050 - 0.9)

local currentWorkMarker = nil

function removeCurrentWorkMarker()
    if currentWorkMarker then
        SKAM.RemoveMarker(currentWorkMarker)
        currentWorkMarker = nil
    end
end

function pickRandomPlace()
    local left = {}
    for i=1,#jailLocations do
        if not visited[i] then table.insert(left, i) end
    end
    if #left == 0 then return nil end
    return left[math.random(1, #left)]
end

function pickAndShowNextWork()
    removeCurrentWorkMarker()
    currentPlace = pickRandomPlace()
    if currentPlace then
        local pos = jailLocations[currentPlace]
        currentWorkMarker = SKAM.RegisterPlace({
            coords = pos,
            Marker = {size = vector3(2.0,2.0,0.3)},
            txt3d = "zacząć pracę społeczną",
            onPress = function()
                if remainingWorks > 0 and currentPlace then
                    exports['skam-ui']:showProgress('Wykonujesz pracę społeczną...', 5000, function(isFinished)
                        if isFinished then
                            visited[currentPlace] = true
                            TriggerServerEvent("skam$prace:doneOneWork")
                            pickAndShowNextWork()
                            if not startWorkPos then
                                startWorkPos = jailLocations[currentPlace]
                            end
                        else
                            ESX.ShowNotification("Przerwałeś wykonywanie pracy!")
                        end
                    end)
                end
            end,
            onExit = function()
                exports['skam-ui']:hideProgress()
            end,
        })
    else
        currentPlace = nil
        removeCurrentWorkMarker()
    end
end

RegisterNetEvent("skam$prace:clearJob")
AddEventHandler("skam$prace:clearJob", function()
    remainingWorks = 0
    startWorkPos = nil
    visited = {}
    currentPlace = nil
    removeCurrentWorkMarker()
    local ped = PlayerPedId()
    SetEntityCoords(ped, freedomLocation.x, freedomLocation.y, freedomLocation.z + 1.0, false, false, false, false)
    ESX.ShowNotification("Wykonałeś wszystkie prace i zostałeś przeniesiony!")
end)

RegisterNetEvent("skam$prace:setStartPos")
AddEventHandler("skam$prace:setStartPos", function(x, y, z)
    startWorkPos = vector3(x, y, z)
end)

RegisterNetEvent("skam$prace:teleportToStart")
AddEventHandler("skam$prace:teleportToStart", function(x, y, z)
    local ped = PlayerPedId()
    SetEntityCoords(ped, x, y, z + 1.0, false, false, false, false)
end)

RegisterNetEvent("skam$prace:setJobCount")
AddEventHandler("skam$prace:setJobCount", function(count)
    remainingWorks = count
    if count > 0 then
        visited = {}
        pickAndShowNextWork()
    else
        removeCurrentWorkMarker()
        currentPlace = nil
    end
end)

SKAM.RegisterPlace({
    coords = buyoutLocation,
    Marker = {size = vector3(2.0,2.0,0.2)},
    txt3d = "wykupić się z prac",
    onPress = function()
        if remainingWorks > 0 then
            TriggerServerEvent("skam$prace:buyFreedom")
        else
            ESX.ShowNotification("Nie masz żadnych prac do wykupienia!")
        end
    end
})

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if remainingWorks > 0 and startWorkPos then
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)
            if #(coords - startWorkPos) > maxDistance then
                SetEntityCoords(ped, startWorkPos.x, startWorkPos.y, startWorkPos.z + 1.0, false, false, false, false)
                ESX.ShowNotification("Nie możesz oddalać się od miejsca prac!")
            end
        end
    end
end)

function DrawHelp3D(coords, text)
    local scale = 0.35
    local x, y, z = coords.x, coords.y, coords.z
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local camCoords = GetGameplayCamCoords()
    local dist = #(vector3(x, y, z) - camCoords)
    local fov = (1 / GetGameplayCamFov()) * 100
    local finalScale = math.min(0.7, math.max(0.25, scale * (1 / dist) * 2 * fov))

    if onScreen then
        SetTextScale(finalScale, finalScale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextCentre(true)
        SetTextEntry("STRING")
        AddTextComponentString(text)

        SetTextColour(255, 255, 255, 255)
        SetTextOutline()
        SetTextDropShadow()
        DrawText(_x, _y)
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if remainingWorks > 0 and currentPlace and jailLocations[currentPlace] then
            DrawHelp3D(GetEntityCoords(PlayerPedId()), ("POZOSTAŁO: ~c~%s"):format(remainingWorks))
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local targetCoords = jailLocations[currentPlace]
            DrawLine(playerCoords.x, playerCoords.y, playerCoords.z, targetCoords.x, targetCoords.y, targetCoords.z, 255, 255, 255, 255)
        end
    end
end)

AddEventHandler("playerSpawned", function()
    TriggerServerEvent("skam$prace:requestJobCount")
end)