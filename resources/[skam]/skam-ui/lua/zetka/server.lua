function CountPlayersInfo()
    local players = ESX.GetPlayers()
    local admins, police = 0, 0
    for _, src in ipairs(players) do
        local xPlayer = ESX.GetPlayerFromId(src)
        if xPlayer then
            local group = xPlayer.getGroup and xPlayer.getGroup() or "user"
            if group == "admin" or group == "sadmin" or group == "headadmin" or group == "owner" then
                admins = admins + 1
            end
            if xPlayer.job and (xPlayer.job.name == "police" or xPlayer.job.name == "sheriff") then
                police = police + 1
            end
        end
    end
    return #players, admins, police
end

AddEventHandler('esx:playerLoaded', function(src, xPlayer)
    Player(xPlayer.source).state.admin = (xPlayer.group ~= 'user')
    Player(xPlayer.source).state.zblock = false

    if exports['skam']:premiumRank(xPlayer) then
        Player(src).state.vip = 'VIP'
    end

    local license = xPlayer.identifier:gsub('license:', '')
    local group = xPlayer.getGroup and xPlayer.getGroup() or "user"

    Player(src).state.group = group
    Player(src).state.identifier = license
end)

RegisterNetEvent('skam$zetka:toggle')
AddEventHandler('skam$zetka:toggle', function(toggle)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    local license = nil
    for _,v in ipairs(GetPlayerIdentifiers(src)) do
        if string.sub(v, 1, 7) == "license" then
            license = v:gsub("license:", "")
            break
        end
    end

    local playerCount, adminCount, policeCount = CountPlayersInfo()
    local group = xPlayer.getGroup and xPlayer.getGroup() or "user"
    local jobLabel = xPlayer.job and xPlayer.job.name and string.sub(xPlayer.job.name, 1, 4) == "org1" and xPlayer.job.label or "GRLZ"

    local data = {
        job = jobLabel,
        group = group,
        id = src,
        identifier = license,
        players = playerCount,
        admins = adminCount,
        police = policeCount
    }
    TriggerClientEvent('skam$zetka:update', src, data)
end)