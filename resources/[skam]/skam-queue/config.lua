queue = {
    serverName = "skam.club",
    discord = "https://discord.gg/skam",
    shop = "https://indrop.app/s/skam",
    serverLogo = "https://r2.fivemanage.com/dUkDYgTeTOjaw8RLwNEAV/skam.png",
    antifloodTime = 5, -- time in seconds to wait before add to queue
    refreshInterval = 5000, -- time in ms to wait before refresh queue
    whitelist = false, -- true/false // set true to turn on whitelist
    lang = "EN",
    langs = {
        ["EN"] = {
            ["no_steam"] = "Nie posiadasz uruchomionego steama",
            ["no_discord"] = "Nie posiadasz uruchomionego discorda",
            ["no_whitelist"] = "Nie posiadzasz whitelisty",
            ["normal_ticket"] = "Standardowy",
            ["buy_premium"] = "Nie chcesz czekać w kolejce? Kup bilet Premium",
            ["aconnecting"] = function(time)
                return "Zostaniesz połączony za "..time.." sekundy"
            end,
            ["in_queue"] = function(player,tbl,time)
                return "Jesteś "..player.."/"..tbl.." w kolejce. Czas w kolejce ("..time..")"
            end
        }
    },
    ranks = {
        ["913692176574214183"] = {priority = 100, name =  "Owner"},
        ["923194392565649459"] = {priority = 50, name = "Admin"},
        ["923564398012932178"] = {priority = 20, name = "Booster"}
    },
    players = {},
    connectingPlayers = {}
}