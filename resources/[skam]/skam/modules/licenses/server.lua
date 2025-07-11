local UsersLicenses = {}

MySQL.ready(function()
    MySQL.query('SELECT identifier, license FROM users', {}, function(data)
        if data then
            for i = 1, #data do
                UsersLicenses[data[i].identifier] = json.decode(data[i].license)
            end
        end
	end)
end)

local function updateUserLicenses(identifier)
    MySQL.update.await('UPDATE users SET license = ? WHERE identifier = ? ', {json.encode(UsersLicenses[identifier]), identifier})
end

local function addLicense(identifier, license, temporary)
    if Config['licenses'][license] then
        if not UsersLicenses[identifier] then
            UsersLicenses[identifier] = {}
        end
        if temporary then
            UsersLicenses[identifier][license] = temporary
        else
            UsersLicenses[identifier][license] = true
        end

        updateUserLicenses(identifier)
    end
end

local function removeLicense(identifier, license)
    if Config['licenses'][license] then
        if not UsersLicenses[identifier] then
            UsersLicenses[identifier] = {}
        elseif UsersLicenses[identifier][license] then
            UsersLicenses[identifier][license] = nil
            updateUserLicenses(identifier)
        end
    end
end

local function checkLicense(identifier, license)
    if not UsersLicenses[identifier] then
        UsersLicenses[identifier] = {}
        return false
    elseif UsersLicenses[identifier][license] then
        return UsersLicenses[identifier][license]
    else
        return false
    end
end

local function getLicenses(identifier)
    if not UsersLicenses[identifier] then
        UsersLicenses[identifier] = {}
    end

    return UsersLicenses[identifier]
end
exports('getLicenses', getLicenses)

local function getConfig()
    return Config['licenses']
end
exports('getConfig', getConfig)

AddEventHandler('skam:getLicenses', function(identifier, cb)
    cb(getLicenses(identifier))
end)

AddEventHandler('skam:checkLicense', function(identifier, license, cb)
    cb(checkLicense(identifier, license))
end)

AddEventHandler('skam:addLicense', function(identifier, license, temporary, cb)
    cb(addLicense(identifier, license, temporary))
end)

AddEventHandler('skam:removeLicense', function(identifier, license, cb)
    cb(removeLicense(identifier, license))
end)

ESX.RegisterCommand('addlicense', {'admin', 'superadmin', 'trialzarzad', 'zarzad', 'glownyzarzad', 'managment'}, function(xPlayer, args, showError)
	if args.playerId and args.license then
        addLicense(args.playerId.identifier, args.license, args.time and os.time() + ESX.Math.Round(args.time * 3600) or false)
        args.playerId.showNotification('Nadano licencję '..args.license..' dla '..args.playerId.source, 'success')
    end
end, true, {help = 'Nadaj licencję dla gracza', arguments = {
	{name = 'playerId', help = 'ID gracza', type = 'player', validate = true},
	{name = 'license', help = 'Nazwa licencji', type = 'string', validate = true},
    {name = 'time', help = 'Czas (w godzinach)', type = 'number', validate = false}
}})

ESX.RegisterCommand('removelicense', {'admin', 'superadmin', 'trialzarzad', 'zarzad', 'glownyzarzad', 'managment'}, function(xPlayer, args, showError)
	if args.playerId and args.license then
        removeLicense(args.playerId.identifier, args.license)
        args.playerId.showNotification('Usunięto licencję '..args.license..' dla '..args.playerId.source, 'success')
    end
end, true, {help = 'Zabierz licencję dla gracza', validate = true, arguments = {
	{name = 'playerId', help = 'ID gracza', type = 'player'},
	{name = 'license', help = 'Nazwa licencji', type = 'string'}
}})

ESX.RegisterServerCallback('skam:checkLicense', function(source, cb, target, licenseType)
    local xPlayer = nil
    if not target then
	    xPlayer = ESX.GetPlayerFromId(source)
    else
        xPlayer = ESX.GetPlayerFromId(target)
    end
	cb(checkLicense(xPlayer.identifier, licenseType))
end)

ESX.RegisterServerCallback('skam:getlicenses', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	cb(getLicenses(xPlayer.identifier))
end)