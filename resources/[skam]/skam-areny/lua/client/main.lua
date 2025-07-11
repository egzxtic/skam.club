ESX = {}
cache = {}
local functions = {}

local cooldowns = {
    permsUpdate = false
}

isVehicleDriver = function(vehicle)
    return GetPedInVehicleSeat(vehicle, -1) == PlayerPedId()
end

getOrgPerms = function()
    if (cooldowns.permsUpdate) then
        return cache.orgPerms
    end

	local promise = promise:new()
	ESX.TriggerServerCallback('skam:getOrgPerms', function(perms)
		cache.orgPerms = perms
        SetTimeout(2500, function()
            cooldowns.permsUpdate = false
        end)
        promise:resolve(perms)
	end)
	return Citizen.Await(promise)
end

hasPermission = function(permission)
    local orgPerms = getOrgPerms()
    local jobGrade = ESX.GetPlayerData().job.grade
    return (jobGrade >= orgPerms[permission])
end

checkJob = function()
    if not (cache.player.loaded) then
        repeat Wait(1)
        until ESX.IsPlayerLoaded()
    end
    if string.find(ESX.GetPlayerData().job.name, "org") then
        if (LocalPlayer.state.customOrgBucket ~= nil) then
            return true
        else
            return (ESX.GetPlayerData().job.name ~= 'unemployed')
        end
    else
        return (ESX.GetPlayerData().job.name ~= 'unemployed')
    end
end

functions.initializeFramework = function()
    ESX = exports['es_extended']:getSharedObject()
end

local stateBags = {
    {name = 'inBattle', value = false},
    {name = 'inOrgBucket', value = false}
}
functions.initializePlayerStatebags = function()
    for _, stateBag in ipairs(stateBags) do
        LocalPlayer.state:set(stateBag.name, stateBag.value, true)
    end
end

clearPedFromProps = function()
    local ped = PlayerPedId()
    local entities = GetGamePool('CObject')
    for _, entity in ipairs(entities) do
        if (IsEntityAttachedToEntity(entity, ped)) then
            DetachEntity(entity)
            DeleteEntity(entity)
        end
    end
    ClearPedTasks(ped)
end

functions.initialization = function()
    functions.initializeFramework()
    functions.initializePlayerStatebags()
    clearPedFromProps()
end

CreateThread(functions.initialization)