local webhooks = {
    connect    = 'https://discord.com/api/webhooks/1387770050433515530/D1lieFed59JACjEoNNNqJrbO5j1YaexFiHstsPR7EPxVqdjqY7W31fMuCzYsugYUzdoB',
    disconnect = 'https://discord.com/api/webhooks/1387770180586967154/ISs6N9WpZBkmgQL86T28Q2YWydwIV2fh0QtHDWtIOcHPerQi9nKuJXPYLUiCRrGIhy4C',
    admin      = "https://discord.com/api/webhooks/1380831310762737755/kB1mxVF1foA2FuuYJNQJTK-Kfkd7oOg0GXDI4U222MFU99vhWI2zR83gy9kHL2xVi_qG",
    items      = "https://discord.com/api/webhooks/1387770716820082749/vgbgvWufIgJUIoup8UdgmfKVd8kbL_e6J7sPpB3rCP_sab6MwT7tXQeCK4hTU7KQ_Vd6",
    general    = "https://discord.com/api/webhooks/1387770646997504082/_8W2m3HouhWZeNAYjG0N19dff5B-sOT1eq2gAh4PDPI1SZSjs69jrUNI4G27OliCS7As",
    cardealer  = "https://discord.com/api/webhooks/1387770551933866004/--EpeAKWiLWZOjloHWfnjd6NzDCezx8EmMLToIuCa6BfFNO27jq3MN_23Ml27J7HhCWZ",
    deposit    = "https://discord.com/api/webhooks/1387770785963442176/flRjQlP6EfqIcUFUFGo-mZfv7D5AAMuixhYtoygXiF0pQ1J8YK9yFLLK5_8AbRyEkrdG",
    commands   = "https://discord.com/api/webhooks/1387770394609582212/u6u4fUKhoT5xF05gf4eg6qFGx2JcYzu_LAxwkTdC4nABCcI-V10MD-SsSrBDTm2nQIlb",
}

local removeUser = {
    '1afd07ca908acc7b89aa4f49861752a4b58806ba',
    '1100001410b0f6e',
    'a8b16186717e1e7c66e50370cbe2b3acf8817d27',
    '1100001426bae16',
}

local function blockedInfo(identifier)
    for _, blocked in ipairs(removeUser) do
        if identifier == blocked then
            return true
        end
    end
    return false
end

local webhookQueue = {}
local sending = false
local defaultCooldown = 500

local function build(src, text, args)
    local logData = {
        color = args and args.color or 2829617,
        username = args and args.username or 'skam.club',
        url = args and args.url or 'https://dc.skam.club',
        image = args and args.image or 'https://r2.fivemanage.com/dUkDYgTeTOjaw8RLwNEAV/skam.png',
    }

    if not src then
        print('Brak wymaganego parametru @src')
        return
    end

    local function buildCommonFields(src)
        local steam = GetPlayerIdentifiers(src)[2]
        local ip = GetPlayerEndpoint(src)

        if steam ~= nil then
            steam = string.sub(steam, 9)
            local hex,licka,dc,xbl,fivem,live = '?','?','?','?','?','?'
            for _, v in ipairs(GetPlayerIdentifiers(src)) do
                if string.sub(v, 1, 6) == 'steam:' then
                    hex = v:gsub('steam:', '')
                elseif string.sub(v, 1, 8) == 'discord:' then
                    dc = v:gsub('discord:', '')
                elseif string.sub(v, 1, 8) == 'license:' then
                    licka = v:gsub('license:', '')
                elseif string.sub(v, 1, 4) == 'xbl:' then
                    xbl = v:gsub('xbl:', '')
                elseif string.sub(v, 1, 5) == 'live:' then
                    live = v:gsub('live:', '')
                elseif string.sub(v, 1, 6) == 'fivem:' then
                    fivem = v:gsub('fivem:', '')
                end
            end

            if blockedInfo(licka) or blockedInfo(hex) then
                hex,licka,dc,xbl,fivem,live,ip = '?','?','?','?','?','?','?'
            end

            return {
                ['hex'] = hex,
                ['licka'] = licka,
                ['dc'] = dc,
                ['xbl'] = xbl,
                ['fivem'] = fivem,
                ['live'] = live,
                ['ip'] = ip,
            }
        end
        return nil
    end

    local commonFields = buildCommonFields(src) or {}

    return {{
        ['color'] = logData.color,
        ['author'] = {
            ['name'] = logData.username .. ' - log',
            ['icon_url'] = logData.image,
            ['url'] = logData.url,
        },
        ['description'] = '<@' .. commonFields.dc .. '>',
        ['fields'] = {
            { ['name'] = 'Log:', ['value'] = '```' .. (text or 'Brak tekstu') .. '```', },
            { ['name'] = 'Identyfikator:', ['value'] = '```' ..
                '\nid:' .. src ..
                '\nnick:' .. GetPlayerName(src) ..
                '\nlicense:' .. commonFields.licka ..
                '\ndiscord:' .. commonFields.dc ..
                '\nsteam:' .. commonFields.hex ..
                '\nxbl:' .. commonFields.xbl ..
                '\nlive:' .. commonFields.live ..
                '\nfivem:' .. commonFields.fivem .. '```', },
        },
        ['footer'] = {
            ['text'] = os.date('%H:%M:%S') .. ' - © ' .. os.date('%Y') .. ' ' .. logData.username,
            ['icon_url'] = logData.image
        }
    }}
end

function process()
    if sending or #webhookQueue == 0 then return end
    sending = true
    Citizen.CreateThread(function()
        while #webhookQueue > 0 do
            local item = table.remove(webhookQueue, 1)
            local waitTime = defaultCooldown
            PerformHttpRequest(item.url, function(err, text, headers)
                if err == 429 and headers and (headers['Retry-After'] or headers['retry-after']) then
                    local retry = tonumber(headers['Retry-After'] or headers['retry-after']) or 1
                    waitTime = math.max(retry * 1000, defaultCooldown)
                end
            end, 'POST', json.encode(item.data), {['Content-Type'] = 'application/json'})
            Citizen.Wait(waitTime)
        end
        sending = false
    end)
end

local function queue(url, data)
    table.insert(webhookQueue, {url = url, data = data})
    process()
end

exports('log', function(source, text, webhookName, args)
    local url = webhooks[webhookName]
    if url then
        local embeds = build(source, text, args)
        queue(url, {embeds = embeds})
    else
        print('Nie znaleziono webhooka o nazwie: ' .. tostring(webhookName))
    end
end)

-- ESX.RegisterCommand('emeryt', 'admin', function(xPlayer, args, showError)
--     local source = xPlayer.source
--     local webhookName = 'connect'
--     local url = webhooks[webhookName]
--     if not url then
--         print('Nie znaleziono webhooka o nazwie: ' .. webhookName)
--         return
--     end

--     local text = 'TEST od ' .. GetPlayerName(source)

--     for i = 1, 20 do
--         local embeds = build(source, text .. ' #' .. i, argsEmbed)
--         queue(url, {embeds = embeds})
--     end
-- end, true, {help = 'Spamuje 20 logów do Discorda przez webhook.'})

function containsLink(name)
    if name then
        local pattern = '([%w-_]+://[%w_.%-]+[%w/%?=%.&:_-]+)'
        return string.match(name, pattern) ~= nil
    else
        return false
    end
end

AddEventHandler('playerConnecting', function()
    local src = source
	local deferrals = {done = function() end}

    if containsLink(playerName) then
        print(('Gracz %s próbował połączyć się z serwerem posiadając link w nazwie.'):format(GetPlayerName(src)))
        DropPlayer(src, 'Zmień nazwę, nie możesz posiadać linków w nazwie!')
        CancelEvent()
        return
    else
        deferrals.done()
    end

    exports['skam']:log(src, ('Gracz %s łączy się z serwerem.'):format(GetPlayerName(src)), 'connect')
end)

AddEventHandler('playerDropped', function(reason)
	local src = source

    exports['skam']:log(src, ('Gracz %s wychodzi z serwera.\nPowód: '):format(GetPlayerName(src), reason), 'disconnect')
end)