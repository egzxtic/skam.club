local garageZones = {
    { coords = vector3(1000.3340, -2508.8540, 28.3001 - 0.9), blip = false },
    { coords = vector3(2774.7571, 3462.0398, 55.5331 - 0.9), blip = false },
    { coords = vector3(-9.3604, -1083.1279, 26.6138 - 0.9), blip = false },
    { coords = vector3(324.8375, -212.2402, 54.0863 - 0.9), blip = true },
    { coords = vector3(-1120.7118, 13.6783, 49.9639 - 0.9), blip = false }, -- GOLFOWE
}
local closeNUI = function()
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "closeGarage" })
end

for _, zone in ipairs(garageZones) do
    if zone.blip then
        local blip = AddBlipForCoord(zone.coords)
        SetBlipSprite(blip, 811)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.5)
        SetBlipColour(blip, 4)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('GARAŻ')
        EndTextCommandSetBlipName(blip)
    end

    SKAM.RegisterPlace({
        coords = zone.coords,
        Marker = {type = 27, size = vector3(5.0,5.0,0.3), dist = 10.0},
        txt3d = nil,
        onPress = function()
            local ped = PlayerPedId()
            if IsPedInAnyVehicle(ped) then
                local vehicle = GetVehiclePedIsIn(ped, false)
                local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
                ESX.TriggerServerCallback("skam$garage:putVehicle", function(isOwned)
                    if isOwned then
                        ESX.Game.DeleteVehicle(vehicle)
                        ESX.ShowNotification('Pojazd został odstawiony do garażu!')
                    else
                        ESX.ShowNotification('Nie możesz odstawiać nie swojego pojazdu!')
                    end
                end, vehicleProps.plate, vehicleProps)
            else
                SetNuiFocus(true, true)
                SendNUIMessage({ action = "openGarage" })
            end
        end,
        onExit = function()
            closeNUI()
        end
    })
end

RegisterNUICallback("getVehiclesData", function(data, cb)
    ESX.TriggerServerCallback("skam$garage:getVehiclesData", function(vehicles)
        for i, v in ipairs(vehicles) do
            local model = tonumber(v.model) or v.model
            local displayName = GetDisplayNameFromVehicleModel(model)
            local label = GetLabelText(displayName)
            if not label or label == "NULL" or label == displayName then
                v.name = displayName or "Nieznany pojazd"
            else
                v.name = label
            end
        end
        cb(vehicles)
    end, data.section)
    --print("Pobrano dane pojazdów z serwera dla sekcji: " .. data.section)
end)

RegisterNUICallback("spawnVehicle", function(data, cb)
    closeNUI()
    TriggerServerEvent("skam$garage:spawnVehicle", data.plate)
    cb({})
end)

RegisterNUICallback("addSubOwner", function(data, cb)
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'add_subowner', {
        title = "Podaj ID gracza, którego chcesz dodać jako współwłaściciela"
    }, function(dialogData, menu)
        local targetId = tonumber(dialogData.value)
        local myId = GetPlayerServerId(PlayerId())
        if not targetId then
            ESX.ShowNotification("Musisz wpisać poprawne ID gracza!")
        elseif targetId == myId then
            ESX.ShowNotification("Nie możesz dodać siebie jako współwłaściciela!")
        else
            TriggerServerEvent("skam$garage:addSubOwner", data.plate, targetId)
        end
        menu.close()
        cb({})
    end, function(data2, menu)
        menu.close()
        cb({})
    end)
end)

RegisterNUICallback("delSubOwner", function(data, cb)
    ESX.TriggerServerCallback('skam$garage:getSubOwners', function(subOwners)
        if not subOwners or #subOwners == 0 then
            ESX.ShowNotification("Brak współwłaścicieli tego pojazdu.")
            cb({})
            return
        end
        local elements = {}
        for _, owner in ipairs(subOwners) do
            table.insert(elements, {
                label = owner.label .. " [" .. owner.id .. "]",
                value = owner.id
            })
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'del_subowner_menu', {
            title = 'Usuń współwłaściciela',
            align = 'center',
            elements = elements
        }, function(menuData, menu)
            TriggerServerEvent("skam$garage:delSubOwner", data.plate, menuData.current.value)
            menu.close()
            cb({})
        end, function(data2, menu)
            menu.close()
            cb({})
        end)
    end, data.plate)
end)

RegisterNUICallback("unchlowVehicle", function(data, cb)
    closeNUI()
    TriggerServerEvent("skam$garage:unchlowVehicle", data.plate)
    cb({})
end)

RegisterNUICallback("unchlowAllVehicles", function(_, cb)
    closeNUI()
    TriggerServerEvent("skam$garage:unchlowAllVehicles")
    cb({})
end)

RegisterNetEvent("skam$garage:forceDeleteVehicleByPlate", function(plate)
    for veh in EnumerateVehicles() do
        if DoesEntityExist(veh) then
            local vehPlate = string.gsub(GetVehicleNumberPlateText(veh), "^%s*(.-)%s*$", "%1")
            if vehPlate == plate then
                local tries = 0
                while not NetworkHasControlOfEntity(veh) and tries < 20 do
                    NetworkRequestControlOfEntity(veh)
                    Citizen.Wait(50)
                    tries = tries + 1
                end
                ESX.Game.DeleteVehicle(veh)
            end
        end
    end
end)

function EnumerateVehicles()
    return coroutine.wrap(function()
        local handle, veh = FindFirstVehicle()
        if not handle or handle == 0 then return end
        local finished = false
        repeat
            coroutine.yield(veh)
            finished, veh = FindNextVehicle(handle)
        until not finished
        EndFindVehicle(handle)
    end)
end

RegisterNUICallback("nuiclose", function(_, cb)
    SetNuiFocus(false, false)
    cb("ok")
end)

RegisterNetEvent("skam$garage:spawnVehicle", function(vehicle, properties)
    if vehicle then
        local timeout = 0
        NetworkRequestControlOfNetworkId(vehicle)
        while not NetworkHasControlOfNetworkId(vehicle) do
            if timeout > 10 then print("Coś poszło nie tak, to potrwa dłużej niż oczekiwano.") break end
            NetworkRequestControlOfNetworkId(vehicle)
            timeout = timeout+1
            Wait(250)
        end

        vehicle = NetToVeh(vehicle)

        if DoesEntityExist(vehicle) then
            ESX.ShowNotification("Wyjęto pojazd z garażu")

            timeout = 0
            NetworkRequestControlOfEntity(vehicle)
            while not NetworkHasControlOfEntity(vehicle) do
                if timeout > 10 then print("Coś poszło nie tak, to potrwa dłużej niż oczekiwano.") break end
                NetworkRequestControlOfEntity(vehicle)
                timeout = timeout+1
                Wait(250)
            end

            ESX.Game.AssignDefaultVehicleSettings(vehicle)
            ESX.Game.SetVehicleProperties(vehicle, properties)

            local npc = GetPedInVehicleSeat(vehicle, -1)
            if DoesEntityExist(npc) then
                DeletePed(npc)
            end

            SetVehicleDirtLevel(vehicle, 0.0)
            TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
        end
    end
end)

RegisterNetEvent('skam:onAddcarCommand')
AddEventHandler('skam:onAddcarCommand', function(vehicle, player)
    if IsModelInCdimage(joaat(vehicle)) then
        local modelHash = joaat(vehicle)
        local displayName = GetDisplayNameFromVehicleModel(modelHash)
        local label = GetLabelText(displayName) or vehicle
        TriggerServerEvent('skam:addCarResponse', exports['skam']:GeneratePlate(), modelHash, vehicle, label, player)
    end
end)