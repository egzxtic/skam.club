local client = {}

client.temporarySettings = {
    map = 'lotnia',
    mapIndex = 1,
    team1_manage = nil,
    team2_manage = nil
}

client.openBattleSettings = function()
    local elements = {
        {label = ('Mapa: %s'):format(client.temporarySettings.map), value = 'map'}
    }
    
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'battleSettings_creator', {
        elements = elements,
        align = 'center',
        title = 'Ustawienia wojny'
    }, function(data, menu)
        local maps = {
            {label = 'Lotnia', value = 'lotnia', mapIndex = 1},
            {label = 'Domki', value = 'domki', mapIndex = 2},
            {label = 'Elektrownia', value = 'elektrownia', mapIndex = 3},
        }
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'battleSettings_mapChoose', {
            elements = maps,
            align = 'center',
            title = 'Wybierz mapę wojny'
        }, function(data2, menu2)
            client.temporarySettings.map = data2.current.value
            client.temporarySettings.mapIndex = data2.current.mapIndex
            ESX.ShowNotification('Ustawiłeś mape bitki na ' .. data2.current.value)
            menu2.close()
            menu.close()
            client.openBattleSettings()
        end, function(data2, menu2)
            menu2.close()
            menu.close()
            client.openBattleSettings()
        end)
    end, function(data,menu)
        menu.close()
    end)
end

client.openOrgsList = function()
    local selectedTeam = promise.new()
    ESX.TriggerServerCallback('skam-battles:getOrgsList', function(list)
        local elements = {}
        for orgName, orgData in pairs(list) do
            elements[#elements+1] = {
                label = ('%s (%s/10)'):format(orgData.org.label, #orgData.members),
                value = orgData
            }
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'orgsList_creator', {
            align = 'center',
            title = 'Lista organizacji do wojny',
                elements = elements
        }, function(data, menu)
            selectedTeam:resolve(data.current.value)
        end, function(data, menu)
            menu.close()
        end)
    end)

    return Citizen.Await(selectedTeam)
end

client.openTeamManagement = function(team)
    local elements = {
        {label = 'Wybierz organizacje do teamu', value = 'showOrgsList'},
        {label = 'Usuń organizację z teamu', value = 'removeCurrentOrg'},
        {label = '----- Członkowie teamu -----'}
    }

    if (client.temporarySettings[team]) then
        for _, member in ipairs(client.temporarySettings[team].members) do
            elements[#elements+1] = {
                label = ('%s Id: %s'):format(GetPlayerName(member), member),
                value = 'xk'
            }
        end
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'battleCreatorTeamManagement', {
        elements = elements,
        align = 'center',
        title = 'Zarządzanie Teamem wojny'
    }, function(data, menu)
        ESX.UI.Menu.CloseAll()
        if (data.current.value == 'showOrgsList') then
            local selectedTeam = client.openOrgsList()
            local otherTeam = (team):find('team1_') and 'team2_manage' or 'team1_manage'
            if (client.temporarySettings[otherTeam] and selectedTeam.org.name == client.temporarySettings[otherTeam].org.name) then
                ESX.UI.Menu.CloseAll()
                return ESX.ShowNotification('Ten team już jest ustawiony jako team!')
            end
            client.temporarySettings[team] = selectedTeam
            TriggerServerEvent('skam-battleCreator:addTeamToBattle', selectedTeam)
            -- print(team, 'team')
            client.openBattleCreator()
        elseif (data.current.value == 'removeCurrentOrg') then
            TriggerServerEvent('skam-battleCreator:removeTeamFromBattle', client.temporarySettings[team])
            client.temporarySettings[team] = nil
            client.openBattleCreator()
        end
    end, function(data, menu)
        ESX.UI.Menu.CloseAll()
    end)
end

client.openBattleCreator = function()
    local elements = {
        {label = ('Team #1 %s'):format(
            client.temporarySettings.team1_manage and ('(%s %s/10)'):format(client.temporarySettings.team1_manage.org.label, #client.temporarySettings.team1_manage.members) or ''
        ), value = 'team1_manage'},
        {label = ('Team #2 %s'):format(
            client.temporarySettings.team2_manage and ('(%s %s/10)'):format(client.temporarySettings.team2_manage.org.label, #client.temporarySettings.team2_manage.members) or ''
        ), value = 'team2_manage'},
        {label = '----- Opcje -----', value = 'xd'},
        {label = 'Ustawienia Bitki', value = 'settings'},
        {label = 'START', value = 'start'}
    }

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'battleCreator', {
        elements = elements,
        align = 'center',
        title = 'Kreator Wojny'
    }, function(data, menu)
        if (data.current.value == 'settings') then
            client.openBattleSettings()
        elseif (data.current.value:find('_manage')) then
            client.openTeamManagement(data.current.value)
        elseif (data.current.value == 'start') then
            client.temporarySettings = {
                map = 'lotnia',
                mapIndex = 1,
                team1_manage = nil,
                team2_manage = nil
            }
            TriggerServerEvent('skam-battleCreator:startBattle', client.temporarySettings)
        end
    end, function(data, menu)
        ESX.UI.Menu.CloseAll()
    end)
end

-- RegisterCommand('wojna', client.openBattleCreator)