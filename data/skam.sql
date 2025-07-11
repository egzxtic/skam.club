CREATE DATABASE IF NOT EXISTS `skam.database`;
USE `skam.database`;

CREATE TABLE IF NOT EXISTS `banking` (
  `identifier` varchar(46) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `amount` int(11) DEFAULT NULL,
  `time` bigint(20) DEFAULT NULL,
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `balance` int(11) DEFAULT 0,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `bank_transactions` (
  `id` int(11) NOT NULL,
  `identifier` varchar(46) DEFAULT NULL,
  `type` enum('deposit','withdraw') NOT NULL,
  `amount` int(11) NOT NULL,
  `date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
  
CREATE TABLE IF NOT EXISTS `bans` (
  `license` varchar(50) NOT NULL,
  `steamhex` varchar(46) DEFAULT NULL,
  `name` varchar(32) DEFAULT NULL,
  `discord` varchar(30) DEFAULT NULL,
  `hwid` longtext DEFAULT NULL,
  `reason` varchar(255) DEFAULT NULL,
  `added` datetime DEFAULT current_timestamp(),
  `live` varchar(21) DEFAULT NULL,
  `xbl` varchar(21) DEFAULT NULL,
  `expired` varchar(50) DEFAULT '0',
  `bannedby` varchar(32) DEFAULT NULL,
  `isBanned` int(11) DEFAULT 0,
  `banid` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`banid`)
) ENGINE=InnoDB AUTO_INCREMENT=87373 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `communityservice` (
  `identifier` varchar(46) NOT NULL,
  `actions_remaining` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `deposits` (
  `identifier` varchar(46) NOT NULL,
  `items` longtext DEFAULT NULL,
  `money` int(11) DEFAULT 0,
  PRIMARY KEY (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `items` (
  `name` varchar(50) NOT NULL,
  `label` varchar(50) NOT NULL,
  `weight` int(11) NOT NULL DEFAULT 1,
  `rare` tinyint(4) NOT NULL DEFAULT 0,
  `can_remove` tinyint(4) NOT NULL DEFAULT 1,
  `limit` int(11) NOT NULL DEFAULT -1,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`, `limit`) VALUES
('ability-joint', 'Joint', 1, 0, 1, 500),
('assaultrifle', 'AK-47', 50, 0, 1, 2),
('assaultsmg', 'Szturmowe SMG', 1, 0, 1, 5),
('bat', 'Kij Bejsbolowy', 1, 0, 1, 5),
('bojowka_sw', 'Pistolet: ProVint', 10, 0, 1, -1),
('car-token', 'Car Token', 0, 1, -1, 5),
('carbinerifle', 'Karabin M4', 50, 0, 1, 2),
('case-basic', 'Skrzynka Obywatela', 1, 0, 1, 20),
('case-premium', 'Skrzynka Premium', 1, 0, 1, 20),
('case-weapon', 'Skrzynka Broni', 1, 0, 1, 20),
('ceramicpistol', 'Pistolet Ceramiczny', 1, 0, 1, 50),
('clip', 'Magazynek do Pistoletu', 0, 0, 1, 5),
('clip_default', 'Standardowy Magazynek', 0, 0, 1, 5),
('clip_extended', 'Rozszerzony Magazynek', 0, 0, 1, 5),
('crowbar', 'Łom', 1, 0, 1, 5),
('custom-beretta', 'Pistolet: Beretta', 10, 0, 1, 1),
('custom-glock18', 'Pistolet (Auto): Glock18', 10, 0, 1, -1),
('custom-glock22', 'Pistolet: Glock22', 1, 0, 1, -1),
('custom-mp9', 'Karabinek: MP9', 10, 0, 1, -1),
('element-dluga', 'Części Broni', 10, 1, 1, 15),
('energydrink', 'Bojowka Energy', 1, 0, 1, 500),
('extendedclip2', 'Powiększony magazynek V2', 1, 0, 1, 5),
('flashlight', 'Latarka', 1, 0, 1, 5),
('gps', 'GPS', 1, 0, 1, 5),
('handcuffs', 'Kajdanki', 1, 0, 1, 5),
('heavypistol', 'Pistolet Heavy', 1, 0, 1, 50),
('heavyrifle', 'Ciężki Karabin Szturmowy', 50, 0, 1, 2),
('Karabin Militarny', 'militaryrifle', 1, 0, 1, 5),
('karta-boost-pojazd-limitowany', 'BOOST Pojazdu Limitowanego (KARTA)', 0, 1, -1, 5),
('karta-custom-tag', 'Custom TAG (KARTA)', 0, 1, -1, 5),
('karta-kamizeleczka-org', 'Kamizelka (KARTA)', 0, 1, -1, 5),
('karta-koszuleczka-org', 'Koszulka (KARTA)', 0, 1, -1, 5),
('karta-pojazd-limitowany', 'Pojazd Limitowany (KARTA)', 0, 1, -1, 5),
('karta-zmiana-pojazd-limitowany', 'Zmiana Pojazdu Limitowanego (KARTA)', 0, 1, -1, 5),
('klucz-zalozenia-organizacji', 'Założenie Organizacji (KLUCZ)', 0, 1, -1, 5),
('knife', 'Noż', 1, 0, 1, 5),
('knuckle', 'Kastet', 1, 0, 1, 5),
('kod-rabatowy-20', 'Kod Rabatowy', 1, 0, -1, 3),
('machete', 'Maczeta', 1, 0, 1, 5),
('microsmg', 'Micro SMG', 50, 0, 1, 2),
('militaryrifle', 'Karabin Militarny', 1, 0, 1, 5),
('napad-datadisk', 'Dysk z Danymi', 5, 0, 1, 1),
('napad-debentures', 'Obligacje', 5, 0, 1, 1),
('napad-hangar', 'Dane Wojskowe', 5, 0, 1, 1),
('napad-humane', 'Dysk z Trojanem', 5, 0, 1, 1),
('napad-laptop', 'Laptop', 5, 0, 1, 1),
('napad-lifeinvader', 'Łom do napadu', 5, 0, 1, 1),
('napad-pacific', 'Dysk Szyfrujący', 5, 0, 1, 1),
('napad-pendrive', 'Pendrive', 5, 0, 1, 1),
('narco-coke', 'Kokaina', 1, 0, 1, -1),
('narco-coke-paczka', 'Paczka Kokainy', 1, 0, 1, -1),
('narco-fentanyl', 'Fentanyl', 1, 0, 1, -1),
('narco-fentanyl-paczka', 'Paczka Fentanylu', 1, 0, 1, -1),
('narco-heroin', 'Heroina', 1, 0, 1, -1),
('narco-heroin-paczka', 'Paczka Heroiny', 1, 0, 1, -1),
('narco-meth', 'Metamfetamina', 1, 0, 1, -1),
('narco-meth-paczka', 'Paczka Metamfetaminy', 1, 0, 1, -1),
('narco-weed', 'Marihuana', 1, 0, 1, -1),
('narco-weed-paczka', 'Paczka Marihuany', 1, 0, 1, -1),
('nightstick', 'Pałka Policyjna', 1, 0, 1, 5),
('pistol', 'Pistolet', 1, 0, 1, 50),
('pistol_ammo', 'Amunicja do Pistoletu', 0, 0, 1, 5000),
('pistol_ammo_box', 'Magazynek do Pistoletu', 0, 0, 1, 2000),
('pistol_mk2', 'Pistolet (MK II)', 1, 0, 1, 50),
('radio', 'Krótkofalówka', 1, 0, 1, 10),
('radiocrime', 'Krótkofalówka Crime', 1, 0, 1, 10),
('repairkit', 'Zestaw Naprawczy', 1, 0, 1, 50),
('revolver', 'Revolver', 50, 0, 1, 5),
('rifle_ammo', 'Amunicja do Karabinu', 0, 0, 1, 5000),
('rifle_ammo_box', 'Magazynek do Karabinu', 0, 0, 1, 2000),
('scope', 'Mały Celownik', 1, 0, 1, 5),
('scope2', 'Duży Celownik', 1, 0, 1, 5),
('smg_ammo', 'Amunicja do SMG', 0, 0, 1, 5000),
('smg_ammo_box', 'Magazynek do SMG', 0, 0, 1, 2000),
('snspistol', 'Pistolet SNS', 1, 0, 1, 50),
('snspistol_mk2', 'Pistolet SNS (MK II)', 1, 0, 1, 50),
('stungun', 'Paralizator', 1, 0, 1, 5),
('suppressor', 'Tłumik', 1, 0, 1, 5),
('ticket-sponsor30', 'SPONSOR (30 Dni)', 0, 0, -1, 5),
('ticket-sponsor7', 'SPONSOR (7 Dni)', 0, 0, -1, 5),
('ticket-svip30', 'SVIP (30 Dni)', 0, 0, -1, 5),
('ticket-svip7', 'SVIP (7 Dni)', 0, 0, -1, 5),
('ticket-vip30', 'VIP (30 Dni)', 0, 0, -1, 5),
('ticket-vip7', 'VIP (7 Dni)', 0, 0, -1, 5),
('vest-heavy', 'Kamizelka Ciężka', 5, 0, 1, 5),
('vest-light', 'Kamizelka Lekka', 1, 0, 1, 5),
('vest-medium', 'Kamizelka Średnia', 3, 0, 1, 5),
('vintagepistol', 'Pistolet Vintage', 1, 0, 1, 50);

CREATE TABLE IF NOT EXISTS `jobs` (
  `name` varchar(50) NOT NULL,
  `label` varchar(50) DEFAULT NULL,
  `whitelisted` tinyint(1) NOT NULL DEFAULT 0,
  `clothes` longtext DEFAULT NULL,
  `grades` longtext DEFAULT NULL,
  `account` int(11) DEFAULT 0,
  `stash` longtext DEFAULT NULL,
  `suspended` timestamp NULL DEFAULT current_timestamp(),
  `kits` varchar(255) DEFAULT NULL,
  `upgrades` varchar(255) DEFAULT NULL,
  `webhooks` longtext DEFAULT NULL,
  `bitkipoints` int(11) unsigned zerofill DEFAULT 00000000000,
  `capturedstrefa` longtext DEFAULT NULL,
  `settings` text DEFAULT NULL,
  `wins` int(11) DEFAULT 0,
  `loses` int(11) DEFAULT 0,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `jobs` (`name`, `label`, `whitelisted`, `clothes`, `grades`, `account`, `stash`, `suspended`, `kits`, `upgrades`, `webhooks`, `bitkipoints`, `capturedstrefa`, `settings`, `wins`, `loses`) VALUES
	('ambulance', 'EMS', 0, '', '[{"name":"szef","permissions":{},"salary":500}]', 0, '[]', '2023-10-06 22:02:11', '[]', '[]', '[]', 00000000000, NULL, NULL, 0, 0),
	('mechanic', 'Mechanik', 0, '', '[{"salary":500,"permissions":[],"name":"szef"},{"salary":0,"permissions":[],"name":"cfel"}]', 0, '[]', NULL, '[]', '{"handcuffs":false,"repairkit":false}', '{"char1:98159a856e5c5ba2b52806ec316a670209d2cba1":380,"char1:1833177120042ddeb177d3eccd3e0efe52fd311f":0,"char1:31807f8ba05efbdd6ab2d9a88ef01929549da1ca":650,"char1:7717f6ac88b114c9895c76e29bc5791216b7c7f8":0,"char1:95181c209da245e8691d417193eb36e182e155be":40}', 00000000000, NULL, NULL, 0, 0),
	('offmechanic', 'Mechanik (PS)', 0, NULL, '[{"salary":500,"permissions":[],"name":"szef"},{"salary":0,"permissions":[],"name":"cfel"}]', 0, NULL, NULL, NULL, NULL, NULL, 00000000000, NULL, NULL, 0, 0),
	('offpolice', 'SASP (PS)', 0, NULL, '[{"salary":500,"permissions":[],"name":"Director Of Police"},{"salary":0,"permissions":{"kits_menager":true,"edit_clothes":true,"withdraw_item":true,"deposit_money":true,"get_car":true,"withdraw_money":true,"members_menager":true},"name":"Chief Of Police"},{"salary":0,"permissions":{"kits_menager":true,"edit_clothes":true,"members_menager":true,"deposit_money":true,"get_car":true,"withdraw_money":true,"withdraw_item":true},"name":"Deuputy Chief Of Police"},{"salary":0,"permissions":{"kits_menager":true,"edit_clothes":true,"withdraw_item":true,"deposit_money":true,"get_car":true,"withdraw_money":true,"members_menager":true},"name":"Assistant Chief of Police"},{"salary":0,"permissions":{"kits_menager":true,"edit_clothes":true,"members_menager":true,"deposit_money":true,"get_car":true,"withdraw_money":true,"withdraw_item":true},"name":"Commander"},{"salary":0,"permissions":{"kits_menager":true,"edit_clothes":true,"withdraw_item":true,"deposit_money":true,"get_car":true,"withdraw_money":true,"members_menager":true},"name":"Deputy Commander"},{"salary":0,"permissions":{"deposit_money":true,"get_car":true,"withdraw_item":true},"name":"Staff Captain"},{"salary":0,"permissions":{"deposit_money":true,"get_car":true,"withdraw_item":true},"name":"Captain"},{"salary":0,"name":"Staff Lieutenant","permissions":{"deposit_money":true,"get_car":true,"withdraw_item":true}},{"salary":0,"name":"Lieutenant","permissions":{"deposit_money":true,"get_car":true,"withdraw_item":true}},{"salary":0,"name":"Staff Sergeant","permissions":{"deposit_money":true,"get_car":true,"withdraw_item":true}},{"salary":0,"name":"Senior Sergeant","permissions":{"deposit_money":true,"get_car":true,"withdraw_item":true}},{"salary":0,"name":"Sergeant","permissions":{"deposit_money":true,"get_car":true,"withdraw_item":true}},{"salary":0,"name":"Staff Trooper","permissions":{"deposit_money":true,"get_car":true,"withdraw_item":true}},{"salary":0,"name":"Senior Trooper","permissions":{"deposit_money":true,"get_car":true,"withdraw_item":true}},{"salary":0,"name":"Trooper","permissions":{"deposit_money":true,"get_car":true,"withdraw_item":true}},{"name":"Cadet","salary":0,"permissions":{"deposit_money":true,"get_car":true,"withdraw_item":true}}]', 0, NULL, '2024-12-06 16:37:43', NULL, NULL, NULL, 00000000000, NULL, NULL, 0, 0),
	('police', 'SASP', 0, '[]', '[{"salary":500,"permissions":[],"name":"Director Of Police"},{"salary":0,"permissions":{"kits_menager":true,"edit_clothes":true,"withdraw_item":true,"deposit_money":true,"get_car":true,"withdraw_money":true,"members_menager":true},"name":"Chief Of Police"},{"salary":0,"permissions":{"kits_menager":true,"edit_clothes":true,"members_menager":true,"deposit_money":true,"get_car":true,"withdraw_money":true,"withdraw_item":true},"name":"Deuputy Chief Of Police"},{"salary":0,"permissions":{"kits_menager":true,"edit_clothes":true,"withdraw_item":true,"deposit_money":true,"get_car":true,"withdraw_money":true,"members_menager":true},"name":"Assistant Chief of Police"},{"salary":0,"permissions":{"kits_menager":true,"edit_clothes":true,"members_menager":true,"deposit_money":true,"get_car":true,"withdraw_money":true,"withdraw_item":true},"name":"Commander"},{"salary":0,"permissions":{"kits_menager":true,"edit_clothes":true,"withdraw_item":true,"deposit_money":true,"get_car":true,"withdraw_money":true,"members_menager":true},"name":"Deputy Commander"},{"salary":0,"permissions":{"deposit_money":true,"get_car":true,"withdraw_item":true},"name":"Staff Captain"},{"salary":0,"permissions":{"deposit_money":true,"get_car":true,"withdraw_item":true},"name":"Captain"},{"salary":0,"name":"Staff Lieutenant","permissions":{"deposit_money":true,"get_car":true,"withdraw_item":true}},{"salary":0,"name":"Lieutenant","permissions":{"deposit_money":true,"get_car":true,"withdraw_item":true}},{"salary":0,"name":"Staff Sergeant","permissions":{"deposit_money":true,"get_car":true,"withdraw_item":true}},{"salary":0,"name":"Senior Sergeant","permissions":{"deposit_money":true,"get_car":true,"withdraw_item":true}},{"salary":0,"name":"Sergeant","permissions":{"deposit_money":true,"get_car":true,"withdraw_item":true}},{"salary":0,"name":"Staff Trooper","permissions":{"deposit_money":true,"get_car":true,"withdraw_item":true}},{"salary":0,"name":"Senior Trooper","permissions":{"deposit_money":true,"get_car":true,"withdraw_item":true}},{"salary":0,"name":"Trooper","permissions":{"deposit_money":true,"get_car":true,"withdraw_item":true}},{"name":"Cadet","salary":0,"permissions":{"deposit_money":true,"get_car":true,"withdraw_item":true}}]', 1, '[{"count":1,"label":"Kajdanki","name":"handcuffs"}]', NULL, '[]', '{"repairkit":false,"handcuffs":false}', '{"char1:424bfbb3ff845c5e57423fc8d06d747ebb1fbdd0":0,"char1:98159a856e5c5ba2b52806ec316a670209d2cba1":1680,"char1:95181c209da245e8691d417193eb36e182e155be":10,"char1:0db314ae044ce044527743fb37b0ea07e3afe8f1":410,"char1:96599ec91346b4bd52d30d35af43707e5ba32e12":90,"char1:9eda534653cdeaa990b3a5177c2363321a8526a1":0}', 00000000000, NULL, NULL, 0, 0),
	('unemployed', 'Unemployed', 0, '', '[{"name":"bezrobotny","permissions":{},"salary":500}]', 0, '[]', NULL, '[]', '{"handcuffs":false,"repairkit":false}', '[]', 00000000000, NULL, NULL, 0, 0);

CREATE TABLE IF NOT EXISTS `kits` (
  `identifier` varchar(46) NOT NULL,
  `data` longtext NOT NULL,
  PRIMARY KEY (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `reportsystem` (
  `license` varchar(255) NOT NULL,
  `count` int(11) DEFAULT 0,
  `discord` varchar(50) NOT NULL,
  `name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `owned_vehicles` (
  `plate` varchar(12) NOT NULL,
  `type` varchar(20) NOT NULL DEFAULT 'car',
  `vehicle` longtext NOT NULL,
  `owner` longtext NOT NULL,
  `state` int(11) DEFAULT 0,
  `co_owner` int(11) DEFAULT NULL,
  `co_owner2` int(11) unsigned DEFAULT NULL,
  `co_owner3` int(11) DEFAULT NULL,
  `owner_type` int(11) DEFAULT NULL,
  `org` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `users` (
  `identifier` varchar(46) NOT NULL,
  `name` varchar(255) NOT NULL,
  `discordid` varchar(255) DEFAULT NULL,
  `license` varchar(255) DEFAULT NULL,
  `accounts` longtext DEFAULT NULL,
  `group` varchar(50) DEFAULT NULL,
  `reports` int(255) NOT NULL DEFAULT 0,
  `premiumgroup` varchar(50) DEFAULT NULL,
  `inventory` longtext DEFAULT NULL,
  `job` varchar(20) DEFAULT 'unemployed',
  `dualjob` varchar(255) NOT NULL DEFAULT 'unemployed',
  `dualjob_grade` int(11) NOT NULL DEFAULT 0,
  `job_grade` int(11) DEFAULT 0,
  `loadout` longtext DEFAULT NULL,
  `position` varchar(255) DEFAULT '{"x":982.9,"y":-2544.5,"z":28.3,"heading":346.7}',
  `skin` longtext DEFAULT NULL,
  `tattoos` longtext DEFAULT NULL,
  `status` longtext DEFAULT NULL,
  `is_dead` tinyint(1) DEFAULT 0,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `disabled` tinyint(1) DEFAULT 0,
  `last_property` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `last_seen` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp(),
  `phone_number` int(11) DEFAULT NULL,
  `pincode` int(11) DEFAULT NULL,
  `weaponcd` varchar(255) DEFAULT NULL,
  `badge` varchar(255) DEFAULT NULL,
  `account_number` varchar(10) DEFAULT NULL,
  `points` int(11) NOT NULL DEFAULT 0,
  `duelaccount` varchar(255) DEFAULT NULL,
  `ranga` varchar(255) NOT NULL DEFAULT 'Brak',
  `received_car` int(11) NOT NULL DEFAULT 0,
  `xp` int(11) NOT NULL DEFAULT 0,
  `rank` int(11) NOT NULL DEFAULT 1,
  `playTime` int(255) NOT NULL DEFAULT 0,
  `kills` int(11) DEFAULT 0,
  `deaths` int(11) DEFAULT 0,
  `advent` int(11) DEFAULT NULL,
  `digit` varchar(50) DEFAULT NULL,
  `auto` tinyint(1) NOT NULL DEFAULT 0,
  `metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`metadata`)),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=94 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `user_dressigns` (
  `identifier` varchar(46) NOT NULL,
  `dressigns` longtext DEFAULT NULL,
  PRIMARY KEY (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `vehicles` (
  `name` varchar(60) NOT NULL,
  `model` varchar(60) NOT NULL,
  `price` int(11) NOT NULL,
  `category` varchar(60) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES
	('Adder', 'adder', 900000, 'super'),
	('T20', 't20', 300000, 'super');

CREATE TABLE IF NOT EXISTS `vehicle_categories` (
  `name` varchar(60) NOT NULL,
  `label` varchar(60) NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `vehicle_categories` (`name`, `label`) VALUES
	('sport', 'Sportówki'),
	('bomb', 'Bombowozy'),
	('normal', 'Zwykłe');