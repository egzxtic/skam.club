adaptivecards = {
    animation = {
        {text = "▬"},
        {text = "▬▬"},
        {text = "▬▬▬"},
        {text = "▬▬▬▬"},
        {text = "▬▬▬▬▬"},
        {text = "▬▬▬▬▬▬"},
        {text = "▬▬▬▬▬▬▬"},
    },
    ["connecting"] = function(def, time, priorityName)
        local text = queue.langs[queue.lang]["aconnecting"](time)
        def.presentCard([[
            {
                "type": "AdaptiveCard",
                "body": [
                    {
                        "type": "ColumnSet",
                        "columns": [
                            {
                                "type": "Column",
                                "items": [
                                    {
                                        "type": "Image",
                                        "style": "Person",
                                        "url": "]]..queue.serverLogo..[[",
                                        "size": "Small",
                                        "horizontalAlignment": "Left"
                                    }
                                ],
                                "width": "auto"
                            },
                            {
                                "type": "Column",
                                "items": [
                                    {
                                        "type": "TextBlock",
                                        "weight": "Bolder",
                                        "wrap": true,
                                        "text": "]]..queue.serverName..[[",
                                        "horizontalAlignment": "Left"
                                    },
                                    {
                                        "type": "TextBlock",
                                        "spacing": "None",
                                        "text": "]]..text..[[",
                                        "isSubtle": true,
                                        "wrap": true,
                                        "horizontalAlignment": "Left"
                                    }                                    
                                ],
                                "width": "stretch"
                            }
                        ]
                    },
                    {
                        "type": "TextBlock",
                        "text": " ",
                        "spacing": "Medium"
                    },
                    {
                        "type": "ColumnSet",
                        "columns": [
                            {
                                "type": "Column",
                                "width": "stretch",
                                "items": [
                                    {
                                        "type": "TextBlock",
                                        "text": "",
                                        "separator": true
                                    }
                                ]
                            }
                        ]
                    }
                ],
                "actions": [
                    {
                        "type": "Action.OpenUrl",
                        "title": "Sklep",
                        "url": "https://skam.club"
                    },
                    {
                        "type": "Action.OpenUrl",
                        "title": "Discord",
                        "url": "https://discord.gg/skam"
                    }
                ],
                "$schema": "http://adaptivecards.io/schemas/adaptive-card.json",
                "version": "1.5"
            }
        ]])
    end,    
    ["queue"] = function(player,tbl,def,loading,time,priorityName)
        local animation = adaptivecards.animation[loading].text
        local text = queue.langs[queue.lang]["in_queue"](player,tbl,time)
        def.presentCard(
            [[
                {
                    "type": "AdaptiveCard",
                    "body": [
                        {
                            "type": "ColumnSet",
                            "columns": [
                                {
                                    "type": "Column",
                                    "items": [
                                        {
                                            "type": "TextBlock",
                                            "weight": "Bolder",
                                            "wrap": true,
                                            "text": "]]..queue.serverName..[[",
                                            "horizontalAlignment": "Center",
                                            "spacing": "Medium",
                                            "style": "heading",
                                            "color": "Warning",
                                            "isSubtle": true,
                                            "size": "Large"
                                        }
                                    ],
                                    "width": "stretch"
                                }
                            ]
                        },
                        {
                            "type": "TextBlock",
                            "text": "Rodzaj Biletu: ]]..priorityName..[[",
                            "wrap": true,
                            "horizontalAlignment": "Center",
                            "color": "Good",
                            "size": "Medium",
                            "weight": "Bolder"
                        },
                        {
                            "type": "TextBlock",
                            "text": "]]..text..[[",
                            "wrap": true,
                            "style": "default",
                            "fontType": "Default",
                            "size": "Medium",
                            "weight": "Bolder",
                            "color": "Accent",
                            "isSubtle": false,
                            "horizontalAlignment": "Center",
                            "spacing": "Medium"
                        },
                        {
                            "type": "TextBlock",
                            "text": "]]..queue.langs[queue.lang]["buy_premium"]..[[",
                            "wrap": true,
                            "horizontalAlignment": "Center",
                            "size": "Medium",
                            "fontType": "Default",
                            "weight": "Bolder",
                            "color": "Accent",
                            "spacing": "Large"
                        },
                        {
                            "type": "TextBlock",
                            "text": "]]..animation..[[",
                            "wrap": true,
                            "horizontalAlignment": "Center",
                            "fontType": "Default",
                            "style": "default",
                            "size": "Large",
                            "color": "Default",
                            "spacing": "Large"
                        }
                    ],
                    "$schema": "http://adaptivecards.io/schemas/adaptive-card.json",
                    "version": "1.5"
                }
            ]]
        )
    end,
    ["nowhitelist"] = function(def)
        def.presentCard([[
            {
                "type": "AdaptiveCard",
                "body": [
                    {
                        "type": "ColumnSet",
                        "columns": [
                            {
                                "type": "Column",
                                "items": [
                                    {
                                        "type": "TextBlock",
                                        "weight": "Bolder",
                                        "wrap": true,
                                        "text": "]]..queue.serverName..[[",
                                        "horizontalAlignment": "Center",
                                        "spacing": "Medium",
                                        "style": "heading",
                                        "color": "Warning",
                                        "isSubtle": true,
                                        "size": "Large"
                                    },
                                    {
                                        "type": "TextBlock",
                                        "text": "]]..queue.langs[queue.lang]["no_whitelist"]..[[",
                                        "wrap": true,
                                        "weight": "Bolder",
                                        "color": "Warning",
                                        "size": "Medium",
                                        "horizontalAlignment": "Center"
                                    }
                                ],
                                "width": "stretch"
                            }
                        ]
                    },
                    {
                        "type": "ActionSet",
                        "actions": [
                            {
                                "type": "Action.OpenUrl",
                                "title": "DISCORD",
                                "url": "]]..queue.discord..[["
                            }
                        ]
                    }
                ],
                "$schema": "http://adaptivecards.io/schemas/adaptive-card.json",
                "version": "1.5"
            }
        ]])
        local pi = 0
        while true do
            pi = pi + 1
            if pi > 10 then
                def.done(queue.langs[queue.lang]["no_whitelist"])
                return
            end
            Wait(1000)
        end
    end
}