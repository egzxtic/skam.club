local finish, inProgress = false, false
local _cb = nil

showProgress = function(title, duration, cb)
    if inProgress then 
        return 
    end

    if type(duration) ~= "number" then
        print("Bł ąd: Czas trwania musi być liczbą!")
        return
    end

    SendNUIMessage({
        type = 'start:progress',
        title = title,
        duration = duration,
    })

    inProgress = true
    finish = false
    _cb = cb
end

hideProgress = function()
    if inProgress then
        finish = false
        inProgress = false
        SendNUIMessage({ type = 'stop:progress' })
        if _cb then
            _cb(false)
            _cb = nil
        end
    else
        print("Błąd: Pasek postępu nie jest aktywny!")
    end
end

RegisterNUICallback('progressbarFinished', function(data, cb)
    if inProgress then
        finish = true
        inProgress = false
        if _cb then
            _cb(true)
            _cb = nil
        end
    end
    if cb then cb('ok') end
end)

exports('showProgress', showProgress)
exports('hideProgress', hideProgress)