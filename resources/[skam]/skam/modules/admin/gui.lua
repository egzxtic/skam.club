local players = {}
CreateThread(function()
	ESX.PlayerData = ESX.GetPlayerData()
	TriggerServerEvent('skam:exadmin:amiadmin')
end)
isAdmin = false

RegisterNetEvent('esx:setGroup')
AddEventHandler('esx:setGroup', function(group)
    ESX.PlayerData.group = group
    if ESX.PlayerData.group ~= 'user' and ESX.PlayerData.group ~= 'revivator' then 
        isAdmin = true 
    end
end)

RegisterCommand('getcoords', function()
	print(GetEntityCoords(PlayerPedId()))
end)

frozen = false
strings = {}
banLength = {}

banlist = {}
settings = {
	button = 289,
	forceShowGUIButtons = false,
}

permissions = {
	ban = false,
	kick = false,
	spectate = false,
	unban = false,
	teleport = false,
	manageserver = false,
	slap = false,
	freeze = false,
	screenshot = false,
	immune = false,
	anon = false,
	debug = false,
	invisible = false,
	noclip = false,
	invincible = false,
	vehicles = false,
	vehiclestune = false,
	griefing = false,
	wezwanie = false,
}

local SlapAmount = {}
for i=1,20 do
	table.insert(SlapAmount, i)
end

CreateThread(function()
	TriggerServerEvent('skam:exadmin:amiadmin')
	TriggerServerEvent('skam:exadmin:requestbanlist')
	TriggerServerEvent('skam:exadmin:requestcachedplayers') 
end)

RegisterCommand('$adminmenu', function()
	Citizen.CreateThread(function()
		playerlist = nil
        TriggerServerEvent('skam:exadmin:requestcachedplayers')
		TriggerServerEvent('skam:exadmin:getinfinityplayerlist')
		repeat
			Wait(100)
		until playerlist
		if strings then
			if ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'menu') then
				ESX.UI.Menu.CloseAll()
			else
				GenerateMenu()
			end
		else
			TriggerServerEvent('skam:exadmin:amiadmin')
		end
	end)
end)

banLength = {
    {label = 'Permamentny', time = 10444633200},
    {label = '1 Dzień', time = 86400},
    {label = '2 Dni', time = 172800},
    {label = '3 Dni', time = 259200},
    {label = '5 Dni', time = 432000},
    {label = '1 Tydzień', time = 518400},
    {label = '2 Tygodnie', time = 1123200},
    {label = '1 Miesiąc', time = 2678400},
    {label = '1 Rok', time = 31536000},
}
NoClip = false
noClipSpeed = 1
noClipLabel = nil
local noClipSpeeds = {
	[1] = 'x1 [min]',
	[2] = 'x2',
	[3] = 'x3',
	[4] = 'x4',
	[5] = 'x5',
	[6] = 'x6',
	[7] = 'x7',
	[8] = 'x8',
	[9] = 'x9',
	[10] = 'x10 [max]'
}
status = {
    ['niewidka'] = false,
}
RegisterKeyMapping('$adminmenu', 'Admin Menu', 'keyboard', 'F10')

Citizen.CreateThread(function()
    TriggerEvent('chat:removeSuggestion', '/$adminmenu')
end)

banlistPage = 1
local function ListaUnban()
    local elementsbanlist = {}
    for i,theBanned in ipairs(banlist) do
        if i<(banlistPage*10)+1 and i>(banlistPage*10)-10 then
            if theBanned then
                local reason = '['..theBanned.identifiers[1]..'] '..(theBanned.reason or 'Brak powodu')..' - '..theBanned.banner or ' Brak'
                table.insert(elementsbanlist, {label = reason, value='unban', value1=theBanned.banid, value2=theBanned.identifiers[1] })
            end
        end
    end
    if #banlist > (banlistPage * 10) then 
        table.insert(elementsbanlist, {label = 'Ostatnia strona»»', value='page', value1=math.ceil(#banlist / 10) })
    end
    if banlistPage > 1 then 
        table.insert(elementsbanlist, {label = '««Pierwsza strona', value='page',value1=1 })
        table.insert(elementsbanlist, {label = '«Poprzednia strona', value='page',value1=banlistPage-1 })
    end
    if #banlist > (banlistPage * 10) then
        table.insert(elementsbanlist, {label = 'Następna strona»', value='page',value1=banlistPage+ 1 })
    end
    table.insert(elementsbanlist, {label = 'Odśwież banlistę', value='refreshbanlist' })

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menu3', {
        title    = ('UWAGA: Naciśnięcie spowoduje odblokowanie tego Gracza'),
        align    = 'bottom-right',
        elements = elementsbanlist
    }, function(data3,menu3)
        if data3.current.value == 'page' then
            banlistPage=data3.current.value1
            ListaUnban()
        elseif data3.current.value=='refreshbanlist' then 
            TriggerServerEvent('skam:exadmin:updatebanlist')
            ListaUnban()
        elseif data3.current.value=='unban' then
            TriggerServerEvent('skam:exadmin:unbanplayer', data3.current.value1, data3.current.value2)
            TriggerServerEvent('skam:exadmin:requestbanlist')
        end
    end,function(data3,menu3)
        menu3.close()
    end)
end

local id,nick,powod,dlugosc,mozliwosc = nil
OpenOfflineBanMenu = function(id,nick,powod,dlugosc,mozliwosc)
    id=id 
    nick=nick
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menu4', {
        title    = ('ADMINMENU | OFFLINE BAN'),
        align    = 'bottom-right',
        elements = {
            {label='Zmień powód bana: '..powod,value='powod'},
            {label='Długość: '..banLength[dlugosc].label,value='dlugosc'},
            label='Możliwość odwołania: '..(mozliwosc and "<span style='color:green;'>TAK</span>" or "<span style='color:red;'>NIE</span>")
            {label='Wystaw Bana',value='wystaw'},
        }
    }, function(data4,menu4)
        if data4.current.value=='powod' then 
            TriggerEvent('skam:keyboard', function(valuee)
                if valuee then
                    powod = valuee
                else
                    powod='Nie określono przyczyny'
                end
                OpenOfflineBanMenu(id,nick,powod,dlugosc,mozliwosc)
            end, {
                limit = 60,
                type = 'textarea',
                title = 'Wprowadź powód bana (maks. 60 znaków)'
            })
        elseif data4.current.value=='dlugosc' then 
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menu5', {
                title    = ('ADMINMENU | DŁUGOŚĆ BANA'),
                align    = 'bottom-right',
                elements = {
                    {label = 'Permamentny', time = 10444633200, valuee=1},
                    {label = '1 Dzień', time = 86400,valuee=2},
                    {label = '2 Dni', time = 172800,valuee=3},
                    {label = '3 Dni', time = 259200,valuee=4},
                    {label = '5 Dni', time = 432000,valuee=5},
                    {label = '1 Tydzień', time = 518400,valuee=6},
                    {label = '2 Tygodnie', time = 1123200,valuee=7},
                    {label = '1 Miesiąc', time = 2678400,valuee=8},
                    {label = '1 Rok', time = 31536000,valuee=9},
                }
            }, function(data5,menu5)
                menu5.close()
                dlugosc = data5.current.valuee
                OpenOfflineBanMenu(id,nick,powod,dlugosc,mozliwosc)
            end, function(data5,menu5) menu5.close() end)
        elseif data4.current.value=='mozliwosc' then
            mozliwosc = not mozliwosc 
            OpenOfflineBanMenu(id,nick,powod,dlugosc,mozliwosc)
        elseif data4.current.value=='wystaw' then
            TriggerServerEvent('skam:exadmin:offlinebanplayer', id, powod, banLength[dlugosc].time, nick, (mozliwosc and 'TAK' or 'NIE'))
            id,nick,powod,dlugosc,mozliwosc = nil
        end
    end, function(data4,menu4) menu4.close() end)
end

OpenBanMenu = function(id, nick, powod, dlugosc, mozliwosc)
    id = id 
    nick=nick
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menu4', {
        title    = ('ADMINMENU | ONLINE BAN'),
        align    = 'bottom-right',
        elements = {
            {label = 'Zmień powód bana: ' .. powod, value = 'powod'},
            {label = 'Długość: ' .. banLength[dlugosc].label, value = 'dlugosc'},
            {label = 'Możliwość odwołania: ' .. (mozliwosc and "<span style='color:green;'>TAK</span>" or "<span style='color:red;'>NIE</span>"), value = 'mozliwosc'},
            {label = 'Wystaw Bana', value = 'wystaw'},
        }
    }, function(data4, menu4)
        if data4.current.value == 'powod' then
            TriggerEvent('skam:keyboard', function(value)
                if value then
                    powod = value
                else
                    powod = 'Nie określono przyczyny'
                end
                OpenBanMenu(id, nick, powod, dlugosc, mozliwosc)
            end, {
                limit = 60,
                type = 'textarea',
                title = 'Wprowadź powód bana (maks. 60 znaków)'
            })
        end
        if data4.current.value == 'dlugosc' then
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menu5', {
                title    = ('ADMINMENU | DŁUGOŚĆ BANA'),
                align    = 'bottom-right',
                elements = {
                    {label = 'Permamentny', time = 10444633200, valuee = 1},
                    {label = '1 Dzień', time = 86400, valuee = 2},
                    {label = '2 Dni', time = 172800, valuee = 3},
                    {label = '3 Dni', time = 259200, valuee = 4},
                    {label = '5 Dni', time = 432000, valuee = 5},
                    {label = '1 Tydzień', time = 518400, valuee = 6},
                    {label = '2 Tygodnie', time = 1123200, valuee = 7},
                    {label = '1 Miesiąc', time = 2678400, valuee = 8},
                    {label = '1 Rok', time = 31536000, valuee = 9},
                }
            }, function(data5, menu5)
                menu5.close()
                dlugosc = data5.current.valuee
                OpenBanMenu(id, nick, powod, dlugosc, mozliwosc)
            end, function(data5, menu5) menu5.close() end)
        end
        if data4.current.value == 'mozliwosc' then
            mozliwosc = not mozliwosc
            OpenBanMenu(id, nick, powod, dlugosc, mozliwosc)
        end
        if data4.current.value == 'wystaw' then
            TriggerServerEvent('skam:exadmin:banplayer', id, powod, banLength[dlugosc].time, nick, (mozliwosc and 'TAK' or 'NIE'))
            id,nick,powod,dlugosc,mozliwosc = nil
            menu4.close()
        end
    end, function(data4, menu4)
        menu4.close() 
    end)
end

function sortowanie(s)
	local t = {}
	for k,v in pairs(s) do
		table.insert(t, v)
	end
	table.sort(t, function(a, b)
		if a.id ~= b.id then
			return a.id < b.id
		end
	end)
	return t
end
drawInfo = false
drawTarget = 0

function DrawPlayerInfo(target, custom)
	drawTarget = target
	local ply = GetPlayerFromServerId(drawTarget)
	if ply and ply ~= -1 then
		TriggerEvent('skam:exadmin:spectate', ply)
	end
	drawInfo = true
	if custom then
		drawCustom = custom
	end
end

function StopDrawPlayerInfo(cb)
	if not drawInfo then
		return
	end
	drawInfo = false
	drawTarget = 0
	TriggerEvent('skam:exadmin:spectate', nil)
	if drawCustom then
		RequestCollisionAtCoord(drawCustom.coords.x, drawCustom.coords.y, drawCustom.coords.z)
		local ped = PlayerPedId()
		SetEntityCoords(ped, drawCustom.coords.x, drawCustom.coords.y, drawCustom.coords.z, 0, 0, GetEntityHeading(ped), false)
		Citizen.CreateThread(function()
			FreezeEntityPosition(ped, false)
			if drawCustom.invisible then
				SetEntityVisible(ped, true)
			end
			if drawCustom.vehicle and drawCustom.vehicle ~= 0 then
				local id, timeout = nil, 30
				repeat
					Citizen.Wait(100)
					id = NetToVeh(drawCustom.vehicle)
					timeout = timeout - 1
				until DoesEntityExist(id) or timeout == 0
				if DoesEntityExist(id) and AreAnyVehicleSeatsFree(id) then
					local tick = 20
					repeat
						TaskWarpPedIntoVehicle(ped, id, -2)
						tick = tick - 1
						Citizen.Wait(50)
					until IsPedInAnyVehicle(ped, false) or tick == 0
				end
				cb()
			else
				Citizen.Wait(1000)
				-- ESX.ShowNotification('~r~Przestałeś spectować','Admin Menu','info')
				SetEntityVisible(ped, true)
				cb()
			end
			drawCustom = nil
		end)
	else
		RequestCollisionAtCoord(table.unpack(GetEntityCoords(PlayerPedId(), false)))
        -- ESX.ShowNotification('~r~Przestałeś spectować','Admin Menu','info')
		cb()
	end
end

local freze ={}
OpenNoclip= function()
    local elementsnoclip = {}
    table.insert(elementsnoclip, {label='Noclip '..(NoClip and "<span style='color:green;'>ON</span>" or "<span style='color:red;'>OFF</span>"), value='onoffnoclip'})
    table.insert(elementsnoclip, {label='Szybkość: '..noClipSpeeds[noClipSpeed]})
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menu2', {
        title    = ('ADMINMENU | NOCLIP'),
        align    = 'bottom-right',
        elements = elementsnoclip
    }, function(data2,menu2)
        if data2.current.value == 'onoffnoclip' then 
            NoClip = not NoClip
            OpenNoclip()
        end
    end, function(data2,menu2)
        menu2.close()
    end)
end
GenerateMenu = function()
	TriggerServerEvent('skam:exadmin:requestcachedplayers')
    ESX.UI.Menu.CloseAll()
	collectgarbage()
	players = {}
    elementsglowne = {
        {label = 'Zarządzanie Graczami', value = 'gracze'},
        -- {label = 'Odbanowywanie', value = 'serwer'},
    }

    if permissions.vehicles and IsPedInAnyVehicle(PlayerPedId(), false) then 
        table.insert(elementsglowne,{label = 'Pojazd',value='pojazd'})
    end
    table.insert(elementsglowne,{label = 'Ustawienia', value = 'settings'})
    if permissions.noclip then
        table.insert(elementsglowne, {label='Noclip', value='noclip'})
    end
	if permissions.invisible then
        table.insert(elementsglowne, {label='Niewidzialność '.. (status['niewidka'] and "<span style='color:green;'>ON</span>" or "<span style='color:red;'>OFF</span>"), value='niewidka'})
        table.insert(elementsglowne, {label='Teleport do znacznika', value='tpway'})
    end
    
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menu', {
		title    = ('ADMINMENU | GŁÓWNE'),
		align    = 'bottom-right',
		elements = elementsglowne
	}, function(data, menu)
        if data.current.value == 'gracze' then 
            elementsgracze = {}
            if permissions.ban then
                table.insert(elementsgracze,{label='Ostatni Gracze', value='ostatni'})
            end
            local ids = sortowanie(playerlist)
            for i,thePlayer in pairs(ids) do
                table.insert(elementsgracze,{label='['..thePlayer.id..'] '..thePlayer.name, value=thePlayer.id, value1=thePlayer.name})
            end
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menu2', {
                title    = ('ADMINMENU | GRACZE'),
                align    = 'bottom-right',
                elements = elementsgracze
            }, function(data2,menu2)
                if data2.current.value=='ostatni' then
                    elemntost = {}
                    for i, cachedplayer in pairs(cachedplayers) do
                        if cachedplayer.droppedTime and not cachedplayer.immune then
                            table.insert(elemntost, {label='['..cachedplayer.id..'] '..cachedplayer.name, value='ban',value1=cachedplayer.id,value2=cachedplayer.name})
                        end
                    end
                    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menu3', {
                        title    = ('ADMINMENU | OSTANI GRACZE'),
                        align    = 'bottom-right',
                        elements = elemntost
                    }, function(data3,menu3)
                        if data3.current.value=='ban' then 
                            OpenOfflineBanMenu(data3.current.value1,data3.current.value2,'Nie określono przyczyny',1,false)
                        end
                    end, function(data3,menu3) menu3.close() end)
                else
                    OpenPlayerOptions(data2.current.value, data2.current.value1)
                end
            end, function(data2,menu2) menu2.close() end)
        elseif data.current.value == 'pojazd' then 
            elementsauta = {
                {label='Naprawa silnika', value='silnik'},
                {label='Naprawa karoseria', value='karoseria'},
                {label='Mycie', value='myjumyju'},
            }
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menu2', {
                title    = ('exADMIN | POJAZD'),
                align    = 'bottom-right',
                elements = elementsauta
            }, function(data2,menu2)
                local vehicle = GetVehiclePedIsIn(PlayerPedId())
                if data2.current.value=='silnik' then 
                    SetVehicleEngineHealth(vehicle, 1000.0)
                    SetVehicleUndriveable(vehicle, false)
                    SetVehicleEngineOn(vehicle, true, true)
                    Citizen.Wait(0)
                    --exports['skam']:SendLog('Naprawił silnik pojazdu', 'exadmin')
                elseif data2.current.value=='karoseria' then 
                    SetVehicleBodyHealth(vehicle, 1000.0)
                    SetVehicleDeformationFixed(vehicle)
                    SetVehicleFixed(vehicle)
                    --exports['skam']:SendLog('Naprawił karoserie pojazdu', 'exadmin')
                elseif data2.current.value=='myjumyju' then 
                    WashDecalsFromVehicle(vehicle, 1.0)
                    SetVehicleDirtLevel(vehicle)
                end
            end, function(data2,menu2)
                menu2.close()
            end)
        elseif data.current.value == 'settings' then
            local elementsustawienia = {
                {label = 'Odśwież ostatnich graczy', value='refreshlastplayers'},
                {label = 'Odśwież uprawnienia', value='refreshperms'},
            }
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menu2', {
                title    = ('exADMIN | USTAWIENIA'),
                align    = 'bottom-right',
                elements = elementsustawienia
            }, function(data2,menu2)
                if data2.current.value == 'refreshperms' then 
                    TriggerServerEvent('skam:exadmin:amiadmin')
                    ESX.UI.Menu.CloseAll()
                elseif data2.current.value == 'refreshlastplayers' then
                    TriggerServerEvent('skam:exadmin:requestcachedplayers')
                    ESX.UI.Menu.CloseAll()
                end
            end, function(data2,menu2)
                menu2.close()
            end)
        elseif data.current.value == 'noclip' then 
            OpenNoclip()
        elseif data.current.value =='niewidka' then
            local pid = PlayerPedId()
            SetEntityVisible(pid, not IsEntityVisible(pid))
            status['niewidka'] = not status['niewidka']
            --exports['skam']:SendLog('Właczył/wyłączył niewidzialność', 'exadmin')
            GenerateMenu()
        elseif data.current.value == 'tpway' then 
            local WaypointHandle = GetFirstBlipInfoId(8)
			if DoesBlipExist(WaypointHandle) then
				local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)
				for height = 1, 1000 do
					SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords['x'], waypointCoords['y'], height + 0.0)
					local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords['x'], waypointCoords['y'], height + 0.0)
					if foundGround then
						SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords['x'], waypointCoords['y'], height + 0.0)
						break
					end
					Citizen.Wait(5)
				end
                --exports['skam']:SendLog('Użył teleportacji do znacznika', 'exadmin')
			end
        end
    end, function(data,menu)
        menu.close()
    end)
end
function OpenPlayerOptions(id, nick)
    local elegracza = {}
    if permissions.kick then
        table.insert(elegracza,{label='Kick',value='kick'})
    end
    if permissions.ban then
        table.insert(elegracza,{label='Ban',value='ban'})
    end
    if permissions.spectate then
        table.insert(elegracza,{label='Spectate',value='spectate'})
        table.insert(elegracza,{label='Wezwij Gracza',value='wezwij'})
    end
    if permissions.teleport then
        table.insert(elegracza,{label='Teleport do gracza',value='tpdogracza'})
        table.insert(elegracza,{label='Teleportuj gracza do mnie',value='tpgraczadomnie'})
    end
    if permissions.freeze then
        if freze[id] == nil then
            freze[id] = false 
        else
            freze[id] = freze[id]
        end
        table.insert(elegracza,{label='Unieruchom gracza '..(freze[id] and "<span style='color:green;'>ON</span>" or "<span style='color:red;'>OFF</span>"),value='freze'})
    end
    local id = tonumber(id)
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menu3', {
        title    = ('exADMIN | ['..id..'] '..nick),
        align    = 'bottom-right',
        elements = elegracza
    }, function(data4,menu4)
        if data4.current.value=='kick' then 
            OpenKickMenu(id,nick,'Nie określono przyczyny')
        elseif data4.current.value == 'spectate' then
            if drawInfo then
                NetworkSetInSpectatorMode(false, PlayerPedId())
                StopDrawPlayerInfo(function()
                    TriggerServerEvent('skam:exadmin:requestspectate', id)
                end)
            else
                TriggerServerEvent('skam:exadmin:requestspectate', id)
            end
        elseif data4.current.value == 'wezwij' then
            OpenWezwijMenu(id,nick,'Nie określono przyczyny')
        elseif data4.current.value=='tpdogracza' then
            TriggerServerEvent('skam:exadmin:teleport', id)
        elseif data4.current.value=='tpgraczadomnie' then
            local px,py,pz = table.unpack(GetEntityCoords(PlayerPedId(),true))
            TriggerServerEvent('skam:exadmin:teleportplayercoords', id, px,py,pz)
        elseif data4.current.value=='freze' then
            if freze[id] == nil then
                freze[id] = true 
            else
                freze[id] = not freze[id]
            end
            TriggerServerEvent('skam:exadmin:freezeplayer', id, freze[id])
            OpenPlayerOptions(id, nick)
        elseif data4.current.value=='ban' then 
            OpenBanMenu(id, nick, 'Nie określono przyczyny', 1, false)
        end
    end, function(data4, menu4) 
        menu4.close() 
    end)
end

local powodwezwij
OpenWezwijMenu = function(id, nick, powodwezwij)
    if powodwezwij == nil then
        powodwezwij = 'Nie określono przyczyny'
    end
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menu4', {
        title    = ('exADMIN | WEZWIJ ['..id..'] '..nick),
        align    = 'bottom-right',
        elements = {
            {label = 'Zmień powód wezwania: ' .. powodwezwij, value = 'powod'},
            {label = 'Wezwij', value = 'wystaw'},
        }
    }, function(data4, menu4)
        if data4.current.value == 'powod' then
            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'wezwanie_reason_dialog', {
                title = 'Wprowadź powód wezwania (maks. 60 znaków)'
            }, function(data, dialogMenu)
                if data.value then
                    powodwezwij = data.value
                else
                    powodwezwij = 'Nie określono przyczyny'
                end
                dialogMenu.close()
                OpenWezwijMenu(id, nick, powodwezwij)
            end, function(data, dialogMenu)
                dialogMenu.close()
            end)
        end
        if data4.current.value == 'wystaw' then
            TriggerServerEvent('skam:exadmin:wezwijgracza', id, powodwezwij)
            id, nick, powodwezwij = nil
            menu4.close()
        end
    end, function(data4, menu4)
        menu4.close() 
    end)
end

local powodkick
OpenKickMenu = function(id, nick, powodkick)
    if powodkick == nil then
        powodkick = 'Nie określono przyczyny'
    end
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menu4', {
        title    = ('exADMIN | KICK ['..id..'] '..nick),
        align    = 'bottom-right',
        elements = {
            {label = 'Zmień powód kicka: ' .. powodkick, value = 'powod'},
            {label = 'Wystaw Kicka', value = 'wystaw'},
        }
    }, function(data4, menu4)
        if data4.current.value == 'powod' then
            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'kick_reason_dialog', {
                title = 'Wprowadź powód kicka (maks. 60 znaków)'
            }, function(data, dialogMenu)
                if data.value then
                    powodkick = data.value
                else
                    powodkick = 'Nie określono przyczyny'
                end
                dialogMenu.close()
                OpenKickMenu(id, nick, powodkick)
            end, function(data, dialogMenu)
                dialogMenu.close()
            end)
        end
        if data4.current.value == 'wystaw' then
            TriggerServerEvent('skam:exadmin:kickplayer', id, powodkick)
            id, nick, powodkick = nil
            menu4.close()
        end
    end, function(data4, menu4)
        menu4.close() 
    end)
end

CreateThread(function()
	while true do
		Wait(0)
        if isAdmin then
            if drawInfo then
                local ply = GetPlayerFromServerId(drawTarget)
                local targetPed = GetPlayerPed(ply)
                local targetCoords = GetEntityCoords(targetPed, false)

                local playerId = PlayerId()
                local playerPed = PlayerPedId()
                local playerCoords = GetEntityCoords(playerPed, false)
                if #(targetCoords - playerCoords) > 250.0 then
                    if not drawCustom then
                        drawCustom = {
                            coords = playerCoords,
                            invisible = IsEntityVisible(playerPed)
                        }

                        drawCustom.coords = vec3(drawCustom.coords.x, drawCustom.coords.y, drawCustom.coords.z - 0.95)
                        if IsPedInAnyVehicle(playerPed, false) then
                            drawCustom.vehicle = VehToNet(GetVehiclePedIsIn(playerPed, false))
                        end

                        FreezeEntityPosition(playerPed, true)
                        if drawCustom.invisible then
                            SetEntityVisible(playerPed, false)
                        end
                    end

                    SetEntityCoords(playerPed, targetCoords.x, targetCoords.y, targetCoords.z - 10.0, 0, 0, GetEntityHeading(playerPed), false)
                end

                local text = {
                    string.format('Gracz: '..GetPlayerName(ply))
                }
                if GetPlayerInvincible(ply) then
                    table.insert(text, 'GD: ~y~Tak')
                else
                    table.insert(text, 'GD: ~r~Nie')
                end

                if not CanPedRagdoll(targetPed) and not IsPedInAnyVehicle(targetPed, false) and (GetPedParachuteState(targetPed) == -1 or GetPedParachuteState(targetPed) == 0) and not IsPedInParachuteFreeFall(targetPed) then
                    table.insert(text, 'Anty-Ragdol: ~y~Tak')
                end

                table.insert(text, 'Health: ' .. GetEntityHealth(targetPed) .. '/' .. GetEntityMaxHealth(targetPed))
                table.insert(text, 'Armor: ' .. GetPedArmour(targetPed))

                table.insert(text, '~w~Naciśnij ~g~E~w~, aby wyjść z trybu obserwatora')
                -- table.insert(text, '~w~Naciśnij ~g~M~w~, aby zobacz jego ekwipunek')

                for i,theText in pairs(text) do
                    SetTextFont(0)
                    SetTextProportional(1)
                    SetTextScale(0.0, 0.30)
                    SetTextDropshadow(0, 0, 0, 0, 255)
                    SetTextEdge(1, 0, 0, 0, 255)
                    SetTextDropShadow()
                    SetTextOutline()
                    SetTextEntry('STRING')
                    AddTextComponentString(theText)
                    EndTextCommandDisplayText(0.3, 0.7+(i/30))
                end
                if IsControlJustPressed(0,103) then
                    NetworkSetInSpectatorMode(false, playerPed)
                    StopDrawPlayerInfo(function()
                        Citizen.Wait(100)
                    end)
                    -- TriggerServerEvent('skam:triggerLog', 'Przestał spectować '..GetPlayerName(ply), 'exadmin')
                -- elseif IsControlJustPressed(0, 244) then
                --     OpenAdminActionMenu(drawTarget)
                end
            else 
                Wait(1000) 
            end
        else
            Wait(1000)
        end
	end
end)


CreateThread(function()
    buttons = setupScaleform('instructional_buttons')
	while true do
		if NoClip and permissions.noclip then
            DrawScaleformMovieFullscreen(buttons)
			local noclipEntity = PlayerPedId()
			if IsPedInAnyVehicle(noclipEntity, false) then
				local vehicle = GetVehiclePedIsIn(noclipEntity, false)
				if GetPedInVehicleSeat(vehicle, -1) == noclipEntity then
					noclipEntity = vehicle
				else
					noclipEntity = nil
				end
			end
			FreezeEntityPosition(noclipEntity, true)
			SetEntityInvincible(noclipEntity, true)
			DisableControlAction(0, 31, true)
			DisableControlAction(0, 30, true)
			DisableControlAction(0, 44, true)
			DisableControlAction(0, 38, true)
			DisableControlAction(0, 32, true)
			DisableControlAction(0, 33, true)
			DisableControlAction(0, 34, true)
			DisableControlAction(0, 35, true)
			local yoff = 0.0
			local zoff = 0.0
			if IsControlJustPressed(0, 21) then
				noClipSpeed = noClipSpeed + 1
				if noClipSpeed > 10 then
					noClipSpeed = 1
				end
                setupScaleform('instructional_buttons')
                ButtonMessage('Zmień prędkość ('..noClipSpeeds[noClipSpeed]..')')
			end
			if IsDisabledControlPressed(0, 32) then
				yoff = 0.25;
			end
			if IsDisabledControlPressed(0, 33) then
				yoff = -0.25;
			end
			if IsDisabledControlPressed(0, 34) then
				SetEntityHeading(PlayerPedId(), GetEntityHeading(PlayerPedId()) + 2.0)
			end
			if IsDisabledControlPressed(0, 35) then
				SetEntityHeading(PlayerPedId(), GetEntityHeading(PlayerPedId()) - 2.0)
			end
			if IsDisabledControlPressed(0, 44) then
				zoff = 0.1;
			end
			if IsDisabledControlPressed(0, 38) then
				zoff = -0.1;
			end
			local newPos = GetOffsetFromEntityInWorldCoords(noclipEntity, 0.0, yoff * (noClipSpeed + 0.3), zoff * (noClipSpeed + 0.3))
			local heading = GetEntityHeading(noclipEntity)
			SetEntityVelocity(noclipEntity, 0.0, 0.0, 0.0)
			SetEntityRotation(noclipEntity, 0.0, 0.0, 0.0, 0, false)
			SetEntityHeading(noclipEntity, heading)
			SetEntityCollision(noclipEntity, false, false)
			SetEntityCoordsNoOffset(noclipEntity, newPos.x, newPos.y, newPos.z, true, true, true)
			Citizen.Wait(0)
			FreezeEntityPosition(noclipEntity, false)
			SetEntityInvincible(noclipEntity, false)
			SetEntityCollision(noclipEntity, true, true)
		else
			Citizen.Wait(500)
		end
	end
end)
function ButtonMessage(text)
    BeginTextCommandScaleformString('STRING')
    AddTextComponentScaleform(text)
    EndTextCommandScaleformString()
end

function Button(ControlButton)
    ScaleformMovieMethodAddParamPlayerNameString(ControlButton)
end

function setupScaleform(scaleform)

    local scaleform = RequestScaleformMovie(scaleform)

    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(1)
    end

    PushScaleformMovieFunction(scaleform, 'CLEAR_ALL')
    PopScaleformMovieFunctionVoid()
    
    PushScaleformMovieFunction(scaleform, 'SET_CLEAR_SPACE')
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, 'SET_DATA_SLOT')
    PushScaleformMovieFunctionParameterInt(4)
    Button(GetControlInstructionalButton(0, 44, 0))
    ButtonMessage('W dół')
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, 'SET_DATA_SLOT')
    PushScaleformMovieFunctionParameterInt(3)
    Button(GetControlInstructionalButton(0, 38, 0))
    ButtonMessage('Do góry')
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, 'SET_DATA_SLOT')
    PushScaleformMovieFunctionParameterInt(2)
    Button(GetControlInstructionalButton(0, 30, 0))
    ButtonMessage('W lewo/prawo')
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, 'SET_DATA_SLOT')
    PushScaleformMovieFunctionParameterInt(1)
    Button(GetControlInstructionalButton(0, 31, 0))
    ButtonMessage('Do przodu/tyłu')
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, 'SET_DATA_SLOT')
    PushScaleformMovieFunctionParameterInt(0)
    Button(GetControlInstructionalButton(0, 21, 0))
    ButtonMessage('Zmień prędkość ('..noClipSpeeds[noClipSpeed]..')')
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, 'DRAW_INSTRUCTIONAL_BUTTONS')
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, 'SET_BACKGROUND_COLOUR')
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(80)
    PopScaleformMovieFunctionVoid()

    return scaleform
end

RegisterNetEvent('skam:exadmin:teleportclient')
AddEventHandler('skam:exadmin:teleportclient', function(coords)
	SetEntityCoords(PlayerPedId(), coords, 0, 0, 0, false)
end)