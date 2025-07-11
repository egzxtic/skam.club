ExecuteCommand("add_ace group.bypassPermGroup command allow")
ExecuteCommand("add_principal resource." .. GetCurrentResourceName() .. " group.bypassPermGroup")

local permissionsGroups = { 
    owner = {
        --[[ AdminMenu ]]  --
        "AdminMenuAccess",
        "AnnouncementAccess",
        "ESPAccess",
        "ClearEntitiesAccess",
        "BanAndKickAccess",
        "GotoAndBringAccess",
        "VehicleAccess",
        "MiscAccess",
        "LogsAccess",
        "PlayerSelectorAccess",
        "BanListAndUnbanAccess",
        "ModelChangerAccess",
        --[[ Client ]] --
        "BypassSpectate",
        "BypassGodMode",
        "BypassInvisible",
        "BypassStealOutfit",
        "BypassInfStamina",
        "BypassNoclip",
        "BypassSuperJump",
        "BypassFreecam",
        "BypassSpeedHack",
        "BypassTeleport",
        "BypassNightVision",
        "BypassThermalVision",
        "BypassOCR",
        "BypassNuiDevtools",
        "BypassBlacklistedTextures",
        "BlipsBypass",
        "BypassCbScanner",
        --[[ Weapon ]] --
        "BypassWeaponDmgModifier",
        "BypassInfAmmo",
        "BypassNoReload",
        "BypassRapidFire",
        --[[ Vehicle ]] --
        "BypassVehicleFixAndGodMode",
        "BypassVehicleHandlingEdit",
        "BypassVehicleModifier",
        "BypassBulletproofTires",
        --[[ Blacklist ]] --
        "BypassModelChanger",
        "BypassWeaponBlacklist",
        --[[ Misc ]] --
        "FGCommands",
        "BypassVPN",
        "BypassExplosion",
        "BypassClearTasks",
        "BypassParticle"
    },
    ceo = {
        "BypassNoclip",
        "BypassSpectate"
    },
    txmanager = {
        "BypassNoclip",
        "BypassSpectate"
    },
    developer = {
        "BypassNoclip",
        "BypassSpectate"
    },
    managment = {
        "BypassNoclip",
        "BypassSpectate"
    },
    mediamanagment = {
        "BypassNoclip",
        "BypassSpectate"
    },
    opiekunadm = {
        "BypassNoclip",
        "BypassSpectate"
    },
    eventmanger = {
        "BypassNoclip",
        "BypassSpectate"
    },
    prezeszarzadu = {
        "BypassNoclip",
        "BypassSpectate"
    },
    zarzad = {
        "BypassNoclip",
        "BypassSpectate"
    },
    headadmin = {
        "BypassNoclip",
        "BypassSpectate"
    },
	admin = {
        "BypassNoclip",
        "BypassSpectate"
    },
    smod = {
        "BypassNoclip",
        "BypassSpectate"
    },
	mod = {
        "BypassNoclip",
        "BypassSpectate"
    },
    support = {
        "BypassSpectate"
    },
	trialsupport = {
        "BypassSpectate"
    },
}

for groupName, permissionsObject in pairs(permissionsGroups) do
    for _, permissionValue in ipairs(permissionsObject) do
        ExecuteCommand("add_ace group." .. groupName .. "_FgGroup " .. permissionValue .. " allow")
    end
end

AddEventHandler("add_principal", function(playerId, group)
    ExecuteCommand("add_principal identifier." .. GetPlayerIdentifier(playerId, 0) .. " group." .. group .. "_FGGroup")
end)

AddEventHandler('txAdmin:events:scheduledRestart', function(eventData)
    local message = nil

    if eventData.secondsRemaining == 300 then
        message = 'Serwer zostanie zrestartowany za 5 minut!'
    elseif eventData.secondsRemaining == 180 then
        message = 'Serwer zostanie zrestartowany za 3 minuty!'
    elseif eventData.secondsRemaining == 60 then
        message = '**Serwer dostępny po restarcie!** - `connect play.skam.club`'
    end

    if message then
        TriggerClientEvent('skam:txNotify', -1, message)
        PerformHttpRequest(channels['restart'], function(err, text, headers)
        end, 'POST', json.encode({
            username = logData.username,
            avatar_url = logData.image,
            content = message
        }), { ['Content-Type'] = 'application/json' })
    end
end)