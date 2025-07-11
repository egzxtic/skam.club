local chatEnabled, suggestions, suggestedCommandRegistered, offchat  = false, {}, {}, false;

CreateThread(function()
    SetTextChatEnabled(false)
    DisableMultiplayerChat(true)
end)

local pCoords
CreateThread(function()
	while true do
		pCoords = GetEntityCoords(PlayerPedId())
        Citizen.Wait(500)
        --print(offchat)
	end
end)

RegisterCommand("offchat", function()
    offchat = not offchat
    SetNuiFocus(false, false)
    SendNUIMessage({
        eventName = "nui:chat:setActive",
        isActive = not offchat
    })
end)

SKAM.addKeybind({
    key = 'T',
    description = 'Pokaż czat',
    onPressed = function()
        if not chatEnabled then
            chatEnabled = true
            SendNUIMessage({
                eventName = "nui:chat:focus"
            })
            SetNuiFocus(true, false)
        end
    end
})

function closeChat()
    chatEnabled = false
    SetNuiFocus(false, false)
    SendNUIMessage({
        eventName = "nui:chat:defocus"
    })
end

RegisterNUICallback("chat/off", function(data, cb)
    closeChat();
    cb('ok')
end)

RegisterNUICallback("chat/send", function(data, cb)
    local message = data.message;
    if not data.message then return end
    closeChat();
    if message then
        if message:sub(1, 1) == "/" then
            ExecuteCommand(message:sub(2))
        else
            ExecuteCommand("LOOC "..message)
        end
    end
    cb('ok')
end)

RegisterNetEvent("skam$chat:addMessage", function(message, messageOwner, messageOwnerCoords)
    ESX.PlayerData = ESX.GetPlayerData();
    local job = "BRAK"
    local command = Config.ChatCommands[message.type];
    if not messageOwner then return end
    if command then
        if command.receivers == "distance" then
            local playerCoords = GetEntityCoords(PlayerPedId())
            local distance = #(playerCoords - messageOwnerCoords) < 25.0;
            if not distance then return end
        elseif command.receivers == "admins" then
            local isAllowed = command.groups[ESX.PlayerData.group];
            if not isAllowed then return end
        end
    end

    if messageOwner then
        if messageOwner.job then
            if messageOwner.job == "UNEMPLOYED" then
                job = "BRAK"
            else
                job = messageOwner.job
            end
        end
    end

    SendNUIMessage({
        eventName = "nui:chat:newMessage",
        newMessage = {
            badge = Config.ChatBadges[messageOwner.group],
            type = string.upper(message.type),
            title = messageOwner.name,
            id = messageOwner.id,
            subtitle = job, 
            content = message.content,
        }
    })
end)

RegisterNetEvent("skam$chat", function(badge, message)
    SendNUIMessage({
        eventName = "nui:chat:newMessage",
        newMessage = {
            id = message.id,
            badge = badge,
            type = string.upper(message.type),
            title = message.name,
            content = message.content,
        }
    })
end)

function addSuggestion(name)
    if not name then return end
    if suggestedCommandRegistered[name] then return end
    suggestions[#suggestions + 1] = name;
    suggestedCommandRegistered[name] = true
end
exports('addSuggestion', addSuggestion)
  
function refreshCommands()
    if GetRegisteredCommands then
        local registeredCommands = GetRegisteredCommands()
        for _, command in ipairs(registeredCommands) do
            if IsAceAllowed('command.'..command.name) then
                addSuggestion(command.name);
            end
        end
        refreshSuggs()
    end
end

AddEventHandler('onClientResourceStart', function(resName)
    Wait(500)
    refreshCommands()
end)
  
AddEventHandler('onClientResourceStop', function(resName)
    Wait(500)
    refreshCommands()
end)

RegisterNetEvent('chat:addSuggestion', function(name)
    addSuggestion(name);
    refreshSuggs();
end)

RegisterNetEvent('chat:addSuggestions', function(suggestions2)
    for _, suggestion in ipairs(suggestions2) do
        addSuggestion(suggestion.name);
    end
    refreshSuggs()
end)

CreateThread(function()
    TriggerServerEvent("chat:init");
    Wait(5000)
    ESX.PlayerData = ESX.GetPlayerData()
end)

function refreshSuggs()
    SendNUIMessage({
        eventName = "nui:chat:updateSuggestions",
        suggestions = suggestions,
    })
end

RegisterNetEvent('skam$chat:adminlist')
AddEventHandler('skam$chat:adminlist', function(admins)
	local elements = {}
	local adminsCount = 0
	for k, v in pairs(admins) do
		adminsCount = adminsCount + 1
		table.insert(elements, {label = v.name..' [ID: '..v.id..'] ['..string.upper(v.rank)..']', value = nil})
	end
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'admin_list', {
		title    = 'Administratorzy online ('..adminsCount..')',
		align    = 'center',
		elements = elements
	}, function(data, menu)
	end, function(data, menu)
		menu.close()
	end)
end)