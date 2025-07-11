local PlayerData = {}
local PlayerDrop = {}
local PlayerBusy = {}
local VehProps = '{    "modDashboard": -1,    "modFrontWheels": -1,    "fuelLevel": 80.0,    "modBrakes": -1,    "modSmokeEnabled": false,    "plate": "%s",    "name": "%s",    "modTrimB": -1,    "modFrontBumper": -1,    "modFrame": -1,    "plateIndex": 0,    "modTrimA": -1,    "dirtLevel": 0.0,    "modHood": -1,    "modOrnaments": -1,    "modDial": -1,    "modTurbo": false,    "dashboardColor": 0,    "brokenDoors": [],    "interiorColor": 0,    "tankHealth": 1000.0,    "neonEnabled": [        false,        false,        false,        false    ],    "modGrille": -1,    "wheels": 0,    "modSpeakers": -1,    "modSideSkirt": -1,    "modXenon": false,    "modTrunk": -1,    "damagedTyres": [],    "brokenWindows": [        4,        5    ],    "engineHealth": 1000.0,    "modArchCover": -1,    "displayName": "Washington",    "xenonColor": 255,    "livery": -1,    "modEngine": -1,    "modArmor": -1,    "color2": 1,    "modAPlate": -1,    "modSpoilers": -1,    "modSeats": -1,    "color1": 1,    "modSteeringWheel": -1,    "modRearBumper": -1,    "wheelColor": 156,    "brokenTyresCompletely": [],    "modFender": -1,    "modTank": -1,    "modAirFilter": -1,    "neonColor": [        255,        0,        255    ],    "modStruts": -1,    "windowTint": -1,    "modHorns": -1,    "extras": {        "12": false,        "11": true    },    "modEngineBlock": -1,    "modAerials": -1,    "modLivery": -1,    "modWindows": -1,    "tyreSmokeColor": [        255,        255,        255    ],    "modSuspension": -1,    "modHydrolic": -1,    "modDoorSpeaker": -1,    "model": %s,    "modDoorR": -1,    "bodyHealth": 1000.0,    "modVanityPlate": -1,    "modLightbar": -1,    "modBackWheels": -1,    "modTransmission": -1,    "modRightFender": -1,    "modShifterLeavers": -1,    "pearlescentColor": 5,    "modRoof": -1,    "modPlateHolder": -1,    "modExhaust": -1}'

AddEventHandler('onResourceStart', function(resourceName)
	if resourceName == GetCurrentResourceName() then
		CreateThread(function()
			for _, xPlayer in ipairs(ESX.GetExtendedPlayers()) do
                local result = MySQL.query.await('SELECT coins, points, inventory FROM skam_coins WHERE identifier = ?', {xPlayer.identifier})
                PlayerData[xPlayer.identifier] = {
                    coins = result[1].coins,
                    points = result[1].points,
                    name = xPlayer.discord.name,
                    avatar = xPlayer.discord.image,
                    inventory = json.decode(result[1].inventory)
                }
			end
		end)
	end
end)

AddEventHandler("onResourceStop", function(ResourceName)
    if ResourceName == GetCurrentResourceName() then
        for identifier, data in pairs(PlayerData) do
            MySQL.update("UPDATE skam_coins SET coins = ?, points = ?, inventory = ? WHERE identifier = ?", {data.coins, data.points, json.encode(data.inventory), identifier})
            PlayerData[identifier] = nil
        end
    end
end)

AddEventHandler('esx:playerLoaded', function(source, xPlayer)
    local _source = source
    local result = MySQL.query.await('SELECT coins, points, inventory FROM skam_coins WHERE identifier = ?', {xPlayer.identifier})
    if result and result[1] then
        PlayerData[xPlayer.identifier] = {
            coins = result[1].coins,
            points = result[1].points,
            name = xPlayer.discord.name,
            avatar = xPlayer.discord.image,
            inventory = json.decode(result[1].inventory)
        }
    else
        PlayerData[xPlayer.identifier] = {
            coins = 0,
            points = 0,
            name = xPlayer.discord.name,
            avatar = xPlayer.discord.image,
            inventory = {},
        }
        MySQL.insert.await('INSERT INTO skam_coins (identifier, coins, points) VALUES (?, ?, ?) ', {xPlayer.identifier, 0, 0})
    end

    local HasNick = GetPlayerName(source) and string.find(GetPlayerName(source), 'skam.club') or false
    local waitTime = HasNick and 180000 or 360000
    local notifyText = HasNick and 'Otrzymano punkty za '..ESX.Math.Round(waitTime / 60000)..' minuty gry (posiadasz skam.club w nicku)' or 'Otrzymano punkty za '..ESX.Math.Round(waitTime/60000)..' minut gry (dodaj skam.club do nicku steam, aby otrzymywać punkty szybciej)'

    CreateThread(function()
        while PlayerData[xPlayer.identifier] do
            if PlayerData[xPlayer.identifier].points then
                PlayerData[xPlayer.identifier].points += (HasNick and 3 or 1)
                TriggerClientEvent('esx:showNotification', source, notifyText)
            end
            Wait(waitTime)
        end
    end)

    TriggerClientEvent('skam-itemshop:client:playerLoaded', _source, PlayerData[xPlayer.identifier])
end)

RegisterNetEvent('esx:playerDropped', function(playerId, reason)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    if not xPlayer then return end
    local data = PlayerData[xPlayer.identifier]
    if data then
        MySQL.update.await("UPDATE skam_coins SET coins = ?, points = ?, inventory = ? WHERE identifier = ?", {data.coins, data.points, json.encode(data.inventory), xPlayer.identifier})
        PlayerData[xPlayer.identifier] = nil
    end
end)

ESX.RegisterServerCallback('skam-itemshop:callback:getSteamPhotoUrl', function(source, cb)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    cb(xPlayer.discord.image)
end)

ESX.RegisterServerCallback('skam-itemshop:callback:openCase', function(source, cb, caseId)
    local xPlayer = ESX.GetPlayerFromId(source)
    local CaseConfig = Config.Cases[caseId]
    if not CaseConfig then
        cb({
            success = false,
            error = 'Nie udało się znaleźć takiej skrzynki'
        })
        return
    end
    local itemek = GetRandomDrop(CaseConfig)
    if not itemek then
        cb({
            success = false,
            error = 'Skrzynka jest źle skonfigurowana - powiadom administrację serwera'
        })
        return
    end
    PlayerDrop[source] = itemek
    if caseId == "71233" then -- freecase
        local Time = MySQL.scalar.await('SELECT freeCase FROM skam_coins WHERE identifier = ?', {xPlayer.identifier})
        if Time and Time > os.time() then
            cb({
                success = false,
                error = 'Otworzyłeś już darmową skrznkę'
            })
            return
        end

        MySQL.update.await("UPDATE skam_coins SET freeCase = ? WHERE identifier = ?", {(os.time() + (24 * (60 * 60))), xPlayer.identifier})

        cb({
            success = true,
            coins = GetPlayerCoins(source),
            points = GetPlayerPoints(source),
            item = itemek
        })
    elseif caseId == "71234" then -- booster case
        if not exports['skam']:PlayerHasDiscordRole(source, Config.BoosterRoleID) then
            cb({
                success = false,
                error = 'Nie posiadasz rangi booster na discordzie'
            })
            return
        end

        local Time = MySQL.scalar.await('SELECT boosterCase FROM skam_coins WHERE identifier = ?', {xPlayer.identifier})
        if Time and Time > os.time() then
            cb({
                success = false,
                error = 'Otworzyłeś już skrzynkę dla boosterów. Kolejny raz będziesz mógł otworzyć ją o godzinie '..os.date("%H:%M:%S", Time)
            })
            return
        end

        MySQL.update.await("UPDATE skam_coins SET boosterCase = ? WHERE identifier = ?", {(os.time() + (24 * (60 * 60))), xPlayer.identifier})

        cb({
            success = true,
            coins = GetPlayerCoins(source),
            points = GetPlayerPoints(source),
            item = itemek
        })
    else
        local caseCost = CaseConfig.price
        local ForPoints = CaseConfig.points and true or false

        if ForPoints then
            local playerPoints = GetPlayerPoints(source)
            local newPoints = playerPoints - caseCost

            if playerPoints < caseCost then
                cb({
                    success = false,
                    error = 'Nie posiadasz wystarczającej ilość punktów',
                    coins = GetPlayerCoins(source),
                    points = playerPoints,
                })
                return
            end
    
            SetPlayerPoints(source, newPoints)

            cb({
                success = true,
                coins = GetPlayerCoins(source),
                points = newPoints,
                item = itemek
            })
        else
            local playerCoins = GetPlayerCoins(source)
            local newCoins = playerCoins - caseCost

            if playerCoins < caseCost then
                cb({
                    success = false,
                    error = 'Nie posiadasz wystarczającej ilość monet',
                    coins = playerCoins,
                    points = GetPlayerPoints(source),
                })
                return
            end
    
            SetPlayerCoins(source, newCoins)

            cb({
                success = true,
                coins = newCoins,
                points = GetPlayerPoints(source),
                item = itemek
            })
        end
    end
end)

ESX.RegisterServerCallback("skam-itemshop:callback:withdrawItem", function(source, cb, data)
    local xPlayer = ESX.GetPlayerFromId(source)
    local currentTime = os.time()

    if PlayerBusy[source] and (currentTime - PlayerBusy[source]) < 2 then
        cb({
            status = false
        })
        return
    end
    PlayerBusy[source] = currentTime

    local ItemData = data.item
    local Success = RemovePlayerItem(xPlayer.identifier, ItemData.name, ItemData.count)
    if not Success then
        cb({
            status = false
        })
        return
    end

    if ItemData.category == "car" then
        local plate = GeneratePlate()
        local model = ItemData.name
        MySQL.insert('INSERT INTO owned_vehicles (identifier, type, plate, vehicle) VALUES (?, ?, ?, ?)', {xPlayer.identifier, 'garage', plate, json.encode({name = model, model = model, plate = plate})}, function(id)
            xPlayer.showNotification('Otrzymano pojazd z rejestracją ' .. plate, 'success')
            exports['skam']:log(xPlayer.source, ('ITEMSHOP\nPOJAZD: %s\nREJESTRACJA: %s'):format(model, plate), 'itemshop')
        end)
    elseif ItemData.category == "item" then
        exports['skam']:log(xPlayer.source, ('ITEMSHOP\nITEM: %s\nILOŚĆ: %s'):format(ItemData.name, ItemData.count), 'itemshop')
        xPlayer.addInventoryItem(ItemData.name, ItemData.count)
    end

    cb({
        status = true,
        data = {
            inventory = ItemData
        }
    })

    TriggerClientEvent('skam-itemshop:client:updatePlayerData', source, PlayerData[xPlayer.identifier])
end)

RegisterNetEvent("skam-itemshop:server:keepItem", function(item)
    if not PlayerDrop[source] then return end
    local Success = CheckTableContability(PlayerDrop[source], item)
    if not Success then
        return
    end

    PlayerDrop[source] = nil

    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end
    local CurrentCoins = GetPlayerCoins(source)
    local NewCoins = CurrentCoins + item.price

    if item.category == "voucher" then
        SetPlayerCoins(source, NewCoins)
    else
        if item.points then
            local CurrentPoints = GetPlayerPoints(source)
            local NewPoints = CurrentPoints + item.points
            SetPlayerPoints(source, NewPoints)
        end
        table.insert(PlayerData[xPlayer.identifier].inventory, item)
        MySQL.update.await("UPDATE skam_coins SET inventory = ? WHERE identifier = ?", {json.encode(PlayerData[xPlayer.identifier].inventory), xPlayer.identifier})
    end

    TriggerClientEvent("skam-itemshop:client:updateLiveDrop", -1, {
        title = item.title,
        category = item.category,
        img = item.img,
        rarity = item.rarity,
        count = item.count
    })

    TriggerClientEvent('skam-itemshop:client:updatePlayerData', xPlayer.source, PlayerData[xPlayer.identifier])
end)

ESX.RegisterServerCallback('skam-itemshop:callback:sellItem', function(source, cb, item)
    local SellType = nil
    if PlayerDrop[source] then
        local Success = CheckTableContability(PlayerDrop[source], item)
        if not Success then
            cb({
                status = false
            })
            return
        end
        PlayerDrop[source] = nil
        SellType = 'drop'
    else
        SellType = 'inventory'
    end

    local xPlayer = ESX.GetPlayerFromId(source)
    local currentTime = os.time()

    if PlayerBusy[source] and (currentTime - PlayerBusy[source]) < 2 then
        cb({
            status = false
        })
        return
    end
    PlayerBusy[source] = currentTime

    if SellType == 'inventory' then
        local Success = RemovePlayerItem(xPlayer.identifier, item.name, item.count)
        if not Success then
            cb({
                status = false
            })
            return
        end
    end

    local CurrentCoins = GetPlayerCoins(source)
    local NewCoins = CurrentCoins + item.price

    exports['skam']:log(xPlayer.source, ('ITEMSHOP\nSPRZEDANO: %s\nZA: %s\nSTAN COINS: %s'):format(item.name, item.price, NewCoins), 'itemshop')

    SetPlayerCoins(source, NewCoins)

    TriggerClientEvent("skam-itemshop:client:updateLiveDrop", -1, {
        title = item.title,
        img = item.img,
        rarity = item.rarity,
        category = item.category,
        count = item.count
    })

    cb({
        status = true,
        data = {
            coins = NewCoins,
            points = GetPlayerPoints(source),
            inventory = item
        }
    })

    TriggerClientEvent('skam-itemshop:client:updatePlayerData', source, PlayerData[xPlayer.identifier])
end)

function addPlayerCoins(source, coins)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
        print('Nie znaleziono gracza z source: ' .. source)
        return false
    end
    local CurrentCoins = GetPlayerCoins(source)
    local newCoins = CurrentCoins + tonumber(coins)

    SetPlayerCoins(source, newCoins)
    TriggerClientEvent('skam-itemshop:client:updatePlayerData', source, PlayerData[xPlayer.identifier])
    print('Dodano '..coins..' monet dla gracza o source: '..source)
end

RegisterCommand('addPlayerCoins', function(source, args, rawCommand)
    if source ~= 0 then return end
    if not args[1] then
        print('Podaj ID gracza')
        return
    elseif not args[2] then
        print('Podaj ilość monet')
        return
    end

    local TargetId = tonumber(args[1])
    local coinsAmount = tonumber(args[2])
    if TargetId and coinsAmount then
        addPlayerCoins(TargetId, coinsAmount)
    else
        print('Nie udało się dodać monet')
    end
end, false)

exports('addPlayerCoins', addPlayerCoins)

-- RegisterCommand('AddPlayerCoins', function(source, args, rawCommand)
--     if source ~= 0 then return end
--     if not args[1] then
--         print('Podaj ID gracza')
--         return
--     elseif not args[2] then
--         print('Podaj ilość monet')
--         return
--     end

--     local TargetId = tonumber(args[1])
--     local xPlayer = ESX.GetPlayerFromId(TargetId)
--     if not xPlayer then
--         print('Nie ma takiego gracza na serwerze')
--         return
--     end
--     local CurrentCoins = GetPlayerCoins(TargetId)
--     local NewCoins = CurrentCoins + tonumber(args[2])
--     SetPlayerCoins(TargetId, NewCoins)
--     TriggerClientEvent('skam-itemshop:client:updatePlayerData', TargetId, PlayerData[xPlayer.identifier])
--     print('Dodano '..args[2]..' monet dla gracza z ID: '..TargetId)
-- end, false)

RegisterCommand("addAllPlayerCoins", function(source, args)
    if source ~= 0 then return end
    if not args[1] then
        print('Ilośc musi być większa od 0')
        return
    end
    local amount = tonumber(args[1])
    if amount <= 0 then
        print('Ilośc musi być większa od 0')
        return
    end
    local xPlayers = ESX.GetExtendedPlayers()
    for _, xPlayer in pairs(ESX.GetExtendedPlayers()) do
        local TargetId = xPlayer.source
        local CurrentCoins = GetPlayerCoins(TargetId)
        local NewCoins = CurrentCoins + amount
        SetPlayerCoins(TargetId, NewCoins)
        TriggerClientEvent('skam-itemshop:client:updatePlayerData', TargetId, PlayerData[xPlayer.identifier])
        Wait(50)
        print('Dodano '..amount..' monet dla '..xPlayer.source..' gracza')
    end
end, false)

ESX.RegisterServerCallback('skam-itemshop:callback:getFreeCaseTime', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local Time = MySQL.scalar.await('SELECT freeCase FROM skam_coins WHERE identifier = ?', {xPlayer.identifier})
    if not Time or Time == 0 then
        Time = os.time() - 5
    end
    cb(os.date("%c", Time))
end)

ESX.RegisterServerCallback('skam-itemshop:callback:buyItem', function(source, cb, data)
    local xPlayer = ESX.GetPlayerFromId(source)
    local ItemName = data["item"].name
    local BoughtCount = MySQL.scalar.await('SELECT count FROM skam_coins_shop WHERE name = ?', {ItemName})

    if not BoughtCount then
        BoughtCount = 0
    end

    if BoughtCount >= data["item"].count then
        cb({
            status = 'brak',
            data = PlayerData[xPlayer.identifier]
        })
        return
    end

    local PlayerCoins = GetPlayerCoins(source)
    local ItemPrice = data["item"].price

    if ItemPrice > PlayerCoins then
        cb({
            status = false,
            data = PlayerData[xPlayer.identifier]
        })
        return
    end
    table.insert(PlayerData[xPlayer.identifier].inventory, data.item)
    SetPlayerCoins(source, PlayerCoins - ItemPrice)
    AddItemCount(ItemName, 1)
    cb({
        status = true,
        data = PlayerData[xPlayer.identifier]
    })
end)

ESX.RegisterServerCallback('skam-itemshop:callback:discount', function(source, cb, data)
    local xPlayer = ESX.GetPlayerFromId(source)
    local UsedCode = string.upper(data.code)
    
    local RewardFromCode = MySQL.scalar.await('SELECT reward FROM skam_coins_promocodes WHERE name = ?', {UsedCode})
    if not RewardFromCode then
        cb({
            status = "Nie ma takiego kodu promocyjnego",
            data = PlayerData[xPlayer.identifier]
        })
        return
    end
    
    local UsedCodes = MySQL.scalar.await('SELECT usedCodes FROM skam_coins WHERE identifier = ?', {xPlayer.identifier})

    local PlayerUseThisCode = false
    if UsedCodes then
        UsedCodes = json.decode(UsedCodes)
        for i = 1, #UsedCodes do
            if UsedCodes[i] == UsedCode then
                PlayerUseThisCode = true
                break
            end
        end
    else
        UsedCodes = {}
    end

    if PlayerUseThisCode then
        cb({
            status = "Użyłeś już tego kodu",
            data = PlayerData[xPlayer.identifier]
        })
        return
    end

    local PlayerCoins = GetPlayerCoins(source)
    SetPlayerCoins(source, PlayerCoins + RewardFromCode)
    MySQL.update.await("INSERT INTO skam_coins_promocodes (name, usages) VALUES (:name, :usages) ON DUPLICATE KEY UPDATE usages = usages + :usages;", {
        name = UsedCode,
        usages = 1
    })
    UsedCodes[#UsedCodes + 1] = UsedCode
    MySQL.update.await("UPDATE skam_coins SET usedCodes = ? WHERE identifier = ?", {json.encode(UsedCodes), xPlayer.identifier})

    cb({
        status = "Odebrano "..RewardFromCode.." monet z kodu promocyjnego",
        data = PlayerData[xPlayer.identifier]
    })
end)

RegisterNetEvent('skam-itemshop:UpdatePlayer', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if not xPlayer then return end
    TriggerClientEvent('skam-itemshop:client:updatePlayerData', _source, PlayerData[xPlayer.identifier])
end)

GetPlayerPoints = function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end
    if not PlayerData[xPlayer.identifier] then return end
    return PlayerData[xPlayer.identifier].points
end

SetPlayerPoints = function(source, newPoints)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end
    if not PlayerData[xPlayer.identifier] then return end
    PlayerData[xPlayer.identifier].points = newPoints
end

GetPlayerCoins = function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end
    if not PlayerData[xPlayer.identifier] then return end
    return PlayerData[xPlayer.identifier].coins
end
exports('GetPlayerCoins', GetPlayerCoins)

SetPlayerCoins = function(source, newCoins)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end
    if not PlayerData[xPlayer.identifier] then return end
    PlayerData[xPlayer.identifier].coins = newCoins
end

RemovePlayerItem = function(identifier, itemName, count)
    for i, item in ipairs(PlayerData[identifier].inventory) do
        if item.name == itemName then
            if item.count >= count then
                item.count -= count
                if item.count == 0 then
                    table.remove(PlayerData[identifier].inventory, i)
                end
                return true
            end
        end
    end
    return false
end

CheckTableContability = function(_table1, _table2)
    for k, v in pairs(_table1) do
        if _table1[k] ~= _table2[k] then
            return false
        end
    end
    return true
end

GetRandomDrop = function(data)
    local random = math.random() * 100
    local chance = 0
    for _, item in pairs(data.items) do
        chance += item.chance
        if random <= chance then
            return item
        end
    end
    return nil
end

AddItemCount = function(name, count)
    MySQL.update.await("INSERT INTO skam_coins_shop (name, count) VALUES (:name, :count) ON DUPLICATE KEY UPDATE count = count + :count;", {
        name = name, 
        count = count
    })
end

-- CreateThread(function()
--     for k, v in pairs(Config.Cases) do
--         local total = 0
--         for _, d in pairs(v.items) do
--             total += d.chance
--         end
--         if total ~= 100.0 then
--             print('Łączne szanse na przedmioty w skrzyni ' .. v.title .. ': ' .. total)
--         end
--     end
-- end)

local NumberCharset = {}
local Charset = {}
local existingPlates = {}

for i = 48, 57 do table.insert(NumberCharset, string.char(i)) end
for i = 65, 90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

GetRandomNumber = function(length)
	Citizen.Wait(1)
	math.randomseed(os.time())
	return length > 0 and (GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]) or ''
end

GetRandomLetter = function(length)
	Citizen.Wait(1)
	math.randomseed(os.time())
	return length > 0 and (GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]) or ''
end

GeneratePlate = function()
    Citizen.Wait(2)
    math.randomseed(GetGameTimer())
    local generatedPlate = string.upper(GetRandomLetter(4) .. ' ' .. GetRandomNumber(3))
    if existingPlates[generatedPlate] then
        return GeneratePlate()
    else
        local result = MySQL.Async.fetchScalar('SELECT owner FROM owned_vehicles WHERE plate LIKE @plate', {
            ['@plate'] = '%'..generatedPlate..'%'
        })
        if result == nil then
            existingPlates[generatedPlate] = true
            return generatedPlate
        else
            return GeneratePlate()
        end
    end
end

ESX.RegisterCommand('konkurs', 'owner', function(xPlayer, args, showError)
    if xPlayer then return end
    local type = args[1]
    local ilosc = tonumber(args[2])
    local cotakiego = args[3]
    
    if not type or not ilosc or not cotakiego then
        print('Poprawne użycie: /konkurs <coins/ranga> <ilosc wygranych> <ilosc/ranga>')
        return
    end

    local players = ESX.GetPlayers()
    print("Aktualna liczba graczy na serwerze:", #players)

    if #players < ilosc then
        print('Na serwerze nie ma wystarczającej liczby graczy')
        return
    end

    local winners = {}
    while #winners < ilosc do
        local randomPlayer = players[math.random(1, #players)]
        table.insert(winners, randomPlayer)
    end

    for _, winner in ipairs(winners) do
        local xTarget = ESX.GetPlayerFromId(winner)
        print("Przyznawanie nagrody dla gracza ID:", winner)
        if type == "coins" then
            local CurrentCoins = GetPlayerCoins(xTarget.source)
            local NewCoins = CurrentCoins + tonumber(cotakiego)

            SetPlayerCoins(xTarget.source, NewCoins)
            TriggerClientEvent('skam-itemshop:client:updatePlayerData', xTarget.source, PlayerData[xTarget.identifier])
            xTarget.showNotification('Gratulacje! Wygrales ' .. tonumber(cotakiego) .. ' coinow.')
        elseif type == "ranga" then
            exports['InDrop']:NadajRangiProduct(cotakiego, xTarget.source)
            xTarget.showNotification('Gratulacje! Wygrales rangę: ' .. cotakiego .. '.')
            print("Przyznano rangę:", cotakiego, "dla gracza ID:", winner)
        end
    end

    local Ziutekktorywygralpozdro = {}
    for _, winner in ipairs(winners) do
        local discordnamedlaziomka = ESX.GetPlayerFromId(winner)
        table.insert(Ziutekktorywygralpozdro, discordnamedlaziomka.discord.name)
    end

    TriggerClientEvent("skam-chat", -1, {
        label = "Konkurs",
        color = "#ffb64c",
    }, {
        type = "Konkurs",
        name = "skam.club",
        content = "Konkurs wygrali: " .. table.concat(Ziutekktorywygralpozdro, ', ')
    })
end, true)