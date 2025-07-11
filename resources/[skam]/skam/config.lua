Config = {}

Config['respawns'] = {
    respawnTime = 20,
    select = {
        { name = 'GREENZONE - DOKI', crds = vector4(1008.3270, -2521.3945, 28.3053, 4.1462) },
        { name = 'GREENZONE - SANDY', crds = vector4(2758.3887, 3466.8523, 55.7347, 249.1807) },
        { name = 'GREENZONE - GOLFOWE', crds = vector4(-1098.7672, 12.1462, 50.7445, 113.9021) },
        { name = 'GREENZONE - LOTNISKO', crds = vector4(-977.3529, -2999.0811, 13.9451, 58.9712) },
        { name = 'GREENZONE - CAYOPERICO', crds = vector4(4890.3247, -5736.5156, 26.3509, 153.2774) },
    }
}

Config['narko'] = {
    meth = {
        zbierz = { name = 'META', coords = vector3(1534.3220, 2231.9094, 77.6991 - 0.9), sprite = 514, color = 0 },
        przerob = { name = 'META', coords = vector3(1390.1576, 3608.0435, 38.9419 - 0.9), sprite = 514, color = 0 },
    },
    weed = {
        zbierz = { name = 'WEED', coords = vector3(2224.1829, 5577.0620, 53.8416 - 0.9), sprite = 496, color = 2 },
        przerob = { name = 'WEED', coords = vector3(1343.0165, 4389.4795, 44.3437 - 0.9), sprite = 496, color = 2 },
    },
    fent = {
        zbierz = { name = 'FENT', coords = vector3(4504.0806, -4553.6602, 4.1719 - 0.9), sprite = 827, color = 7 },
        przerob = { name = 'FENT', coords = vector3(5193.8047, -5134.5923, 3.3461 - 0.9), sprite = 827, color = 7 },
    }
}

Config['noloot'] = {
    zones = {
        ['Parking'] = { center = vec3(486.2976, -44.6110, 88.8568), radius = 50.0 },
        ['Strzelnica'] = { center = vec3(13.9137, -1073.3542, 38.1521), radius = 100.0 },
    }
}

Config['strefy'] = {
    captureTime = 120,
    cooldown = 180,
    zones = {
        { name = 'Hangar', coords = vec3(2351.5232, 3132.8816, 48.2087 - 0.9), rewardItem = { name = 'weapon_pistol', count = 1 }, third = false },
        { name = 'Stodoła', coords = vec3(1904.0664, 4922.7188, 48.8410 - 0.9), rewardItem = { name = 'weapon_pistol', count = 1 }, third = false },
        { name = 'Elektrownia', coords = vec3(2750.7007, 1491.9626, 24.5007 - 0.9), rewardItem = { name = 'weapon_pistol', count = 1 }, third = false },
        { name = 'Budowa', coords = vec3(1090.2198, 2308.9729, 45.5131 - 0.9), rewardItem = { name = 'weapon_pistol', count = 1 }, third = false },        
        { name = 'Motel', coords = vec3(1573.7517, 3590.6931, 35.3615 - 0.9), rewardItem = { name = 'weapon_pistol', count = 1 }, third = false },
        { name = 'Tłocznia', coords = vec3(317.6292, 2866.0991, 43.5023 - 0.9), rewardItem = { name = 'weapon_pistol', count = 1 }, third = false },
        { name = 'Latarnia', coords = vec3(3315.6917, 5166.0508, 18.4153 - 0.9), rewardItem = { name = 'weapon_pistol', count = 1 }, third = false },
        { name = 'Wiatraki', coords = vec3(2215.7314, 2064.5786, 132.3552 - 0.9), rewardItem = { name = 'weapon_pistol', count = 1 }, third = false },
        { name = 'Strzelnica', coords = vec3(13.9137, -1073.3542, 38.1521 - 0.9), rewardItem = { name = 'weapon_pistol', count = 1 }, third = true, thirdRadius = 100.0 },
        { name = 'Parking', coords = vec3(486.2976, -44.6110, 88.8568 - 0.9), rewardItem = { name = 'weapon_pistol', count = 1 }, third = true, thirdRadius = 50.0 },
    }
}

Config['greenzone'] = {
    ['DOKI'] = {
        crds = vector3(1014.8843, -2529.4507, 28.3006),
        radius = 45.0,
        color = {r = 255, g = 255, b = 255, a = 0.1},
        blip = {
            name = 'GREENZONE',
            sprite = 835,
            color = 0,
            addBlip = true,
            addRadius = true,
        },
    },
    ['SENDY'] = {
        crds = vector3(2752.2637, 3471.0288, 55.7214),
        radius = 50.0,
        color = {r = 255, g = 255, b = 255, a = 0.1},
        blip = {
            name = 'GREENZONE',
            sprite = 835,
            color = 0,
            addBlip = true,
            addRadius = true,
        },
    },
    ['CAYOPERICO'] = {
        crds = vector3(4890.3667, -5736.5781, 26.3509),
        radius = 50.0,
        color = {r = 255, g = 255, b = 255, a = 0.1},
        blip = {
            name = 'GREENZONE',
            sprite = 835,
            color = 0,
            addBlip = true,
            addRadius = true,
        },
    },
    ['MIASTO'] = {
        crds = vector3(-1098.9359, 11.8312, 50.7336),
        radius = 30.0,
        color = {r = 255, g = 255, b = 255, a = 0.1},
        blip = {
            name = 'GREENZONE',
            sprite = 835,
            color = 0,
            addBlip = true,
            addRadius = true,
        },
    },
    ['CITYTOWN'] = {
        crds = vector3(-541.1413, -210.9345, 37.6045),
        radius = 40.0,
        color = {r = 255, g = 255, b = 255, a = 0.1},
        blip = {
            name = 'GREENZONE',
            sprite = 835,
            color = 0,
            addBlip = false,
            addRadius = false,
        },
    },
    ['CARDEALER'] = {
        crds = vector3(-580.7408, -421.6904, 35.1721),
        radius = 50.0,
        color = {r = 255, g = 255, b = 255, a = 0.1},
        blip = {
            name = 'GREENZONE',
            sprite = 835,
            color = 39,
            addBlip = false,
            addRadius = false,
        },
    },
    ['JAIL'] = {
        crds = vector3(1693.9004, 2591.6670, 45.5649),
        radius = 200.0,
        color = {r = 255, g = 255, b = 255, a = 0.1},
        blip = {
            name = 'WIĘZIENIE',
            sprite = 430,
            color = 1,
            scale = 1.0,
            addBlip = false,
            addRadius = false,
        },
    },
    ['LOTNISKO'] = {
        crds = vector3(-959.9393, -2983.7991, 13.9451),
        radius = 75.0,
        color = {r = 255, g = 255, b = 255, a = 0.1},
        blip = {
            name = 'GREENZONE',
            sprite = 835,
            color = 0,
            addBlip = true,
            addRadius = true,
        },
    },
}

Config['vehicleshop'] = {}
Config['vehicleshop'].PlateLetters = 3
Config['vehicleshop'].PlateNumbers = 3
Config['vehicleshop'].PlateUseSpace = true
Config['vehicleshop'].Zones = {
	ShopEntering = {Pos = vector3(976.9445, -2516.5068, 28.4523 - 0.9)},
	ShopInside = {Pos = vector3(989.5685, -2520.5762, 28.3020 - 0.9), Heading = 1.0},
	ShopOutside = {Pos = vector3(987.5583, -2508.1428, 28.3020), Heading = 20.0},
}

Config['healer'] = {}
Config['healer'].HealerPrice = 10000
Config['healer'].Healers = {
    vector3(2528.05, 2588.88, 36.94), -- DINO
    vector3(-1089.0668, 18.1691, 49.9738), -- GOLFOWE
    vector3(1018.6856, -2511.5869, 27.4754), -- DOKI
}

-- Config['shops'] = {
--     sellMultiplier = 0.1,
--     coords = {
--         vector4(2640.4822, 3287.4041, 55.2544-0.9, 255.9387),
--         vector4(1017.3318, -2529.2117, 27.3001, 77.5220),
--     },
--     shopItems = {
--         { label = 'Energetyk', item = 'energydrink', price = 2500 },
--         { label = 'Krótkofalówka', item = 'radiocrime', price = 10000 },
--         { label = 'Magazynek do pistoletu', item = 'pistol_ammo_box', price = 12500 },
--         { label = 'Zestaw naprawczy', item = 'repairkit', price = 15000 },
--         { label = 'Kajdanki', item = 'handcuffs', price = 20000 },
--         { label = 'Laptop do hackowania', item = 'napad-laptop', price = 50000 },
--         { label = 'Łom do napadu', item = 'napad-lifeinvader', price = 60000 },
--         { label = 'Pistolet SNS', item = 'snspistol', price = 70000 },
--         { label = 'Pistolet', item = 'pistol', price = 100000 },
--         { label = 'Pistolet (MK II)', item = 'pistol_mk2', price = 140000 },
--         { label = 'Pistolet SNS (MK II)', item = 'snspistol_mk2', price = 250000 },
--         { label = 'Pistolet Vintage', item = 'vintagepistol', price = 250000 },
--         { label = 'Pistolet Ceramiczny', item = 'ceramicpistol', price = 280000 },
--         { label = 'Pistolet Heavy', item = 'heavypistol', price = 1000000 },
--     },
-- }

Config['shops'] = {
    ShopConfig = {
        coords = {
            vector4(2640.4822, 3287.4041, 54.3544, 255.9387),
            vector4(1017.3318, -2529.2117, 27.3001, 77.5220),
            vector4(-1084.3246, 12.5978, 49.7547, 92.2746), -- GOLFOWE
        },
        items = {
            { item = 'energydrink', price = 2500 },
            { item = 'radiocrime', price = 10000 },
            { item = 'pistol_ammo_box', price = 12500 },
            { item = 'repairkit', price = 15000 },
            { item = 'handcuffs', price = 20000 },
            { item = 'napad-laptop', price = 50000 },
            { item = 'napad-lifeinvader', price = 60000 },
            { item = 'snspistol', price = 70000 },
            { item = 'suppressor', price = 500000 },
            { item = 'pistol', price = 100000 },
            { item = 'pistol_mk2', price = 140000 },
            { item = 'snspistol_mk2', price = 250000 },
            { item = 'vintagepistol', price = 250000 },
            { item = 'ceramicpistol', price = 280000 },
            { item = 'heavypistol', price = 1000000 },
        }
    }
}

Config['clotheshop'] = {
    Price = 1000,
    Shops = {
        vector3(75.3675, -1398.3821, 29.3785-0.9),
        vector3(-710.3318, -161.6475, 37.4153-0.9),
        vector3(-156.4907, -297.4386, 39.7334-0.9),
        vector3(425.2813, -800.7861, 29.4935-0.9),
        vector3(-827.0078, -1075.9574, 11.3304-0.9),
        vector3(-1458.8124, -239.7576, 49.8013-0.9),
        vector3(9.0692, 6515.7617, 31.8801-0.9),
        vector3(124.3844, -219.1595, 54.5577-0.9),
        vector3(1693.7871, 4828.1216, 42.0655-0.9),
        vector3(617.4639, 2759.2559, 42.0883-0.9),
        vector3(1191.4226, 2710.5498, 38.2250-0.9),
        vector3(-1194.4746, -772.3811, 17.3235-0.9),
        vector3(556.5380, -2773.5364, 6.0907-0.9),
        vector3(-3171.5891, 1048.3875, 20.8634-0.9),
        vector3(-1105.3882, 2707.1033, 19.1102-0.9)
    }
}

Config['deposit'] = {}
Config['deposit'].Zones = {
    vector4(2530.19, 2576.74, 36.94, 288.79), -- DINO
    vector4(-1088.8228, 5.8929, 49.7881, 42.0866), -- GOLFOWE
    vector4(1018.23, -2520.25, 27.30, 86.62), -- DOKI
}

Config['extras'] = {}
Config['extras'].Zones = {
    vector3(454.06, -1025.57, 27.6),
    vector3(-1122.2, -860.94, 12.65), -- vinewood
    vector3(1872.68, 3696.29, 32.59), -- sandy
    vector3(-478.92, 6020.98, 30.44), -- paleto
}

Config['orgs'] = {}
Config['orgs'] = {
    Zones = {
        vector4(-1111.7153, 5.0432, 49.1793, 283.7881), -- GOLFOWE
        vector4(2521.62, 2624.51, 36.99, 297.6),  -- GREENZONE DINO
        vector4(1002.69, -2529.75, 27.45, 357.0), -- GREENZONE DOKI
    },
    upgrades = {
        handcuffs = {label = 'Kajdanki', price = 2000000, f6menu = true, time = 7*24*60*60},
        repairkit = {label = 'Naprawka', price = 800000, f6menu = true, time = 7*24*60*60},
    },
}

Config['weaponcomponents'] = {}
Config['weaponcomponents'].componentsList = {
    suppressor = {
        [`WEAPON_PISTOL`] = `COMPONENT_AT_PI_SUPP_02`,
        [`WEAPON_PISTOL_MK2`] = `COMPONENT_AT_PI_SUPP_02`,
        [`WEAPON_COMBATPISTOL`] = `COMPONENT_AT_PI_SUPP`,
        [`WEAPON_SNSPISTOL_MK2`] = `COMPONENT_AT_PI_SUPP_02`,
        [`WEAPON_HEAVYPISTOL`] = `COMPONENT_AT_PI_SUPP`,
        [`WEAPON_VINTAGEPISTOL`] = `COMPONENT_AT_PI_SUPP`,
        [`WEAPON_B92FS`] = `COMPONENT_AT_PI_SUPP`,
        [`WEAPON_CERAMICPISTOL`] = `COMPONENT_CERAMICPISTOL_SUPP`,
    },
    suppressor2 = {
        [`WEAPON_MICROSMG`] = `COMPONENT_AT_AR_SUPP_02`,
        [`WEAPON_SMG_MK2`] = `COMPONENT_AT_PI_SUPP`,
    },
    extendedclip = {
        [`WEAPON_SNSPISTOL`] = `COMPONENT_SNSPISTOL_CLIP_02`,
        [`WEAPON_SNSPISTOL_MK2`] = `COMPONENT_SNSPISTOL_MK2_CLIP_02`,
        [`WEAPON_VINTAGEPISTOL`] = `COMPONENT_VINTAGEPISTOL_CLIP_02`,
        [`WEAPON_B92FS`] = `COMPONENT_VINTAGEPISTOL_CLIP_02`,
        [`WEAPON_PISTOL`] = `COMPONENT_PISTOL_CLIP_02`,
        [`WEAPON_PISTOL_MK2`] = `COMPONENT_PISTOL_MK2_CLIP_02`,
        [`WEAPON_COMBATPISTOL`] = `COMPONENT_COMBATPISTOL_CLIP_02`,
        [`WEAPON_HEAVYPISTOL`] = `COMPONENT_HEAVYPISTOL_CLIP_02`,
        [`WEAPON_CERAMICPISTOL`] = `COMPONENT_CERAMICPISTOL_CLIP_02`,
    },
    extendedclip2 = {
        [`WEAPON_MINISMG`] = `COMPONENT_MINISMG_CLIP_02`,
        [`WEAPON_MICROSMG`] = `COMPONENT_MICROSMG_CLIP_02`,
        [`WEAPON_SMG_MK2`] = `COMPONENT_SMG_MK2_CLIP_02`,
    },
    flashlight = {
        [`WEAPON_SNSPISTOL_MK2`] = `COMPONENT_AT_PI_FLSH_03`,
        [`WEAPON_PISTOL`] = `COMPONENT_AT_PI_FLSH`,
        [`WEAPON_PISTOL_MK2`] = `COMPONENT_AT_PI_FLSH_02`,
        [`WEAPON_COMBATPISTOL`] = `COMPONENT_AT_PI_FLSH`,
        [`WEAPON_HEAVYPISTOL`] = `COMPONENT_AT_PI_FLSH`,
    },
    scope = {
        [`WEAPON_MICROSMG`] = `COMPONENT_AT_SCOPE_MACRO`,
        [`WEAPON_SMG_MK2`] = `COMPONENT_AT_SCOPE_MACRO_02_SMG_MK2`,
    },
    scope2 = {
        [`WEAPON_SMG_MK2`] = `COMPONENT_AT_SCOPE_SMALL_SMG_MK2`,
    },
}

Config['licenses'] = {
    ['seu_pd'] = 'Licencja SEU',
    ['heli_pd'] = 'Licencja ASU',
    ['mr_pd'] = 'Licencja Motocykle',
    ['cs_pd'] = 'Licencja Zarząd',
    ['hwp_pd'] = 'Licencja HWP',
    ['cttf_pd'] = 'Licencja C.T.T.F'
}

Config['announcements'] = {
    Messages = {
        'Pamiętaj, że możesz odbierać /kit start co 3 godziny',
        'Skrzynki możesz otwierać za pomocą /skrzynki',
        'Zapraszamy na naszą stronę: https://skam.club',
        'Użyj F4 aby otworzyć panel gracza',
        'Pamiętaj, aby zapoznać się z regulaminem serwera'
    }
}

Config['duels'] = {
    TimeToDraw = 60,
    Teleports = {
        vector4(1004.845, -2524.931, 28.30514-0.9, 274.8314),
        vector4(-1108.6080, 13.6221, 49.5878, 259.7252)
    },
    Locations = {
        ['Rury'] = {
            vector4(2483.7212, 1533.5035, 33.9439, 94.8406),
            vector4(2419.0771, 1535.2861, 33.9942, 266.3807)
        },
        ['Szopa'] = {
            vector4(1551.9854, 2193.9490, 77.9731, 180.0976),
            vector4(1552.2271, 2152.1086, 77.9916, 358.9707)
        },
        ['Rampy'] = {
            vector4(-262.9098, -1556.7623, 30.9489, 168.0365),
            vector4(-268.9475, -1586.0828, 30.9493, 348.3157)
        },
        ['Domki'] = {
            vector4(249.6030, 3092.6907, 41.6532, 6.0100),
            vector4(253.1388, 3185.8748, 41.8008, 182.7244)
        },
        ['La Fuenta'] = {
            vector4(1434.8208, 1154.1841, 114.1708-.9, 266.6116),
            vector4(1475.1462, 1154.2867, 114.2992-.9, 85.4899)
        },
        ['Mini Losty'] = {
            vector4(2329.5444, 2558.6035, 45.6894, 349.1674),
            vector4(2331.0789, 2599.3416, 45.6676, 181.8025)
        },
        ['Kościół'] = {
            vector4(-304.4837, 2828.6611, 57.6459, 149.9363),
            vector4(-330.0071, 2790.3962, 58.2699, 320.4191)
        },
    }
}

Config['heists'] = {
    hackingItem = 'napad-laptop',
    list = {
        ['FleecaVespucciBoulevard'] = {
            difficulty = 'easy',
            coords = vector3(147.0, -1044.86, 29.47-.95),
            moneyReward = {min = 1150000, max = 1500000},
            heistName = 'Fleeca Bank (Vespucci Boulevard)',
            secondsRemaining = 300,
            policeRequired = 5,
            blip = {
                icon = 891,
                color = 4,
                size = 0.8,
            },
            requiredItems = {
                {name = 'napad-laptop', count = 1}
            },
            dropItems = {
                {name = 'napad-pacific', countMin = 1, countMax = 1, chance = 60},
                {name = 'napad-debentures', countMin = 1, countMax = 1, chance = 50},
                {name = 'napad-lifeinvader', countMin = 1, countMax = 1, chance = 15},
                {name = 'napad-casino', countMin = 1, countMax = 1, chance = 5},
            },
            enabled = true,
        },
        ['FleecaBoulevardDelPerro'] = {
            difficulty = 'easy',
            coords = vector3(-1211.65, -335.63, 37.79-.95),
            moneyReward = {min = 1150000, max = 1500000},
            heistName = 'Fleeca Bank (Boulevard Del Perro)',
            secondsRemaining = 300,
            policeRequired = 5,
            blip = {
                icon = 891,
                color = 4,
                size = 0.8,
            },
            requiredItems = {
                {name = 'napad-laptop', count = 1}
            },
            dropItems = {
                {name = 'napad-pacific', countMin = 1, countMax = 1, chance = 60},
                {name = 'napad-debentures', countMin = 1, countMax = 1, chance = 50},
                {name = 'napad-lifeinvader', countMin = 1, countMax = 1, chance = 15},
                {name = 'napad-casino', countMin = 1, countMax = 1, chance = 5},
            },
            enabled = true,
        },
        ['FleecaGreatOceanHighway'] = {
            difficulty = 'easy',
            coords = vector3(-2957.52, 481.71, 15.7-.95),
            moneyReward = {min = 1150000, max = 1500000},
            heistName = 'Fleeca Bank (Great Ocean Highway)',
            secondsRemaining = 300,
            policeRequired = 5,
            blip = {
                icon = 891,
                color = 4,
                size = 0.8,
            },
            requiredItems = {
                {name = 'napad-laptop', count = 1}
            },
            dropItems = {
                {name = 'napad-pacific', countMin = 1, countMax = 1, chance = 60},
                {name = 'napad-debentures', countMin = 1, countMax = 1, chance = 50},
                {name = 'napad-lifeinvader', countMin = 1, countMax = 1, chance = 15},
                {name = 'napad-casino', countMin = 1, countMax = 1, chance = 5},
            },
            enabled = true,
        },
        ['FleecaHawickAvenue'] = {
            difficulty = 'easy',
            coords = vector3(-353.57, -54.08, 49.04-.95),
            moneyReward = {min = 1150000, max = 1500000},
            heistName = 'Fleeca Bank (Hawick Avenue)',
            secondsRemaining = 300,
            policeRequired = 5,
            blip = {
                icon = 891,
                color = 4,
                size = 0.8,
            },
            requiredItems = {
                {name = 'napad-laptop', count = 1}
            },
            dropItems = {
                {name = 'napad-pacific', countMin = 1, countMax = 1, chance = 60},
                {name = 'napad-debentures', countMin = 1, countMax = 1, chance = 50},
                {name = 'napad-lifeinvader', countMin = 1, countMax = 1, chance = 15},
                {name = 'napad-casino', countMin = 1, countMax = 1, chance = 5},
            },
            enabled = true,
        },
        ['FleecaHawickAvenue2'] = {
            difficulty = 'easy',
            coords = vector3(311.4, -283.19, 54.16-.95),
            moneyReward = {min = 1150000, max = 1500000},
            heistName = 'Fleeca Bank (Hawick Avenue 2)',
            secondsRemaining = 300,
            policeRequired = 5,
            blip = {
                icon = 891,
                color = 4,
                size = 0.8,
            },
            requiredItems = {
                {name = 'napad-laptop', count = 1}
            },
            dropItems = {
                {name = 'napad-pacific', countMin = 1, countMax = 1, chance = 60},
                {name = 'napad-debentures', countMin = 1, countMax = 1, chance = 50},
                {name = 'napad-lifeinvader', countMin = 1, countMax = 1, chance = 15},
                {name = 'napad-casino', countMin = 1, countMax = 1, chance = 5},
            },
            enabled = true,
        },
        ['FleecaRoute68'] = {
            difficulty = 'easy',
            coords = vector3(1176.28, 2711.66, 38.09-.95),
            moneyReward = {min = 1150000, max = 1500000},
            heistName = 'Fleeca Bank (Route 68)',
            secondsRemaining = 300,
            policeRequired = 5,
            blip = {
                icon = 891,
                color = 4,
                size = 0.8,
            },
            requiredItems = {
                {name = 'napad-laptop', count = 1}
            },
            dropItems = {
                {name = 'napad-pacific', countMin = 1, countMax = 1, chance = 60},
                {name = 'napad-debentures', countMin = 1, countMax = 1, chance = 50},
                {name = 'napad-lifeinvader', countMin = 1, countMax = 1, chance = 15},
                {name = 'napad-casino', countMin = 1, countMax = 1, chance = 5},
            },
            enabled = true,
        },
        ['Lifeinvader'] = {
            difficulty = 'medium',
            coords = vector3(-1054.0555, -233.0622, 44.0211 - 0.9),
            moneyReward = {min = 500000, max = 750000},
            heistName = 'Lifeinvader',
            secondsRemaining = 300,
            policeRequired = 4,
            blip = {
                icon = 521,
                color = 1,
                size = 0.8,
            },
            requiredItems = {
                {name = 'napad-lifeinvader', count = 1}
            },
            dropItems = {
                {name = 'napad-lifeinvader', countMin = 1, countMax = 1, chance = 70},
                {name = 'napad-pendrive', countMin = 1, countMax = 1, chance = 50},
                {name = 'napad-laptop', countMin = 1, countMax = 1, chance = 10},
            },
            enabled = true,
        },
        ['Jubiler'] = {
            difficulty = 'medium',
            coords = vector3(-630.79, -229.19, 38.06-.95),
            moneyReward = {min = 800000, max = 1000000},
            heistName = 'Jubiler',
            secondsRemaining = 300,
            policeRequired = 4,
            blip = {
                icon = 617,
                color = 1,
                size = 0.8,
            },
            requiredItems = {
                {name = 'napad-lifeinvader', count = 1}
            },
            dropItems = {
                {name = 'napad-laptop', countMin = 1, countMax = 1, chance = 60},
                {name = 'napad-pacific', countMin = 1, countMax = 1, chance = 15},
                {name = 'napad-lifeinvader', countMin = 1, countMax = 1, chance = 5},
            },
            enabled = true,
        },
        ['BlaineCounty'] = {
            difficulty = 'medium',
            coords = vector3(-103.77, 6477.87, 31.63-.95),
            moneyReward = {min = 1150000, max = 1500000},
            heistName = 'Blaine County Savings Bank',
            secondsRemaining = 300,
            policeRequired = 5,
            blip = {
                icon = 891,
                color = 4,
                size = 0.8,
            },
            requiredItems = {
                {name = 'napad-laptop', count = 1}
            },
            dropItems = {
                {name = 'napad-pacific', countMin = 1, countMax = 1, chance = 60},
                {name = 'napad-debentures', countMin = 1, countMax = 1, chance = 50},
                {name = 'napad-lifeinvader', countMin = 1, countMax = 1, chance = 15},
                {name = 'napad-casino', countMin = 1, countMax = 1, chance = 5},
            },
            enabled = true,
        },
        ['PacificBank'] = {
            difficulty = 'medium',
            coords = vector3(255.69, 225.27, 101.88-.95),
            moneyReward = {min = 1700000, max = 2200000},
            heistName = 'Pacific Standard Bank',
            secondsRemaining = 480,
            policeRequired = 6,
            blip = {
                icon = 674,
                color = 1,
                size = 0.8,
            },
            requiredItems = {
                {name = 'napad-pacific', count = 1}
            },
            dropItems = {
                {name = 'napad-lifeinvader', countMin = 1, countMax = 1, chance = 50},
                {name = 'napad-laptop', countMin = 1, countMax = 1, chance = 20},
                {name = 'napad-casino', countMin = 1, countMax = 1, chance = 10},
            },
            enabled = true,
        },
    }
}