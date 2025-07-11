local price = 1250000
local MaxKitCount = 10

local Labeles = {}
local WebHooks = {}
local Stashes = {}
local Accounts = {}
local BitkiPoints = {}
local CapturedStrefa = {}
local Suspended = {}
local Kits = {}
local Upgrades = {}

MySQL.ready(function()
    MySQL.query('SELECT label, name FROM jobs', {}, function(data)
        if data then
            for i = 1, #data do
                Labeles[data[i].name] = data[i].label
            end
        end
	end)
end)

ESX.RegisterServerCallback("orgs:BuyOrg", function(src, cb, JobLabel)
    local xPlayer = ESX.GetPlayerFromId(src)
    local cash, bank = xPlayer.getAccount("money"), xPlayer.getAccount("bank")
    local useBank, useMoney = false, false

    if bank.money >= price then
        useBank = true
    elseif cash.money >= price then
        useMoney = true
    end

    if not useBank and not useMoney then
        cb(false)
    else
        if useBank then
            xPlayer.removeAccountMoney("bank", price)
        else
            xPlayer.removeAccountMoney("money", price)
        end

        local variable = 1
        local jobs = ESX.GetJobs()

        while true do
            if not jobs["org"..variable] then
                break
            end
            variable = variable + 1
        end

        local JobName = "org"..variable

        local JobGrades = {
            {
                name = "Szef",
                salary = 0,
                permissions = {
                    all = true
                }
            }
        }

        MySQL.insert.await("INSERT INTO jobs (name, label, grades) VALUES (?, ?, ?) ", {JobName, JobLabel, json.encode(JobGrades)})

        ESX.RefreshJobs()
        xPlayer.setJob(JobName, 1)

        Labeles[JobName] = JobLabel
        WebHooks[JobName] = {}
        Stashes[JobName] = {}
        Accounts[JobName] = 0
        BitkiPoints[JobName] = 0
        CapturedStrefa[JobName] = {}
        Kits[JobName] = {}
        Upgrades[JobName] = {}

        cb(true)
    end
end)

function Split(string)
    local output
    for str in string.gmatch(string, "([^org]+)") do
        output = str
    end
    return tonumber(output)
end

--===================================================== Grades ===========================================================--

ESX.RegisterServerCallback("orgs:GetGrades", function(src, cb)
    local xPlayer = ESX.GetPlayerFromId(src)
    local grades = ESX.GetJobs()[xPlayer.job.name].grades
    for i = 1, #grades do
        grades[i].id = i
        grades[i].label = grades[i].name
    end
    cb(grades)
end)

ESX.RegisterServerCallback("orgs:AddNewGrade", function(src, cb, newGrade)
    local xPlayer = ESX.GetPlayerFromId(src)
    local grades = ESX.GetJobs()[xPlayer.job.name].grades
    grades[#grades+1] = newGrade

    for i = 1, #grades do
        grades[i].id = nil
        grades[i].label = nil
    end

    MySQL.update.await("UPDATE jobs SET grades = ? WHERE name = ?", {json.encode(grades), xPlayer.job.name})

    ESX.RefreshJobs()
    for i = 1, #grades do
        grades[i].id = i
        grades[i].label = grades[i].name
    end
    cb(grades)
end)

ESX.RegisterServerCallback("orgs:RemoveGrade", function(src, cb, gradeId)
    local xPlayer = ESX.GetPlayerFromId(src)
    local grades = ESX.GetJobs()[xPlayer.job.name].grades

    local members = GetMembers(xPlayer, gradeId)
    for identifier, mPlayer in pairs(members) do
        if mPlayer.online then
            ESX.GetPlayerFromIdentifier(identifier).setJob("unemployed", 1)
        end
    end
    MySQL.update.await("UPDATE users SET job = ?, job_grade = ? WHERE job = ? AND job_grade = ?", {"unemployed", 1, xPlayer.job.name, gradeId})


    table.remove(grades, gradeId)

    for i = 1, #grades do
        grades[i].id = nil
        grades[i].label = nil
    end

    MySQL.update.await("UPDATE jobs SET grades = ? WHERE name = ? ", {json.encode(grades), xPlayer.job.name})

    ESX.RefreshJobs()
    for i = 1, #grades do
        grades[i].id = i
        grades[i].label = grades[i].name
    end

    local xPlayers = ESX.GetExtendedPlayers("job", xPlayer.job.name)
    for i = 1, #xPlayers do
        if xPlayers[i].job.grade > gradeId then
            xPlayers[i].setJob(xPlayer.job.name, xPlayers[i].job.grade - 1)
        end
    end
    MySQL.update.await("UPDATE users SET job_grade = job_grade - 1 WHERE job = ? AND job_grade > ?", {xPlayer.job.name, gradeId})
    cb(grades)
end)

ESX.RegisterServerCallback("orgs:ChangeGradeName", function(src, cb, gradeId, newName)
    local xPlayer = ESX.GetPlayerFromId(src)
    local grades = ESX.GetJobs()[xPlayer.job.name].grades

    grades[gradeId].name = newName

    for i = 1, #grades do
        grades[i].id = nil
        grades[i].label = nil
    end

    MySQL.update.await("UPDATE jobs SET grades = ? WHERE name = ? ", {json.encode(grades), xPlayer.job.name})

    ESX.RefreshJobs()
    for i = 1, #grades do
        grades[i].id = i
        grades[i].label = grades[i].name
    end
    cb(grades)
end)

ESX.RegisterServerCallback("orgs:UpdateGrade", function(src, cb, updateGrade)
    local xPlayer = ESX.GetPlayerFromId(src)
    local grades = ESX.GetJobs()[xPlayer.job.name].grades

    grades[updateGrade.id] = updateGrade

    for i = 1, #grades do
        grades[i].id = nil
        grades[i].label = nil
    end

    MySQL.update.await("UPDATE jobs SET grades = ? WHERE name = ? ", {json.encode(grades), xPlayer.job.name})

    ESX.RefreshJobs()

    for i = 1, #grades do
        grades[i].id = i
        grades[i].label = grades[i].name
    end

    cb(grades)
end)

--===================================================== Members ===========================================================--

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

function GetMembers(xPlayer, gradeId)
    local xPlayers = ESX.GetExtendedPlayers("job", xPlayer.job.name)
    local members = {}
    for i = 1, #xPlayers do
        if isxPlayerHaveGrade(gradeId, xPlayers[i].job.grade) then
            members[xPlayers[i].identifier] = {
                name = xPlayers[i].name,
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

    local result = MySQL.query.await("SELECT identifier, name, job_grade FROM users WHERE job = ?", {xPlayer.job.name})

    local grades = ESX.GetJobs()[xPlayer.job.name].grades
    if result then
        for i = 1, #result do
            if not members[result[i].identifier] and isxPlayerHaveGrade(gradeId, tonumber(result[i].job_grade)) then
                members[result[i].identifier] = {
                    name = result[i].name,
                    identifier = result[i].identifier,
                    online = false,
                    job = {
                        name = xPlayer.job.name,
                        label = xPlayer.job.label,
                        grade = tonumber(result[i].job_grade),
                        grade_name = grades[result[i].job_grade].name,
                        grade_permissions = grades[result[i].job_grade].grade_permissions
                    }
                }
            end
        end
    end
    return members
end

ESX.RegisterServerCallback("orgs:GetMembers", function(src, cb, gradeId)
    local xPlayer = ESX.GetPlayerFromId(src)
    local members = GetMembers(xPlayer, gradeId)

    cb(members)
end)

ESX.RegisterServerCallback("orgs:GetNearPlayers", function(src, cb)
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

RegisterNetEvent("orgs:server:AskToJoin", function(targetId, grade)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent("orgs:client:AskToJoin", targetId, xPlayer.source, xPlayer.job.name, grade)
end)

RegisterNetEvent("orgs:server:ResponseToJoin", function(targetId, grade, bool)
    local xPlayer = ESX.GetPlayerFromId(source)
    local tPlayer = ESX.GetPlayerFromId(targetId)
    if bool then
        xPlayer.setJob(tPlayer.job.name, grade.id)
        tPlayer.showNotification("Gracz "..xPlayer.name.." ["..xPlayer.source.."] dołączył do organizacji")
    else
        tPlayer.showNotification("Gracz "..xPlayer.name.." ["..xPlayer.source.."] odrzucił zaproszenie do organizacji")
    end
end)

ESX.RegisterServerCallback("orgs:ChangeMemberRank", function(src, cb, grade, tPlayer)
    local xPlayer = ESX.GetPlayerFromId(src)
    local newtPlayer = ESX.GetPlayerFromIdentifier(tPlayer.identifier)
    if newtPlayer then
        tPlayer = newtPlayer
        tPlayer.online = true
        tPlayer.setJob(tPlayer.job.name, grade.id)
    else
        MySQL.update.await('UPDATE users SET job = ?, job_grade = ? WHERE identifier = ? ', {xPlayer.job.name, grade.id, tPlayer.identifier})
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

ESX.RegisterServerCallback("orgs:KickMember", function(src, cb, tPlayer)
    local newtPlayer = ESX.GetPlayerFromIdentifier(tPlayer.identifier)
    if newtPlayer then
        tPlayer = newtPlayer
        tPlayer.setJob("unemployed", 1)
    else
        MySQL.update.await('UPDATE users SET job = ?, job_grade = ? WHERE identifier = ? ', {"unemployed", 1, tPlayer.identifier})
    end

    cb()
end)

--===================================================== webhooks ===========================================================--

MySQL.ready(function()
    MySQL.query('SELECT webhooks, name FROM jobs', {}, function(data)
        if data then
            for i = 1, #data do
                WebHooks[data[i].name] = json.decode(data[i].webhooks)
            end
        end
	end)
end)

ESX.RegisterServerCallback("orgs:GetWebhooks", function(src, cb)
    local xPlayer = ESX.GetPlayerFromId(src)
    local IsSetted = {}
    for k, v in pairs(WebHooks[xPlayer.job.name]) do
        IsSetted[k] = true
    end
    cb(IsSetted)
end)

ESX.RegisterServerCallback("orgs:AddWebhook", function(src, cb, webHookName, webHookLink)
    local xPlayer = ESX.GetPlayerFromId(src)

    if not WebHooks[xPlayer.job.name] then
        WebHooks[xPlayer.job.name] = {}
    end

    WebHooks[xPlayer.job.name][webHookName] = webHookLink

    MySQL.update.await("UPDATE jobs SET webhooks = ? WHERE name = ? ", {json.encode(WebHooks[xPlayer.job.name]), xPlayer.job.name})

    SendLog(webHookLink, "Log testowy", "Twój webhook działa!", 5763719)
    xPlayer.showNotification('Pomyślnie ustawiono webhook, wysłano testowy webhook na kanał', 'success')

    local IsSetted = {}
    for k, v in pairs(WebHooks[xPlayer.job.name]) do
        IsSetted[k] = true
    end
    cb(IsSetted)
end)

--===================================================== removeorg ===========================================================--

ESX.RegisterServerCallback("orgs:RemoveOrg", function(src, cb)
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer.job.grade == 1 and string.find(xPlayer.job.name, "org") then
        local members = GetMembers(xPlayer)
        for identifier, mPlayer in pairs(members) do
            if mPlayer.online then
                ESX.GetPlayerFromIdentifier(identifier).setJob("unemployed", 1)
            end
        end
        MySQL.update.await("UPDATE users SET job = ?, job_grade = ? WHERE job = ?", {"unemployed", 1, xPlayer.job.name})
        MySQL.update.await('DELETE FROM jobs WHERE name = ?', {xPlayer.job.name})
        ESX.RefreshJobs()
    end

    cb()
end)

ESX.RegisterServerCallback("orgs:LeaveOrg", function(src, cb)
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer.job.grade ~= 1 and string.find(xPlayer.job.name, "org") then
        xPlayer.setJob("unemployed", 1)
        cb(true)
    else
        cb(false)
    end
end)

--===================================================== Ulepszenia ===========================================================--

MySQL.ready(function()
    MySQL.query('SELECT upgrades, name FROM jobs', {}, function(data)
        if data then
            for i = 1, #data do
                if data[i].upgrades then
                    Upgrades[data[i].name] = json.decode(data[i].upgrades)
                end
            end
        end
	end)
end)

ESX.RegisterServerCallback('orgs:BuyUpgrade', function(src, cb, ItemUpgrade)
    local xPlayer = ESX.GetPlayerFromId(src)
    local upgradePrice = Config['orgs'].upgrades[ItemUpgrade].price
    if Accounts[xPlayer.job.name] >= upgradePrice then
        ManipulateOrgMoney(xPlayer.job.name, -upgradePrice)
        if Config['orgs'].upgrades[ItemUpgrade].time then
            Upgrades[xPlayer.job.name][ItemUpgrade] = os.time() + Config['orgs'].upgrades[ItemUpgrade].time
        else
            Upgrades[xPlayer.job.name][ItemUpgrade] = true
        end

        MySQL.update.await("UPDATE jobs SET upgrades = ? WHERE name = ? ", {json.encode(Upgrades[xPlayer.job.name]), xPlayer.job.name})

        cb(Upgrades[xPlayer.job.name])

        local xPlayers = ESX.GetExtendedPlayers("job", xPlayer.job.name)
        for i = 1, #xPlayers do
            TriggerClientEvent("orgs:NewUpdates", xPlayers[i].source, Upgrades[xPlayer.job.name])
        end
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback('orgs:GetUpgrades', function(src, cb)
    local xPlayer = ESX.GetPlayerFromId(src)
    
    -- Make sure the job name exists first
    if not xPlayer or not xPlayer.job or not xPlayer.job.name then
        return cb({})
    end
    
    -- Initialize the upgrades table for this job if it doesn't exist
    if not Upgrades[xPlayer.job.name] then
        Upgrades[xPlayer.job.name] = {}
    end
    
    local count = 0
    for _ in pairs(Upgrades[xPlayer.job.name]) do
        count = count + 1
    end

    if count == 0 then
        -- Initialize with default values if empty
        for upgrade, values in pairs(Config['orgs'].upgrades) do
            Upgrades[xPlayer.job.name][upgrade] = false
        end
        
        -- Save to database
        MySQL.update.await("UPDATE jobs SET upgrades = ? WHERE name = ? ", {json.encode(Upgrades[xPlayer.job.name]), xPlayer.job.name})
    else
        -- Check for expired upgrades
        local changes = false
        for upgrade, tempTime in pairs(Upgrades[xPlayer.job.name]) do
            if type(tempTime) ~= 'boolean' then
                local time = tonumber(tempTime)
                if time and time < os.time() then
                    Upgrades[xPlayer.job.name][upgrade] = false
                    changes = true
                end
            end
        end
        
        -- Save changes if needed
        if changes then
            MySQL.update.await("UPDATE jobs SET upgrades = ? WHERE name = ? ", {json.encode(Upgrades[xPlayer.job.name]), xPlayer.job.name})
            
            -- Notify players of updates
            local xPlayers = ESX.GetExtendedPlayers("job", xPlayer.job.name)
            for i = 1, #xPlayers do
                TriggerClientEvent("orgs:NewUpdates", xPlayers[i].source, Upgrades[xPlayer.job.name])
            end
        end
    end

    cb(Upgrades[xPlayer.job.name])
end)

--===================================================== Schowek ===========================================================--

MySQL.ready(function()
    MySQL.query('SELECT stash, name FROM jobs', {}, function(data)
        if data and #data > 0 then -- Ensure data exists
            for i = 1, #data do
                if data[i].stash then
                    Stashes[data[i].name] = json.decode(data[i].stash) or {} -- Ensure decoding doesn't return nil
                else
                    Stashes[data[i].name] = {} -- Initialize an empty stash if nil
                end
            end
        end
    end)
end)


ESX.RegisterServerCallback('orgs:getPlayerInventory', function(src, cb)
	local xPlayer = ESX.GetPlayerFromId(src)
	cb(xPlayer.inventory)
end)

ESX.RegisterServerCallback('orgs:putAllInStock', function(src, cb)
	local xPlayer = ESX.GetPlayerFromId(src)
    local inventory = xPlayer.inventory
    local itemsList = ""

    for _, item in ipairs(inventory) do
        if item.count > 0 then
            xPlayer.removeInventoryItem(item.name, item.count)
            local found = false
            for i = 1, #Stashes[xPlayer.job.name] do
                if Stashes[xPlayer.job.name][i].name == item.name then
                    found = true
                    Stashes[xPlayer.job.name][i].count = Stashes[xPlayer.job.name][i].count + item.count
                    itemsList = itemsList..Stashes[xPlayer.job.name][i].label.." x"..item.count.."\n"
                end
            end

            if not found then
                Stashes[xPlayer.job.name][#Stashes[xPlayer.job.name]+1] = {name = item.name, label = item.label, count = item.count}
                itemsList = itemsList..item.label.." x"..item.count.."\n"
            end
        end
    end

    xPlayer.showNotification("Schowano wszystko w szafce", "success")

    MySQL.update.await("UPDATE jobs SET stash = ? WHERE name = ? ", {json.encode(Stashes[xPlayer.job.name]), xPlayer.job.name})

    SendLog(WebHooks[xPlayer.job.name].stashboard, 'Schowano wszystkie przedmioty', '**ID: **'..xPlayer.source..'\n**Nick: **'..xPlayer.name..'\n**Licencja: **'..xPlayer.identifier..'\n**Postać: **'..xPlayer.get('firstName')..' '..xPlayer.get('lastName')..'\n**Przedmioty: **'..itemsList, 5763719)

	cb()
end)

ESX.RegisterServerCallback('orgs:putStockItems', function(src, cb, itemName, count)
	local xPlayer = ESX.GetPlayerFromId(src)
	local sourceItem = xPlayer.getInventoryItem(itemName)

    if sourceItem.count >= count and count > 0 then
        xPlayer.removeInventoryItem(itemName, count)

        local found = false
        for i = 1, #Stashes[xPlayer.job.name] do
            if Stashes[xPlayer.job.name][i].name == itemName then
                found = true
                Stashes[xPlayer.job.name][i].count = Stashes[xPlayer.job.name][i].count + count
            end
        end

        if not found then
            Stashes[xPlayer.job.name][#Stashes[xPlayer.job.name]+1] = {name = itemName, label = sourceItem.label, count = count}
        end

        xPlayer.showNotification("Włożono "..count.."x "..sourceItem.label)
        MySQL.update.await("UPDATE jobs SET stash = ? WHERE name = ? ", {json.encode(Stashes[xPlayer.job.name]), xPlayer.job.name})

        SendLog(WebHooks[xPlayer.job.name].stashboard, 'Schowano przedmiot', '**ID: **'..xPlayer.source..'\n**Nick: **'..xPlayer.name..'\n**Licencja: **'..xPlayer.identifier..'\n**Postać: **'..xPlayer.get('firstName')..' '..xPlayer.get('lastName')..'\n**Przedmiot: **'..sourceItem.label..' ('..count..')', 5763719)
    else
        xPlayer.showNotification("Nieprawidłowa ilość", "error")
    end

    xPlayer = ESX.GetPlayerFromId(src)
	cb(xPlayer.inventory)
end)

ESX.RegisterServerCallback('orgs:getStockItems', function(src, cb)
    local xPlayer = ESX.GetPlayerFromId(src)
	cb(Stashes[xPlayer.job.name])
end)

ESX.RegisterServerCallback('orgs:getStockItem', function(src, cb, itemName, count)
    local xPlayer = ESX.GetPlayerFromId(src)

    for i = 1, #Stashes[xPlayer.job.name] do
        if Stashes[xPlayer.job.name][i] and Stashes[xPlayer.job.name][i].name == itemName then
            if count > 0 and Stashes[xPlayer.job.name][i].count >= count then

                if xPlayer.canCarryItem(itemName, count) then
                    Stashes[xPlayer.job.name][i].count = Stashes[xPlayer.job.name][i].count - count
                    if Stashes[xPlayer.job.name][i].count == 0 then
                        table.remove(Stashes[xPlayer.job.name], i)
                    end
                    xPlayer.addInventoryItem(itemName, count)
                    xPlayer = ESX.GetPlayerFromId(src)
                    xPlayer.showNotification("Wyjęto "..count.."x "..xPlayer.getInventoryItem(itemName).label)
                    MySQL.update.await("UPDATE jobs SET stash = ? WHERE name = ? ", {json.encode(Stashes[xPlayer.job.name]), xPlayer.job.name})

                    SendLog(WebHooks[xPlayer.job.name].stashboard, 'Wyjęto przedmiot', '**ID: **'..xPlayer.source..'\n**Nick: **'..xPlayer.name..'\n**Licencja: **'..xPlayer.identifier..'\n**Postać: **'..xPlayer.get('firstName')..' '..xPlayer.get('lastName')..'\n**Przedmiot: **'..xPlayer.getInventoryItem(itemName).label..' ('..count..')', 15548997)
                else
                    xPlayer.showNotification("Brak miejsca w ekwipunku", "error")
                end
            else
                xPlayer.showNotification("Nieprawidłowa ilość", "error")
            end
        end
    end

	cb(Stashes[xPlayer.job.name])
end)

--===================================================== Konto ===========================================================--

MySQL.ready(function()
    MySQL.query('SELECT account, name FROM jobs', {}, function(data)
        if data then
            for i = 1, #data do
                Accounts[data[i].name] = data[i].account
            end
        end
	end)
end)

ESX.RegisterServerCallback('orgs:getAccount', function(src, cb)
    local xPlayer = ESX.GetPlayerFromId(src)
	cb(Accounts[xPlayer.job.name], xPlayer.getMoney())
end)

ESX.RegisterServerCallback('orgs:putMoney', function(src, cb, count)
    local xPlayer = ESX.GetPlayerFromId(src)

    if count <= xPlayer.getMoney() then
        xPlayer.removeAccountMoney("money", count)
        Accounts[xPlayer.job.name] = Accounts[xPlayer.job.name] + count
        MySQL.update.await("UPDATE jobs SET account = ? WHERE name = ? ", {Accounts[xPlayer.job.name], xPlayer.job.name})

        SendLog(WebHooks[xPlayer.job.name].bank, 'Schowano pieniądze', '**ID: **'..xPlayer.source..'\n**Nick: **'..xPlayer.name..'\n**Licencja: **'..xPlayer.identifier..'\n**Postać: **'..xPlayer.get('firstName')..' '..xPlayer.get('lastName')..'\n**Ilość: **'..count..'$', 5763719)
    end

	cb(Accounts[xPlayer.job.name], xPlayer.getMoney())
end)

ESX.RegisterServerCallback('orgs:getMoney', function(src, cb, count)
    local xPlayer = ESX.GetPlayerFromId(src)

    if count <= Accounts[xPlayer.job.name] then
        Accounts[xPlayer.job.name] = Accounts[xPlayer.job.name] - count
        xPlayer.addAccountMoney("money", count)
        MySQL.update.await("UPDATE jobs SET account = ? WHERE name = ? ", {Accounts[xPlayer.job.name], xPlayer.job.name})

        SendLog(WebHooks[xPlayer.job.name].bank, 'Wyjęto pieniądze', '**ID: **'..xPlayer.source..'\n**Nick: **'..xPlayer.name..'\n**Licencja: **'..xPlayer.identifier..'\n**Postać: **'..xPlayer.get('firstName')..' '..xPlayer.get('lastName')..'\n**Ilość: **'..count..'$', 15548997)
    end

	cb(Accounts[xPlayer.job.name], xPlayer.getMoney())
end)

function ManipulateOrgMoney(org, count)
    Accounts[org] = Accounts[org] + count
    MySQL.update.await("UPDATE jobs SET account = ? WHERE name = ? ", {Accounts[org], org})
end

--===================================================== BitkiPoints ===========================================================--

MySQL.ready(function()
    MySQL.query('SELECT bitkipoints, name FROM jobs', {}, function(data)
        if data then
            for i = 1, #data do
                BitkiPoints[data[i].name] = data[i].bitkipoints
            end
        end
	end)
end)

function GetBitkiPoints(job)
    return BitkiPoints[job]
end

AddEventHandler("bitki:GetBitkiPoints", function(job, cb)
    cb(BitkiPoints[job])
end)

function AddBitkiPoints(job, points)
    BitkiPoints[job] = BitkiPoints[job] + points
    MySQL.update.await("UPDATE jobs SET bitkipoints = ? WHERE name = ? ", {BitkiPoints[job], job})

    local orgPlayers = ESX.GetExtendedPlayers("job", job)
    for i = 1, #orgPlayers do
        TriggerClientEvent('skam-xp:add', orgPlayers[i].source, points)
    end
end

function RemoveBitkiPoints(job, points)
    BitkiPoints[job] = BitkiPoints[job] - points
    if BitkiPoints[job] < 0 then
        BitkiPoints[job] = 0
    end
    MySQL.update.await("UPDATE jobs SET bitkipoints = ? WHERE name = ? ", {BitkiPoints[job], job})

    local orgPlayers = ESX.GetExtendedPlayers("job", job)
    for i = 1, #orgPlayers do
        TriggerClientEvent('skam-xp:remove', orgPlayers[i].source, points)
    end
end

--===================================================== CapturedStrefa ===========================================================--

MySQL.ready(function()
    MySQL.query('SELECT capturedstrefa, name FROM jobs', {}, function(data)
        if data then
            for i = 1, #data do
                CapturedStrefa[data[i].name] = json.decode(data[i].capturedstrefa)
            end
        end
	end)
end)

function AddCapturedStrefa(job, name)
    if CapturedStrefa[job][name] then
        CapturedStrefa[job][name] = CapturedStrefa[job][name] + 1
    else
        CapturedStrefa[job][name] = 1
    end

    MySQL.update.await("UPDATE jobs SET capturedstrefa = ? WHERE name = ? ", {json.encode(CapturedStrefa[job]), job})
end

--===================================================== Suspended ===========================================================--

MySQL.ready(function()
    MySQL.query('SELECT suspended, name FROM jobs', {}, function(data)
        if data then
            for i = 1, #data do
                if data[i].suspended and data[i].suspended ~= 0 then
                    Suspended[data[i].name] = data[i].suspended / 1000
                end
            end
        end
	end)
end)

ESX.RegisterCommand('zawiesorg', {'trialzarzad', 'zarzad', 'glownyzarzad', 'managment'}, function(xPlayer, args, showError)
    if not string.find(args.job, "org") then
        xPlayer.showNotification("Stary to nie jest nazwa org")
    elseif ESX.GetJobs()[args.job] then
        local expireTime = os.time() + ESX.Math.Round(args.time * 3600)

        if expireTime == os.time() then
            MySQL.update.await('UPDATE jobs SET suspended = ? WHERE name = ? ', {nil, args.job})
            Suspended[args.job] = nil
        else
            MySQL.update.await('UPDATE jobs SET suspended = ? WHERE name = ? ', {os.date("%Y-%m-%d %H:%M:%S", expireTime), args.job})
            Suspended[args.job] = expireTime
        end

        LogCommands('zawiesorg', xPlayer, {
            job = args.job,
            time = args.time
        })

        --TriggerClientEvent('skam:chatMessage', xPlayer.source, 'rgb(255, 0, 0)', 'fa-solid fa-volume-xmark', 'WYCISZENIE', xPlayer.name..' wyciszył cię do '..os.date('%Y-%m-%d %H:%M:%S', expireTime))
    else
        xPlayer.showNotification("Nie ma takiej organizacji")
	end
end, true, {help = 'Zawieś organizacje', validate = false, arguments = {
    {name = 'job', validate = true, help = 'Nazwa org', type = 'string'},
    {name = 'time', validate = true, help = 'Czas (godziny)', type = 'number'},
}})

function IsSuspended(job)
    if Suspended[job] then
        if Suspended[job] <= os.time() then
            MySQL.update.await('UPDATE jobs SET suspended = ? WHERE name = ? ', {nil, job})
            Suspended[job] = nil
            return false
        else
            return os.date("%Y-%m-%d %H:%M:%S", Suspended[job])
        end
    else
        return false
    end
end

ESX.RegisterServerCallback('orgs:IsSuspended', function(src, cb)
    local xPlayer = ESX.GetPlayerFromId(src)
    
    if not xPlayer or not xPlayer.job or not xPlayer.job.name then
        return cb(false)
    end
    
    if Suspended[xPlayer.job.name] then
        if Suspended[xPlayer.job.name] <= os.time() then
            MySQL.update.await('UPDATE jobs SET suspended = ? WHERE name = ? ', {nil, xPlayer.job.name})
            Suspended[xPlayer.job.name] = nil
            cb(false)
        else
            cb(os.date("%Y-%m-%d %H:%M:%S", Suspended[xPlayer.job.name]))
        end
    else
        cb(false)
    end
end)

--===================================================== Kits ===========================================================--

MySQL.ready(function()
    MySQL.query('SELECT kits, name FROM jobs', {}, function(data)
        if data then
            for i = 1, #data do
                if data[i].kits then
                    Kits[data[i].name] = json.decode(data[i].kits)
                end
            end
        end
	end)
end)

ESX.RegisterServerCallback('orgs:GetKits', function(src, cb)
    local xPlayer = ESX.GetPlayerFromId(src)
	cb(Kits[xPlayer.job.name])
end)

ESX.RegisterServerCallback('orgs:CreateKit', function(src, cb, kitName)
    local xPlayer = ESX.GetPlayerFromId(src)
    local Inventory = xPlayer.getInventory(true)
    local itemsList = ""
    local Items = {}

    for item, count in pairs(Inventory) do
        Items[#Items+1] = {item = item, count = count}
        itemsList = itemsList..xPlayer.getInventoryItem(item).label.." x"..count.."\n"
    end

    if #Kits[xPlayer.job.name] <= MaxKitCount then
        Kits[xPlayer.job.name][#Kits[xPlayer.job.name]+1] = {label = kitName, items = Items}
        MySQL.update.await('UPDATE jobs SET kits = ? WHERE name = ? ', {json.encode(Kits[xPlayer.job.name]), xPlayer.job.name})
        xPlayer.showNotification('Zapisano zestaw: '..kitName, 'success')

        SendLog(WebHooks[xPlayer.job.name].kits, 'Dodano kit', '**ID: **'..xPlayer.source..'\n**Nick: **'..xPlayer.name..'\n**Licencja: **'..xPlayer.identifier..'\n**Postać: **'..xPlayer.get('firstName')..' '..xPlayer.get('lastName')..'\n**Kit: **'..kitName..'\n**Przedmioty: **'..itemsList, 5763719)
        cb(true, Kits[xPlayer.job.name])
    else
        xPlayer.showNotification('Twoja organizacja posiada już maksymalną ilość zestawów', 'error')
        cb(false)
    end
end)

ESX.RegisterServerCallback('orgs:DeleteKit', function(src, cb, iteration)
    local xPlayer = ESX.GetPlayerFromId(src)

    if Kits[xPlayer.job.name][iteration] then
        SendLog(WebHooks[xPlayer.job.name].kits, 'Usunięto kit', '**ID: **'..xPlayer.source..'\n**Nick: **'..xPlayer.name..'\n**Licencja: **'..xPlayer.identifier..'\n**Postać: **'..xPlayer.get('firstName')..' '..xPlayer.get('lastName')..'\n**Kit: **'..Kits[xPlayer.job.name][iteration].label, 15548997)
        table.remove(Kits[xPlayer.job.name], iteration)
        MySQL.update.await('UPDATE jobs SET kits = ? WHERE name = ? ', {json.encode(Kits[xPlayer.job.name]), xPlayer.job.name})
    end

    cb(Kits[xPlayer.job.name])
end)

ESX.RegisterServerCallback('orgs:EquipKit', function(src, cb, iteration, tsrc)
    local xPlayer = ESX.GetPlayerFromId(src)
    local tPlayer = ESX.GetPlayerFromId(tsrc)
    if not tPlayer then
        tPlayer = xPlayer
    end

    if Kits[xPlayer.job.name][iteration] then
        local kitItems = Kits[xPlayer.job.name][iteration].items
        local stashItems = Stashes[xPlayer.job.name]
        local itemsList = ""

        for i = 1, #kitItems do
            local foundIteration
            for j = 1, #stashItems do
                if kitItems[i].item == stashItems[j].name then
                    foundIteration = j
                    break
                end
            end

            if foundIteration and stashItems[foundIteration].count >= kitItems[i].count then
                if tPlayer.canCarryItem(kitItems[i].item, kitItems[i].count) then
                    Stashes[xPlayer.job.name][foundIteration].count = Stashes[xPlayer.job.name][foundIteration].count - kitItems[i].count

                    itemsList = itemsList..Stashes[xPlayer.job.name][foundIteration].label.." x"..Stashes[xPlayer.job.name][foundIteration].count.."\n"

                    if Stashes[xPlayer.job.name][foundIteration].count == 0 then
                        table.remove(Stashes[xPlayer.job.name], foundIteration)
                    end

                    tPlayer.addInventoryItem(kitItems[i].item, kitItems[i].count)
                else
                    tPlayer.showNotification("Brak miejsca w ekwipunku", "error")
                end
            else
                xPlayer.showNotification('W szafce nie ma wystarczająco '..kitItems[i].item, 'error')
            end
        end

        SendLog(WebHooks[xPlayer.job.name].kits, 'Wyjęto kit', '**ID: **'..xPlayer.source..'\n**Nick: **'..xPlayer.name..'\n**Licencja: **'..xPlayer.identifier..'\n**Postać: **'..xPlayer.get('firstName')..' '..xPlayer.get('lastName')..'\n**Kit: **'..Kits[xPlayer.job.name][iteration].label..'\n**Przedmioty: **'..itemsList, 9807270)
    end

    cb()
end)

local function getTopPlayers(identifier)
    local finalPlayersTop = {}
    local pointsTable = json.decode(json.encode(GlobalPointsTable))
    finalPlayersTop[#finalPlayersTop+1] = {label = pointsTable[identifier].name, points = pointsTable[identifier].points}

    for top = 1, 10 do
        local tempBestPlayer
        local tempBestPlayerLicense
        local tempBestPlayerPoints

        for license, data in pairs(pointsTable) do
            if not tempBestPlayerPoints or data.points > tempBestPlayerPoints then
                tempBestPlayerLicense = license
                tempBestPlayer = data.name
                tempBestPlayerPoints = data.points
            end
        end

        pointsTable[tempBestPlayerLicense] = nil

        finalPlayersTop[#finalPlayersTop+1] = {label = tempBestPlayer, points = tempBestPlayerPoints}
    end

    return finalPlayersTop
end

ESX.RegisterCommand('top', 'user', function(xPlayer, args, showError)
    TriggerClientEvent("skam:OpenTopka", xPlayer.source, BitkiPoints, CapturedStrefa, Labeles, getTopPlayers(xPlayer.identifier), BitkiPoints[xPlayer.job.name], Labeles[xPlayer.job.name])
end, false, {help = 'Sprawdź aktualne topki'})

ESX.RegisterCommand('setrankingorg', {'trialzarzad', 'zarzad', 'glownyzarzad', 'managment'}, function(xPlayer, args, showError)
    if BitkiPoints[args.org] then
        BitkiPoints[args.org] = args.ranking
        MySQL.update.await("UPDATE jobs SET bitkipoints = ? WHERE name = ? ", {BitkiPoints[args.org], args.org})
        if xPlayer then
            xPlayer.showNotification('Ustawiono ranking organizacji '..args.org..' na '..args.ranking, 'info')
        else
            print('Ustawiono ranking organizacji '..args.org..' na '..args.ranking)
        end
        LogCommands('setrankingorg', xPlayer, {
            org = args.org,
            ranking = args.ranking
        })
    else
        if xPlayer then
            xPlayer.showNotification('Nie znaleziono organizacji: '..args.org, 'info')
        else
            print('Nie znaleziono organizacji: '..args.org)
        end
    end
end, true, {help = 'Ustaw ranking organizacji', validate = true, arguments = {
    {name = 'org', help = 'Job organizacji (np. org555)', type = 'string'},
    {name = 'ranking', help = 'Ilość rankingu', type = 'number'},
}})

ESX.RegisterCommand('stworzorg', {'trialzarzad', 'zarzad', 'glownyzarzad', 'managment'}, function(xPlayer, args, showError)
    if not args.nazwa then
        return xPlayer.showNotification('Podaj nazwę organizacji', 'error')
    end
    
    local JobLabel = args.nazwa
    
    if string.len(JobLabel) > 15 then
        return xPlayer.showNotification("Nazwa ogranizacji musi mieć do 15 znaków", 'error')
    elseif string.len(JobLabel) < 2 then
        return xPlayer.showNotification("Nazwa ogranizacji musi mieć co najmniej 2 znaki", 'error')
    end
    
    local variable = 1
    local jobs = ESX.GetJobs()

    while true do
        if not jobs["org"..variable] then
            break
        end
        variable = variable + 1
    end

    local JobName = "org"..variable

    local JobGrades = {
        {
            name = "Szef",
            salary = 0,
            permissions = {
                all = true
            }
        }
    }

    MySQL.insert.await("INSERT INTO jobs (name, label, grades) VALUES (?, ?, ?) ", {JobName, JobLabel, json.encode(JobGrades)})
    ESX.RefreshJobs()

    Labeles[JobName] = JobLabel
    WebHooks[JobName] = {}
    Stashes[JobName] = {}
    Accounts[JobName] = 0
    BitkiPoints[JobName] = 0
    CapturedStrefa[JobName] = {}
    Kits[JobName] = {}
    Upgrades[JobName] = {}
    
    xPlayer.showNotification("Pomyślnie utworzono organizację o nazwie: " .. JobLabel .. " (Job: " .. JobName .. ")")
    
    LogCommands('stworzorg', xPlayer, {
        jobName = JobName,
        jobLabel = JobLabel
    })
    
    return true
end, true, {help = 'Utwórz nową organizację (tylko owner)', validate = false, arguments = {
    {name = 'nazwa', help = 'Nazwa organizacji', type = 'string'}
}})

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    
    if not Upgrades then Upgrades = {} end
    if not Suspended then Suspended = {} end
    if not Stashes then Stashes = {} end
    if not Kits then Kits = {} end
end)