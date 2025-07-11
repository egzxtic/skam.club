TriggerEvent('esx_society:registerSociety', 'police', 'Police', 'society_police', 'society_police', 'society_police', {type = 'public'})

local jestespedalem = false

SetLoot = function(state)
    jestespedalem = state
end

GetLoot = function()
    return jestespedalem
end

RegisterNetEvent('esx_policejob:confiscatePlayerItem', function(target, itemType, itemName, amount)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local xTarget = ESX.GetPlayerFromId(target)

    -- if not jestespedalem then
    --     xPlayer.showNotification("Nie mozesz jeszcze lootwac graczy.")
    --     return
    -- end

    if not xTarget then
        return
    end

    if itemType == 'item_standard' then
        local targetItem = xTarget.getInventoryItem(itemName)
        local sourceItem = xPlayer.getInventoryItem(itemName)

        if targetItem.count > 0 and targetItem.count <= amount then
            if xPlayer.canCarryItem(itemName, sourceItem.count) then
                xTarget.removeInventoryItem(itemName, amount)
                xPlayer.addInventoryItem   (itemName, amount)
                xPlayer.showNotification(_U('you_confiscated', amount, sourceItem.label, xTarget.name))
                xTarget.showNotification(_U('got_confiscated', amount, sourceItem.label, xPlayer.name))
                --exports['skam']:SendLog(xPlayer.source, string.format("Zabral Przedmioty [%s]: \n%s (%d)", xTarget.source, sourceItem.label, amount), 'handcuffs')
            else
                xPlayer.showNotification(_U('quantity_invalid'))
            end
        else
            xPlayer.showNotification('Brak miejsca w ekwipunku', 'error')
        end

	elseif itemType == 'item_account' then
		local targetAccount = xTarget.getAccount(itemName)
		if targetAccount.money >= amount then
			xTarget.removeAccountMoney(itemName, amount, "Confiscated")
			xPlayer.addAccountMoney   (itemName, amount, "Confiscated")

			xPlayer.showNotification(_U('you_confiscated_account', amount, itemName, xTarget.name), "error")
			xTarget.showNotification(_U('got_confiscated_account', amount, itemName, xPlayer.name), "error")
		else
			xPlayer.showNotification(_U('quantity_invalid'), "error")
		end

	elseif itemType == 'item_weapon' then
		if amount == nil then amount = 0 end

		if xTarget.hasWeapon(itemName) then
			xTarget.removeWeapon(itemName)
			xPlayer.addWeapon   (itemName, amount)

			xPlayer.showNotification(_U('you_confiscated_weapon', ESX.GetWeaponLabel(itemName), xTarget.name, amount), "error")
			xTarget.showNotification(_U('got_confiscated_weapon', ESX.GetWeaponLabel(itemName), amount, xPlayer.name), "error")
		else
			xPlayer.showNotification(_U('quantity_invalid'), "error")
		end
	end
end)

function calcCoords(source, target)
    if target == -1 then
        return false
    end

    local sourceCoords = GetEntityCoords(GetPlayerPed(source))
    local targetCoords = GetEntityCoords(GetPlayerPed(target))

    if #(sourceCoords - targetCoords) > 10.0 then
       return false
    end

    return true
end

RegisterNetEvent('esx_policejob:handcuff')
AddEventHandler('esx_policejob:handcuff', function(target, isPed)
	local src = source

	if isPed then
		TriggerClientEvent('esx_policejob:handcuffPed', src, target)
	else
		if calcCoords(src, target) then
            --exports['skam']:SendLog(src, string.format("Zakul: %s", target), 'handcuffs')
			TriggerClientEvent('esx_policejob:handcuff', target)
		end
	end
end)

RegisterNetEvent('esx_policejob:drag')
AddEventHandler('esx_policejob:drag', function(target, isPed)
	local src = source
	if isPed then
		TriggerClientEvent('esx_policejob:dragPed', src, target)
	else
		if calcCoords(src, target) then
			TriggerClientEvent('esx_policejob:drag', target, src)
		end
	end
end)

RegisterNetEvent('esx_policejob:putInVehicle')
AddEventHandler('esx_policejob:putInVehicle', function(target)
	local src = source
	if calcCoords(src, target) then
		TriggerClientEvent('esx_policejob:putInVehicle', target)
	end
end)

RegisterNetEvent('esx_policejob:OutVehicle')
AddEventHandler('esx_policejob:OutVehicle', function(target)
	local src = source
	if calcCoords(src, target) then
		TriggerClientEvent('esx_policejob:OutVehicle', target)
	end
end)

ESX.RegisterServerCallback('esx_policejob:getVehicleInfos', function(source, cb, plate)
	local retrivedInfo = {
		plate = plate
	}
	if Config.EnableESXIdentity then
		MySQL.single('SELECT users.name FROM owned_vehicles JOIN users ON owned_vehicles.identifier = users.identifier WHERE plate = ?', {plate},
		function(result)
			if result then
				retrivedInfo.owner = ('%s %s'):format(result.name)
			end
			cb(retrivedInfo)
		end)
	else
		MySQL.scalar('SELECT identifier FROM owned_vehicles WHERE plate = ?', {plate},
		function(owner)
			if owner then
				local xPlayer = ESX.GetPlayerFromIdentifier(owner)
				if xPlayer then
					retrivedInfo.owner = xPlayer.getName()
				end
			end
			cb(retrivedInfo)
		end)
	end
end)

local SavedInfo = {}

AddEventHandler('playerDropped', function()
	local playerId = source
	if playerId then
		local xPlayer = ESX.GetPlayerFromId(playerId)

		if xPlayer then
			if xPlayer.job.name == 'police' then
				Wait(5000)
				TriggerClientEvent('esx_policejob:updateBlip', -1)
			end
			-- if SavedInfo[xPlayer.identifier] then
			-- 	TriggerClientEvent("esx_policejob:droppedPlayer", -1, xPlayer.identifier, GetEntityCoords(GetPlayerPed(playerId)))
			-- end
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

RegisterServerEvent("esx_policejob:revive-offlineBodySearch", function()
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if xPlayer then
		SavedInfo[xPlayer.identifier] = nil
	end
end)

RegisterServerEvent("esx_policejob:death-offlineBodySearch", function()
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
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

ESX.RegisterServerCallback('esx_policejob:getOtherPlayerData', function(source, cb, target, notify)
	local xPlayer = ESX.GetPlayerFromId(target)

	if notify then
		xPlayer.showNotification(_U('being_searched'))
	end

	if xPlayer then
		local data = {
			name = xPlayer.getName(),
			--characterName = xPlayer.get('firstName') .. ' ' .. xPlayer.get('lastName'),
			job = xPlayer.job.label,
			grade = xPlayer.job.grade_name,
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

-- ESX.RegisterServerCallback('esx_policejob:getOtherPlayerDataOffline', function(source, cb, target)
-- 	cb(SavedInfo[target])
-- end)

ESX.RegisterServerCallback('esx_policejob:getHandcuffsCount', function(source, cb, target)
	cb(ESX.GetPlayerFromId(source).getInventoryItem('handcuffs').count)
end)

RegisterServerEvent('esx_policejob:confiscatePlayerItemOffline', function(target, itemType, itemName, amount)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local xTarget = ESX.GetPlayerFromIdentifier(target)

	if not xTarget then
		if itemType == 'item_standard' then
			local targetItem = getItem(target, itemName)
			local sourceItem = xPlayer.getInventoryItem(itemName)

			if targetItem and targetItem > 0 and targetItem <= amount then
				if xPlayer.canCarryItem(itemName, sourceItem.count) then
					removeItem(target, itemName, amount)
					xPlayer.addInventoryItem   (itemName, amount)
					xPlayer.showNotification(_U('you_confiscated', amount, sourceItem.label, 'Gracza offline'), "error")

                    --exports['skam']:SendLog(xPlayer.source, string.format("Zabral Przedmioty (offline) [%s]: \n%s (%d)", target, sourceItem.label, amount), 'handcuffs')
				else
					xPlayer.showNotification(_U('quantity_invalid'), "error")
				end
			else
				xPlayer.showNotification(_U('quantity_invalid'), "error")
			end

		elseif itemType == 'item_account' then
			local targetAccount = getAccMoney(target, itemName)

			if targetAccount and targetAccount >= amount then
				removeAccMoney(target, itemName, amount)
				xPlayer.addAccountMoney(itemName, amount, "Confiscated")
				xPlayer.showNotification(_U('you_confiscated_account', amount, itemName, 'Gracza offline'), "error")
			else
				xPlayer.showNotification(_U('quantity_invalid'), "error")
			end
		end
	else
		xPlayer.showNotification('Gracz wrócił już na serwer', 'error')
	end
end)

RegisterNetEvent('esx_policejob:spawned')
AddEventHandler('esx_policejob:spawned', function()
	local playerId = source
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if xPlayer and xPlayer.job.name == 'police' then
		Wait(5000)
		TriggerClientEvent('esx_policejob:updateBlip', -1)
	end
end)

RegisterNetEvent('esx_policejob:forceBlip')
AddEventHandler('esx_policejob:forceBlip', function()
	for _, xPlayer in pairs(ESX.GetExtendedPlayers('job', 'police')) do
		TriggerClientEvent('esx_policejob:updateBlip', xPlayer.source)
	end
end)

local usedCommands = {
	['10-13'] = {},
	['code0'] = {},
}

RegisterCommand('10-13', function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
        if xPlayer.job and xPlayer.job.name == 'police' then
            local gpsItem = xPlayer.getInventoryItem('gps')

            if gpsItem and gpsItem.count > 0 then
                if Player(xPlayer.source).state.dead then
                    if not usedCommands['10-13'][xPlayer.source] then
                        usedCommands['10-13'][xPlayer.source] = true

                        for _, xTarget in pairs(ESX.GetExtendedPlayers('job', 'police')) do
                            if xTarget.source and GetPlayerPed(xPlayer.source) then
                                TriggerClientEvent('esx_policejob:send1013', xTarget.source, GetEntityCoords(GetPlayerPed(xPlayer.source)))
                                TriggerClientEvent('skam:showNotification', xTarget.source, {
                                    type = 'info',
                                    duration = 5000,
                                    title = 'RANNY FUNKCJONARIUSZ',
                                    text = '10-13 | ' .. xPlayer.discord.name
                                })
                            end
                        end

                        SetTimeout(20000, function()
                            usedCommands['10-13'][xPlayer.source] = nil
                        end)
                    end
                end
            else
                xPlayer.showNotification('Nie posiadasz GPS', 'error')
            end
        else
            -- Handle the case when the player is not a police officer
        end
    else
        -- Handle the case when xPlayer is nil
    end
end, false)


RegisterCommand('code0', function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)

    usedCommands = usedCommands or {}
    usedCommands['code0'] = usedCommands['code0'] or {}

    if xPlayer and xPlayer.job and xPlayer.job.name == 'police' then
        local gpsItem = xPlayer.getInventoryItem('gps')

        if gpsItem and gpsItem.count > 0 then
            if not usedCommands['code0'][xPlayer.source] then
                usedCommands['code0'][xPlayer.source] = true

                for _, xTarget in pairs(ESX.GetExtendedPlayers('job', 'police')) do
                    if xTarget and xTarget.source and xPlayer and xPlayer.source then
                        TriggerClientEvent('esx_policejob:sendCode0', xTarget.source, GetEntityCoords(GetPlayerPed(xPlayer.source)))
                        TriggerClientEvent('skam:showNotification', xTarget.source, {
                            type = 'info',
                            duration = 5000,
                            title = 'CODE 0',
                            text = 'POTRZEBNE WSPARCIE | ' .. xPlayer.discord.name
                        })
                    end
                end

                SetTimeout(20000, function()
                    usedCommands['code0'][xPlayer.source] = nil
                end)
            else
                xPlayer.showNotification('Kod 0 już został użyty', 'error')
            end
        else
            xPlayer.showNotification('Nie posiadasz GPS', 'error')
        end
    end
end, false)


AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		Wait(5000)
		for _, xPlayer in pairs(ESX.GetExtendedPlayers('job', 'police')) do
			TriggerClientEvent('esx_policejob:updateBlip', xPlayer.source)
		end
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('esx_phone:removeNumber', 'police')
	end
end)

-- bossmenu
local duty_hours = {}

ESX.RegisterServerCallback("esx_policejob:GetGrades", function(src, cb)
    local grades = ESX.GetJobs()["police"].grades
    cb(grades)
end)

ESX.RegisterServerCallback("esx_policejob:ChangeGradeName", function(src, cb, oldName, newName)
    local xPlayer = ESX.GetPlayerFromId(src)
    local grades = ESX.GetJobs()[xPlayer.job.name].grades

    for i = 1, #grades do
        if grades[i].name == oldName then
            grades[i].name = newName
        end
    end

    for i = 1, #grades do
        grades[i].id = nil
    end
    MySQL.update.await("UPDATE jobs SET grades = ? WHERE name = ? OR name = ?", {json.encode(grades), "police", "offpolice"})

    ESX.RefreshJobs()
    cb(grades)
end)

ESX.RegisterServerCallback("esx_policejob:RemoveGrade", function(src, cb, gradeId)
    local grades =  ESX.GetJobs()["police"].grades

    local members = GetMembers(gradeId)
    for identifier, mPlayer in pairs(members) do
        if mPlayer.online then
            ESX.GetPlayerFromIdentifier(identifier).setJob("unemployed", 1)
        end
    end
    MySQL.update.await("UPDATE users SET job = ?, job_grade = ? WHERE job = ? AND job_grade = ? OR job = ? AND job_grade = ?", {"unemployed", 1, "police", gradeId, "offpolice", gradeId})

	grades[gradeId] = nil
	for i = 1, #grades do
		grades[i].id = nil
	end

    MySQL.update.await("UPDATE jobs SET grades = ? WHERE name = ? OR name = ?", {json.encode(grades), "police", "offpolice"})

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
    local xPlayers = ESX.GetExtendedPlayers("job", "police")
    local members = {}
    for i = 1, #xPlayers do
        if isxPlayerHaveGrade(gradeId, xPlayers[i].job.grade) then
            members[xPlayers[i].identifier] = {
                name = xPlayers[i].discord.name,
                identifier = xPlayers[i].identifier,
                online = true,
                job = {
                    name = xPlayers[i].job.name,
                    label = xPlayers[i].job.label,
                    grade = xPlayers[i].job.grade,
                    grade_name = xPlayers[i].job.grade_name,
                    grade_permissions = xPlayers[i].job.grade_permissions
                }
            }
        end
    end

	xPlayers = ESX.GetExtendedPlayers("job", "offpolice")
    for i = 1, #xPlayers do
        if isxPlayerHaveGrade(gradeId, xPlayers[i].job.grade) then
            members[xPlayers[i].identifier] = {
                name = xPlayers[i].discord.name,
                identifier = xPlayers[i].identifier,
                online = true,
                job = {
                    name = xPlayers[i].job.name,
                    label = xPlayers[i].job.label,
                    grade = xPlayers[i].job.grade,
                    grade_name = xPlayers[i].job.grade_name,
                    grade_permissions = xPlayers[i].job.grade_permissions
                }
            }
        end
    end

    local result = MySQL.query.await("SELECT identifier, name, job, job_grade, name FROM users WHERE job = ? or job = ?", {"police", "offpolice"})

    local grades = {}

	grades["police"] = ESX.GetJobs()["police"].grades
	grades["offpolice"] = ESX.GetJobs()["offpolice"].grades

    if result then
        for i = 1, #result do
            if not members[result[i].identifier] and isxPlayerHaveGrade(gradeId, tonumber(result[i].job_grade)) then
                members[result[i].identifier] = {
                    name =  result[i].name,
                    identifier = result[i].identifier,
                    online = false,
                    job = {
                        name = result[i].job,
                        label = "SASP",
                        grade = tonumber(result[i].job_grade),
                        grade_name = grades[result[i].job][result[i].job_grade].name,
                        grade_permissions = grades[result[i].job][result[i].job_grade].grade_permissions
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

ESX.RegisterServerCallback("esx_policejob:GetMembers", function(src, cb, gradeId)
    local members = GetMembers(gradeId)
    cb(members)
end)

ESX.RegisterServerCallback("esx_policejob:UpdateGrade", function(src, cb, updateGrade)
    local xPlayer = ESX.GetPlayerFromId(src)
    local grades = ESX.GetJobs()["police"].grades

    for i = 1, #grades do
        if grades[i].name == updateGrade.name then
            grades[i] = updateGrade
        end
    end

    for i = 1, #grades do
        grades[i].id = nil
    end
    MySQL.update.await("UPDATE jobs SET grades = ? WHERE name = ? or name = ?", {json.encode(grades), "police", "offpolice"})

    ESX.RefreshJobs()
    cb(grades)
end)

ESX.RegisterServerCallback("esx_policejob:GetNearPlayers", function(src, cb)
    local players = ESX.GetExtendedPlayers('job', 'unemployed')
    local playerCoords = GetEntityCoords(GetPlayerPed(src))
    local nearPlayers = {}

    for i = 1, #players do
        if #(playerCoords - GetEntityCoords(GetPlayerPed(players[i].source))) < 7.0 then
            nearPlayers[players[i].source] = players[i].name
        end
    end

    cb(nearPlayers)
end)

RegisterNetEvent("esx_policejob:server:AskToJoin", function(tagetId, grade)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent("esx_policejob:client:AskToJoin", tagetId, xPlayer.source, grade)
end)

RegisterNetEvent("esx_policejob:server:ResponseToJoin", function(tagetId, grade, bool)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.setJob("police", grade.id)
    ESX.GetPlayerFromId(tagetId).showNotification("Gracz "..GetPlayerName(xPlayer.source).. " ["..xPlayer.source.."] dołączył do psiego patrolu")
end)

ESX.RegisterServerCallback("esx_policejob:KickMember", function(src, cb, tPlayer)
    local newtPlayer = ESX.GetPlayerFromIdentifier(tPlayer.identifier)
    if newtPlayer then
        tPlayer = newtPlayer
        tPlayer.setJob("unemployed", 1)
    else
        MySQL.update.await('UPDATE users SET job = ?, job_grade = ? WHERE identifier = ? ', {"unemployed", 1, tPlayer.identifier})
    end

    cb()
end)

ESX.RegisterServerCallback("esx_policejob:ChangeMemberRank", function(src, cb, grade, tPlayer)
    local xPlayer = ESX.GetPlayerFromId(src)
    local newtPlayer = ESX.GetPlayerFromIdentifier(tPlayer.identifier)
    if newtPlayer then
        tPlayer = newtPlayer
        tPlayer.online = true
        tPlayer.setJob(tPlayer.job.name, grade.id)
    else
        MySQL.update.await('UPDATE users SET job_grade = ? WHERE identifier = ? ', {grade.id, tPlayer.identifier})
        tPlayer.online = false
        tPlayer.job = {
            name = tPlayer.job.name,
            label = tPlayer.job.label,
            grade = grade.id,
            grade_name = grade.name,
            grade_permissions = grade.permissions
        }
    end

    cb(tPlayer)
end)

ESX.RegisterServerCallback("esx_policejob:AddNewGrade", function(src, cb, newGrade)
    local xPlayer = ESX.GetPlayerFromId(src)
    local grades = ESX.GetJobs()["police"].grades
    grades[#grades+1] = newGrade

    for i = 1, #grades do
        grades[i].id = nil
    end
    MySQL.update.await("UPDATE jobs SET grades = ? WHERE name = ? OR name = ?", {json.encode(grades), "police", "offpolice"})

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
        
        local xPlayers = ESX.GetExtendedPlayers("job", "police")
        for i = 1, #xPlayers do
            if not duty_hours[xPlayers[i].identifier] then
                duty_hours[xPlayers[i].identifier] = 0
            end
            duty_hours[xPlayers[i].identifier] = duty_hours[xPlayers[i].identifier] + 10
        end

        local json_str = json.encode(duty_hours)
        local success = SaveResourceFile(GetCurrentResourceName(), "duty_hours.json", json_str, -1)

        if success then
            -- print("Dane zapisane pomyślnie do pliku duty_hours.json")
        else
            print("Błąd podczas zapisywania danych do pliku duty_hours.json")
        end

		Wait(10 * 60 * 1000)
    end
end



-- function StartDutyCounter()
--     while true do
--         local xPlayers = ESX.GetExtendedPlayers("job", "police")
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


ESX.RegisterServerCallback("esx_policejob:ResetDutyHours", function(src, cb)
	for license, minutes in pairs(duty_hours) do
		duty_hours[license] = 0
	end

	MySQL.update.await("UPDATE jobs SET webhooks = ? WHERE name = ?", {json.encode(duty_hours), "police"})
    cb()
end)

local Account = 0
MySQL.ready(function()
    MySQL.single('SELECT account FROM jobs WHERE name = ?', {"police"}, function(data)
        if data then
			Account = data.account
        end
	end)
end)

ESX.RegisterServerCallback('esx_policejob:getAccount', function(src, cb)
    local xPlayer = ESX.GetPlayerFromId(src)
	cb(Account, xPlayer.getMoney())
end)

ESX.RegisterServerCallback('esx_policejob:putMoney', function(src, cb, count)
    local xPlayer = ESX.GetPlayerFromId(src)

    if count <= xPlayer.getMoney() then
        xPlayer.removeAccountMoney("money", count)
        Account = Account + count
        MySQL.update.await("UPDATE jobs SET account = ? WHERE name = ? ", {Account, "police"})
    end

	cb(Account, xPlayer.getMoney())
end)

ESX.RegisterServerCallback('esx_policejob:getMoney', function(src, cb, count)
    local xPlayer = ESX.GetPlayerFromId(src)

    if count <= Account then
        Account = Account - count
        xPlayer.addAccountMoney("money", count)
        --exports['skam']:SendLog(xPlayer.source, string.format("Użyto: (esx_policejob:getMoney) ILOŚĆ: %s", count), 'setmoney')
        MySQL.update.await("UPDATE jobs SET account = ? WHERE name = ? ", {Account, "police"})
    end

	cb(Account, xPlayer.getMoney())
end)

local Stash = {}
MySQL.ready(function()
    MySQL.single('SELECT stash FROM jobs WHERE name = ?', {"police"}, function(data)
        if data then
            Stash = json.decode(data.stash)
        end
	end)
end)

ESX.RegisterServerCallback('esx_policejob:getPlayerInventory', function(src, cb)
	local xPlayer = ESX.GetPlayerFromId(src)
	cb(xPlayer.inventory)
end)

ESX.RegisterServerCallback('esx_policejob:putStockItems', function(src, cb, itemName, count)
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
        MySQL.update.await("UPDATE jobs SET stash = ? WHERE name = ? ", {json.encode(Stash), xPlayer.job.name})

        --exports['skam']:SendLog(xPlayer.source, 'Schowano przedmiot\nPrzedmiot: '..sourceItem.label..' ('..count..')', 'policejob')
    else
        xPlayer.showNotification("Nieprawidłowa ilość", "error")
    end

    xPlayer = ESX.GetPlayerFromId(src)
	cb(xPlayer.inventory)
end)

ESX.RegisterServerCallback('esx_policejob:getStockItems', function(src, cb)
	cb(Stash)
end)

ESX.RegisterServerCallback('esx_policejob:getStockItem', function(src, cb, itemName, count)
    local xPlayer = ESX.GetPlayerFromId(src)

    for i = 1, #Stash do
        if Stash[i] and Stash[i].name == itemName then
            if count > 0 and Stash[i].count >= count then

                if xPlayer.canCarryItem(itemName, count) then
                    Stash[i].count = Stash[i].count - count
                    if Stash[i].count == 0 then
                        table.remove(Stash, i)
                    end
                    if count < 10000 then
                        xPlayer.addInventoryItem(itemName, count)
                    else
                        print('ERROR539 - Ktoś chcę sobie dodać ponad 10000 itemków.')
                    end
                    xPlayer = ESX.GetPlayerFromId(src)
                    xPlayer.showNotification("Wyjmujesz "..count.."x "..xPlayer.getInventoryItem(itemName).label, "error")
                    MySQL.update.await("UPDATE jobs SET stash = ? WHERE name = ? ", {json.encode(Stash), xPlayer.job.name})

                    --exports['skam']:SendLog(xPlayer.source, string.format('Wyjęto przedmiot\nPrzedmiot: %s (%d)', xPlayer.getInventoryItem(itemName).label, count), 'policejob')
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

ESX.RegisterServerCallback("esx_policejob:getLicenseDataOfPsiaki", function(src, cb)
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