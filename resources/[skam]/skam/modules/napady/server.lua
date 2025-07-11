local heists = Config['heists'].list
local cooldowns = {}

ESX.RegisterServerCallback('skam$item:getlabel', function(source, cb, itemNames)
    local labels = {}
    for _, itemName in ipairs(itemNames) do
        local label = ESX.GetItemLabel(itemName)
        labels[itemName] = label or '*error.item'
    end
    cb(labels)
end)

function GetPoliceCount()
    local xPlayers = ESX.GetExtendedPlayers('job', 'police')
    return #xPlayers
end

ESX.RegisterServerCallback('skam$heist:canStart', function(source, cb, heistKey)
    local xPlayer = ESX.GetPlayerFromId(source)
    local v = heists[heistKey]
    local now = os.time()
    cooldowns[heistKey] = cooldowns[heistKey] or 0

    if now < cooldowns[heistKey] then
        local remaining = math.ceil((cooldowns[heistKey] - now) / 60)
        cb(false, 'Ten napad jest dostępny za '..remaining..' min.')
        return
    end

    if GetPoliceCount() < v.policeRequired then
        cb(false, 'Na służbie jest za mało policjantów!')
        return
    end

    for _, item in ipairs(v.requiredItems) do
        if xPlayer.getInventoryItem(item.name).count < item.count then
            cb(false, 'Brakuje wymaganych przedmiotów: '..item.name)
            return
        end
    end

    cb(true)
end)

RegisterNetEvent('skam$heist:reward')
AddEventHandler('skam$heist:reward', function(heistKey)
    local src = source
    local v = heists[heistKey]
    local xPlayer = ESX.GetPlayerFromId(src)
    if not v then return end

    if not activeHeists or not activeHeists[src] or activeHeists[src] ~= heistKey then
        print(("Gracz %s próbował odebrać nagrodę do napadu %s nie biorąc w nim udziału!"):format(src, heistKey))
        --DropPlayer(src, "Próba nadużycia napadu.")
        return
    end

    if (cooldowns[heistKey] or 0) > os.time() then
        TriggerClientEvent('esx:showNotification', src, 'Ten napad jest aktualnie na cooldownie!')
        return
    end

    cooldowns[heistKey] = os.time() + 10 * 60

    local money = math.random(v.moneyReward.min, v.moneyReward.max)
    xPlayer.addAccountMoney('black_money', money)

    for _, drop in ipairs(v.dropItems) do
        local chance = math.random(1,100)
        if chance <= drop.chance then
            local count = math.random(drop.countMin, drop.countMax)
            xPlayer.addInventoryItem(drop.name, count)
        end
    end

    for _, item in ipairs(v.requiredItems) do
        xPlayer.removeInventoryItem(item.name, item.count)
    end

    TriggerClientEvent('esx:showNotification', src, 'Napad zakończony sukcesem!')

    for _, police in pairs(ESX.GetExtendedPlayers('job', 'police')) do
        TriggerClientEvent('skam$heist:policeNotify', police.source, v.coords, v.heistName)
    end

    activeHeists[src] = nil
end)