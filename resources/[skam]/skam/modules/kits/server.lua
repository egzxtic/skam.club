local KITS = {
    ['start'] = {
        cooldown = 3,
        items = {
            { item = 'handcuffs', count = 1 },
            { item = 'radiocrime', count = 1 },
            { item = 'energydrink', count = 20 },
            { item = 'narco-meth-paczka', count = 5 },
            { item = 'vintagepistol', count = 1 },
            { item = 'pistol_ammo_box', count = 10 },
        }
    },
    ['vip'] = {
        cooldown = 3,
        items = {
            { item = 'handcuffs', count = 2 },
            { item = 'radiocrime', count = 3 },
            { item = 'energydrink', count = 100 },
            { item = 'narco-meth-paczka', count = 50 },
            { item = 'vintagepistol', count = 3 },
            { item = 'snspistol_mk2', count = 3 },
            { item = 'pistol_ammo_box', count = 20 },
        }
    },
    ['ultra'] = {
        cooldown = 6,
        items = {
            { item = 'handcuffs', count = 3 },
            { item = 'radiocrime', count = 5 },
            { item = 'energydrink', count = 150 },
            { item = 'vintagepistol', count = 5 },
            { item = 'snspistol_mk2', count = 5 },
            { item = 'narco-meth-paczka', count = 75 },
            { item = 'vest-medium', count = 5 },
            { item = 'pistol_ammo_box', count = 50 },
        }
    },
    ['master'] = {
        cooldown = 6,
        items = {
            { item = 'handcuffs', count = 5 },
            { item = 'radiocrime', count = 10 },
            { item = 'energydrink', count = 250 },
            { item = 'vintagepistol', count = 10 },
            { item = 'snspistol_mk2', count = 10 },
            { item = 'narco-meth-paczka', count = 100 },
            { item = 'vest-heavy', count = 5 },
            { item = 'pistol_ammo_box', count = 100 },
        }
    }
}

local premiumItems = {
    ['ticket-vip7'] = { group = 'vip', days = 7 },
    ['ticket-vip30'] = { group = 'vip', days = 30 },
    ['ticket-ultra7'] = { group = 'ultra', days = 7 },
    ['ticket-ultra30'] = { group = 'ultra', days = 30 },
    ['ticket-master7'] = { group = 'master', days = 7 },
    ['ticket-master30'] = { group = 'master', days = 30 },
}

for itemName, cfg in pairs(premiumItems) do
    ESX.RegisterUsableItem(itemName, function(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        local identifier = xPlayer.identifier
        MySQL.Async.fetchAll('SELECT premiumgroup, premium_until FROM users WHERE identifier=@identifier', {
            ['@identifier'] = identifier
        }, function(result)
            local now = os.time()
            local new_until = now + (cfg.days * 86400)
            local group = cfg.group

            local current_until = tonumber(result[1] and result[1].premium_until or 0) or 0
            local current_group = tostring(result[1] and result[1].premiumgroup or '')

            if current_group == group and current_until > now then
                new_until = current_until + (cfg.days * 86400)
            else
                new_until = now + (cfg.days * 86400)
            end

            MySQL.Async.execute('UPDATE users SET premiumgroup=@group, premium_until=@until WHERE identifier=@identifier', {
                ['@group'] = group,
                ['@until'] = new_until,
                ['@identifier'] = identifier
            }, function()
                xPlayer.removeInventoryItem(itemName, 1)
                xPlayer.showNotification('Aktywowano rangę ~y~'..group:upper()..'~s~ na '..cfg.days..' dni!')
            end)
        end)
    end)
end

function getPremiumGroup(xPlayer, cb)
    local identifier = xPlayer.identifier
    MySQL.Async.fetchAll('SELECT premiumgroup, premium_until FROM users WHERE identifier = @identifier', {
        ['@identifier'] = identifier
    }, function(result)
        local group = result[1] and result[1].premiumgroup or nil
        local ntil = tonumber(result[1] and result[1].premium_until or 0) or 0
        if group and ntil > os.time() then
            cb(group)
        else
            if group or ntil > 0 then
                MySQL.Async.execute('UPDATE users SET premiumgroup=NULL, premium_until=0 WHERE identifier=@identifier', {
                    ['@identifier'] = identifier
                })
            end
            cb(nil)
        end
    end)
end

function getKitsCooldowns(xPlayer, cb)
    local identifier = xPlayer.identifier
    MySQL.Async.fetchScalar('SELECT kits_cooldowns FROM users WHERE identifier = @identifier', {
        ['@identifier'] = identifier
    }, function(jsonStr)
        local data = {}
        if jsonStr and jsonStr ~= "" then
            data = json.decode(jsonStr)
        end
        cb(data or {})
    end)
end

function setKitCooldown(xPlayer, kitName)
    getKitsCooldowns(xPlayer, function(cooldowns)
        local identifier = xPlayer.identifier
        local now = os.time()
        cooldowns[kitName] = now
        MySQL.Async.execute('UPDATE users SET kits_cooldowns = @cd WHERE identifier = @identifier', {
            ['@cd'] = json.encode(cooldowns),
            ['@identifier'] = identifier
        })
    end)
end

function canTakeKit(xPlayer, kitName, cb)
    getKitsCooldowns(xPlayer, function(cooldowns)
        local last = tonumber(cooldowns[kitName] or 0)
        local now = os.time()
        local kit = KITS[kitName]
        local cooldown = (kit and kit.cooldown or 24) * 3600
        if now - last >= cooldown then
            cb(true)
        else
            cb(false, cooldown - (now - last))
        end
    end)
end

function giveKit(xPlayer, kitName)
    local kit = KITS[kitName]
    if not kit then
        xPlayer.showNotification('Taki kit nie istnieje!')
        return
    end
    for _, v in ipairs(kit.items) do
        xPlayer.addInventoryItem(v.item, v.count)
    end
    xPlayer.showNotification('Odebrano zestaw: ' .. kitName:upper())
end

ESX.RegisterCommand('kit', 'user', function(xPlayer, args, showError)
    local kitType = args.kit and string.lower(args.kit) or nil
    if not kitType or not KITS[kitType] then
        xPlayer.showNotification('Użycie: /kit [start|vip|ultra|master]')
        return
    end
    canTakeKit(xPlayer, kitType, function(canTake, cooldownLeft)
        if canTake then
            if kitType == "start" then
                giveKit(xPlayer, 'start')
                setKitCooldown(xPlayer, 'start')
                return
            end
            getPremiumGroup(xPlayer, function(level)
                if level == kitType then
                    giveKit(xPlayer, kitType)
                    setKitCooldown(xPlayer, kitType)
                elseif (level == 'ultra' and kitType == 'vip') or (level == 'master' and (kitType == 'vip' or kitType == 'ultra')) then
                    giveKit(xPlayer, kitType)
                    setKitCooldown(xPlayer, kitType)
                else
                    xPlayer.showNotification('Nie masz uprawnień do tego kitu!')
                end
            end)
        else
            xPlayer.showNotification("Możesz odebrać ten kit za: " .. math.ceil(cooldownLeft/60) .. " minut.")
        end
    end)
end, false, {help = "Odbierz kit", validate = true, arguments = {
    {name = 'kit', help = "Rodzaj kitu: start/vip/ultra/master", type = 'string'}
}})

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
    local identifier = xPlayer.identifier
    MySQL.Async.fetchAll('SELECT premiumgroup, premium_until FROM users WHERE identifier = @identifier', {
        ['@identifier'] = identifier
    }, function(result)
        local group = result[1] and result[1].premiumgroup or nil
        local ntil = tonumber(result[1] and result[1].premium_until or 0) or 0
        local now = os.time()
        if group and ntil > now then
            local days = math.max(1, math.floor((ntil-now)/86400))
            xPlayer.showNotification("Witaj, VIP "..group:upper().."! Twój status ważny jeszcze przez: "..days.." dni.")
            local timeLeft = ntil - now
            if timeLeft < 24*60*60 then
                xPlayer.showNotification("Uwaga! Twój VIP ("..group:upper()..") wygasa za mniej niż " .. math.ceil(timeLeft/3600) .. " godzin.")
            end
        else
            xPlayer.showNotification("Kup VIP na sklepie! Zyskasz dostęp do kitów, bonusów i wielu atrakcji.")
        end
    end)
end)

local function premiumRank(xPlayer)
    if not xPlayer then return false end
    local result = MySQL.Sync.fetchAll('SELECT premium_until FROM users WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    })
    local untilTime = tonumber(result[1] and result[1].premium_until or 0) or 0
    return untilTime > os.time()
end

exports('premiumRank', premiumRank)