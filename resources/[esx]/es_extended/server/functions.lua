function ESX.SetTimeout(msec, cb)
  local id = Core.TimeoutCount + 1

  SetTimeout(msec, function()
    if Core.CancelledTimeouts[id] then
      Core.CancelledTimeouts[id] = nil
    else
      cb()
    end
  end)

  Core.TimeoutCount = id

  return id
end

local clientRequests = {}
local ClRequestId = 0

ESX.TriggerClientCallback = function(player, eventName, callback, ...)
    clientRequests[ClRequestId] = callback

    TriggerClientEvent("esx:triggerClientCallback", player, eventName, ClRequestId, GetInvokingResource() or "unknown", ...)

    ClRequestId = ClRequestId + 1
end

RegisterNetEvent("esx:clientCallback", function(requestId, invoker, ...)
    if not clientRequests[requestId] then
        return print(("[^1ERROR^7] Client Callback with requestId ^5%s^7 Was Called by ^5%s^7 but does not exist."):format(requestId, invoker))
    end

    clientRequests[requestId](...)
    clientRequests[requestId] = nil
end)

function ESX.RegisterCommand(name, group, cb, allowConsole, suggestion)
  if type(name) == 'table' then
    for k, v in ipairs(name) do
      ESX.RegisterCommand(v, group, cb, allowConsole, suggestion)
    end

    return
  end

  if Core.RegisteredCommands[name] then
    print(('[^3WARNING^7] Command ^5"%s" ^7already registered, overriding command'):format(name))

    if Core.RegisteredCommands[name].suggestion then
      TriggerClientEvent('chat:removeSuggestion', -1, ('/%s'):format(name))
    end
  end

  if suggestion then
    if not suggestion.arguments then
      suggestion.arguments = {}
    end
    if not suggestion.help then
      suggestion.help = ''
    end

    TriggerClientEvent('chat:addSuggestion', -1, ('%s'):format(name), suggestion.help, suggestion.arguments)
  end

  Core.RegisteredCommands[name] = {group = group, cb = cb, allowConsole = allowConsole, suggestion = suggestion}

  RegisterCommand(name, function(playerId, args, rawCommand)
    local command = Core.RegisteredCommands[name]

    if not command.allowConsole and playerId == 0 then
      print(('[^3WARNING^7] ^5%s'):format(_U('commanderror_console')))
    else
      local xPlayer, error = ESX.Players[playerId], nil

      if command.suggestion then
        if command.suggestion.validate then
          if #args ~= #command.suggestion.arguments then
            error = _U('commanderror_argumentmismatch', #args, #command.suggestion.arguments)
          end
        end

        if not error and command.suggestion.arguments then
          local newArgs = {}

          for k, v in ipairs(command.suggestion.arguments) do
            if v.type then
              if v.type == 'number' then
                local newArg = tonumber(args[k])

                if newArg then
                  newArgs[v.name] = newArg
                else
                  error = _U('commanderror_argumentmismatch_number', k)
                end
              elseif v.type == 'player' or v.type == 'playerId' then
                local targetPlayer = tonumber(args[k])

                if args[k] == 'me' then
                  targetPlayer = playerId
                end

                if targetPlayer then
                  local xTargetPlayer = ESX.GetPlayerFromId(targetPlayer)

                  if xTargetPlayer then
                    if v.type == 'player' then
                      newArgs[v.name] = xTargetPlayer
                    else
                      newArgs[v.name] = targetPlayer
                    end
                  else
                    error = _U('commanderror_invalidplayerid')
                  end
                else
                  error = _U('commanderror_argumentmismatch_number', k)
                end
              elseif v.type == 'string' then
                newArgs[v.name] = args[k]
              elseif v.type == 'item' then
                if ESX.Items[args[k]] then
                  newArgs[v.name] = args[k]
                else
                  error = _U('commanderror_invaliditem')
                end
              elseif v.type == 'weapon' then
                if ESX.GetWeapon(args[k]) then
                  newArgs[v.name] = string.upper(args[k])
                else
                  error = _U('commanderror_invalidweapon')
                end
              elseif v.type == 'any' then
                newArgs[v.name] = args[k]
              end
            end

            if v.validate == false then
              error = nil
            end

            if error then
              break
            end
          end

          args = newArgs
        end
      end

      if error then
        if playerId == 0 then
          print(('[^3WARNING^7] %s^7'):format(error))
        else
          xPlayer.showNotification(error)
        end
      else
        cb(xPlayer or false, args, function(msg)
          if playerId == 0 then
            print(('[^3WARNING^7] %s^7'):format(msg))
          else
            xPlayer.showNotification(msg)
          end
        end)
      end
    end
  end, true)

  if type(group) == 'table' then
    for k, v in ipairs(group) do
      ExecuteCommand(('add_ace group.%s command.%s allow'):format(v, name))
    end
  else
    ExecuteCommand(('add_ace group.%s command.%s allow'):format(group, name))
  end
end

function ESX.ClearTimeout(id)
  Core.CancelledTimeouts[id] = true
end

function ESX.RegisterServerCallback(name, cb)
  Core.ServerCallbacks[name] = cb
end

function ESX.TriggerServerCallback(name, requestId, source, cb, ...)
  if Core.ServerCallbacks[name] then
    Core.ServerCallbacks[name](source, cb, ...)
  else
    print(('[^3WARNING^7] Server callback ^5"%s"^0 does not exist. ^1Please Check The Server File for Errors!'):format(name))
  end
end

function Core.SavePlayer(xPlayer, cb)
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
  MySQL.prepare(
    'UPDATE `users` SET `name` = ?, `discordid` = ?, `accounts` = ?, `job` = ?, `job_grade` = ?, `dualjob` = ?, `dualjob_grade` = ?, `group` = ?, `position` = ?, `inventory` = ?, `loadout` = ? WHERE `identifier` = ?',
    {xPlayer.name, discord, json.encode(xPlayer.getAccounts(true)), xPlayer.job.name, xPlayer.job.grade, xPlayer.dualjob.name, xPlayer.dualjob.grade, xPlayer.group, json.encode(xPlayer.getCoords()),
     json.encode(xPlayer.getInventory(true)), json.encode(xPlayer.getLoadout(true)), xPlayer.identifier}, function(affectedRows)
      if affectedRows == 1 then
        --print(('[^2INFO^7] Saved player ^5"%s^7"'):format(xPlayer.name))
        TriggerEvent('esx:playerSaved', xPlayer.playerId, xPlayer)
      end
      if cb then
        cb()
      end
    end)
end

function Core.SavePlayers(cb)
  local xPlayers = ESX.GetExtendedPlayers()
  local count = #xPlayers
  if count > 0 then
    local parameters = {}
    local time = os.time()
    for i = 1, count do
      local xPlayer = xPlayers[i]
      parameters[#parameters + 1] = {xPlayer.name, json.encode(xPlayer.getAccounts(true)), xPlayer.job.name, xPlayer.job.grade, xPlayer.dualjob.name, xPlayer.dualjob.grade,
                                     xPlayer.group, json.encode(xPlayer.getCoords()), json.encode(xPlayer.getInventory(true)), json.encode(xPlayer.getLoadout(true)),
                                     xPlayer.identifier}
    end
    MySQL.prepare(
      "UPDATE `users` SET `name` = ?, `accounts` = ?, `job` = ?, `job_grade` = ?, `dualjob` = ?, `dualjob_grade` = ?, `group` = ?, `position` = ?, `inventory` = ?, `loadout` = ? WHERE `identifier` = ?",
      parameters, function(results)
        if results then
          if type(cb) == 'function' then
            cb()
          else
            print(('[^2INFO^7] Saved %s %s over %s ms'):format(count, count > 1 and 'players' or 'player', (os.time() - time) / 1000000))
          end
        end
      end)
  end
end

function ESX.GetPlayers()
  local sources = {}

  for k, v in pairs(ESX.Players) do
    sources[#sources + 1] = k
  end

  return sources
end

function ESX.GetExtendedPlayers(key, val)
  local xPlayers = {}
  for k, v in pairs(ESX.Players) do
    if key then
      if (key == 'job' and v.job.name == val) or v[key] == val then
        xPlayers[#xPlayers + 1] = v
      elseif (key == 'dualjob' and v.dualjob.name == val) or v[key] == val then
        xPlayers[#xPlayers + 1] = v
      end
    else
      xPlayers[#xPlayers + 1] = v
    end
  end
  return xPlayers
end

function ESX.GetPlayerFromId(source)
  return ESX.Players[tonumber(source)]
end

function ESX.GetPlayerFromIdentifier(identifier, split)
  if not split then
    for k, v in pairs(ESX.Players) do
      if v.identifier == identifier then
        return v
      end
    end
  else
    for k, v in pairs(ESX.Players) do
      if SplitId(v.identifier) == identifier then
        return v
      end
    end
  end
end

function SplitId(string)
  local output
  for str in string.gmatch(string, "([^:]+)") do
      output = str
  end
  return output
end

function ESX.GetIdentifier(playerId)
  local fxDk = GetConvarInt('sv_fxdkMode', 0)
  if fxDk == 1 then
    return "ESX-DEBUG-LICENCE"
  end
  for k, v in ipairs(GetPlayerIdentifiers(playerId)) do
    if string.match(v, 'license:') then
      local identifier = string.gsub(v, 'license:', '')
      return identifier
    end
  end
end

function ESX.GetVehicleType(Vehicle, Player, cb)
  Core.CurrentRequestId = Core.CurrentRequestId < 65535 and Core.CurrentRequestId + 1 or 0
  Core.ClientCallbacks[Core.CurrentRequestId] = cb
  TriggerClientEvent("esx:GetVehicleType", Player, Vehicle, Core.CurrentRequestId)
end

function ESX.RefreshJobs()
  local Jobs = {}
  local jobs = MySQL.query.await('SELECT * FROM jobs')

  if jobs then
    for i = 1, #jobs do
      Jobs[jobs[i].name] = jobs[i]
      
      -- Check if 'grades' field exists and is not nil
      if jobs[i].grades then
        local decodedGrades, decodeError = json.decode(jobs[i].grades)

        if decodedGrades then
          Jobs[jobs[i].name].grades = decodedGrades

          for j = 1, #Jobs[jobs[i].name].grades do
            Jobs[jobs[i].name].grades[j].id = j
          end
        else
          print("Error decoding 'grades' JSON:", decodeError)
        end
      else
        print("The 'grades' field is nil for job:", jobs[i].name)
      end
    end

    ESX.Jobs = Jobs
    Jobs = {}
  else
    print("No jobs found in the database.")
  end
end


function ESX.RegisterUsableItem(item, cb)
  Core.UsableItemsCallbacks[item] = cb
end

function ESX.UseItem(source, item, ...)
  if ESX.Items[item] then
    local itemCallback = Core.UsableItemsCallbacks[item]

    if itemCallback then
      local success, result = pcall(itemCallback, source, item, ...)

      if not success then
        return result and print(result) or
                 print(('[^3WARNING^7] An error occured when using item ^5"%s"^7! This was not caused by ESX.'):format(item))
      end
    end
  else
    print(('[^3WARNING^7] Item ^5"%s"^7 was used but does not exist!'):format(item))
  end
end

function ESX.RegisterPlayerFunctionOverrides(index, overrides)
  Core.PlayerFunctionOverrides[index] = overrides
end

function ESX.SetPlayerFunctionOverride(index)
  if not index or not Core.PlayerFunctionOverrides[index] then
    return print('[^3WARNING^7] No valid index provided.')
  end

  Config.PlayerFunctionOverride = indexESX.J
end

function ESX.GetItemLabel(item)
  if ESX.Items[item] then
    return ESX.Items[item].label
  else
    print('[^3UWAGA^7] Attemting to get invalid Item -> ' .. item)
  end
end

function ESX.GetJobs()
  return ESX.Jobs
end

function ESX.GetUsableItems()
  local Usables = {}
  for k in pairs(Core.UsableItemsCallbacks) do
    Usables[k] = true
  end
  return Usables
end

if not Config.OxInventory then
  function ESX.CreatePickup(type, name, count, label, playerId, components, tintIndex)
    local pickupId = (Core.PickupId == 65635 and 0 or Core.PickupId + 1)
    local xPlayer = ESX.Players[playerId]
    local coords = xPlayer.getCoords()

    Core.Pickups[pickupId] = {type = type, name = name, count = count, label = label, coords = coords}

    if type == 'item_weapon' then
      Core.Pickups[pickupId].components = components
      Core.Pickups[pickupId].tintIndex = tintIndex
    end

    TriggerClientEvent('esx:createPickup', -1, pickupId, label, coords, type, name, components, tintIndex)
    Core.PickupId = pickupId
  end
end

function ESX.DoesJobExist(job, grade)
  grade = tonumber(grade)

  if job and grade then
    if ESX.Jobs[job] and ESX.Jobs[job].grades[grade] then
      return true
    end
  end

  return false
end

function Core.IsPlayerAdmin(playerId)
  if (IsPlayerAceAllowed(playerId, 'command') or GetConvar('sv_lan', '') == 'true') and true or false then
    return true
  end

  local xPlayer = ESX.Players[playerId]

  if xPlayer then
    if xPlayer.group == 'owner' then
      return true
    end
  end

  return false
end

function ESX.getDiscordData(src)
  local discordIdentifier = GetPlayerIdentifierByType(src, "discord");
  discordIdentifier = string.gsub(discordIdentifier, "discord:", "")
  local name
  local image
  PerformHttpRequest("https://discord.com/api/v9/guilds/913692176540655627/members/"..discordIdentifier, function(err, text, headers)
      local DiscordData = json.decode(text)
      if DiscordData then
          if DiscordData.nick then
              name = DiscordData.nick
          else
              name = DiscordData.user.username
          end
          if DiscordData.user.avatar then
              image = "https://cdn.discordapp.com/avatars/"..discordIdentifier.."/"..DiscordData.user.avatar..".webp?size=128"
          else
              image = "https://upload.wikimedia.org/wikipedia/commons/thumb/b/bc/Unknown_person.jpg/925px-Unknown_person.jpg"
          end
      else
          name = GetPlayerName(src)
          image = "https://upload.wikimedia.org/wikipedia/commons/thumb/b/bc/Unknown_person.jpg/925px-Unknown_person.jpg"
      end
  end, 'GET', nil, {['Content-Type'] = 'application/json', ["Authorization"] = "Bot ODc3OTA3NTg0OTgyNjE0MDc3.G4CV7p.Qw5gsZFmdcrtAnjNEaUGI_h6BYVV9G2OVXdG8A"})
  while not name or not image do
      Wait(100)
  end
  return {name = name, image = image}
end