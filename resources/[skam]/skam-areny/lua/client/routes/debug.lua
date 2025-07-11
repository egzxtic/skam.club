debug = {}
debugstate = false

debug.print = function(prefix, msg)
    if debugstate then
        print('[' .. prefix .. '-DEBUG] -> ' .. msg)
    end
end