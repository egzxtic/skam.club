local reportTable = {}
local adminList = {}
local cooldowns = {
    ['local'] = { time = 3, players = {} },
    ['report'] = { time = 30, players = {} },
    ['global'] = { time = 5, players = {} },
    ['rynek'] = { time = 120, players = {} },
    ['orgchat'] = { time = 10, players = {} },
    ['ooc'] = { time = 120, players = {} },
    ['msg'] = { time = 3, players = {} },
    ['narrations'] = { time = 2, players = {} },
}

MySQL.ready(function()
    MySQL.query('SELECT * FROM reportsystem', {}, function(data)
        if data and type(data) == "table" then
            for _, value in pairs(data) do
                if value.license and value.count then
                    reportTable[value.license] = value.count
                end
            end
        end
    end)
end)

CreateThread(function()
    for k, v in pairs(Config.ChatCommands) do
        RegisterCommand(k, function(source, args, raw)
            if not args[1] then return end
            local xPlayer = ESX.GetPlayerFromId(source)
            local receivers = -1

            if v.groups then 
                if not v.groups[xPlayer.group] then 
                    return xPlayer.showNotification("Nie posiadasz permisji!")
                end 
            end

            local cdType = k
            if not cooldowns[cdType] then
                cdType = 'global'
            end

            if getChatCooldown(xPlayer.source, cdType) then return end
            addChatCooldown(xPlayer.source, xPlayer.getGroup(), cdType)

            local content = table.concat(args, " ", 1)
            TriggerClientEvent("skam$chat:addMessage", receivers, {
                type = k,
                content = content,
            }, {
                group = xPlayer.group,
                name = xPlayer.discord.name,
                id = xPlayer.source,
                job = string.upper(xPlayer.job.label), 
            }, (v.receivers == "distance" and GetEntityCoords(GetPlayerPed(source)) or nil))
        end)
    end
end)

ESX.RegisterCommand({'msg', 'dm', 'w'}, 'user', function(xPlayer, args, showError)
    if not (#args > 1) then 
        return xPlayer.showNotification("Musisz podać id!") 
    end
    local playerID = tonumber(args[1])
    if not playerID then
        return xPlayer.showNotification("Nieprawidłowe ID gracza!") 
    end
    local xTarget = ESX.GetPlayerFromId(playerID)
    table.remove(args, 1)
    if not xTarget then
        return xPlayer.showNotification('Podany gracz jest offline', 'error')
    end
    local content = table.concat(args, ' ')

    if getChatCooldown(xPlayer.source, 'msg') then return end

    addChatCooldown(xPlayer.source, xPlayer.getGroup(), 'msg')

    TriggerClientEvent("skam$chat:addMessage", xTarget.source, {
        type = "DM",
        content = "Otrzymano wiadomość: " .. content,
    }, {
        group = xPlayer.group,
        name = xPlayer.discord.name,
        id = xPlayer.source,
        job = string.upper(xPlayer.job.label), 
    })

    TriggerClientEvent("skam$chat:addMessage", xPlayer.source, {
        type = "DM",
        content = "Wysłano wiadomość: " .. content .. ". Do: " .. xTarget.discord.name,
    }, {
        group = xPlayer.group,
        name = xPlayer.discord.name,
        id = xPlayer.source,
        job = string.upper(xPlayer.job.label), 
    })

    exports['skam']:log(xPlayer.source, ('PRYWATNA WIADOMOŚĆ\n%s'):format(content), 'general')
    xPlayer.showNotification('Wysłano wiadomość do: ' .. xTarget.source, 'info')
end, false)

local requestReport = {}

local function generateReportNumber(source)
    local doBreak = false
    local reportNumber = nil
    while true do
        Wait(0)
        reportNumber = math.random(1111, 9999)
        if not requestReport[reportNumber] then
            doBreak = true
            requestReport[reportNumber] = source
        end

        if doBreak then
            break
        end
    end
    return reportNumber
end

local notAdminGroups = { ["user"] = true, ["revivator"] = true }

function addChatCooldown(source, rank, cdType)
    if notAdminGroups[rank] then
        if not cdType then cdType = 'global' end
        cooldowns[cdType].players[source] = os.time() + cooldowns[cdType].time
    end
end

function getChatCooldown(source, cdType)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not cdType or not cooldowns[cdType] then cdType = 'global' end
    if not source then
        print("[chat] getChatCooldown: source is nil!")
        return false
    end
    local cd = cooldowns[cdType].players[source] or 0
    if cd > os.time() then
        local remaining = cd - os.time()
        xPlayer.showNotification("Masz jeszcze " .. remaining .. " sekund cooldownu na czat: " .. cdType)
        return true
    end
    return false
end

ESX.RegisterCommand('adminlist', 'trialsupport', function(xPlayer, args, showError)
    local xPlayers = ESX.GetExtendedPlayers()
    local adminList = {}

    for i = 1, #(xPlayers) do 
        local player = xPlayers[i]
        if not notAdminGroups[player.getGroup()] then
            table.insert(adminList, {
                name = player.discord and player.discord.name or "Brak nicku",
                id = player.source,
                rank = player.getGroup()
            })
        end
    end

    xPlayer.triggerEvent('skam$chat:adminlist', adminList)
end, false)

ESX.RegisterCommand('ooc', 'headadmin', function(xPlayer, args, showError)
    local xPlayers = ESX.GetExtendedPlayers()
    local content = table.concat(args, ' ')

    if getChatCooldown(xPlayer.source, 'ooc') then return end

    addChatCooldown(xPlayer.source, xPlayer.getGroup(), 'ooc')

    for i = 1, #(xPlayers) do 
        TriggerClientEvent("skam$chat:addMessage", xPlayers[i].source, {
            type = "Ogloszenie",
            content = content,
            color = "#874cff",
        }, {
            group = xPlayer.group,
            name = xPlayer.discord.name,
            id = xPlayer.source,
            job = "0101", 
        })
    end
end, false)

function SplitId(str)
    if not str then return nil end
    local id = str:match("^[^:]+:(.+)$")
    return id
end

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
    local playerGroup = xPlayer.getGroup()
    if not notAdminGroups[playerGroup] then
        adminList[xPlayer.source] = true
        --local splitIdentifier = SplitId(xPlayer.identifier)
        -- if not splitIdentifier then
        --     print("[skam-ui] BŁĄD: Nieprawidłowy identifier gracza: ", tostring(xPlayer.identifier))
        --     return
        -- end
        local discord = ""
        if xPlayer and xPlayer.source then
            for k, v in pairs(GetPlayerIdentifiers(xPlayer.source))do   
                if string.sub(v, 1, string.len("discord:")) == "discord:" then
                    discord = v
                end
            end
        end
        if discord ~= "" then
            discord = string.gsub(discord, "discord:", "")
        end
        if not reportTable[xPlayer.identifier] then
            reportTable[xPlayer.identifier] = 0
            MySQL.insert.await('INSERT INTO reportsystem (license, discord, name, count) VALUES (?, ?, ?, ?)', {xPlayer.identifier, discord, xPlayer.getName(), 0})
        end
    end
end)

AddEventHandler('esx:playerDropped', function(playerId, reason)
    if not notAdminGroups[playerGroup] then
        adminList[playerId] = nil
        local xPlayer = ESX.GetPlayerFromId(playerId)
        --local xPlayer.identifier = SplitId(xPlayer.identifier)
        local discord = ""
        if xPlayer then
            if xPlayer.source then
                for k, v in pairs(GetPlayerIdentifiers(xPlayer.source))do   
                    if string.sub(v, 1, string.len("discord:")) == "discord:" then
                        discord = v
                    end
                end
            end
        end
        if discord ~= "" then
            discord = string.gsub(discord, "discord:", "")
        end
        if reportTable[xPlayer.identifier] then
            MySQL.update.await('UPDATE reportsystem SET discord = ?, name = ?, count = ? WHERE license = ?', {discord, xPlayer.getName(), reportTable[xPlayer.identifier], xPlayer.identifier})
        end
    end
end)

ESX.RegisterCommand('report', 'user', function(xPlayer, args, showError)
    if #args <= 0 then 
        return xPlayer.showNotification("Nie napisano zdarzenia w zgłoszeniu!") 
    end

    local count = 0
    for _, v in ipairs(ESX.GetExtendedPlayers()) do
        if not notAdminGroups[v.group] then
            count = count + 1
        end
    end

    if count == 0 then 
        return xPlayer.showNotification('Brak dostępnej administracji na serwerze') 
    end

    if getChatCooldown(xPlayer.source, 'report') then return end
    addChatCooldown(xPlayer.source, xPlayer.getGroup(), 'report')

    local reportNumber = generateReportNumber(xPlayer.source)
    local content = table.concat(args, ' ')

    for k, v in ipairs(ESX.GetExtendedPlayers()) do
        if not notAdminGroups[v.group] then
            TriggerClientEvent("skam$chat", v.source, {
                label = "#" .. reportNumber,
                color = "#ff4c4c",
            }, {
                type = "REPORT",
                name = xPlayer.discord.name,
                content = "[" .. xPlayer.source .. "] Treść reporta: " .. content
            })
        end
    end

    TriggerClientEvent("skam$chat", xPlayer.source, {
        label = "#" .. reportNumber,
        color = "#ff4c4c",
    }, {
        type = "REPORT",
        name = xPlayer.discord.name,
        content = "Wysłałeś/aś reporta o treści: " .. content .. ". Do " .. count .. " adminów",
    })

    exports['skam']:log(xPlayer.source, ('REPORT %s\n%s'):format(reportNumber, content), 'general')
end, false)

ESX.RegisterCommand('cls', 'headadmin', function(xPlayer, args, showError)
    if not args[1] then 
        return xPlayer.showNotification("Nie podano id zgłoszenia!") 
    end

    local clsID = tonumber(args[1])
    if not clsID then
        return xPlayer.showNotification("Podano nieprawidłowe ID zgłoszenia!") 
    end

    if notAdminGroups[xPlayer.group] then 
        return xPlayer.showNotification("Nie posiadasz do tego permisji!") 
    end

    if not requestReport[clsID] then 
        return xPlayer.showNotification('Brak zgłoszenia o takim ID', 'error') 
    end

    --local splitIdentifier = SplitId(xPlayer.identifier)
    if reportTable[xPlayer.identifier] then
        reportTable[xPlayer.identifier] = reportTable[xPlayer.identifier] + 1
    end

    local reportedSource = requestReport[clsID]
    requestReport[clsID] = nil

    for _, v in ipairs(ESX.GetExtendedPlayers()) do
        if not notAdminGroups[v.group] then
            TriggerClientEvent("skam$chat", v.source, {
                label = "#" .. clsID,
                color = "#4cb939",
            }, {
                type = "CLS",
                name = xPlayer.discord.name,
                content = "Zgłoszenie #" .. clsID .. " zaakceptowane przez administratora!",
            })
        end
    end

    if reportedSource then
        TriggerClientEvent('skam$chat', reportedSource, {
            label = '#' .. clsID,
            color = '#4cb939',
        }, {
            type = 'CLS',
            name = xPlayer.discord.name,
            content = 'Zgłoszenie #' .. clsID .. ' zaakceptowane przez administratora!',
        })
    end

    xPlayer.showNotification('Zgłoszenie #' .. clsID .. ' zostało zaakceptowane!')
end, false)

local function refreshCommands(player)
    if GetRegisteredCommands then
        local registeredCommands = GetRegisteredCommands()
        local suggestions = {}
        for _, command in ipairs(registeredCommands) do
            if IsPlayerAceAllowed(player, 'command.'..command.name) then
                table.insert(suggestions, {
                    name = command.name,
                })
            end
        end
        TriggerClientEvent('chat:addSuggestions', player, suggestions)
    end
end

AddEventHandler('onServerResourceStart', function(resName)
    Wait(500)
    for _, player in ipairs(GetPlayers()) do
        refreshCommands(player)
    end
end)

RegisterServerEvent('chat:init', function()
    local source = source
    refreshCommands(source)
end)