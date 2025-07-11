local WeaponsConfig = {
    Weapons = {
        ["advancedrifle"] = `WEAPON_ADVANCEDRIFLE`,
        ["assaultrifle"] = `WEAPON_ASSAULTRIFLE`,
        ["bat"] = `WEAPON_BAT`,
        ["bottle_weapon"] = `WEAPON_BOTTLE`,
        ["carbinerifle"] = `WEAPON_CARBINERIFLE`,
        ["ceramicpistol"] = `WEAPON_CERAMICPISTOL`,
        ["combatpdw"] = `WEAPON_COMBATPDW`,
        ["combatpistol"] = `WEAPON_COMBATPISTOL`,
        ["compactrifle"] = `WEAPON_COMPACTRIFLE`,
		["pumpshotgun"] = `WEAPON_PUMPSHOTGUN`,
        ["crowbar"] = `WEAPON_CROWBAR`,
        ["doubleaction"] = `WEAPON_DOUBLEACTION`,
        ["flare"] = `WEAPON_FLARE`,
        ["flaregun"] = `WEAPON_FLAREGUN`,
        ["flashlight_weapon"] = `WEAPON_FLASHLIGHT`,
        ["golfclub"] = `WEAPON_GOLFCLUB`,
        ["gusenberg"] = `WEAPON_GUSENBERG`,
        ["hammer"] = `WEAPON_HAMMER`,
        ["hatchet"] = `WEAPON_HATCHET`,
        ["heavypistol"] = `WEAPON_HEAVYPISTOL`,
        ["heavysniper"] = `WEAPON_HEAVYSNIPER`,
        ["knife"] = `WEAPON_KNIFE`,
        ["knuckle"] = `WEAPON_KNUCKLE`,
        ["machete"] = `WEAPON_MACHETE`,
        ["microsmg"] = `WEAPON_MICROSMG`,
		["minismg"] = `WEAPON_MINISMG`,
        ["musket"] = `WEAPON_MUSKET`,
        ["nightstick"] = `WEAPON_NIGHTSTICK`,
        ["pistol"] = `WEAPON_PISTOL`,
        ["pistol_mk2"] = `WEAPON_PISTOL_MK2`,
        ["poolcue"] = `WEAPON_POOLCUE`,
        ["railgun"] = `WEAPON_RAILGUN`,
        ["smg"] = `WEAPON_SMG`,
        ["smg_mk2"] = `WEAPON_SMG_MK2`,
        ["sniperrifle"] = `WEAPON_SNIPERRIFLE`,
        ["snspistol"] = `WEAPON_SNSPISTOL`,
        ["snspistol_mk2"] = `WEAPON_SNSPISTOL_MK2`,
        ["stungun"] = `WEAPON_STUNGUN`,
        ["switchblade"] = `WEAPON_SWITCHBLADE`,
        ["vintagepistol"] = `WEAPON_VINTAGEPISTOL`,
		["custom-m9"] = `WEAPON_M9`,
		["custom-glock20"] = `WEAPON_GLOCK20`,
		["custom-beretta"] = `WEAPON_BERETTA`,
        ["wrench"] = `WEAPON_WRENCH`,
        ["specialcarbine"] = `WEAPON_SPECIALCARBINE`,
        ["bullpuprifle_mk2"] = `WEAPON_BULLPUPRIFLE_MK2`,
        ["molotov"] = `WEAPON_MOLOTOV`,
        ["stickybomb"] = `WEAPON_STICKYBOMB`
    },
    AmmoTypes = {
        [`AMMO_PISTOL`] = 'pistol_ammo',
        [`AMMO_FLARE`] = 'flare_ammo',
        [`AMMO_RIFLE`] = 'rifle_ammo',
        [`AMMO_SMG`] = 'smg_ammo',
        [`AMMO_MG`] = 'smg_ammo',
        [`AMMO_SHOTGUN`] = 'shotgun_ammo',
        [`AMMO_SNIPER`] = 'sniper_ammo',
        [`AMMO_MOLOTOV`] = 'molotov',
        [`AMMO_STICKYBOMB`] = 'stickybomb',
    }
}

local PlayerInventory = nil
local ForceOverride = false

local lastWeaponHash = nil
local lastWeaponAmmoItem = nil

AddEventHandler('CEventGunShotWhizzedBy', function(entities, eventEntity, args)
    if PlayerPedId() ~= eventEntity then
        return
    end

	if lastWeaponAmmoItem then
		TriggerServerEvent('esx_weaponsync:removeAmmo', lastWeaponAmmoItem, 1)
	end
end)

local function IsItemAWeapon(item)
	return WeaponsConfig.Weapons[item] ~= nil
end

local function GetWeaponHashFromItem(item)
	return WeaponsConfig.Weapons[item]
end

local function GetInventoryItemCount(name)
	if PlayerInventory and type(PlayerInventory) == "table" then
		for i=1, #PlayerInventory, 1 do
			if PlayerInventory[i].name == name then
				return PlayerInventory[i].count
			end
		end
	end

	return nil
end

local function GetAmmoTypeFromItem(name)
	for ammoType, ammoItem in pairs(WeaponsConfig.AmmoTypes) do
		if ammoItem == name then
			return ammoType
		end
	end

	return nil
end

local function RefreshLoadout()
	if PlayerInventory and type(PlayerInventory) == "table" then
		local playerPed = PlayerPedId()

		RemoveAllPedWeapons(playerPed, false)

		for itemName, weaponHash in pairs(WeaponsConfig.Weapons) do
			local itemCount = GetInventoryItemCount(itemName)

			if itemCount and itemCount > 0 then
				GiveWeaponToPed(playerPed, weaponHash, 0, false, false)
			end
		end
	end
end

local function RefreshPedAmmoByItem(name, type)
	if not type then
		type = GetAmmoTypeFromItem(name)
	end

	local ammo = GetInventoryItemCount(name)

	if ammo then
		SetPedAmmoByType(PlayerPedId(), type, ammo)
	end
end

local function RefreshAllPedAmmo()
	if PlayerInventory and type(PlayerInventory) == "table" then
		for i=1, #PlayerInventory, 1 do
			local ammoType = GetAmmoTypeFromItem(PlayerInventory[i].name)

			if ammoType then
				RefreshPedAmmoByItem(PlayerInventory[i].name, ammoType)
			end
		end
	end
end

CreateThread(function()
	while true do
		local playerPed = PlayerPedId()
		local sleep = 1000

		if IsPedArmed(playerPed, 4) or IsPedArmed(playerPed, 2) then
			local weaponHash = GetSelectedPedWeapon(playerPed)

			if weaponHash ~= `WEAPON_UNARMED` then
				if ForceOverride or (lastWeaponHash ~= weaponHash) then
					local ammoType = GetPedAmmoTypeFromWeapon(playerPed, weaponHash)
					local ammoItem = WeaponsConfig.AmmoTypes[ammoType]
					local ammo = GetInventoryItemCount(ammoItem)

					if ammo then
						if ammoItem == `flaregun` then
							ammo = 25
						end

						SetPedAmmo(playerPed, weaponHash, ammo)
					end

					lastWeaponHash = weaponHash
					lastWeaponAmmoItem = ammoItem

					if ForceOverride then
						ForceOverride = false
					end
				end
			end
			sleep = 0
		else
			if lastWeaponHash then
				lastWeaponHash = nil
				lastWeaponAmmoItem = nil
			end
			sleep = 1000
		end
		Wait(sleep)
	end
end)

RegisterNetEvent('esx:addInventoryItem', function(item)
	Wait(1)

	local playerPed = PlayerPedId()
	PlayerInventory = ESX.GetPlayerData("inventory")

	if IsItemAWeapon(item) then
		local weaponHash = GetWeaponHashFromItem(item)

		if not HasPedGotWeapon(playerPed, weaponHash, false) then
			GiveWeaponToPed(playerPed, weaponHash, 0, false, false)

			local ammoType = GetPedAmmoTypeFromWeapon(playerPed, weaponHash)
			if ammoType then
				local ammoItem = WeaponsConfig.AmmoTypes[ammoType]

				if ammoType then
					RefreshPedAmmoByItem(ammoItem, ammoType)
				end
			end
		end
	else
		if not IsPedArmed(playerPed, 4) and not IsPedArmed(playerPed, 2) then
			RefreshPedAmmoByItem(item)
		else
			local weaponHash = GetSelectedPedWeapon(playerPed)
			local weaponAmmoType = GetPedAmmoTypeFromWeapon(playerPed, weaponHash)
			local ammoType = GetAmmoTypeFromItem(item)

			if weaponAmmoType ~= ammoType then
				RefreshPedAmmoByItem(item, ammoType)
			else
				ForceOverride = true
			end
		end
	end
end)

RegisterNetEvent('esx:removeInventoryItem', function(item)
	Wait(1)

	local playerPed = PlayerPedId()
	PlayerInventory = ESX.GetPlayerData("inventory")

	if IsItemAWeapon(item) then
		if GetInventoryItemCount(item) == 0 then
			local weaponHash = GetWeaponHashFromItem(item)

			if HasPedGotWeapon(playerPed, weaponHash, false) then
				RemoveWeaponFromPed(playerPed, weaponHash)
			end
		end
	else
		if not IsPedArmed(playerPed, 4) and not IsPedArmed(playerPed, 2) then
			RefreshPedAmmoByItem(item)
		else
			local weaponHash = GetSelectedPedWeapon(playerPed)
			local weaponAmmoType = GetPedAmmoTypeFromWeapon(playerPed, weaponHash)
			local ammoType = GetAmmoTypeFromItem(item)

			if weaponAmmoType ~= ammoType then
				RefreshPedAmmoByItem(item, ammoType)
			elseif weaponAmmoType == ammoType and not IsControlPressed(0, 24) then
				ForceOverride = true
			end
		end
	end
end)

RegisterNetEvent('esx:playerLoaded', function(PlayerData)
	PlayerInventory = PlayerData.inventory
end)

AddEventHandler('esx:onPlayerSpawn', function()
	RefreshLoadout()
	RefreshAllPedAmmo()
end)

AddEventHandler('skinchanger:modelLoaded', function()
	RefreshLoadout()
	RefreshAllPedAmmo()
end)

RegisterNetEvent('reload:weaponsync')
AddEventHandler('reload:weaponsync', function()
    RefreshLoadout()
	RefreshAllPedAmmo()
end)