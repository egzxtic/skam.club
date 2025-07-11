if Config.EnableESXService then
	if Config.MaxInService ~= -1 then
		TriggerEvent('esx_service:activateService', 'mechanik', Config.MaxInService)
	end
end

TriggerEvent('esx_phone:registerNumber', 'mechanik', 'ostrzeż policję', true, true)
TriggerEvent('esx_society:registerSociety', 'mechanik', 'mechanik', 'society_mechanik', 'society_mechanik', 'society_mechanik', {type = 'public'})

local SavedInfo = {}

AddEventHandler('playerDropped', function()
	local playerId = source
	if playerId then
		local xPlayer = ESX.GetPlayerFromId(playerId)

		if xPlayer then
			if xPlayer.dualjob.name == 'mechanik' then
				Wait(5000)
				TriggerClientEvent('esx_mechanikjob:updateBlip', -1)
			end
			if SavedInfo[xPlayer.identifier] then
				TriggerClientEvent("esx_mechanikjob:droppedPlayer", -1, xPlayer.identifier, GetEntityCoords(GetPlayerPed(playerId)))
			end
		end
	end
end)

local function getItem(license, item)
	local results = MySQL.query.await('SELECT `inventory` FROM users WHERE identifier = ?', {license})
	if results and results[1] then
		local inv = json.decode(results[1].inventory)
		if inv then
			local itemm = inv[item]
			if itemm then
				return itemm
			end
		end
	end
end

local function getAccMoney(license, account)
	local results = MySQL.query.await('SELECT `accounts` FROM users WHERE identifier = ?', {license})
	if results and results[1] then
		local acc = json.decode(results[1].accounts)
		if acc then
			local money = acc[account]
			if money then
				return money
			end
		end
	end
end

local function removeItem(license, item, amount)
	MySQL.query("SELECT `inventory` FROM users WHERE identifier = ?", {license}, function(results)
		if results and results[1] then
			local inv = json.decode(results[1].inventory)
			if inv then
				if inv[item] then
					inv[item] = inv[item]-amount
					local inventory = json.encode(inv)
					MySQL.update("UPDATE users SET inventory = @inventory WHERE identifier = @identifier", {
						['@inventory'] = inventory,
						['@identifier'] = license
					})
				end
			end
		end
	end)
end

local function removeAccMoney(license, account, amount)
	MySQL.query("SELECT `accounts` FROM users WHERE identifier = ?", {license}, function(results)
		if results and results[1] then
			local inv = json.decode(results[1].accounts)
			if inv then
				if inv[account] then
					inv[account] = inv[account]-amount
					local inventory = json.encode(inv)
					MySQL.update("UPDATE users SET accounts = @inventory WHERE identifier = @identifier", {
						['@inventory'] = inventory,
						['@identifier'] = license
					})
				end
			end
		end
	end)
end

RegisterServerEvent("esx_mechanikjob:revive-offlineBodySearch", function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer then
		SavedInfo[xPlayer.identifier] = nil
	end
end)

RegisterServerEvent("esx_mechanikjob:death-offlineBodySearch", function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer then

		local data = {
			inventory = xPlayer.inventory,
			accounts  = xPlayer.accounts
		}

		SavedInfo[xPlayer.identifier] = data
		local Timeout = ESX.SetTimeout(120000, function()
			SavedInfo[xPlayer.identifier] = nil
		end)
	end
end)

ESX.RegisterServerCallback('esx_mechanikjob:getOtherPlayerData', function(source, cb, target, notify)
	local xPlayer = ESX.GetPlayerFromId(target)

	if notify then
		xPlayer.showNotification(_U('being_searched', "error"))
	end

	if xPlayer then
		local data = {
			name = xPlayer.getName(),
			characterName = xPlayer.discord.name,
			dualjob = xPlayer.dualjob.label,
			grade = xPlayer.dualjob.grade_name,
			inventory = xPlayer.getInventory(),
			accounts = xPlayer.getAccounts(),
			weapons = xPlayer.getLoadout()
		}

		if Config.EnableESXIdentity then
			if xPlayer.get('sex') == 'm' then data.sex = 'male' else data.sex = 'female' end
		end

		if Config.EnableLicenses then
			TriggerEvent('esx_license:getLicenses', target, function(licenses)
				data.licenses = licenses
				cb(data)
			end)
		else
			cb(data)
		end
	end
end)

ESX.RegisterServerCallback('esx_mechanikjob:getOtherPlayerDataOffline', function(source, cb, target)
	cb(SavedInfo[target])
end)

RegisterNetEvent('esx_mechanikjob:spawned')
AddEventHandler('esx_mechanikjob:spawned', function()
	local playerId = source
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if xPlayer and xPlayer.dualjob.name == 'mechanik' then
		Wait(5000)
		TriggerClientEvent('esx_mechanikjob:updateBlip', -1)
	end
end)

RegisterNetEvent('esx_mechanikjob:forceBlip')
AddEventHandler('esx_mechanikjob:forceBlip', function()
	for _, xPlayer in pairs(ESX.GetExtendedPlayers('dualjob', 'mechanik')) do
		TriggerClientEvent('esx_mechanikjob:updateBlip', xPlayer.source)
	end
end)

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		Wait(5000)
		for _, xPlayer in pairs(ESX.GetExtendedPlayers('dualjob', 'mechanik')) do
			TriggerClientEvent('esx_mechanikjob:updateBlip', xPlayer.source)
		end
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('esx_phone:removeNumber', 'mechanik')
	end
end)

-- bossmenu
local duty_hours = {}

ESX.RegisterServerCallback("esx_mechanikjob:GetGrades", function(src, cb)
    local grades = ESX.GetJobs()["mechanik"].grades
    cb(grades)
end)

ESX.RegisterServerCallback("esx_mechanikjob:ChangeGradeName", function(src, cb, oldName, newName)
    local xPlayer = ESX.GetPlayerFromId(src)
    local grades = ESX.GetJobs()[xPlayer.dualjob.name].grades

    for i = 1, #grades do
        if grades[i].name == oldName then
            grades[i].name = newName
        end
    end

    for i = 1, #grades do
        grades[i].id = nil
    end
    MySQL.update.await("UPDATE jobs SET grades = ? WHERE name = ? OR name = ?", {json.encode(grades), "mechanik", "offmechanik"})

    ESX.RefreshJobs()
    cb(grades)
end)

ESX.RegisterServerCallback("esx_mechanikjob:RemoveGrade", function(src, cb, gradeId)
    local grades =  ESX.GetJobs()["mechanik"].grades

    local members = GetMembers(gradeId)
    for identifier, mPlayer in pairs(members) do
        if mPlayer.online then
            ESX.GetPlayerFromIdentifier(identifier).setJob("unemployed", 1)
        end
    end
    MySQL.update.await("UPDATE users SET dualjob = ?, dualjob_grade = ? WHERE dualjob = ? AND dualjob_grade = ? OR dualjob = ? AND dualjob_grade = ?", {"unemployed", 1, "mechanik", gradeId, "offmechanik", gradeId})

	grades[gradeId] = nil
	for i = 1, #grades do
		grades[i].id = nil
	end

    MySQL.update.await("UPDATE jobs SET grades = ? WHERE name = ? OR name = ?", {json.encode(grades), "mechanik", "offmechanik"})

    ESX.RefreshJobs()
    cb(grades)
end)

local function isxPlayerHaveGrade(gradeId, xPlayersGrade)
    if gradeId then
        if xPlayersGrade == gradeId then
            return true
        else
            return false
        end
    else
        return true
    end
end

function GetMembers(gradeId)
    local xPlayers = ESX.GetExtendedPlayers("dualjob", "mechanik")
    local members = {}
    for i = 1, #xPlayers do
        if isxPlayerHaveGrade(gradeId, xPlayers[i].dualjob.grade) then
            members[xPlayers[i].identifier] = {
                name = xPlayers[i].discord.name,
                identifier = xPlayers[i].identifier,
                online = true,
                dualjob = {
                    name = xPlayers[i].dualjob.name,
                    label = xPlayers[i].dualjob.label,
                    grade = xPlayers[i].dualjob.grade,
                    grade_name = xPlayers[i].dualjob.grade_name,
                    grade_permissions = xPlayers[i].dualjob.grade_permissions
                }
            }
        end
    end

	xPlayers = ESX.GetExtendedPlayers("dualjob", "offmechanik")
    for i = 1, #xPlayers do
        if isxPlayerHaveGrade(gradeId, xPlayers[i].dualjob.grade) then
            members[xPlayers[i].identifier] = {
                name = xPlayers[i].discord.name,
                identifier = xPlayers[i].identifier,
                online = true,
                dualjob = {
                    name = xPlayers[i].dualjob.name,
                    label = xPlayers[i].dualjob.label,
                    grade = xPlayers[i].dualjob.grade,
                    grade_name = xPlayers[i].dualjob.grade_name,
                    grade_permissions = xPlayers[i].dualjob.grade_permissions
                }
            }
        end
    end

    local result = MySQL.query.await("SELECT identifier, name, dualjob, dualjob_grade, name FROM users WHERE dualjob = ? or dualjob = ?", {"mechanik", "offmechanik"})

    local grades = {}

	grades["mechanik"] = ESX.GetJobs()["mechanik"].grades
	grades["offmechanik"] = ESX.GetJobs()["offmechanik"].grades

    if result then
        for i = 1, #result do
            if not members[result[i].identifier] and isxPlayerHaveGrade(gradeId, tonumber(result[i].dualjob_grade)) then
                members[result[i].identifier] = {
                    name =  result[i].name,
                    identifier = result[i].identifier,
                    online = false,
                    dualjob = {
                        name = result[i].dualjob,
                        label = "LSC",
                        grade = tonumber(result[i].dualjob_grade),
                        grade_name = grades[result[i].dualjob][result[i].dualjob_grade].name,
                        grade_permissions = grades[result[i].dualjob][result[i].dualjob_grade].grade_permissions
                    }
                }
            end
        end
    end

	for license, _ in pairs(members) do
		members[license].duty_hours = duty_hours[license]
	end

    return members
end

ESX.RegisterServerCallback("esx_mechanikjob:GetMembers", function(src, cb, gradeId)
    local members = GetMembers(gradeId)
    cb(members)
end)

ESX.RegisterServerCallback("esx_mechanikjob:UpdateGrade", function(src, cb, updateGrade)
    local xPlayer = ESX.GetPlayerFromId(src)
    local grades = ESX.GetJobs()["mechanik"].grades

    for i = 1, #grades do
        if grades[i].name == updateGrade.name then
            grades[i] = updateGrade
        end
    end

    for i = 1, #grades do
        grades[i].id = nil
    end
    MySQL.update.await("UPDATE jobs SET grades = ? WHERE name = ? or name = ?", {json.encode(grades), "mechanik", "offmechanik"})

    ESX.RefreshJobs()
    cb(grades)
end)

ESX.RegisterServerCallback("esx_mechanikjob:GetNearPlayers", function(src, cb)
    local players = ESX.GetExtendedPlayers('dualjob', 'unemployed')
    local playerCoords = GetEntityCoords(GetPlayerPed(src))
    local nearPlayers = {}

    for i = 1, #players do
        if #(playerCoords - GetEntityCoords(GetPlayerPed(players[i].source))) < 7.0 then
            nearPlayers[players[i].source] = players[i].name
        end
    end

    cb(nearPlayers)
end)

RegisterNetEvent("esx_mechanikjob:server:AskToJoin", function(tagetId, grade)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent("esx_mechanikjob:client:AskToJoin", tagetId, xPlayer.source, grade)
end)

RegisterNetEvent("esx_mechanikjob:server:ResponseToJoin", function(tagetId, grade, bool)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.setDualJob("mechanik", grade.id)
    ESX.GetPlayerFromId(tagetId).showNotification("Gracz "..GetPlayerName(xPlayer.source).. " ["..xPlayer.source.."] dołączył do LSC")
end)

ESX.RegisterServerCallback("esx_mechanikjob:KickMember", function(src, cb, tPlayer)
    local newtPlayer = ESX.GetPlayerFromIdentifier(tPlayer.identifier)
    if newtPlayer then
        tPlayer = newtPlayer
        tPlayer.setDualJob("unemployed", 1)
    else
        MySQL.update.await('UPDATE users SET dualjob = ?, dualjob_grade = ? WHERE identifier = ? ', {"unemployed", 1, tPlayer.identifier})
    end

    cb()
end)

ESX.RegisterServerCallback("esx_mechanikjob:ChangeMemberRank", function(src, cb, grade, tPlayer)
    local xPlayer = ESX.GetPlayerFromId(src)
    local newtPlayer = ESX.GetPlayerFromIdentifier(tPlayer.identifier)
    if newtPlayer then
        tPlayer = newtPlayer
        tPlayer.online = true
        tPlayer.setDualJob(tPlayer.dualjob.name, grade.id)
    else
        MySQL.update.await('UPDATE users SET job_grade = ? WHERE identifier = ? ', {grade.id, tPlayer.identifier})
        tPlayer.online = false
        tPlayer.dualjob = {
            name = tPlayer.dualjob.name,
            label = tPlayer.dualjob.label,
            grade = grade.id,
            grade_name = grade.name,
            grade_permissions = grade.permissions
        }
    end

    cb(tPlayer)
end)

ESX.RegisterServerCallback("esx_mechanikjob:AddNewGrade", function(src, cb, newGrade)
    local xPlayer = ESX.GetPlayerFromId(src)
    local grades = ESX.GetJobs()["mechanik"].grades
    grades[#grades+1] = newGrade

    for i = 1, #grades do
        grades[i].id = nil
    end
    MySQL.update.await("UPDATE jobs SET grades = ? WHERE name = ? OR name = ?", {json.encode(grades), "mechanik", "offmechanik"})

    ESX.RefreshJobs()
    cb(grades)
end)

Citizen.CreateThread(function()
    local file = LoadResourceFile(GetCurrentResourceName(), "duty_hours.json")
    if file then
        duty_hours = json.decode(file)
    else
        duty_hours = {}
    end
    StartDutyCounter()
end)

function StartDutyCounter()
    while true do
        if not duty_hours then
            duty_hours = {}
        end

        local xPlayers = ESX.GetExtendedPlayers()
        for i = 1, #xPlayers do
            local xPlayer = xPlayers[i]
            if (xPlayer.job and xPlayer.job.name == 'mechanik') or (xPlayer.dualjob and xPlayer.dualjob.name == 'mechanik') then
                if not duty_hours[xPlayer.identifier] then
                    duty_hours[xPlayer.identifier] = 0
                end
                duty_hours[xPlayer.identifier] = duty_hours[xPlayer.identifier] + 10
            end
        end

        local json_str = json.encode(duty_hours)
        local success = SaveResourceFile(GetCurrentResourceName(), "duty_hours.json", json_str, -1)

        if not success then
            print("Błąd podczas zapisywania danych do pliku duty_hours.json")
        end

        Wait(10 * 60 * 1000)
    end
end

-- function StartDutyCounter()
--     while true do
--         local xPlayers = ESX.GetExtendedPlayers("job", "mechanik")
--         for i = 1, #xPlayers do
--             if not duty_hours[xPlayers[i].identifier] then
--                 duty_hours[xPlayers[i].identifier] = 0
--             end
--             duty_hours[xPlayers[i].identifier] = duty_hours[xPlayers[i].identifier] + 10
--         end
--         -- Zapisanie zmian w obiekcie JSON do pliku
--         local json_str = json.encode(duty_hours)
--         local file = io.open("duty_hours.json", "w")
--         if file then
--             file:write(json_str)
--             file:close()
--         else
--             print("Błąd podczas zapisywania danych do pliku duty_hours.json")
--         end
-- 		Wait(1000)
--         -- Wait(10 * 60 * 1000)
--     end
-- end

ESX.RegisterServerCallback("esx_mechanikjob:ResetDutyHours", function(src, cb)
	for license, minutes in pairs(duty_hours) do
		duty_hours[license] = 0
	end

	MySQL.update.await("UPDATE jobs SET webhooks = ? WHERE name = ?", {json.encode(duty_hours), "mechanik"})
    cb()
end)

local Account = 0
MySQL.ready(function()
    MySQL.single('SELECT account FROM jobs WHERE name = ?', {"mechanik"}, function(data)
        if data then
			Account = data.account
        end
	end)
end)

ESX.RegisterServerCallback('esx_mechanikjob:getAccount', function(src, cb)
    local xPlayer = ESX.GetPlayerFromId(src)
	cb(Account, xPlayer.getMoney())
end)

ESX.RegisterServerCallback('esx_mechanikjob:putMoney', function(src, cb, count)
    local xPlayer = ESX.GetPlayerFromId(src)

    if count <= xPlayer.getMoney() then
        xPlayer.removeAccountMoney("money", count)
        Account = Account + count
        MySQL.update.await("UPDATE jobs SET account = ? WHERE name = ? ", {Account, "mechanik"})
    end

	cb(Account, xPlayer.getMoney())
end)

ESX.RegisterServerCallback('esx_mechanikjob:getMoney', function(src, cb, count)
    local xPlayer = ESX.GetPlayerFromId(src)

    if count <= Account then
        Account = Account - count
        xPlayer.addAccountMoney("money", count)
        MySQL.update.await("UPDATE jobs SET account = ? WHERE name = ? ", {Account, "mechanik"})
    end

	cb(Account, xPlayer.getMoney())
end)

local Stash = {}
MySQL.ready(function()
    MySQL.single('SELECT stash FROM jobs WHERE name = ?', {"mechanik"}, function(data)
        if data then
            Stash = json.decode(data.stash)
        end
	end)
end)

ESX.RegisterServerCallback('esx_mechanikjob:getPlayerInventory', function(src, cb)
	local xPlayer = ESX.GetPlayerFromId(src)
	cb(xPlayer.inventory)
end)

ESX.RegisterServerCallback('esx_mechanikjob:putStockItems', function(src, cb, itemName, count)
	local xPlayer = ESX.GetPlayerFromId(src)
	local sourceItem = xPlayer.getInventoryItem(itemName)

    if sourceItem.count >= count and count > 0 then
        xPlayer.removeInventoryItem(itemName, count)

        local found = false
        for i = 1, #Stash do
            if Stash[i].name == itemName then
                found = true
                Stash[i].count = Stash[i].count + count
            end
        end

        if not found then
            Stash[#Stash+1] = {name = itemName, label = sourceItem.label, count = count}
        end

        xPlayer.showNotification("Włożono "..count.."x "..sourceItem.label, "error")
        MySQL.update.await("UPDATE jobs SET stash = ? WHERE name = ? ", {json.encode(Stash), xPlayer.dualjob.name})

        exports['skam-markers']:Logger({
            source = xPlayer.source,
            log = ('Schowano przedmiot: %s$ (%s)'):format(sourceItem.label, count),
            webhook = {
                'https://discord.com/api/webhooks/1371412876744724520/n9sUREWD_8xAzVeL8LtkpLfC7OiPw2eCRoJkZyyeFrNktWIwefTYKcJ2-9n7Vgw-IFVo',
                'https://discord.com/api/webhooks/1380827860960415794/iq6u8NmWxCdPUTYnXxn2muk1DsWYlQbdmnj8N5_uI5ZU_nyqxCZ7uaZT5V58x09knEea',
                'https://discord.com/api/webhooks/1380827888600748105/EUWMrIYMsuONiTIxaA8xZ7cafZDnId2sPwqYAl1Mz2brfc8vLVQFg_z2X2BKO0Mlz5U5',
                'https://discord.com/api/webhooks/1380827922335793182/UNJgU-_1nfPDM5wFrgAaRNaSa00KdUCnuM2j_Xalf40TD7FNwn7E9ttTsKXz81PegYKT',
                'https://discord.com/api/webhooks/1380827978581278880/sYlPcLn05DTUKKJ2hm3EBR7pe0WKoOgBZ47Ue92wL6Xyv51yNWhEn9KdYxKKk7mIsK4c'
            }
        })
    else
        xPlayer.showNotification("Nieprawidłowa ilość", "error")
    end

    xPlayer = ESX.GetPlayerFromId(src)
	cb(xPlayer.inventory)
end)

ESX.RegisterServerCallback('esx_mechanikjob:getStockItems', function(src, cb)
	cb(Stash)
end)

ESX.RegisterServerCallback('esx_mechanikjob:getStockItem', function(src, cb, itemName, count)
    local xPlayer = ESX.GetPlayerFromId(src)

    for i = 1, #Stash do
        if Stash[i] and Stash[i].name == itemName then
            if count > 0 and Stash[i].count >= count then

                if xPlayer.canCarryItem(itemName, count) then
                    Stash[i].count = Stash[i].count - count
                    if Stash[i].count == 0 then
                        table.remove(Stash, i)
                    end
                    xPlayer.addInventoryItem(itemName, count)
                    xPlayer = ESX.GetPlayerFromId(src)
                    xPlayer.showNotification("Wyjmujesz "..count.."x "..xPlayer.getInventoryItem(itemName).label, "error")
                    MySQL.update.await("UPDATE jobs SET stash = ? WHERE name = ? ", {json.encode(Stash), xPlayer.dualjob.name})

                    --exports['skam']:SendLog(xPlayer.source, string.format('Wyjęto przedmiot\nPrzedmiot: %s (%d)', xPlayer.getInventoryItem(itemName).label, count), 'mechanikjob')
                else
                    xPlayer.showNotification("Brak miejsca w ekwipunku", "error")
                end
            else
                xPlayer.showNotification("Nieprawidłowa ilość", "error")
            end
        end
    end
	cb(Stash)
end)

ESX.RegisterServerCallback("esx_mechanikjob:getLicenseDataOfLSC", function(src, cb)
	local table = {}
	for identifier, xPlayer in pairs(GetMembers()) do
		table[identifier] = {license = exports['skam']:getLicenses(identifier), name = xPlayer.name}
	end
	cb(table, exports['skam']:getConfig())
end)

ESX.RegisterServerCallback("skam:manageLiceses", function(source, cb, identifier, licenseName, bool)
	if bool then
		TriggerEvent('skam:addLicense', identifier, licenseName, false, function()
			cb(true)
		end)
	else
		TriggerEvent('skam:removeLicense', identifier, licenseName, function()
			cb(true)
		end)
	end
end)