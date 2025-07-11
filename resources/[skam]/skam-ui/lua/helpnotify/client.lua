local function helpNotify(data)
    if type(data) ~= "table" or not data.desc then
        print("[helpNotify] Nieprawidłowe dane do powiadomienia!")
        return
    end
    SendNUIMessage({
        action = "nui:helpnotify:show",
        show = true,
        data = {
            title = data.title or 'Pomoc!',
            desc = data.desc,
        }
    })
end

local function hideHelpNotify()
    SendNUIMessage({
        action = "nui:helpnotify:hide"
    })
end

exports('helpNotify', helpNotify)
exports('hideHelpNotify', hideHelpNotify)