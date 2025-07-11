queue.debuglog = true

queue.getIdentifiers = function(player)
    local ids = {
        steam = nil,
        license = nil,
        discord = nil,
        fivem = nil,
        xbl = nil,
        liveid = nil,
        --ip = nil,
        tokens = {}
    }
    
    for i = 1,GetNumPlayerTokens(player) do
        table.insert(ids.tokens, GetPlayerToken(player,i))
    end
    
    for k,v in pairs(GetPlayerIdentifiers(player))do
        if string.find(v, "steam:") then
            ids.steam = string.gsub(v,"steam:","")
        elseif string.find(v, "license:") then
            ids.license = string.gsub(v,"license:","")
        elseif string.find(v, "discord:") then
            ids.discord = string.gsub(v,"discord:","")
        elseif string.find(v, "fivem:") then
            ids.fivem = string.gsub(v,"fivem:","")
        elseif string.find(v, "xbl:") then
            ids.xbl = string.gsub(v,"xbl:","")
        elseif string.find(v, "liveid:") then
            ids.liveid = string.gsub(v,"liveid:","")
        --elseif string.find(v, "ip:") then
            --ids.ip = string.gsub(v,"ip:","")
        end
    end
    return ids
end

queue.tableLength = function(tbl)
    local result = 0
    for k, v in pairs(tbl) do
      result = result + 1
    end
    return result
end

queue.checkWhitelist = function(discord)
    return exports[GetCurrentResourceName()]:getWhitelist(discord)
end

queue.addToQueue = function(player,steam,discord,def)
    local ranks = exports[GetCurrentResourceName()]:getPremiumRanks(discord)
    local priority = 0
    local name = queue.langs[queue.lang]["normal_ticket"]
    if ranks then
        for i = 1,#ranks do
            if queue.ranks[ranks[i]] then
                if queue.ranks[ranks[i]].priority > priority then
                    priority = queue.ranks[ranks[i]].priority
                    name = queue.ranks[ranks[i]].name
                end
            end
        end
    end
    if priority > 0 then
        if #queue.players > 0 then
            local added = false
            local finish = false
            local newIndex = 0
            local newQueue = {}
            for k,v in pairs(queue.players) do
                if priority > v.priority then
                    newIndex = k
                    if not added then
                        added = true
                        local inx = 1
                        local plrnum = 1
                        for _,value in pairs(queue.players) do
                            if inx == newIndex then
                                if not finish then
                                    finish = true
                                    plrindx = 1 + plrnum
                                    a = queue.players[inx]
                                    newQueue[inx] = {timeInQueue = 0, animation = 1, player = player, def = def, steam = steam, priority = priority, priorityName = name}
                                    newQueue[plrindx] = a
                                end
                            else
                                if not finish then
                                    newQueue[inx] = value
                                else
                                    local plrindx = 1 + plrnum
                                    newQueue[plrindx] = value
                                end
                            end
                            plrnum = plrnum + 1
                            inx = inx + 1
                            if plrnum > #queue.players then
                                queue.players = newQueue
                                return
                            end
                        end
                        queue.players = newQueue
                        return
                    end
                end
            end
            if not finish or not added then
                table.insert(queue.players, {timeInQueue = 0, animation = 1, player = player, def = def, steam = steam, priority = priority, priorityName = name})
                return
            end
            return
        else
            table.insert(queue.players, {timeInQueue = 0, animation = 1, player = player, def = def, steam = steam, priority = priority, priorityName = name})
            return
        end
    else
        table.insert(queue.players, {timeInQueue = 0,animation = 1, player = player, def = def, steam = steam, priority = 0, priorityName = name})
        return
    end
end

queue.reloadQueue = function()
    for i = 1,#queue.players do
        if queue.players[i] == nil then
            local locate = false
            local oldIndex = 0
            local index = 0
            for k,v in pairs(queue.players) do
                if locate then
                    local tempInfo = queue.players[k]
                    queue.players[k] = nil
                    queue.players[oldIndex] = tempInfo
                    oldIndex = oldIndex + 1
                else
                    if (k - 1) == i then
                        locate = true
                        oldIndex = k -1
                        local tempInfo = queue.players[k]
                        queue.players[k] = nil
                        queue.players[oldIndex] = tempInfo
                        oldIndex = oldIndex + 1
                    end
                end
            end
        end
    end
end

CreateThread(function()
    while true do
        Wait(queue.refreshInterval)
        if tonumber(queue.tableLength(queue.connectingPlayers)) + tonumber(GetNumPlayerIndices()) < tonumber(GetConvar("sv_maxClients", 2000)) then
            if queue.players[1] then
                if GetPlayerLastMsg(queue.players[1].player) > 30000 then
                    queue.players[1] = nil
                else
                    queue.connectingPlayers[queue.players[1].steam] = {player = queue.players[1].player}
                    queue.players[1].def.done()
                    queue.players[1] = nil
                end
                
            end
        end
        for k,v in pairs(queue.players) do
            for i = 1,#queue.players do
                if queue.players[i] == nil then
                    queue.reloadQueue()
                end
            end
            if queue.players[k] ~= nil then
                if GetPlayerName(queue.players[k].player) ~= nil then
                    local def = v.def
                    local time = tostring(os.date("!%X",v.timeInQueue))
                    adaptivecards["queue"](k,#queue.players,def,v.animation,string.sub(time,4,string.len(time)),v.priorityName)
                    queue.players[k].animation = queue.players[k].animation + 1
                    queue.players[k].timeInQueue = queue.players[k].timeInQueue + 1
                    if queue.players[k].animation > #adaptivecards.animation then
                        queue.players[k].animation = 1
                    end
                else
                    queue.players[k] = nil
                end
            end

        end
        for k,v in pairs(queue.connectingPlayers) do
            if GetPlayerLastMsg(v.player) > 30000 then
                queue.connectingPlayers[k] = nil
            end
        end
    end
end)

AddEventHandler("playerDropped", function(reason)
    local player = source
    local i = queue.getIdentifiers(player)
    i.steam = i.discord
    if queue.connectingPlayers[i.steam] then
        queue.connectingPlayers[i.steam] = nil
    end
end)

AddEventHandler("playerConnecting", function(nickname,kickReason,def)
    local player = source
    local i = queue.getIdentifiers(player)

    def.defer()
    Wait(0)

    if not i.steam then
        def.done(queue.langs[queue.lang]["no_steam"])
        return
    end

    if not i.discord then
        def.done(queue.langs[queue.lang]["no_discord"])
        return
    end

    if queue.whitelist then
        local whitelist = queue.checkWhitelist(i.discord)
        if not whitelist then
            adaptivecards["nowhitelist"](def)
            CancelEvent()
            return
        end
    end
    
    local tempTime = queue.antifloodTime

    while tempTime > 0 do
        adaptivecards["connecting"](def,tempTime)
        tempTime = tempTime - 1
        Wait(1000)
    end
    queue.addToQueue(player,i.steam,i.discord,def)
end)

local tempPlayerSpawned = {}

RegisterNetEvent("skam-queue:playerSpawned")
AddEventHandler("skam-queue:playerSpawned", function()
    local player = source
    local i = queue.getIdentifiers(player)
    if not tempPlayerSpawned[tostring(player)] then
        tempPlayerSpawned[tostring(player)] = true
        queue.connectingPlayers[i.steam] = nil
    end
end)