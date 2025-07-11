Config = {}

Config.BoosterRoleID = 923564398012932178

Config.Info = {
    firstLogoPart = "SKAM",
    secondLogoPart = "CASE",
    color = "#999999",
    shopLink = "https://indrop.eu/s/skam"
}

Config.Events = {
    time = "26 October 2025 00:00:00 UTC+2", 
    img = "https://i.ibb.co/4KywRq0/image-128.png",
}

Config.Giveaway = true
Config.Giveaway = {
   item = {category = "AUTO", rarity = "green", title = "TESLA MODEL ?", img = "https://r2.fivemanage.com/pub/2od1b0qzzxle.png", chance = 0.5, price = 0},
   price = "1200",
   time = "26 October 2025 17:15:30 UTC+2",
}

Config.CaseCategory = {
    -- {
    --     title = 'SKRZYNKI EVENTOWE',
    --     cases = {
    --         { id = 200, title = 'Points Case', img = 'https://i.ibb.co/8NpnL2Y/image-84.png', price = 100, oldprice = 0, isNew = true, points = true}
    --     }
    -- },
    {
        title = 'SKRZYNKI',
        cases = {
            { id = 1, title = 'Crime Case', img = 'https://i.ibb.co/n8qqVqz/image-51.png', price = 300, oldprice = 550, isNew = false},
          --  { id = 2, title = '50/50 Case', img = 'https://i.ibb.co/xq7vMcD/599140fd-72f0-4491-8d50-09a058f5d459.webp', price = 200, oldprice = 0, isNew = false},
          --  { id = 3, title = 'Gold Case', img = 'https://i.ibb.co/VmDh7Ks/bmww.png', price = 600, oldprice = 0, isNew = false},
          --  { id = 4, title = 'Animated Case', img = 'https://i.ibb.co/d7JLJx3/image-49.png', price = 1000, oldprice = 0, isNew = false},
          --  { id = 5, title = 'Millionare Case', img = 'https://i.ibb.co/rpMbxRX/image-79.png', price = 1800, oldprice = 2000, isNew = false},
        }
    },
     {
         title = 'SKRZYNKI ZA PUNKTY',
         cases = {
            -- { id = 100, title = 'Stars Case', img = 'https://i.ibb.co/8NpnL2Y/image-84.png', price = 800, oldprice = 0, isNew = true, points = true}
         }
     },
    {
        title = 'POZOSTAŁE SKRZYNKI',
        cases = {
            { id = 71234, title = 'Booster', img = 'https://i.ibb.co/bKtHgc8/image-82.png', price = 0, booster = true}
        }
    },
}

Config.Cases = {
    ["1"] = {
        title = 'RISK CASE',
        price = 300,
        items = {
            {category = "item", rarity = "blue", title = "Pistolet Vintage", name = 'vintagepistol', count = 1, img = "null", chance = 20, price = 70, points = 15},
            {category = "item", rarity = "blue", title = "Paczka Metaamfetaminy x10", name = 'narco-meth-paczka', count = 10, img = "https://i.ibb.co/zVTBYR0/meta.png", chance = 20, price = 75, points = 14},
            {category = "item", rarity = "blue", title = "Kamizelka lekka", name = 'lightvest x5', count = 5, img = "null", chance = 20, price = 70, points = 10},
            {category = "item", rarity = "purple", title = "Kamizelka średnia", name = 'mediumvest', count = 2, img = "null", chance = 10, price = 100, points = 41},
            {category = "item", rarity = "purple", title = "Pistolet SNS", name = 'weapon_snspistol', count = 1, img = "https://i.ibb.co/2jzCKtL/sns.png", chance = 10, price = 110, points = 25},
            {category = "item", rarity = "purple", title = "Paczka zioła x5", name = 'ability-joint', count = 5, img = "https://i.ibb.co/7vmr7Qp/joint.png", chance = 5, price = 110, points = 25},
            {category = "money", rarity = "purple", title = "Gotówka x100000", name = 'money', count = 100000, img = "https://i.ibb.co/ZJMWBkM/money.png", chance = 5, price = 180, points = 41},
            {category = 'item', rarity = 'gold', title = 'Nic', name = 'cwel', count = 1, img = 'null', chance = 3, price = 0, points = 0},
            {category = "item", rarity = "gold", title = "Fentanyl x1", name = 'fentanyl', count = 1, img = "null", chance = 2, price = 190, points = 54},
            {category = "item", rarity = "gold", title = "Pistolet Ceramiczny", name = 'caramicpistol', count = 1, img = "null", chance = 2, price = 185, points = 55},
            {category = "money", rarity = "gold", title = "Gotówka x500000", name = 'money', count = 500000, img = "https://i.ibb.co/ZJMWBkM/money.png", chance = 1.5, price = 190, points = 59},
            {category = "item", rarity = "gold", title = "Bon na Vipa 7 dni", name = 'ticket-vip7', count = 1, img = "https://i.ibb.co/dWLzPr9/vip7.png", chance = 1.5, price = 190, points = 60},
        }
    },
    ["2"] = {
        title = '50/50 CASE',
        price = 200,
        points = false,
        items = {
            {category = "car", rarity = "blue", title = "Samochód Cheburek", name = 'cheburek', count = 1, img = "https://i.ibb.co/LzbBZwr/cheburek.png", chance = 50, price = 25, points = 15},
            {category = "car", rarity = "pink", title = "Samochód M5", name = '404_m5off', count = 1, img = "https://r2.fivemanage.com/M5W3SoC4arMYbexPATHmo/404_m5off.png", chance = 50, price = 200, points = 25},

        }
    },
    ["3"] = {
        title = 'GOLDEN CASE',
        price = 600,
        points = false,
        items = {
            {category = "item", rarity = "blue", title = "SMG Ammo x500", name = 'smg_ammo', count = 500, img = "https://r2.fivemanage.com/AGPalBu8NXp4pzQU3xysv/AmmoBox_9mm_2048.webp", chance = 45, price = 150, points = 15},
            {category = "money", rarity = "blue", title = "Gotówka x500000", name = 'money', count = 500000, img = "https://i.ibb.co/dG9wnGh/money2.png", chance = 15, price = 300},
            {category = "item", rarity = "pink", title = "Bon na Vipa 30 Dni", name = 'ticket-vip30', count = 1, img = "https://i.ibb.co/gFmnGYL/vip30.png", chance = 9.8, price = 350, points = 15},
            {category = "item", rarity = "pink", title = "Joint x200", name = 'ability-joint', count = 200, img = "https://i.ibb.co/7vmr7Qp/joint.png", chance = 12, price = 350, points = 15},
            {category = "item", rarity = "pink", title = "Powiekszony Magazynek V2", name = 'extendedclip2', count = 1, img = "https://r2.fivemanage.com/AGPalBu8NXp4pzQU3xysv/Extended_Mag_93R.webp", chance = 10, price = 350, points = 15},
            {category = "voucher", rarity = "red", title = "Voucher 700 monet", name = 'voucher', count = 1, img = "https://i.ibb.co/Mcy70Nv/voucher700.png", chance = 5.2, price = 700, points = 25},
            {category = "item", rarity = "gold", title = "Micro SMG", name = 'microsmg', count = 1, img = "https://r2.fivemanage.com/AGPalBu8NXp4pzQU3xysv/MicroSMG-GTAV-beta.webp", chance = 3, price = 777, points = 150},

        }
    },
    ["4"] = {
        title = 'ANIMATED CASE',
        price = 1000,
        points = false,
        items = {
            {category = "car", rarity = "blue", title = "Samochód Passat", name = 'VOLKSSLE', count = 1, img = "https://r2.fivemanage.com/AGPalBu8NXp4pzQU3xysv/removal.ai_dd5e10d1-d23f-4c74-9a3b-d9bf6a81e4fb-obraz_2024-11-14_204325083.png", chance = 70, price = 25, points = 15},
            {category = "car", rarity = "gold", title = "Samochód Supra MK4", name = 'TOYOTAFT', count = 1, img = "https://r2.fivemanage.com/AGPalBu8NXp4pzQU3xysv/removal.ai_6c892218-1e9b-442f-a5d8-24ad5abd8a74-obraz_2024-11-14_203846225.png", chance = 10, price = 1200, points = 250},
            {category = "car", rarity = "gold", title = "Samochód RX7", name = 'KillerRx7', count = 1, img = "https://r2.fivemanage.com/AGPalBu8NXp4pzQU3xysv/removal.ai_9c38121c-ee2b-428e-ab64-9b50ce088243-obraz_2024-11-14_203628941.png", chance = 10, price = 1200, points = 250},
            {category = "car", rarity = "gold", title = "Samochód Jesko", name = 'jeskoanim', count = 1, img = "https://r2.fivemanage.com/AGPalBu8NXp4pzQU3xysv/removal.ai_538f8e9f-575a-445e-8ac4-066a5117488b-obraz_2024-11-14_203057803.png", chance = 10, price = 1200, points = 250},

        }
    },
    ["5"] = {
        title = 'MILLIONARE CASE',
        price = 1800,
        points = false,
        items = {
            {category = "money", rarity = "blue", title = "Gotówka x10,000,000", name = 'money', count = 10000000, img = "https://i.ibb.co/ZJMWBkM/money.png", chance = 60, price = 500, points = 15},
            {category = "voucher", rarity = "blue", title = "Voucher 700 Monet", name = 'voucher', count = 1, img = "https://i.ibb.co/Mcy70Nv/voucher700.png", chance = 29, price = 700, points = 15},
            {category = "car", rarity = "red", title = "Samochód F8 Tributo", name = 'f8tributo', count = 1, img = "https://r2.fivemanage.com/AGPalBu8NXp4pzQU3xysv/removal.ai_95d54a53-add8-4893-9621-16421a7f34f9-obraz_2024-11-14_210830210.png", chance = 5, price = 2000, points = 25},
            {category = "car", rarity = "red", title = "Samochód Chiron", name = 'chironps', count = 1, img = "https://r2.fivemanage.com/AGPalBu8NXp4pzQU3xysv/removal.ai_57c670ee-767f-4c61-be1e-c706b9b62295_obraz_2024-11-14_211307589.png", chance = 5, price = 2000, points = 25},
            {category = "item", rarity = "gold", title = "Revolver", name = 'revolver', count = 1, img = "https://r2.fivemanage.com/AGPalBu8NXp4pzQU3xysv/Heavy-revolver-mk2.webp", chance = 1, price = 2500, points = 1000},

        }
    },
    ["100"] = {
        title = 'Stars Case',
        price = 800,
        points = true,
        items = {
            {category = "money", rarity = "blue", title = "Gotówka x5,000,000", name = 'money', count = 5000000, img = "https://i.ibb.co/ZJMWBkM/money.png", chance = 50, price = 5},
            {category = "item", rarity = "blue", title = "Porcja Mety x500", name = 'narco-meth-paczka', count = 500, img = "https://i.ibb.co/zVTBYR0/meta.png", chance = 10, price = 20},
            {category = "voucher", rarity = "blue", title = "Voucher 50 Monet", name = 'voucher', count = 1, img = "https://i.ibb.co/CJdtvn7/voucher50.png", chance = 20, price = 50},
            {category = "item", rarity = "pink", title = "1x Części Broni", name = 'element-dluga', count = 1, img = "xxxx", chance = 3, price = 80},
            {category = "item", rarity = "pink", title = "500x Amunicja do długiej", name = 'rifle_ammo', count = 500, img = "xxxx", chance = 5, price = 80},
            {category = "item", rarity = "pink", title = "Bon na Vipa 7 dni", name = 'ticket-vip7', count = 1, img = "https://i.ibb.co/dWLzPr9/vip7.png", chance = 6, price = 100},
            {category = "item", rarity = "red", title = "2x Części Broni", name = 'element-dluga', count = 2, img = "xxxx", chance = 2, price = 150},
            {category = "item", rarity = "red", title = "1000x Amunicja do długiej", name = 'rifle_ammo', count = 1000, img = "xxxx", chance = 3, price = 150},
            {category = "item", rarity = "gold", title = "3x Części Broni", name = 'element-dluga', count = 3, img = "xxxx", chance = 1, price = 200},
        }
    },

    ["71234"] = {
        title = 'BOOSTER CASE',
        price = 0,
        items = {
            {category = "car", rarity = "blue", title = "Rower BMX", name = 'bmx', count = 1, img = "https://i.ibb.co/nb8SKRW/bmx.png", chance = 15.4, price = 25},
            {category = "money", rarity = "blue", title = "Gotówka x15000", name = 'money', count = 15000, img = "https://i.ibb.co/dG9wnGh/money2.png", chance = 14, price = 35},
            {category = "item", rarity = "blue", title = "Pistolet SNS x1", name = 'weapon_snspistol', count = 1, img = "https://i.ibb.co/2jzCKtL/sns.png", chance = 13.6, price = 40},
            {category = "item", rarity = "purple", title = "Nóż", name = 'knife', count = 1, img = "https://r2.fivemanage.com/AGPalBu8NXp4pzQU3xysv/W_ME_Knife.webp", chance = 11, price = 45},
            {category = "item", rarity = "purple", title = "Amunicja do pistoletu x100", name = 'pistol_ammo', count = 100, img = "https://r2.fivemanage.com/M5W3SoC4arMYbexPATHmo/pistol_ammo_box.png", chance = 9.8, price = 50},
            {category = "item", rarity = "purple", title = "Bon na Vipa 7 dni", name = 'ticket-vip7', count = 1, img = "https://i.ibb.co/dWLzPr9/vip7.png", chance = 7.9, price = 70},
            {category = "item", rarity = "pink", title = "Metka x250", name = 'meth_pooch', count = 250, img = "https://i.ibb.co/zVTBYR0/meta.png", chance = 7, price = 80},
            {category = "item", rarity = "pink", title = "SMG Ammo x100", name = 'smg_ammo', count = 100, img = "https://r2.fivemanage.com/AGPalBu8NXp4pzQU3xysv/AmmoBox_9mm_2048.webp", chance = 5.9, price = 100},
            {category = "voucher", rarity = "pink", title = "Voucher 200 monet", name = 'voucher', count = 1, img = "https://i.ibb.co/71n0vZB/voucher200.png", chance = 5.3, price = 200},
            {category = "item", rarity = "red", title = "Pistolet ProVint x2", name = 'skam_sw', count = 2, img = "https://r2.fivemanage.com/pub/6ot841n3kslm.png", chance = 4, price = 180},
            {category = "car", rarity = "gold", title = "Samochód RX7", name = 'KillerRx7', count = 1, img = "https://r2.fivemanage.com/AGPalBu8NXp4pzQU3xysv/removal.ai_9c38121c-ee2b-428e-ab64-9b50ce088243-obraz_2024-11-14_203628941.png", chance = 3.8, price = 145},
            {category = "car", rarity = "gold", title = "Samochód G900 Mansory", name = 'manso6633', count = 1, img = "https://r2.fivemanage.com/M5W3SoC4arMYbexPATHmo/manso6633.png", chance = 2.3, price = 200},
        }
    },

    ["71233"] = {
        title = "DARMOWA SKRZYNKA",
        price = 0,
        items = {
            {category = "money", rarity = "blue", title = "Gotówka x10000", name = 'money', count = 500, img = "https://i.ibb.co/dG9wnGh/money2.png", chance = 21.6, price = 5, points = 1},
            {category = "voucher", rarity = "blue", title = "Voucher 10 monet", name = 'voucher', count = 10, img = "https://i.ibb.co/cL7RNcG/voucher10.png", chance = 20, price = 10, points = 3},
            {category = "item", rarity = "blue", title = "RedBull x200", name = 'energydrink', count = 200, img = "https://i.ibb.co/9T4s2dL/redbull.png", chance = 15.3, price = 11, points = 4},
            {category = "item", rarity = "pink", title = "Kajdanki x1", name = 'handcuff', count = 1, img = "https://r2.fivemanage.com/pub/icnxhkb921f2.png", chance = 11.8, price = 13, points = 6},
            {category = "item", rarity = "pink", title = "Zestaw naprawczy x1", name = 'fixkit', count = 1, img = "https://r2.fivemanage.com/pub/cjcd3c9igkfk.png", chance = 10, price = 15, points = 7},
            {category = "car", rarity = "pink", title = "Rower BMX", name = 'bmx', count = 1, img = "https://i.ibb.co/nb8SKRW/bmx.png", chance = 7.1, price = 20, points = 9},
            {category = "voucher", rarity = "red", title = "Voucher 25 monet", name = 'voucher', count = 25, img = "https://i.ibb.co/r7GTV1L/voucher25.png", chance = 5.2, price = 25, points = 10},
            {category = "item", rarity = "red", title = "Amunicja do pistoletu x10", name = 'pistol_ammo', count = 10, img = "https://r2.fivemanage.com/M5W3SoC4arMYbexPATHmo/pistol_ammo_box.png", chance = 3.2, price = 27, points = 11},
            {category = "car", rarity = "red", title = "Samochód Club", name = 'club', count = 1, img = "https://r2.fivemanage.com/pub/6rblh3yp3pf3.png", chance = 2.4, price = 28, points = 13},
            {category = "voucher", rarity = "gold", title = "Voucher 50 monet", name = 'voucher', count = 50, img = "https://i.ibb.co/CJdtvn7/voucher50.png", chance = 1.9, price = 50, points = 15},
            {category = "item", rarity = "gold", title = "Pistolet SNS x1", name = 'snspistol', count = 1, img = "https://i.ibb.co/2jzCKtL/sns.png", chance = 1.2, price = 55, points = 18},
            {category = "voucher", rarity = "gold", title = "Voucher 200 monet", name = 'voucher', count = 1, img = "https://i.ibb.co/71n0vZB/voucher200.png", chance = 0.3, price = 200, points = 20},
        }
    },
}

Config.ShopItems  = {
    --{category = "car", rarity = 'gold', title = 'BMW X6', name = 'x666', count = 10, img = "https://i.ibb.co/8b5zCJd/obraz-2025-01-16-153840241.png", price = 3800},
    --{category = "car", rarity = 'gold', title = 'BUGATTI Atlantic', name = 'rmodatlantic', count = 5, img = "?????????????????????????????", price = 5000},
    --{category = "car", rarity = 'red', title = 'MCLAREN 570s', name = 'zacoe570s', count = 10, img = "https://i.ibb.co/RTknMvGk/obraz-2025-01-30-141924364.png", price = 2800},
    {category = "car", rarity = 'gold', title = 'Lambo Ultimae', name = 'limitedcarchest3_lamboultimae', count = 10, img = "https://i.ibb.co/KcQ5C52B/obraz-2025-01-30-142826348.png", price = 3800},
    --{category = "car", rarity = 'gold', title = 'BUGATTI Chiron', name = 'limitedcarchest3_ikx3chironss22', count = 10, img = "https://i.ibb.co/jPWpBk8m/obraz-2025-01-30-142044836.png", price = 3800},
    --{category = "car", rarity = 'gold', title = 'BMW M4 CSL (2023)', name = 'limitedcarchest3_bmwm4csl23', count = 5, img = "https://i.ibb.co/LfD0f62/obraz-2025-01-30-142855889.png", price = 3800},
    --{category = "car", rarity = 'gold', title = 'Maseratti MC20', name = 'limitedcarchest3_mmc20', count = 10, img = "https://i.ibb.co/j95X1n0G/obraz-2025-01-30-142943088.png", price = 3800},
    --{category = "car", rarity = 'red', title = 'AUDI R8', name = 'jpr8', count = 10, img = "https://i.ibb.co/C3cQGLKF/obraz-2025-01-30-142129954.png", price = 2800},
    {category = "car", rarity = 'red', title = 'BRABUS G900', name = '2020g900', count = 10, img = "https://i.ibb.co/HLbVB79d/obraz-2025-01-30-142209910.png", price = 2800},
    --{category = "car", rarity = 'red', title = 'PORSCHE GT3 DEMON', name = 'gt3demon', count = 10, img = "https://i.ibb.co/4nq1tnz5/obraz-2025-01-30-142255800.png", price = 2800},
    {category = "car", rarity = 'red', title = 'BMW M3', name = 'm323', count = 10, img = "https://i.ibb.co/fGvvtqQV/obraz-2025-01-30-142357638.png", price = 2800},
    --{category = "car", rarity = 'red', title = 'Alfa Giulia', name = 'AlfaGiuliaGTAM23', count = 10, img = "https://i.ibb.co/h5pdYJw/obraz-2025-01-30-142426390.png", price = 2800},
    --{category = "car", rarity = 'red', title = 'Lambo Huracan', name = 'dphuracan24', count = 10, img = "https://i.ibb.co/JJ6BtX9/obraz-2025-01-30-142500929.png", price = 2800},
    --{category = "car", rarity = 'red', title = 'McLaren 720', name = 'sou_720_wb', count = 10, img = "https://i.ibb.co/DDxBnfT0/obraz-2025-01-30-142529994.png", price = 2800},
    --{category = "car", rarity = 'red', title = 'Maseratti', name = 'xmc20', count = 10, img = "https://i.ibb.co/8gkxxrSd/obraz-2025-01-30-142616059.png", price = 2800},
    --{category = "car", rarity = 'red', title = 'McLaren SENNA', name = 'SENNA', count = 10, img = "https://i.ibb.co/Mk9F00b1/obraz-2025-01-30-142648518.png", price = 2800},
    --{category = "car", rarity = 'red', title = 'BMW M3 CS (2018)', name = 'bumbim3', count = 10, img = "https://i.ibb.co/H3dn939/obraz-2025-01-30-142718022.png", price = 2800},
    --{category = "car", rarity = 'red', title = 'Mercedes E55', name = 'benze55', count = 10, img = "https://i.ibb.co/n8m0H6Cf/obraz-2025-01-30-142758552.png", price = 2800},
    --{category = "car", rarity = 'pink', title = 'BOMBOWÓZ X700', name = 'x700', count = 10, img = "https://i.ibb.co/SD9dJ82R/obraz-2025-01-30-143040081.png", price = 2800},
    {category = "car", rarity = 'pink', title = 'DODGE RAM TRX', name = 'TRX', count = 10, img = "https://i.ibb.co/CKhVDwzc/obraz-2025-01-30-143009828.png", price = 2000},
    -- {category = "car", rarity = 'blue', title = 'PORSCHE GT3 RS (PD)', name = 'vc_polgt3rs', count = 10, img = "https://i.ibb.co/8b5zCJd/obraz-2025-01-16-153840241.png", price = 3800},
    -- {category = "car", rarity = 'blue', title = 'BMW M3 (PD)', name = 'bmwm3bpd', count = 10, img = "https://i.ibb.co/8b5zCJd/obraz-2025-01-16-153840241.png", price = 3800},
    -- {category = "car", rarity = 'blue', title = 'BMW M3 (PD)', name = 'bmwm3bpd', count = 10, img = "https://i.ibb.co/8b5zCJd/obraz-2025-01-16-153840241.png", price = 3800},
    -- {category = "car", rarity = 'blue', title = 'Nissan R35 (PD)', name = 'r35kream', count = 5, img = "https://i.ibb.co/8b5zCJd/obraz-2025-01-16-153840241.png", price = 3800},
    -- {category = "car", rarity = 'blue', title = 'Lambo Huracan (PD)', name = 'hurcop', count = 5, img = "https://i.ibb.co/8b5zCJd/obraz-2025-01-16-153840241.png", price = 3800},
    -- {category = "car", rarity = 'blue', title = 'GOLF 8R (PD)', name = 'vc_polgolf8r', count = 5, img = "https://i.ibb.co/8b5zCJd/obraz-2025-01-16-153840241.png", price = 3800},
    -- {category = "car", rarity = 'blue', title = 'Nissan R36 (PD)', name = 'nm_r36', count = 5, img = "https://i.ibb.co/8b5zCJd/obraz-2025-01-16-153840241.png", price = 3800},
}

Config.AllItems = {}