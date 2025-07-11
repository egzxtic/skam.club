local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local currentProp = nil
local timer = GetGameTimer()
local isBinding = false

function startAnim(libr, anim, loop, propTable)

	local ped = PlayerPedId()

	if exports['skam']:isPedAble(ped) then
		SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)

		if propTable then
			if currentProp then
				DeleteEntity(currentProp)
				currentProp = nil
			end
			currentProp = CreateObject(propTable.name, GetEntityCoords(ped), true)
			AttachEntityToEntity(currentProp, ped, GetPedBoneIndex(ped, propTable.bone), propTable.xPos, propTable.yPos, propTable.zPos, tonumber(propTable.xRot), tonumber(propTable.yRot), tonumber(propTable.zRot), true, propTable.useSoftPinning, propTable.collision, propTable.isPed, propTable.rotationOrder, propTable.fixedRot)
		end

		ESX.Streaming.RequestAnimDict(libr, function()
			TaskPlayAnim(ped, libr, anim, 8.0, -8.0, -1, loop, 1, false, false, false)
			RemoveAnimDict(libr)
		end)
	end
end

exports('startAnim', startAnim)

function chooseAnim(animTable, propTable, animType)
	if animType == 'scenario' then
		startScenario(animTable.anim)
	elseif animType == 'attitude' then
		startAttitude(animTable.lib, animTable.anim)
	elseif animType == 'faceExpression' then
		startFaceExpression(animTable.anim)
	elseif animType == 'anim' then
		startAnim(animTable.lib, animTable.anim, animTable.loop, propTable)
	end
end

function playAnim(anim)
	for i=1, #Anims['anims'].Animations, 1 do
		for j=1, #Anims['anims'].Animations[i].items, 1 do
			if Anims['anims'].Animations[i].items[j].data.e == anim then
				local item = Anims['anims'].Animations[i].items[j]
				chooseAnim(item.data, item.prop, item.type)
				break
			end
		end
	end
end

function cancelAnim()
    local ped = PlayerPedId()
    ClearPedTasks(ped)
    if currentProp then
        DeleteEntity(currentProp)
        currentProp = nil
    end
end

CreateThread(function()
    while true do
        Wait(0)
        if IsControlJustReleased(0, 73) and not IsControlPressed(0, 25) then
            cancelAnim()
        end
    end
end)

function startAttitude(lib, anim)
	ESX.Streaming.RequestAnimSet(lib, function()
		SetPedMovementClipset(PlayerPedId(), anim, true)
	end)
end

function startScenario(anim)
	SetCurrentPedWeapon(PlayerPedId(), `WEAPON_UNARMED`, true)
	TaskStartScenarioInPlace(PlayerPedId(), anim, 0, false)
end

function startFaceExpression(anim)
	SetFacialIdleAnimOverride(PlayerPedId(), anim)
end

function OpenAnimationsMenu(showAnimations, useBinding)
	local elements = {}
	local title = 'Animacje'

	if not useBinding then
		if showAnimations then
			ESX.UI.Menu.CloseAll()
			for i=1, #Anims['anims'].Animations, 1 do
				elements[#elements+1] = {label = Anims['anims'].Animations[i].label, value = Anims['anims'].Animations[i].name}
			end
			title = 'Kategorie'
		else
			elements[#elements+1] = { label = "Wybierz animacje", value = "animations" }
			elements[#elements+1] = { label = "Przypisz animacje", value = "bind" }
			elements[#elements+1] = { label = "Lista przypisanych animacji", value = "binds" }
			elements[#elements+1] = { label = "Wspólne animacje", value = "synced" }
		end
	else
		for i=1, #Anims['anims'].Animations, 1 do
			elements[#elements+1] = {label = Anims['anims'].Animations[i].label, value = Anims['anims'].Animations[i].name}
		end
		title = 'Bindy'
	end
	
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), (useBinding and "animations_2") or 'animations', {
		title    = title,
		align    = 'right',
		elements = elements
	}, function(data, menu)
		if data.current.value then
			if data.current.value == "bind" then
				OpenAnimationsMenu(false, true)
			elseif data.current.value == "synced" then
				OpenSyncedMenu()
			elseif data.current.value == "binds" then
				OpenBindsMenu()
			elseif data.current.value == "animations" then
				OpenAnimationsMenu(true, false)
			else		
				OpenAnimationsSubMenu(data.current.value, useBinding)			
			end
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenAnimationsSubMenu(menu, binding)
	local elements, title = {}, ""

	for i=1, #Anims['anims'].Animations, 1 do
		if Anims['anims'].Animations[i].name == menu then
			title = Anims['anims'].Animations[i].label

			for j=1, #Anims['anims'].Animations[i].items, 1 do
				if Anims['anims'].Animations[i].items[j].data.e ~= nil and tostring(Anims['anims'].Animations[i].items[j].data.e) ~= "" then
					elements[#elements+1] = {
						label = Anims['anims'].Animations[i].items[j].label .. ' <span style="color: #20cc02; text-transform: none">'..tostring(Anims['anims'].Animations[i].items[j].data.e)..'</span>',
						type  = Anims['anims'].Animations[i].items[j].type,
						value = Anims['anims'].Animations[i].items[j].data,
						bind = Anims['anims'].Animations[i].items[j].data.e
					}
				else
					elements[#elements+1] = {
						label = Anims['anims'].Animations[i].items[j].label,
						type  = Anims['anims'].Animations[i].items[j].type,
						value = Anims['anims'].Animations[i].items[j].data,
						prop = Anims['anims'].Animations[i].items[j].prop
					}
				end
			end

			break
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), (useBinding and "animations_sub_2") or 'animations_sub', {
		title = title,
		align = 'right',
		elements = elements
	}, function(data, menu)
		if binding then
			ESX.ShowNotification("Za chwilę rozpocznie się nasłuchiwanie klawisza (BACKSPACE/ESC = Anulowanie)", "info")
			Wait(1500)
			isBinding = true
			ESX.ShowNotification("Trwa nasłuchiwanie klawisza...", "info")
			while isBinding do
				if IsControlJustPressed(0, 202) then
					ESX.ShowNotification("Anulowano bindowanie", "info")
					isBinding = false
					break
				end

				for keyName,keyId in pairs(Keys) do
					if IsControlJustPressed(0, keyId) then
						menu.close()
						BindKey(keyName:upper(), data.current.bind)
						isBinding = false				
						return
					end
				end

				Wait(0)
			end
		else
			local animTable = data.current.value
			local animPropTable = data.current.prop
			local animType = data.current.type

			chooseAnim(animTable, animPropTable, animType)
		end
	end, function(data, menu)
		menu.close()
	end)
end

----------- [[
-- Binding
----------- ]]
Bindings = {}

RegisterNUICallback("setBinding", function(data)
	if data.binding then
		for key, anim in pairs(data.binding) do
			local remove = SKAM.RegisterButton(key, function()
				playAnim(anim)
			end)

			Bindings[key] = {anim = (type(anim) == "string" and anim or anim.anim), remove = remove}
		end
	end
end)

function OpenBindsMenu()
	local elements = {}
	local bindCount = 0

	for k, v in pairs(Bindings) do
		bindCount += 1
	end

	if bindCount > 0 then
		elements[#elements+1] = {label = "======= Usuń wszystkie =======", value = "ALL"}
		for key, data in pairs(Bindings) do
			elements[#elements+1] = {label = ("%s - /e %s"):format(key, data.anim), value = key}
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'bind_delter', {
			title = 'Aktualne bindy',
			align = 'right',
			elements = elements
		}, function(data, menu)
			menu.close()

			if data.current.value ~= "ALL" then
				ESX.ShowNotification(("Pomyślnie usunięto powiązanie [%s] z /e %s"):format(data.current.value, Bindings[data.current.value]), 'success')

				Bindings[data.current.value].remove()
				Bindings[data.current.value] = nil

				SendNUIMessage({
					action = 'animations',
					key = 'binding',
					data = json.encode(Bindings)
				})

				Wait(200)
				OpenBindsMenu()
			else
				for key, data2 in pairs(Bindings) do
					data2.remove()
				end

				SendNUIMessage({
					action = 'animations',
					key = 'binding',
					data = json.encode(Bindings)
				})

				menu.close()
			end
		end, function(data, menu)
			menu.close()
		end)
	else
		ESX.ShowNotification('Nie posiadasz przypisanych animacji', 'error')
	end
end

function BindKey(key, anim)
	if not Bindings[key:upper()] then
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'bind_check', {
			title = 'Potwierdź przypisanie '..key..' do /e '..anim..'.',
			align = 'right',
			elements = { { label = "Tak", check = true }, { label = "Nie" } }
		}, function(data, menu)
			menu.close()

			if data.current.check then
				local remove = SKAM.RegisterButton(key, function()
					playAnim(anim)
				end)

				Bindings[key] = {anim = anim, remove = remove}
				SendNUIMessage({
					action = 'animations',
					key = 'binding',
					data = json.encode(Bindings)
				})
				ESX.ShowNotification(("Pomyślnie powiązano [%s] z /e %s"):format(key:upper(), anim:lower()), "success")
			end
		end, function(data, menu)
			menu.close()
		end)
	else
		ESX.ShowNotification("Ten klawisz jest już zajęty", "error")
	end
end

-- SYNCED

function OpenSyncedMenu()
	local elements2 = {}

	for k, v in pairs(Anims['anims'].Synced) do
		elements2[#elements2+1] = {label = v['Label'], id = k}
	end
            
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'play_synced',
	{
		title = 'Wspólne animacje',
		align = 'right',
		elements = elements2
	}, function(data2, menu2)
		local allowed = false
		if Anims['anims'].Synced[data2.current.id]['Car'] then
			if IsPedInAnyVehicle(PlayerPedId(), false) then
				allowed = true
			else
				ESX.ShowNotification('Nie jesteś w pojeździe', 'error')
			end
		else
			allowed = true
		end
		if allowed then
			if timer < GetGameTimer() then
				local player = ESX.UI.ChoosePlayerMenu()
				if player then
					TriggerServerEvent('skam-anims:requestSynced', player, data2.current.id)
					timer = GetGameTimer() + 10000
				end
			else
				ESX.ShowNotification('Poczekaj chwilę przed następną propozycją wspólnej animacji', 'error')
			end
		end
	end, function(data2, menu2)
		menu2.close()
	end)
end

RegisterNetEvent('skam-anims:syncRequest', function(requester, id)
    local accepted = false

	local elements = {}

	elements[#elements+1] = { label = "Zaakceptuj", value = true }
	elements[#elements+1] = { label = "Odrzuć", value = false }

	CreateThread(function()
		local resetmenu = false
		local menu = ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'synced_animation_request', {
			title = 'Propozycja animacji '..Anims['anims'].Synced[id]['Label']..' od '..requester,
			align = 'center',
			elements = {
				{ label = '<span style="color: lightgreen">Zaakceptuj</span>', value = true },
				{ label = '<span style="color: lightcoral">Odrzuć</span>', value = false },
			}
		}, function(data, menu)
			menu.close()
			if data.current.value then
				resetmenu = true
				TriggerServerEvent('skam-anims:syncAccepted', requester, id)
			else
				resetmenu = true
				TriggerServerEvent('skam-anims:cancelSync', requester)
				ESX.ShowNotification('Odrzuciłeś/aś propozycję wspólnej animacji', 'info')
			end
		end, function(data, menu)
			resetmenu = true
			menu.close()
			TriggerServerEvent('skam-anims:cancelSync', requester)
			ESX.ShowNotification('Odrzuciłeś/aś propozycję wspólnej animacji', 'info')
		end)
		Wait(5000)
		if not resetmenu then
			menu.close()
			TriggerServerEvent('skam-anims:cancelSync', requester)
			ESX.ShowNotification('Propozycja wspólnej animacji wygasła', 'info')
		end
	end)
end)

RegisterNetEvent('skam-anims:playSynced', function(serverid, id, type)
    local anim = Anims['anims'].Synced[id][type]

    local target = GetPlayerPed(GetPlayerFromServerId(serverid))
    if anim['Attach'] then
        local attach = anim['Attach']
        AttachEntityToEntity(PlayerPedId(), target, attach['Bone'], attach['xP'], attach['yP'], attach['zP'], attach['xR'], attach['yR'], attach['zR'], 0, 0, 0, 0, 2, 1)
    end

    Wait(750)

    if anim['Type'] == 'animation' then
		ESX.Streaming.RequestAnimDict(anim['Dict'], function()
			TaskPlayAnim(PlayerPedId(), anim['Dict'], anim['Anim'], 8.0, -8.0, -1, anim['Flags'] or 0, 1, false, false, false)
			RemoveAnimDict(anim['Dict'])
		end)
    end

    if type == 'Requester' then
        anim = Anims['anims'].Synced[id]['Accepter']
    else
        anim = Anims['anims'].Synced[id]['Requester']
    end

    while not IsEntityPlayingAnim(target, anim['Dict'], anim['Anim'], 3) do
        Wait(0)
        SetEntityNoCollisionEntity(PlayerPedId(), target, true)
    end

    DetachEntity(PlayerPedId())

    while IsEntityPlayingAnim(target, anim['Dict'], anim['Anim'], 3) do
        Wait(0)
        SetEntityNoCollisionEntity(PlayerPedId(), target, true)
    end

    ClearPedTasks(PlayerPedId())
end)

CreateThread(function()
	for i=1, #Anims['anims'].Animations, 1 do
		for j=1, #Anims['anims'].Animations[i].items, 1 do
			if Anims['anims'].Animations[i].items[j].data.e ~= "" then
				TriggerEvent('chat:addSuggestion', 'e '..Anims['anims'].Animations[i].items[j].data.e, Anims['anims'].Animations[i].items[j].label)
			end
		end
	end
end)

RegisterCommand('e', function(source, args)
	if not LocalPlayer.state.dead then
		playAnim(args[1])
	end
end)

RegisterCommand('animacje', function()
	if not LocalPlayer.state.dead then
		OpenAnimationsMenu()
	end
end)

RegisterKeyMapping('animacje', 'Otwórz menu animacji', 'keyboard', 'F3')