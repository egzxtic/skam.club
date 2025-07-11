local playerGroups = {
    ['user'] = {name = "GRACZ", color = {255, 255, 255}},
    -- ['vip'] = {name = "VIP", color = {229, 198, 44}},
    ['hounds'] = {name = "HOUNDS", color = {20, 20, 20}},
    ['revivator'] = {name = "REVIVATOR", color = {100, 150, 200}},
    ['trialsupport'] = {name = "TRIAL SUPPORT", color = {50, 100, 30}},
    ['support'] = {name = "SUPPORT", color = {100, 200, 50}},
    ['mod'] = {name = "MODERATOR", color = {50, 100, 200}},
    ['smod'] = {name = "SENIOR MODERATOR", color = {4, 32, 158}},
    ['admin'] = {name = "ADMIN", color = {150, 20, 20}},
    ['headadmin'] = {name = "HEAD ADMIN", color = {255, 50, 50}},
    ['zarzad'] = {name = "ZARZAD", color = {135, 153, 174}},
    ['prezeszarzadu'] = {name = "PREZES ZARZADU", color = {65, 63, 63}},
    ['eventmanager'] = {name = "EVENT MANAGER", color = {212, 132, 61}},
    ['opiekunadm'] = {name = "OPIEKUN ADMINISTRACJI", color = {130, 107, 194}},
    ['mediamanagment'] = {name = "MEDIA MANAGMENT", color = {200, 100, 150}},
    ['managment'] = {name = "MANAGMENT", color = {76, 173, 208}},
    ['developer'] = {name = "DEVELOPER", color = {230, 50, 107}},
    ['txmanager'] = {name = "TX MANAGER", color = {250, 232, 8}},
    ['ceo'] = {name = "CEO", color = {50, 200, 100}},
    ['owner'] = {name = "OWNER", color = {10, 10, 10}},
}

local MVMNT = {
    tags = {
        ['1afd07ca908acc7b89aa4f49861752a4b58806ba'] = { name = 'egzxtic', color = {0, 0, 0} },
        ['79671ec3d420f08e1a9bd5aeebcfaddf924822e3'] = { name = 'KICIA KOCIA', color = {252, 158, 239} },
    },
    store = {
        player = {},
        dict = 'amb@world_human_clipboard@male@idle_a',
        anim = 'idle_a'
    },
    cache = {
        players = {},
        using = {},
        toggled = false
    },
    func = {}
}

RegisterNetEvent('skam$zetka:update')
AddEventHandler('skam$zetka:update', function(data)
    if data then
        orgLabel = data.job or "GRLZ"
        groupName = playerGroups[data.group] and playerGroups[data.group].name or "GRACZ"
        groupColor = playerGroups[data.group] and playerGroups[data.group].color or {255,255,255}
        myId = data.id or GetPlayerServerId(PlayerId())
        myIdentifier = data.identifier or nil
        playerCount = data.players or 0
        adminCount = data.admins or 0
        policeCount = data.police or 0

        SendNUIMessage({
            type = "nui:scoreboard:update",
            admins = adminCount,
            police = policeCount,
            players = playerCount,
            job = orgLabel
        })
    end
end)

exports('getPlayerCount', function()
    return playerCount or 0
end)

MVMNT.func.canUseAnim = function(ped)
    if not LocalPlayer.state.dead and
    not IsPedInAnyVehicle(ped, false) and
    not IsPedFalling(ped) and
    not IsPedCuffed(ped) and
    not IsPedDiving(ped) and
    not IsPedInCover(ped, false) and
    not IsPedInParachuteFreeFall(ped) and
    GetPedParachuteState(ped) < 1 then
        return true
    else
        return false
    end
end

MVMNT.func.globalThread = function(switch)
    local ped = PlayerPedId()
    MVMNT.store.player.ped = ped
    MVMNT.store.player.coords = GetEntityCoords(ped)
    MVMNT.store.player.admin = LocalPlayer.state.admin or false
    MVMNT.cache.toggled = switch
    MVMNT.func.spawnProp()
    if MVMNT.cache.toggled then
        MVMNT.func.scrapingThread()
        MVMNT.func.displayThread()
    end
end

MVMNT.func.spawnProp = function()
    TriggerServerEvent('skam$zetka:toggle', MVMNT.cache.toggled)
    if MVMNT.store.player.admin then return end
    if MVMNT.cache.toggled then
        if MVMNT.func.canUseAnim(MVMNT.store.player.ped) then
            MVMNT.cache.prop = CreateObject(`p_cs_clipboard`, MVMNT.store.player.coords, false)
            ESX.Streaming.RequestAnimDict(MVMNT.store.dict, function()
                TaskPlayAnim(MVMNT.store.player.ped, MVMNT.store.dict, MVMNT.store.anim, 8.0, -8.0, -1, 1, 0.0, false, false, false)
                AttachEntityToEntity(MVMNT.cache.prop, MVMNT.store.player.ped, GetPedBoneIndex(MVMNT.store.player.ped, 36029), 0.1, 0.015, 0.12, 45.0, -130.0, 180.0, true, false, false, false, 0, true)
                RemoveAnimDict(MVMNT.store.dict)
            end)
        end
    else
        ClearPedTasks(MVMNT.store.player.ped)
        StopAnimTask(MVMNT.store.player.ped, MVMNT.store.dict, MVMNT.store.anim, 1.0)
        if DoesEntityExist(MVMNT.cache.prop) then
            DeleteEntity(MVMNT.cache.prop)
        end
    end
end

MVMNT.func.scrapingThread = function()
    CreateThread(function()
        while MVMNT.cache.toggled do
            MVMNT.store.player.coords = GetEntityCoords(PlayerPedId())
            for _,v in ipairs(GetActivePlayers()) do
                local ped = GetPlayerPed(v)
                local coords = GetEntityCoords(ped)
                local dist = #(MVMNT.store.player.coords - coords)
                if dist < (MVMNT.store.player.admin and 60 or 40) then
                    MVMNT.cache.players[v] = {
                        id = GetPlayerServerId(v),
                        ped = ped,
                        group = Player(GetPlayerServerId(v)).state.group,
                        identifier = Player(GetPlayerServerId(v)).state.identifier
                    }
                else
                    MVMNT.cache.players[v] = nil
                end
            end
            Wait(500)
            if not MVMNT.store.player.admin and (not IsEntityPlayingAnim(MVMNT.store.player.ped, MVMNT.store.dict, MVMNT.store.anim, 1) and MVMNT.func.canUseAnim(MVMNT.store.player.ped)) then
                MVMNT.func.globalThread(false)
                break
            end
        end
    end)
end

MVMNT.func.canSee = function(ped)
    return MVMNT.store.player.admin or IsEntityVisible(ped) == 1
end

MVMNT.func.drawText = function(text, coords, color, add, scale)
    if not color then color = {255, 255, 255} end
    add = add or 1.0
    scale = scale or 1.0
    local onScreen, _x, _y = GetScreenCoordFromWorldCoord(coords.x, coords.y, coords.z + add)
    local camCoords = GetFinalRenderedCamCoord()
    local dist = #(camCoords - coords)
    local fov = (1 / GetGameplayCamFov()) * 100
    local drawScale = (1 / dist) * scale * fov
    if onScreen then
        SetTextScale(1.0 * drawScale, 1.55 * drawScale)
        SetTextFont(0)
        SetTextColour(color[1], color[2], color[3], 255)
        SetTextDropshadow(0, 0, 5, 0, 255)
        SetTextDropShadow()
        SetTextOutline()
        SetTextCentre(1)
        BeginTextCommandDisplayText('STRING')
        AddTextComponentSubstringPlayerName(tostring(text))
        EndTextCommandDisplayText(_x,_y)
    end
end

MVMNT.func.displayThread = function()
    CreateThread(function()
        while MVMNT.cache.toggled do
            for k,v in pairs(MVMNT.cache.players) do
                local talking = NetworkIsPlayerTalking(k)
                local color = {255, 255, 255}
                if talking then
                    color = {100, 100, 100}
                end
                if MVMNT.func.canSee(v.ped) then
                    local pos = GetWorldPositionOfEntityBone(v.ped, GetPedBoneIndex(v.ped, 0x796E))
                    MVMNT.func.drawText(v.id, pos, color, 0.55, 1.1)
                    local group = v.group or "user"
                    local displayName = playerGroups[group] and playerGroups[group].name or "GRACZ"
                    local displayColor = playerGroups[group] and playerGroups[group].color or {255,255,255}
                    if v.identifier and MVMNT.tags[v.identifier] then
                        local tag = MVMNT.tags[v.identifier]
                        MVMNT.func.drawText(tag.name, pos, tag.color, 0.35, 0.65)
                    else
                        MVMNT.func.drawText(displayName, pos, displayColor, 0.35, 0.65)
                    end
                end
            end
            Wait(1)
        end
    end)
end

SKAM.addKeybind({
    key = 'Z',
    description = 'Pokaż/Ukryj - Zetka',
    onPressed = function()
        MVMNT.func.globalThread(true)
        SendNUIMessage({ type = 'nui:scoreboard:show', showZetka = true })
    end,
    onReleased = function()
        MVMNT.func.globalThread(false)
        SendNUIMessage({ type = 'nui:scoreboard:show', showZetka = false })
    end,
})