local events = {}
GlobalState.battleBigWeapons = false

events.toggleBigWeapons = function(xPlayer, args, err)
    local battleBigWeapons = GlobalState.battleBigWeapons
    battleBigWeapons = not battleBigWeapons
    GlobalState.battleBigWeapons = battleBigWeapons
    local notiString = ('Przełączyłeś tryb długich podczas bitki na: %s'):format(
        (battleBigWeapons == true) and 'Włączony' or 'Wyłączony'
    )
    xPlayer.showNotification(notiString)
end

ESX.RegisterCommand('bitkadlugie', {'god'}, events.toggleBigWeapons, true, {help = 'Przełącz pozwolenie na bronie długie podczas bitki.', validate = false})