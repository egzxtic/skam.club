local entityEnumerator = {
    __gc = function(enum)
        if enum.destructor and enum.handle then
            enum.destructor(enum.handle)
        end
        enum.destructor = nil
        enum.handle = nil
    end
}

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(function()
        local iter, id = initFunc()
        if not id or id == 0 then
            disposeFunc(iter)
            return
        end

        local enum = {handle = iter, destructor = disposeFunc}
        setmetatable(enum, entityEnumerator)

        local next = true
        repeat
            coroutine.yield(id)
            next, id = moveFunc(iter)
        until not next

        enum.destructor, enum.handle = nil, nil
        disposeFunc(iter)
    end)
end

function EnumerateVehicles()
    return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

local COLLISION_RADIUS = 50.0

CreateThread(function()
    while true do
        Wait(1500)
        local playerPed = PlayerPedId()
        local playerVeh = GetVehiclePedIsIn(playerPed, false)
        local px, py, pz = table.unpack(GetEntityCoords(playerPed))

        for veh in EnumerateVehicles() do
            if veh ~= playerVeh then
                local vx, vy, vz = table.unpack(GetEntityCoords(veh))
                local dist = #(vector3(px, py, pz) - vector3(vx, vy, vz))
                if dist < COLLISION_RADIUS then
                    SetEntityNoCollisionEntity(veh, playerPed, false)
                    SetEntityNoCollisionEntity(playerPed, veh, false)
                end
            end
        end
    end
end)