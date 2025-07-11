Config                            = {}
Config.EnableESXIdentity          = true
Config.EnableHandcuffTimer        = true
Config.HandcuffTimer              = 10 * 60000
Config.Locale                     = 'pl'
Config.PoliceStations = {
	LSPD = {
		Blip = {
			Coords  = vector3(-580.5566, -405.6201, 35.1821),
			Sprite  = 60,
			Display = 4,
			Scale   = 1.0,
			Colour  = 29
		},

		Cloakrooms = {
			vector3(-599.0, -422.0, 35.0),
		},

		Armories = {
			vector3(-308.0455, -1064.3782, 28.3406),
		},

		Vehicles = {
			{
				Spawner = vector3(-459.86, 6015.53, 20.59),
				SpawnPoint = vector3(-587.0782, -408.5511, 31.1603),
				Deleter = vector3(-577.1765, -423.9785, 30.1603),
				Heading = 313.62,
			}
		},

		Helicopters = {
			{
				Spawner = vector3(-594.9279, -417.0018, 49.5453),
				SpawnPoint = vector3(-595.5798, -431.2027, 51.3841),
				Deleter = vector3(-596.0550, -431.0464, 50.3881)
			}
		},

		BossActions = {
			vector3(-303.3775, -1045.3826, 31.2609),
		}

	},
}

Config.AuthorizedWeapons = {
	{ name = 'combatpistol', label = 'Pistolet Bojowy', price = 0 },
	{ name = 'heavypistol', label = 'Pistolet Heavy', price = 75000 },
	{ name = 'pistol_ammo_box', label = 'Magazynek do pistoletu', price = 5000 },
	{ name = 'stungun', label = 'Tazer', price = 7500 },
	{ name = 'gps', label = 'GPS', price = 0 },
	{ name = 'radio', label = 'Radio', price = 0 },
}

Config.VehiclesGroups = {
	'Zarzad', -- 1
	'HWP', -- 2
	'SEU', -- 3
    'S.W.A.T', -- 4
    'Adam', -- 5
	'Offroad', -- 6
	'Motocykle', -- 7
	'TASK', -- 8
	'JEDNOSTKA OPÓR', -- 9	
}

Config.AuthorizedVehicles = {
    {model = 'pd_viper', label = 'Viper', groups = {9}, license = 'seu_pd'},
    {model = 'pd_avent', label = 'Aventador', groups = {9}, license = 'seu_pd'},
    {model = 'pd_amggtr', label = 'AMG GTR', groups = {9}, license = 'seu_pd'},
    {model = 'hp_challenger', label = 'Dodge Challenger', groups = {2}, license = "hwp_pd"},
    {model = 'pd_charger14', label = 'Dodge Charger 2014', groups = {5}},
    {model = 'pd_charger18', label = 'Dodge Charger 2018', groups = {5}},
    {model = 'riot', label = 'Riot', groups = {5}},
    {model = 'hp_amggtr', label = 'Mercedes AMG GTR', groups = {2}, license = "hwp_pd"},
    {model = 'hp_gt63s', label = 'Mercedes GT63S', groups = {2}, license = "hwp_pd"},
    {model = 'pd_victoria', label = 'Ford Victoria', groups = {5}},
    {model = 'pd_viper', label = 'Dodge Viper 2018', groups = {3}, license = 'seu_pd'},
    {model = 'hp_gt17', label = 'Ford GT', groups = {3}, license = "seu_pd"},
    {model = 'hp_laferrari', label = 'LaFerrari', groups = {1}, license = "cs_pd"},
    {model = 'DL_bmwm4', label = 'BMW M4', groups = {1}, license = "cs_pd"},
    {model = 'hp_m8', label = 'BMW M8', groups = {2}, license = "hwp_pd"},
    {model = 'pd_camaro', label = 'Chevrolet Camaro', groups = {2}, license = "cs_pd"},
    {model = 'hp_lambo', label = 'Lamborghini', groups = {1}, license = "cs_pd"},
    {model = 'pd_bronco', label = 'Ford Bronco', groups = {6}},
    {model = 'pd_tahoe21', label = 'Chevrolet Tahoe', groups = {6}},
    {model = 'pd_durango', label = 'Dodge Durango', groups = {6}},
    {model = 'pd_explo', label = 'Chevrolet Explorer', groups = {6}},
    {model = 'pd_freecrawler', label = 'Freecrawler', groups = {3}, license = 'seu_pd'},
    {model = 'pd_raptor', label = 'Ford Raptor', groups = {3}, license = "seu_pd"},
    {model = 'swat_jeep', label = 'Swat Jeep', groups = {4}, license = "cttf_pd"},
    {model = 'pd_titan17', label = 'Nissan Titan', groups = {6}},
    {model = 'pitbullbb', label = 'Pitbull', groups = {4}, license = "cttf_pd"},
    {model = 'bearcat', label = 'BearCat', groups = {4}, license = "cttf_pd"},
    {model = 'pd_h1', label = 'H1', groups = {4}, license = "cttf_pd"},
    {model = 'riot', label = 'Riot CTTF', groups = {4}, license = "cttf_pd"},
    {model = 'hp_bmw', label = 'BMW', groups = {7}, license = "mr_pd"},
    {model = 'pd_r1custom', label = 'R1', groups = {7}, license = "mr_pd"},
    {model = 'hp_rs5', label = 'RS5', groups = {3}, license = "seu_pd"},
    {model = 'pd_response', label = 'Medic Car', groups = {8}, license = "cttf_pd"},
    {model = 'pd_sprinter', label = 'Sprinter', groups = {8}, license = "cttf_pd"},
    {model = 'pd_van', label = 'Van', groups = {8}, license = "cttf_pd"},
    {model = 'pd_camaroSU', label = 'SWAT Camaro', groups = {4}, license = "cttf_pd"},
    {model = 'pd_escalader', label = 'Escalader', groups = {5}},
    {model = 'titanwbpd1', label = 'CODE BLACK', groups = {1}, license = "cs_pd"},
    {model = 'pd_hummerSU', label = 'Hummer', groups = {4}, license = "cttf_pd"},
    {model = 'pd_c8', label = 'Chevrolet C8', groups = {3}, license = "seu_pd"},
    {model = 'pd_lexus', label = 'Lexus', groups = {5}},
    {model = 'pd_sprinter', label = 'Sprinter', groups = {8}, license = "cttf_pd"},
    {model = 'hp_divo', label = 'Bugatti Divo', groups = {2}, license = "hwp_pd"},
    {model = 'pd_kawasaki', label = 'Kawasaki', groups = {7}, license = "mr_pd"},
    {model = 'hp_wrxp', label = 'WRXP', groups = {2}, license = "hwp_pd"},
    {model = 'pd_caracara', label = 'Caracara', groups = {6}},
    {model = 'hp_x6', label = 'BMW X6r', groups = {2}, license = "hwp_pd"},
    {model = 'hp_mustangwb', label = 'Mustang WB', groups = {2}, license = "hwp_pd"},
    {model = 'pd_snake', label = 'Shelby Snaker', groups = {1}, license = "cs_pd"},
    {model = 'pd_impala19', label = 'Impala', groups = {5}},
    {model = 'pd_fusion16', label = 'Ford Fusion', groups = {5}},
    {model = 'pd_taurus', label = 'Taurus', groups = {5}},
    {model = 'pd_sultan', label = 'Sultan', groups = {3}, license = "seu_pd"},
    {model = 'cheburekpd', label = 'Cheburek', groups = {3}, license = "seu_pd"},
    {model = 'hp_911', label = 'Porshe 911', groups = {2}, license = "hwp_pd"},
    {model = 'hp_chiron', label = 'Bugatti Chiron', groups = {2}, license = "hwp_pd"},
    {model = 'pd_harley', label = 'Harley', groups = {7}, license = "mr_pd"},
    {model = 'hp_rs6', label = 'Audi RS6', groups = {3}, license = "seu_pd"},
    {model = 'hp_r35', label = 'Nissan R35', groups = {2}, license = "hwp_pd"},
    {model = 'vc_poltdf', label = 'Ferrari F12', groups = {3}, license = "seu_pd"},
    {model = 'hp_m8f92', label = 'BMW M8F92', groups = {3}, license = "seu_pd"},
    {model = 'hp_a45', label = 'A45 CADET', groups = {5}},
    {model = 'hp_charger18', label = 'Dodge Charger 2018', groups = {3}, license = "seu_pd"},
    {model = 'hp_zr1', label = 'Corvette ZR1', groups = {3}, license = "seu_pd"},
    {model = 'zm_demonhawkk', label = 'JEEP Demonhawk', groups = {2}, license = 'seu_pd'},
    {model = 'polvigerowb', label = 'Niggero', groups = {1}, license = "cs_pd"},
    {model = 'hp_explorer', label = 'Ford Explorer', groups = {2}, license = 'seu_pd'},
    {model = 'pd_komoda', label = 'Komoda', groups = {5}},
    {model = 'hp_p1', label = 'Mclaren P1', groups = {2}, license = 'seu_pd'},
    {model = 'hp_r8', label = 'Audi R8', groups = {2}, license = 'seu_pd'},
    {model = 'pol458', label = 'Ferrari 458', groups = {2}, license = 'seu_pd'},
    {model = 'ghispo2', label = 'Maserati Ghibli', groups = {2}, license = 'seu_pd'},
    {model = 'POLBUFFALOSX', label = 'Buffalo Inteceptor', groups = {5}},
    {model = 'polbuffwb', label = 'Buffalo STX', groups = {5}},
    {model = 'hp_chiron', label = 'Bugatti Chiron', groups = {3}, license = 'seu_pd'},
    {model = 'hp_f430', label = 'Ferrari F430', groups = {3}, license = 'seu_pd'},
    {model = 'zm_sf90', label = 'Ferrari SF90', groups = {9}, license = 'seu_pd'},
    {model = 'G632019X', label = 'Czarne palce marchewy', groups = {1}, license = 'seu_pd'},
    {model = 'vc_polb50', label = 'Wóz szefa', groups = {1}, license = 'seu_pd'},
    {model = 'bolidepo', label = 'Bugatti Bolide', groups = {1}, license = 'seu_pd'},
    {model = '939amborg', label = 'Lamborghini Amborg', groups = {3}, license = 'seu_pd'}
}

Config.AuthorizedHelicopters = {
	{model = 'pd_heli',label = 'Helikopter',license = "heli_pd"},
	{model = 'sw_heli',label = 'SWAT Helikopter',license = "heli_pd"},
	{model = 'polmav',label = 'Helikopter Szkoleniowy',license = "heli_pd"}
}

Config.CustomPeds = {
	shared = {
		{label = 'Sheriff Ped', maleModel = 's_m_y_sheriff_01', femaleModel = 's_f_y_sheriff_01'},
		{label = 'Police Ped', maleModel = 's_m_y_cop_01', femaleModel = 's_f_y_cop_01'}
	},
	recruit = {},
	officer = {},
	sergeant = {},
	lieutenant = {},
	boss = {
		{label = 'SWAT Ped', maleModel = 's_m_y_swat_01', femaleModel = 's_m_y_swat_01'}
	}
}

Config.Uniforms = {
	recruit = {
		male = {
			tshirt_1 = 59,  tshirt_2 = 1,
			torso_1 = 55,   torso_2 = 0,
			decals_1 = 0,   decals_2 = 0,
			arms = 41,
			pants_1 = 25,   pants_2 = 0,
			shoes_1 = 25,   shoes_2 = 0,
			helmet_1 = 46,  helmet_2 = 0,
			chain_1 = 0,    chain_2 = 0,
			ears_1 = 2,     ears_2 = 0
		},
		female = {
			tshirt_1 = 36,  tshirt_2 = 1,
			torso_1 = 48,   torso_2 = 0,
			decals_1 = 0,   decals_2 = 0,
			arms = 44,
			pants_1 = 34,   pants_2 = 0,
			shoes_1 = 27,   shoes_2 = 0,
			helmet_1 = 45,  helmet_2 = 0,
			chain_1 = 0,    chain_2 = 0,
			ears_1 = 2,     ears_2 = 0
		}
	},

	officer = {
		male = {
			tshirt_1 = 58,  tshirt_2 = 0,
			torso_1 = 55,   torso_2 = 0,
			decals_1 = 0,   decals_2 = 0,
			arms = 41,
			pants_1 = 25,   pants_2 = 0,
			shoes_1 = 25,   shoes_2 = 0,
			helmet_1 = -1,  helmet_2 = 0,
			chain_1 = 0,    chain_2 = 0,
			ears_1 = 2,     ears_2 = 0
		},
		female = {
			tshirt_1 = 35,  tshirt_2 = 0,
			torso_1 = 48,   torso_2 = 0,
			decals_1 = 0,   decals_2 = 0,
			arms = 44,
			pants_1 = 34,   pants_2 = 0,
			shoes_1 = 27,   shoes_2 = 0,
			helmet_1 = -1,  helmet_2 = 0,
			chain_1 = 0,    chain_2 = 0,
			ears_1 = 2,     ears_2 = 0
		}
	},

	sergeant = {
		male = {
			tshirt_1 = 58,  tshirt_2 = 0,
			torso_1 = 55,   torso_2 = 0,
			decals_1 = 8,   decals_2 = 1,
			arms = 41,
			pants_1 = 25,   pants_2 = 0,
			shoes_1 = 25,   shoes_2 = 0,
			helmet_1 = -1,  helmet_2 = 0,
			chain_1 = 0,    chain_2 = 0,
			ears_1 = 2,     ears_2 = 0
		},
		female = {
			tshirt_1 = 35,  tshirt_2 = 0,
			torso_1 = 48,   torso_2 = 0,
			decals_1 = 7,   decals_2 = 1,
			arms = 44,
			pants_1 = 34,   pants_2 = 0,
			shoes_1 = 27,   shoes_2 = 0,
			helmet_1 = -1,  helmet_2 = 0,
			chain_1 = 0,    chain_2 = 0,
			ears_1 = 2,     ears_2 = 0
		}
	},

	lieutenant = {
		male = {
			tshirt_1 = 58,  tshirt_2 = 0,
			torso_1 = 55,   torso_2 = 0,
			decals_1 = 8,   decals_2 = 2,
			arms = 41,
			pants_1 = 25,   pants_2 = 0,
			shoes_1 = 25,   shoes_2 = 0,
			helmet_1 = -1,  helmet_2 = 0,
			chain_1 = 0,    chain_2 = 0,
			ears_1 = 2,     ears_2 = 0
		},
		female = {
			tshirt_1 = 35,  tshirt_2 = 0,
			torso_1 = 48,   torso_2 = 0,
			decals_1 = 7,   decals_2 = 2,
			arms = 44,
			pants_1 = 34,   pants_2 = 0,
			shoes_1 = 27,   shoes_2 = 0,
			helmet_1 = -1,  helmet_2 = 0,
			chain_1 = 0,    chain_2 = 0,
			ears_1 = 2,     ears_2 = 0
		}
	},

	boss = {
		male = {
			tshirt_1 = 58,  tshirt_2 = 0,
			torso_1 = 55,   torso_2 = 0,
			decals_1 = 8,   decals_2 = 3,
			arms = 41,
			pants_1 = 25,   pants_2 = 0,
			shoes_1 = 25,   shoes_2 = 0,
			helmet_1 = -1,  helmet_2 = 0,
			chain_1 = 0,    chain_2 = 0,
			ears_1 = 2,     ears_2 = 0
		},
		female = {
			tshirt_1 = 35,  tshirt_2 = 0,
			torso_1 = 48,   torso_2 = 0,
			decals_1 = 7,   decals_2 = 3,
			arms = 44,
			pants_1 = 34,   pants_2 = 0,
			shoes_1 = 27,   shoes_2 = 0,
			helmet_1 = -1,  helmet_2 = 0,
			chain_1 = 0,    chain_2 = 0,
			ears_1 = 2,     ears_2 = 0
		}
	},

	bullet_wear = {
		male = {
			bproof_1 = 11,  bproof_2 = 1
		},
		female = {
			bproof_1 = 13,  bproof_2 = 1
		}
	},

	gilet_wear = {
		male = {
			tshirt_1 = 59,  tshirt_2 = 1
		},
		female = {
			tshirt_1 = 36,  tshirt_2 = 1
		}
	}
}