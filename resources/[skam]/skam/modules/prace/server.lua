local jailStartPos = vector3(1661.2617, 2533.4802, 45.5648 - 0.9)
local buyoutLocation = vector3(1664.0663, 2533.8523, 45.5649 - 0.9)

local function getLicense(source)
    for _,v in ipairs(GetPlayerIdentifiers(source)) do
        if string.sub(v, 1, 8) == "license:" then
            return string.sub(v, 9)
        end
    end
    return false
end

ESX.RegisterCommand('prace', 'admin', function(xPlayer, args, showError)
    local xTarget = ESX.GetPlayerFromId(args.id)
    local count = tonumber(args.ilosc)
    if not xTarget or not count or count < 1 then
        xPlayer.showNotification("Użycie: /prace [id] [liczba_prac]")
        return
    end
    local license = getLicense(xTarget.source)
    if not license then
        xPlayer.showNotification("Brak license.")
        return
    end
    MySQL.update('REPLACE INTO socialwork (license, remaining, lastupdate) VALUES (?, ?, ?)', {
        license, count, os.time()
    }, function()
        TriggerClientEvent("skam$prace:setJobCount", xTarget.source, count)
        TriggerClientEvent("skam$prace:setStartPos", xTarget.source, jailStartPos.x, jailStartPos.y, jailStartPos.z)
        TriggerClientEvent("skam$prace:teleportToStart", xTarget.source, jailStartPos.x, jailStartPos.y, jailStartPos.z)
        xTarget.showNotification("Musisz wykonać " .. count .. " prac, aby móc dalej grać!")
        xPlayer.showNotification("Nadałeś graczowi z ID " .. xTarget.source .. ", " .. count .. " prac.")
    end)
end, true, {help = "Nadaj prace więźniowi", validate = true, arguments = {
    {name = 'id', help = 'ID gracza', type = 'number'},
    {name = 'ilosc', help = 'Liczba prac', type = 'number'}
}})

ESX.RegisterCommand('unprace', 'admin', function(xPlayer, args, showError)
    local xTarget = ESX.GetPlayerFromId(args.id)
    if not xTarget then
        xPlayer.showNotification("Gracz offline lub ID nieprawidłowe.")
        return
    end
    local license = getLicense(xTarget.source)
    MySQL.update('DELETE FROM socialwork WHERE license = ?', {license}, function()
        TriggerClientEvent("skam$prace:clearJob", xTarget.source)
        xTarget.showNotification("Zostałeś zwolniony z prac!")
        xPlayer.showNotification("Zwolniono gracza ID " .. xTarget.source .. " z prac.")
    end)
end, true, {help = "Usuń prace więźniowi", validate = true, arguments = {
    {name = 'id', help = 'ID gracza', type = 'number'}
}})

RegisterNetEvent("skam$prace:doneOneWork")
AddEventHandler("skam$prace:doneOneWork", function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local license = getLicense(src)
    MySQL.query('SELECT * FROM socialwork WHERE license = ?', {license}, function(result)
        if result[1] and result[1].remaining > 0 then
            local new = result[1].remaining - 1
            MySQL.update('UPDATE socialwork SET remaining = ?, lastupdate = ? WHERE license = ?', {
                new, os.time(), license
            }, function()
                TriggerClientEvent("skam$prace:setJobCount", src, new)
                if new > 0 then
                    xPlayer.showNotification("Pozostało ci " .. new .. " prac do końca!")
                else
                    TriggerClientEvent("skam$prace:clearJob", src)
                end
            end)
        end
    end)
end)

RegisterNetEvent("skam$prace:requestJobCount")
AddEventHandler("skam$prace:requestJobCount", function()
    local src = source
    local license = getLicense(src)
    MySQL.query('SELECT remaining FROM socialwork WHERE license = ?', {license}, function(result)
        TriggerClientEvent("skam$prace:setJobCount", src, result[1] and result[1].remaining or 0)
        if result[1] and result[1].remaining > 0 then
            TriggerClientEvent("skam$prace:setStartPos", src, jailStartPos.x, jailStartPos.y, jailStartPos.z)
        end
    end)
end)

RegisterNetEvent("skam$prace:buyFreedom")
AddEventHandler("skam$prace:buyFreedom", function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local license = getLicense(src)
    MySQL.query('SELECT remaining FROM socialwork WHERE license = ?', {license}, function(result)
        if result[1] and result[1].remaining > 0 then
            local count = result[1].remaining
            local price = count * 50000000
            if xPlayer.getMoney() >= price then
                xPlayer.removeMoney(price)
                MySQL.update('DELETE FROM socialwork WHERE license = ?', {license}, function()
                    TriggerClientEvent("skam$prace:clearJob", src)
                    xPlayer.showNotification("Wykupiłeś się z prac za $" .. price .. "!")
                end)
            else
                xPlayer.showNotification("Nie stać cię! Koszt wykupu: $" .. price)
            end
        else
            xPlayer.showNotification("Nie masz żadnych prac do wykupienia!")
        end
    end)
end)