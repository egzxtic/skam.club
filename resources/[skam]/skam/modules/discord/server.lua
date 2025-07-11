discordData = {
    botTkn = 'MTM2NTUyMjQ1NTQ0NzIwODA5Ng.GjUr-H.2i_wPFzpl1AhKlZ2ru8tavUl1UTJGys152WVDc',
    guildId = '913692176540655627'
}

discordRoles = {
    ['913692176574214183'] = 'owner',
    ['1380291162031656980'] = 'ceo',
    ['1380292627819270238'] = 'txmanager',
    ['1370052430078808235'] = 'developer',
    ['1380292362130952304'] = 'managment',
    ['1386021839360233493'] = 'mediamanagment',
    ['1380292068148248576'] = 'opiekunadm',
    ['1380298816464355429'] = 'eventmanager',
    ['1380291834206486528'] = 'prezeszarzadu',
    ['1370048891021562028'] = 'zarzad',
    ['1370048890434490438'] = 'headadmin',
    ['1370048889838768229'] = 'admin',
    ['1380293083111096361'] = 'smod',
    ['1370048891604701244'] = 'mod',
    ['1370048889326932068'] = 'support',
    ['1370048886391050391'] = 'trialsupport',
    ['1370048817667379410'] = 'revivator',
}

discordRolePriority = {
    owner = 1,
    ceo = 2,
    txmanager = 3,
    developer = 4,
    managment = 5,
    mediamanagment = 6,
    opiekunadm = 7,
    eventmanager = 8,
    prezeszarzadu = 9,
    zarzad = 10,
    headadmin = 11,
    admin = 12,
    smod = 13,
    mod = 14,
    support = 15,
    trialsupport = 16,
    revivator = 17,
    user = 99
}

local function DiscordApiRequest(method, endpoint, jsondata, retries)
    retries = retries or 3
    local finished, response = false, {}

    local function makeRequest()
        PerformHttpRequest(
            'https://discordapp.com/api/' .. endpoint,
            function(code, body, headers)
                response = {code=code, data=body, headers=headers}
                finished = true
            end,
            method,
            (jsondata and next(jsondata)) and json.encode(jsondata) or '',
            {
                ['Content-Type'] = 'application/json',
                ['Authorization'] = 'Bot ' .. discordData.botTkn
            }
        )
    end

    makeRequest()
    local waited = 0

    while not finished and waited < 10000 do
        Citizen.Wait(5)
        waited = waited + 5
    end

    if response.code == 429 and retries > 0 then
        local retryAfter
        if response.data then
            local ok, data = pcall(json.decode, response.data)
            if ok and data and data.retry_after then
                retryAfter = tonumber(data.retry_after)
            end
        end
        retryAfter = retryAfter or 1
        print('[DiscordApiRequest] Ratelimit! Retry za ' .. retryAfter .. ' sekund...')
        Citizen.Wait(math.ceil(retryAfter * 1000))
        return DiscordApiRequest(method, endpoint, jsondata, retries - 1)
    end

    if not finished then
        print('DiscordApiRequest timeout!')
        return {code=504, data=nil}
    end

    return response
end

local function GetPlayerDiscordId(player)
    for _, id in ipairs(GetPlayerIdentifiers(player)) do
        local discord = id:match('^discord:(%d+)')
        if discord then return discord end
    end
    return nil
end

local function GetUserDiscordAvatar(player)
    local defaultAvatar = 'https://media.discordapp.net/attachments/1305298601647538290/1376192116828540948/profile.png?ex=68346e49&is=68331cc9&hm=5b3cef08597121806fa4e1bf68718b737fd678e33e8efca79d6bd359fdcb465a&=&format=webp&quality=lossless&width=680&height=680'
    local discordId = GetPlayerDiscordId(player)
    if not discordId then return defaultAvatar end

    local res = DiscordApiRequest('GET', 'users/' .. discordId, {})
    if res.code == 200 and res.data then
        local ok, data = pcall(json.decode, res.data)
        if ok and data then
            if data.avatar then
                local ext = 'png'
                if string.sub(data.avatar, 1, 2) == 'a_' then
                    ext = 'gif'
                end
                return ('https://cdn.discordapp.com/avatars/%s/%s.%s?size=128'):format(discordId, data.avatar, ext)
            else
                if data.discriminator then
                    local disc = tonumber(data.discriminator) % 5
                    return ('https://cdn.discordapp.com/embed/avatars/%s.png'):format(disc)
                end
            end
        end
    end
    return defaultAvatar
end

local function GetUserDiscordRoles(player)
    local discordId = GetPlayerDiscordId(player)
    if not discordId then return false end

    local endpoint = ('guilds/%s/members/%s'):format(discordData.guildId, discordId)
    local res = DiscordApiRequest('GET', endpoint, {})
    if res.code == 200 and res.data then
        local ok, data = pcall(json.decode, res.data)
        if ok and data and data.roles then return data.roles end
    end
    return false
end

local function PlayerHasDiscordRole(player, roleId)
    local roles = GetUserDiscordRoles(player)
    if not roles then return false end
    roleId = tostring(roleId)
    for _, r in ipairs(roles) do
        if r == roleId then return true end
    end
    return false
end

Citizen.CreateThread(function()
    local guild = DiscordApiRequest('GET', 'guilds/' .. discordData.guildId, {})
    if guild.code == 200 and guild.data then
        local ok, data = pcall(json.decode, guild.data)
        if ok and data then
            print('SERVER DISCORD: ' .. data.name .. ' (' .. data.id .. ')')
        end
    else
        print('Błąd połączenia z Discordem! Sprawdź konfigurację. ' .. (guild.data or guild.code))
    end
end)

-- local function checkDiscordAdmin(player)
--     local userRoles = GetUserDiscordRoles(player)
--     if userRoles and type(userRoles) == 'table' then
--         for _, roleId in ipairs(userRoles) do
--             local roleGroup = discordRoles[roleId]
--             if roleGroup then
--                 --print(json.encode(roleGroup))
--                 return roleGroup
--             end
--         end
--     end
--     return 'user'
-- end

local function checkDiscordAdmin(player)
    local userRoles = GetUserDiscordRoles(player)
    local bestGroup = 'user'
    local bestPriority = discordRolePriority['user']

    if userRoles and type(userRoles) == 'table' then
        for _, roleId in ipairs(userRoles) do
            local roleGroup = discordRoles[roleId]
            if roleGroup and discordRolePriority[roleGroup] then
                local prio = discordRolePriority[roleGroup]
                if prio < bestPriority then
                    bestPriority = prio
                    bestGroup = roleGroup
                end
            end
        end
    end
    return bestGroup
end

exports('GetUserDiscordAvatar', GetUserDiscordAvatar)
exports('GetPlayerDiscordId', GetPlayerDiscordId)
exports('GetUserDiscordRoles', GetUserDiscordRoles)
exports('PlayerHasDiscordRole', PlayerHasDiscordRole)
exports('checkDiscordAdmin', checkDiscordAdmin)