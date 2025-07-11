local narkoItems = {
    meth = { raw = 'narco-meth', process = 'narco-meth-paczka' },
    weed = { raw = 'narco-weed', process = 'narco-weed-paczka' },
    fent = { raw = 'narco-fentanyl', process = 'narco-fentanyl-paczka' }
}

local narkoCooldowns = {}
local rawCooldown = 60
local processCooldown = 120

local function getNarkoCoords(drugType, stage)
    if Config['narko'] and Config['narko'][drugType] and Config['narko'][drugType][stage] then
        return Config['narko'][drugType][stage].coords
    end
    return nil
end

local function isWithin(coords1, coords2, maxDist)
    if not coords1 or not coords2 then return false end
    local dx, dy, dz = coords1.x - coords2.x, coords1.y - coords2.y, (coords1.z or 0) - (coords2.z or 0)
    local dist = math.sqrt(dx*dx + dy*dy + dz*dz)
    return dist <= maxDist
end

ESX.RegisterServerCallback('skam$cpun:check', function(source, cb, drugType, stage)
    local xPlayer = ESX.GetPlayerFromId(source)
    local item = narkoItems[drugType]
    if not item then cb(false, 'Nieznany typ narkotyku!'); return end

    narkoCooldowns[source] = narkoCooldowns[source] or {}
    narkoCooldowns[source][drugType] = narkoCooldowns[source][drugType] or {raw = 0, process = 0}
    local now = os.time()

    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    local coords = getNarkoCoords(drugType, stage == "raw" and "zbierz" or "przerob")
    if not isWithin(playerCoords, coords, 5.0) then
        cb(false, 'Musisz być przy odpowiednim punkcie!')
        return
    end

    if stage == "raw" then
        if narkoCooldowns[source][drugType].raw > now then
            local left = narkoCooldowns[source][drugType].raw - now
            cb(false, 'Odczekaj jeszcze ' .. left .. 's przed kolejnym zbiorem!')
            return
        end
        cb(true)
    elseif stage == "process" then
        if narkoCooldowns[source][drugType].process > now then
            local left = narkoCooldowns[source][drugType].process - now
            cb(false, 'Odczekaj jeszcze ' .. left .. 's przed kolejnym przerabianiem!')
            return
        end
        if xPlayer.getInventoryItem(item.raw).count < 5 then
            cb(false, 'Nie masz wystarczająco surowca (min. 5) do przerobienia!')
            return
        end
        cb(true)
    else
        cb(false, 'Nieprawidłowy etap!')
    end
end)

RegisterNetEvent('skam$cpun:raw', function(drugType)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local item = narkoItems[drugType]
    if not item then return end

    narkoCooldowns[src] = narkoCooldowns[src] or {}
    narkoCooldowns[src][drugType] = narkoCooldowns[src][drugType] or {raw = 0, process = 0}
    local now = os.time()

    local ped = GetPlayerPed(src)
    local playerCoords = GetEntityCoords(ped)
    local zbierzCoords = getNarkoCoords(drugType, 'zbierz')
    if not isWithin(playerCoords, zbierzCoords, 5.0) then
        xPlayer.showNotification('Musisz być przy punkcie zbierania!')
        return
    end

    if narkoCooldowns[src][drugType].raw > now then
        xPlayer.showNotification('Odczekaj do końca cooldownu!')
        return
    end

    xPlayer.addInventoryItem(item.raw, 25)
    narkoCooldowns[src][drugType].raw = now + rawCooldown
end)

RegisterNetEvent('skam$cpun:process', function(drugType)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local item = narkoItems[drugType]
    if not item then return end

    narkoCooldowns[src] = narkoCooldowns[src] or {}
    narkoCooldowns[src][drugType] = narkoCooldowns[src][drugType] or {raw = 0, process = 0}
    local now = os.time()

    local ped = GetPlayerPed(src)
    local playerCoords = GetEntityCoords(ped)
    local przerobCoords = getNarkoCoords(drugType, 'przerob')
    if not isWithin(playerCoords, przerobCoords, 5.0) then
        xPlayer.showNotification('Musisz być przy punkcie przeróbki!')
        return
    end

    if narkoCooldowns[src][drugType].process > now then
        xPlayer.showNotification('Odczekaj do końca cooldownu!')
        return
    end

    local rawCount = xPlayer.getInventoryItem(item.raw).count
    local packs = math.floor(rawCount / 5)
    if packs > 0 then
        local toRemove = packs * 5
        xPlayer.removeInventoryItem(item.raw, toRemove)
        xPlayer.addInventoryItem(item.process, packs)
        narkoCooldowns[src][drugType].process = now + processCooldown
        xPlayer.showNotification('Przerobiono x'..toRemove..' na '..packs..' paczek!')
    else
        xPlayer.showNotification('Nie masz wystarczająco surowca (min. 5) do przerobienia!')
    end
end)