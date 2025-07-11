RegisterServerEvent('skam:useHealer')
AddEventHandler('skam:useHealer', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local cash, bank = xPlayer.getAccount('money'), xPlayer.getAccount('bank')
    local useBank, useMoney = false, false
    local serverCoords = GetEntityCoords(GetPlayerPed(xPlayer.source))
    local isClose = false
    local price = Config['healer'].HealerPrice

    for k, v in pairs(Config['healer'].Healers) do
        if #(vector3(v.x, v.y, v.z) - serverCoords) < 10.0 then
            if not isClose then
                isClose = true
                break
            end
        end
    end

    if not isClose then
        --exports['skam-interiors']:banPlayer(xPlayer.source, 'skam:useHealer', false, GetCurrentResourceName())
        return
    end

    if bank.money >= price then
        useBank = true
    elseif cash.money >= price then
        useMoney = true
    end

    if not useBank and not useMoney then
        xPlayer.showNotification('Nie posiadasz wystarczająco dużo pieniędzy. Brakuje Ci '..math.floor(price-cash.money)..'$ gotówki lub '..math.floor(price-bank.money)..'$ na koncie')
        return
    end

    if useBank then
        xPlayer.removeAccountMoney('bank', price)
    else
        xPlayer.removeAccountMoney('money', price)
    end

    xPlayer.showNotification('Zapłacono '..price..'$ za pomoc medyczną')
    xPlayer.triggerEvent('skam$death:revive')
end)