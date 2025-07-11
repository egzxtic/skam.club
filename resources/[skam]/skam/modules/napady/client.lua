local heists = Config['heists'].list
local activeHeist = nil
local progressActive = false
local blips = {}

local function getDropListWithLabels(heist, cb)
    local itemNames = {}
    for _, drop in ipairs(heist.dropItems) do
        table.insert(itemNames, drop.name)
    end
    ESX.TriggerServerCallback('skam$item:getlabel', function(labels)
        local drops = {}
        if heist.moneyReward and heist.moneyReward.min and heist.moneyReward.max then
            table.insert(drops, {
                label = string.format(
                    'Możliwa wygrana: $%s - $%s',
                    ESX.Math.GroupDigits(heist.moneyReward.min),
                    ESX.Math.GroupDigits(heist.moneyReward.max)
                )
            })
        end
        for _, drop in ipairs(heist.dropItems) do
            local label = labels[drop.name] or drop.name
            table.insert(drops, {
                label = string.format('%s: %dx (szansa %d%%)', label, drop.countMax, drop.chance)
            })
        end
        cb(drops)
    end, itemNames)
end

local function PDAlert(coords, heistName)
    local blip = AddBlipForCoord(coords)
    SetBlipSprite(blip, 161)
    SetBlipScale(blip, 1.2)
    SetBlipColour(blip, 1)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString('Napad: '..heistName)
    EndTextCommandSetBlipName(blip)
    ESX.ShowNotification('Alarm napadowy: '..heistName)

    Citizen.SetTimeout(120000, function()
        RemoveBlip(blip)
    end)
end

for key, v in pairs(heists) do
    if v.enabled then
        if v.blip then
            local blip = AddBlipForCoord(v.coords)
            SetBlipSprite(blip, v.blip.icon or 1)
            SetBlipScale(blip, v.blip.size or 0.8)
            SetBlipColour(blip, v.blip.color or 1)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString('NAPAD: ' .. (v.heistName or 'BANK'))
            EndTextCommandSetBlipName(blip)
            blips[key] = blip
        end

        SKAM.RegisterPlace({
            coords = v.coords,
            Marker = {size = vector3(2.0,2.0,0.3)},
            txt3d = 'rozpocząć napad na: ' .. v.heistName,
            onPress = function()
                local elements = {
                    {label = 'Rozpocznij napad', action = 'start'},
                    {label = 'Sprawdź łupy', action = 'drops'}
                }
                ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'napad_menu_'..key, {
                    title    = v.heistName,
                    align    = 'center',
                    elements = elements
                }, function(data, menu)
                    if data.current.action == 'start' then
                        if activeHeist then
                            ESX.ShowNotification('Już trwa inny napad!')
                            return
                        end
                        
                        if GetSelectedPedWeapon(PlayerPedId()) == GetHashKey('WEAPON_UNARMED') then
                            ESX.ShowNotification('Musisz trzymać broń w ręku, aby rozpocząć napad!')
                            return
                        end
    
                        ESX.TriggerServerCallback('skam$heist:canStart', function(canStart, msg)
                            if canStart then
                                TriggerEvent('skam$heist:startHeist', key)
                                menu.close()
                            else
                                ESX.ShowNotification(msg)
                            end
                        end, key)
                    elseif data.current.action == 'drops' then
                        getDropListWithLabels(v, function(drops)
                            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'napad_drops_'..key, {
                                title    = 'Możliwe łupy',
                                align    = 'center',
                                elements = drops
                            }, function(data2, menu2) end,
                            function(data2, menu2)
                                menu2.close()
                            end)
                        end)
                    end
                end, function(data, menu)
                    menu.close()
                end)
            end,
            onExit = function()
                ESX.UI.Menu.CloseAll()
                exports['skam-ui']:hideProgress()
            end
        })
    end
end

RegisterNetEvent('skam$heist:startHeist')
AddEventHandler('skam$heist:startHeist', function(heistKey)
    local v = heists[heistKey]
    activeHeist = heistKey
    progressActive = false

    exports['skam-ui']:StartGame(v.difficulty, function(success)
        if success then
            progressActive = true
            exports['skam-ui']:showProgress('Otwieranie sejfu', v.secondsRemaining * 1000, function(isFinished)
                if isFinished and progressActive then
                    TriggerServerEvent('skam$heist:reward', heistKey)
                end
                activeHeist = nil
                progressActive = false
                exports['skam-ui']:hideProgress()
            end)
        else
            activeHeist = nil
            progressActive = false
            exports['skam-ui']:hideProgress()
            ESX.ShowNotification('Nieudana próba włamania!')
        end
    end)
end)
 
RegisterNetEvent('skam$heist:policeNotify')
AddEventHandler('skam$heist:policeNotify', function(coords, heistName)
    PDAlert(coords, heistName)
end)

AddEventHandler('skam$death', function()
    if activeHeist then
        ESX.ShowNotification('Napad został przerwany przez śmierć!')
        exports['skam-ui']:hideProgress()
        activeHeist = nil
        progressActive = false
    end
end)