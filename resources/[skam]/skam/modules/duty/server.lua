ESX.RegisterCommand('duty', 'user', function(xPlayer, args, showError)
    local job, grade = xPlayer.job.name, xPlayer.job.grade
    if job == 'offpolice' then
        xPlayer.setJob('police', grade)
        xPlayer.showNotification('Wchodzisz na służbę', 'success', 3000)
    elseif job == 'police' then
        xPlayer.setJob('offpolice', grade)
        xPlayer.showNotification('Schodzisz z służby', 'error', 3000)
    end
end, false, {help = 'Wejdź/Wyjdź z służby'})