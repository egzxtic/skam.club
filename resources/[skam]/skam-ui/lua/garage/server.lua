ESX.RegisterServerCallback("skam$garage:getVehiclesData", function(src, cb, section)
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return cb({}) end

    local query, params

    if not section or section == "all" then
        query = 'SELECT * FROM owned_vehicles WHERE identifier = @identifier'
        params = { ['@identifier'] = xPlayer.identifier }
    else
        query = 'SELECT * FROM owned_vehicles WHERE identifier = @identifier AND type = @type'
        params = { ['@identifier'] = xPlayer.identifier, ['@type'] = section }
    end

    MySQL.Async.fetchAll(query, params, function(result)
        local vehicles = {}
        for _, v in ipairs(result) do
            local props = {}
            if v.vehicle then
                local ok, decoded = pcall(json.decode, v.vehicle)
                if ok and type(decoded) == "table" then
                    props = decoded
                end
            end
            props.plate = v.plate or props.plate or ""
            props.icon = props.icon or "fa-solid fa-car"
            props.type = v.type or section
            props.model = props.model or v.model or ""
            table.insert(vehicles, props)
        end
        cb(vehicles)
    end)
end)

RegisterNetEvent('skam$garage:spawnVehicle', function(plate)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not plate or not xPlayer then return end

    spawningVehicle = spawningVehicle or {}
    if spawningVehicle[src] then return end

    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate AND identifier = @identifier', {
        ['@plate'] = plate,
        ['@identifier'] = xPlayer.identifier
    }, function(result)
        if result[1] then
            local vehicleType = result[1].type or 'garage'
            if vehicleType ~= 'garage' then
                xPlayer.showNotification('Ten pojazd nie jest w garażu!')
                return
            end

            spawningVehicle[src] = true

            local vehicleData = json.decode(result[1].vehicle)
            vehicleData.plate = plate

            local coords = GetEntityCoords(GetPlayerPed(src))
            local heading = GetEntityHeading(GetPlayerPed(src))
            local model = vehicleData.model

            local spawnedVeh = CreateVehicle(model, coords.x, coords.y, coords.z, heading, true, true)
            while not DoesEntityExist(spawnedVeh) do Wait(10) end

            MySQL.Async.execute('UPDATE owned_vehicles SET type = @type WHERE plate = @plate AND identifier = @identifier', {
                ['@type'] = 'towing',
                ['@plate'] = plate,
                ['@identifier'] = xPlayer.identifier
            })

            spawningVehicle[src] = nil

            TriggerClientEvent('skam$garage:spawnVehicle', src, NetworkGetNetworkIdFromEntity(spawnedVeh), vehicleData)
        else
            xPlayer.showNotification('Nie znaleziono pojazdu o tej tablicy!')
        end
    end)
end)

ESX.RegisterServerCallback("skam$garage:putVehicle", function(source, cb, plate, vehprops)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not plate or not xPlayer then return cb(false) end

    MySQL.Async.fetchScalar('SELECT plate FROM owned_vehicles WHERE plate = @plate AND identifier = @identifier', {
        ['@plate'] = plate,
        ['@identifier'] = xPlayer.identifier
    }, function(foundPlate)
        if foundPlate then
            MySQL.Async.execute('UPDATE owned_vehicles SET vehicle = @vehprops, type = @type WHERE plate = @plate AND identifier = @identifier', {
                ['@vehprops'] = json.encode(vehprops),
                ['@type'] = 'garage',
                ['@plate'] = plate,
                ['@identifier'] = xPlayer.identifier
            }, function(rowsChanged)
                if rowsChanged and rowsChanged > 0 then
                    cb(true)
                else
                    cb(false)
                end
            end)
        else
            cb(false)
        end
    end)
end)

function table.contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

RegisterNetEvent("skam$garage:addSubOwner", function(plate, targetId)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local target = ESX.GetPlayerFromId(targetId)
    if not target then
        xPlayer.showNotification('Podany gracz nie jest online!')
        return
    end
    if targetId == src then
        xPlayer.showNotification('Nie możesz dodać siebie jako współwłaściciela!')
        return
    end
    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate AND identifier = @identifier', {
        ['@plate'] = plate,
        ['@identifier'] = xPlayer.identifier
    }, function(result)
        if result[1] then
            local subOwners = json.decode(result[1].subOwners or "[]")
            if not table.contains(subOwners, target.identifier) then
                table.insert(subOwners, target.identifier)
                MySQL.Async.execute('UPDATE owned_vehicles SET subOwners = @subOwners WHERE plate = @plate AND identifier = @identifier', {
                    ['@subOwners'] = json.encode(subOwners),
                    ['@plate'] = plate,
                    ['@identifier'] = xPlayer.identifier
                }, function(rowsChanged)
                    if rowsChanged > 0 then
                        xPlayer.showNotification('Dodano gracza ['..targetId..'] jako współwłaściciela pojazdu.')
                        target.showNotification('Zostałeś dodany jako współwłaściciel pojazdu o tablicy: '..plate)
                    else
                        xPlayer.showNotification('Nie udało się dodać współwłaściciela.')
                    end
                end)
            else
                xPlayer.showNotification('Ten gracz już jest współwłaścicielem tego pojazdu.')
            end
        else
            xPlayer.showNotification('Nie znaleziono pojazdu o tej tablicy!')
        end
    end)
end)

function table.contains(tbl, element)
    for _, value in ipairs(tbl) do
        if value == element then return true end
    end
    return false
end

function table.removeValue(tbl, value)
    for i = #tbl, 1, -1 do
        if tbl[i] == value then
            table.remove(tbl, i)
        end
    end
    return tbl
end

ESX.RegisterServerCallback('skam$garage:getSubOwners', function(src, cb, plate)
    local xPlayer = ESX.GetPlayerFromId(src)
    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate AND identifier = @identifier', {
        ['@plate'] = plate,
        ['@identifier'] = xPlayer.identifier
    }, function(result)
        local ret = {}
        if result[1] then
            local subOwners = json.decode(result[1].subOwners or "[]")
            for _, identifier in ipairs(subOwners) do
                local found = false
                for _, p in pairs(GetPlayers()) do
                    local player = ESX.GetPlayerFromId(tonumber(p))
                    if player and player.identifier == identifier then
                        table.insert(ret, { label = player.getName(), id = identifier })
                        found = true
                        break
                    end
                end
                if not found then
                    table.insert(ret, { label = string.sub(identifier, 1, 8) .. "...", id = identifier })
                end
            end
        end
        cb(ret)
    end)
end)

RegisterNetEvent("skam$garage:forceDeleteVehicleByPlate", function(plate)
    TriggerClientEvent("skam$garage:forceDeleteVehicleByPlate", -1, plate)
end)

RegisterNetEvent("skam$garage:unchlowVehicle", function(plate)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE identifier = @identifier AND type = @type AND plate = @plate', {
        ['@identifier'] = xPlayer.identifier,
        ['@type'] = 'towing',
        ['@plate'] = plate
    }, function(result)
        if result and #result > 0 then
            MySQL.Async.execute('UPDATE owned_vehicles SET type = @newType WHERE plate = @plate AND identifier = @identifier', {
                ['@newType'] = 'garage',
                ['@plate'] = plate,
                ['@identifier'] = xPlayer.identifier
            }, function(rowsChanged)
                if rowsChanged > 0 then
                    TriggerEvent("skam$garage:forceDeleteVehicleByPlate", plate)
                    xPlayer.showNotification('Pojazd został przeniesiony do garażu.')
                else
                    xPlayer.showNotification('Nie udało się przenieść pojazdu do garażu.')
                end
            end)
        else
            xPlayer.showNotification('Nie posiadasz pojazdu typu "towing" o tej tablicy.')
        end
    end)
end)

RegisterNetEvent("skam$garage:unchlowAllVehicles", function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE identifier = @identifier AND type = @type', {
        ['@identifier'] = xPlayer.identifier,
        ['@type'] = 'towing'
    }, function(result)
        if result and #result > 0 then
            local totalCost = #result * 10000
            if xPlayer.getMoney() >= totalCost then
                xPlayer.removeMoney(totalCost)
                for _, vehicle in ipairs(result) do
                    MySQL.Async.execute('UPDATE owned_vehicles SET type = @newType WHERE plate = @plate AND identifier = @identifier', {
                        ['@newType'] = 'garage',
                        ['@plate'] = vehicle.plate,
                        ['@identifier'] = xPlayer.identifier
                    })
                    TriggerEvent("skam$garage:forceDeleteVehicleByPlate", vehicle.plate)
                end
                xPlayer.showNotification('Odholowano wszystkie pojazdy za kwotę $' .. totalCost .. '.')
            else
                xPlayer.showNotification('Nie masz wystarczająco pieniędzy. Koszt: $' .. totalCost .. '.')
            end
        else
            xPlayer.showNotification('Nie posiadasz pojazdów do odholowania.')
        end
    end)
end)

local addCarResponse = {}
ESX.RegisterCommand('addcar', 'zarzad', function(xPlayer, args, showError)
	args.playerId.triggerEvent('skam:onAddcarCommand', args.car, xPlayer.source)
	addCarResponse[args.playerId.source] = true
end, true, {help = 'Nadaj pojazd dla gracza', validate = true, arguments = {
    {name = 'playerId', help = 'ID gracza', type = 'player'},
	{name = 'car', help = 'Nazwa modelu', type = 'string'},
}})

RegisterServerEvent('skam:addCarResponse')
AddEventHandler('skam:addCarResponse', function(plate, modelHash, modelString, label, sender)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(sender)

    if not modelHash then
        xPlayer.showNotification("Użycie: /addcar [model] [rejestracja]")
        return
    end

    if addCarResponse[xPlayer.source] then
        MySQL.Async.fetchScalar('SELECT COUNT(*) FROM owned_vehicles WHERE identifier = @identifier AND plate = @plate', {
            ['@identifier'] = xPlayer.identifier,
            ['@plate'] = plate
        }, function(count)
            if count > 0 then
                xPlayer.showNotification("Masz już pojazd o tej rejestracji!")
                return
            end

            MySQL.Async.execute('INSERT INTO owned_vehicles (identifier, plate, vehicle, type) VALUES (@identifier, @plate, @vehicle, @type)', {
                ['@identifier'] = xPlayer.identifier,
                ['@plate'] = plate,
                ['@vehicle'] = json.encode({
                    model = modelHash,
                    plate = plate,
                    name = label,
                    icon = "fa-solid fa-car"
                }),
                ['@type'] = 'garage',
            }, function(rowsChanged)
                if rowsChanged > 0 then
                    xTarget.showNotification('Nadano pojazd z rejestracją '..plate..' dla '..xPlayer.name..' ('..xPlayer.source..')', 'success')
                    xPlayer.showNotification('Otrzymano pojazd z rejestracją '..plate, 'success')
                else
                    xPlayer.showNotification("Nie udało się dodać pojazdu.")
                end
            end)
        end)
        addCarResponse[xPlayer.source] = nil
    end
end)

ESX.RegisterCommand('removecar', 'zarzad', function(xPlayer, args, showError)
	local plate = args.plate:gsub("%-", " ")
	local deletedResults = 0
	MySQL.query('SELECT plate FROM owned_vehicles WHERE plate = ?', {plate}, function(data)
        if data then
			for k, v in pairs(data) do
				deletedResults = deletedResults + 1
				MySQL.update('DELETE FROM owned_vehicles WHERE plate = ?', {v.plate})
			end
			if xPlayer then
				xPlayer.showNotification('Usunięto: '..deletedResults..' rekordów ('..plate..')', 'success')
			else
				print('Usunięto: '..deletedResults..' rekordów ('..plate..')')
			end
        end
	end)
end, true, {help = 'Usuń pojazd z bazy danych', validate = true, arguments = {
	{name = 'plate', help = 'Rejestracja (spacje zastąp "-")', type = 'string'},
}})

ESX.RegisterCommand("odbierzauto", "user", function(xPlayer, args, showError)
    if not xPlayer then return end

    MySQL.Async.fetchScalar('SELECT starterCar FROM users WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    }, function(starterCar)
        if starterCar == 1 then
            xPlayer.showNotification("Już odebrałeś swój samochód startowy!")
            return
        end

        local function generatePlate()
            local letters = ""
            for i = 1, 3 do
                letters = letters .. string.char(math.random(65, 90))
            end
            local numbers = tostring(math.random(1111, 9999))
            return letters .. ' ' .. numbers
        end

        local plate = generatePlate()
        local starterVehicle = "skam_gtr"

        MySQL.Async.execute('INSERT INTO owned_vehicles (identifier, plate, vehicle) VALUES (@identifier, @plate, @vehicle)', {
            ['@identifier'] = xPlayer.identifier,
            ['@plate'] = plate,
            ['@vehicle'] = json.encode({model = GetHashKey(starterVehicle), plate = plate})
        }, function(rowsChanged)
            MySQL.Async.execute('UPDATE users SET starterCar = 1 WHERE identifier = @identifier', {
                ['@identifier'] = xPlayer.identifier
            })
            xPlayer.showNotification("Otrzymałeś swój samochód startowy: ~y~"..plate)
        end)
    end)
end, false)