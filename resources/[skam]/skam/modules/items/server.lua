local itemList = {
    energydrink = 'energydrink',
    vestlight = 'vest-light',
    vestmedium = 'vest-medium',
    vestheavy = 'vest-heavy',
    repairkit = 'repairkit',
    handcuff = 'handcuffs',
    joint = 'ability-joint',
    fentanyl = 'narco-fentanyl-paczka',
    coke = 'narco-coke-paczka',
    heroin = 'narco-heroin-paczka',
    weed = 'narco-weed-paczka',
    codeine = 'narco-codeine-paczka',
    meth = 'narco-meth-paczka',
}

ESX.RegisterUsableItem(itemList.energydrink, function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent('skam:onEnergyDrink', xPlayer.source)
    xPlayer.removeInventoryItem(itemList.energydrink, 1)
end)

ESX.RegisterUsableItem(itemList.joint, function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent('skam:onSmokeWeed', xPlayer.source)
    xPlayer.removeInventoryItem(itemList.joint, 1)
end)

ESX.RegisterUsableItem(itemList.codeine, function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent('skam:onRecoilDrug', xPlayer.source)
    xPlayer.removeInventoryItem(itemList.codeine, 1)
end)

ESX.RegisterUsableItem(itemList.meth, function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent('skam:onMethPooch', xPlayer.source)
    xPlayer.removeInventoryItem(itemList.meth, 1)
end)

ESX.RegisterUsableItem(itemList.handcuff, function(source)
    TriggerClientEvent('skam:onHandcuffs', source)
end)

ESX.RegisterUsableItem(itemList.repairkit, function(source)
    TriggerClientEvent('skam:onRepairKit', source)
end)

local vestTypes = {
    [itemList.vestlight] = 25,
    [itemList.vestmedium] = 50,
    [itemList.vestheavy] = 100,
}

for itemName, value in pairs(vestTypes) do
    ESX.RegisterUsableItem(itemName, function(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        TriggerClientEvent('skam:useVest', xPlayer.source, value)
        xPlayer.removeInventoryItem(itemName, 1)
    end)
end