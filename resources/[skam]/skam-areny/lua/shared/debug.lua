debug = {}
debugstate = false

debug.print = function(msg)
    if debugstate then
        print('[DEBUG-BATTLES]', ' # ' .. msg)
    end
end