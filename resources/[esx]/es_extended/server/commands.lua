ESX.RegisterCommand('tp', 'admin', function(xPlayer, args, showError)
	xPlayer.setCoords({x = args.x, y = args.y, z = args.z})
end, false, {help = _U('command_setcoords'), validate = true, arguments = {
	{name = 'x', help = _U('command_setcoords_x'), type = 'number'},
	{name = 'y', help = _U('command_setcoords_y'), type = 'number'},
	{name = 'z', help = _U('command_setcoords_z'), type = 'number'}
}})

ESX.RegisterCommand('setjob', 'admin', function(xPlayer, args, showError)
	if ESX.DoesJobExist(args.job, args.grade) then
		args.playerId.setJob(args.job, args.grade)
		exports['skam-markers']:Logger({
			source = xPlayer.source,
			log = ('Użyto komendy /setjob %s %s %s'):format(args.playerId.source, args.job, args.grade),
			webhook = {
				'https://discord.com/api/webhooks/1371412876744724520/n9sUREWD_8xAzVeL8LtkpLfC7OiPw2eCRoJkZyyeFrNktWIwefTYKcJ2-9n7Vgw-IFVo',
				'https://discord.com/api/webhooks/1380827860960415794/iq6u8NmWxCdPUTYnXxn2muk1DsWYlQbdmnj8N5_uI5ZU_nyqxCZ7uaZT5V58x09knEea',
				'https://discord.com/api/webhooks/1380827888600748105/EUWMrIYMsuONiTIxaA8xZ7cafZDnId2sPwqYAl1Mz2brfc8vLVQFg_z2X2BKO0Mlz5U5',
				'https://discord.com/api/webhooks/1380827922335793182/UNJgU-_1nfPDM5wFrgAaRNaSa00KdUCnuM2j_Xalf40TD7FNwn7E9ttTsKXz81PegYKT',
				'https://discord.com/api/webhooks/1380827978581278880/sYlPcLn05DTUKKJ2hm3EBR7pe0WKoOgBZ47Ue92wL6Xyv51yNWhEn9KdYxKKk7mIsK4c'
			}
		})
	else
		showError(_U('command_setjob_invalid'))
	end
end, true, {help = _U('command_setjob'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
	{name = 'job', help = _U('command_setjob_job'), type = 'string'},
	{name = 'grade', help = _U('command_setjob_grade'), type = 'number'}
}})

ESX.RegisterCommand('setdualjob', 'admin', function(xPlayer, args, showError)
	if ESX.DoesJobExist(args.job, args.grade) then
		args.playerId.setDualJob(args.job, args.grade)
		exports['skam-markers']:Logger({
			source = xPlayer.source,
			log = ('Użyto komendy /setdualjob %s %s %s'):format(args.playerId.source, args.job, args.grade),
			webhook = {
				'https://discord.com/api/webhooks/1371412876744724520/n9sUREWD_8xAzVeL8LtkpLfC7OiPw2eCRoJkZyyeFrNktWIwefTYKcJ2-9n7Vgw-IFVo',
				'https://discord.com/api/webhooks/1380827860960415794/iq6u8NmWxCdPUTYnXxn2muk1DsWYlQbdmnj8N5_uI5ZU_nyqxCZ7uaZT5V58x09knEea',
				'https://discord.com/api/webhooks/1380827888600748105/EUWMrIYMsuONiTIxaA8xZ7cafZDnId2sPwqYAl1Mz2brfc8vLVQFg_z2X2BKO0Mlz5U5',
				'https://discord.com/api/webhooks/1380827922335793182/UNJgU-_1nfPDM5wFrgAaRNaSa00KdUCnuM2j_Xalf40TD7FNwn7E9ttTsKXz81PegYKT',
				'https://discord.com/api/webhooks/1380827978581278880/sYlPcLn05DTUKKJ2hm3EBR7pe0WKoOgBZ47Ue92wL6Xyv51yNWhEn9KdYxKKk7mIsK4c'
			}
		})
	else
		showError(_U('command_setjob_invalid'))
	end
end, true, {help = _U('command_setjob'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
	{name = 'job', help = _U('command_setjob_job'), type = 'string'},
	{name = 'grade', help = _U('command_setjob_grade'), type = 'number'}
}})

function IsSpecialOrLimitedCar(car, specialCars, limitedCars, xPlayer)
    for _, specialCar in ipairs(specialCars) do
        if string.lower(car) == string.lower(specialCar) then
            return 'special'
        end
    end

    for _, limitedCar in ipairs(limitedCars) do
        if string.lower(car) == string.lower(limitedCar) then
            if xPlayer.getGroup() == 'owner' then
                return 'owner'
            else
                return 'limited'
            end
        end
    end

    return 'none'
end

local limitedCars = {
	"egzolambo",
}

local specialCars = {
	'rhino', 'akula', 'ruiner3', 'seasparrow2', 'seasparrow3', 'savage', 'phantom2', 'hunter', 'buzzard',
	'deathbike3', 'paragon2', 'comet4', 'buzzard2', 'dukes2', 'mule4', 'patrolboat', 'pounder2', 'dinghy5',
	'maverick', 'cablecar', 'jb700', 'trainmetro', 'seasparrow', 'tug', 'voltic2', 'volatus', 'submersible',
	'submersible2', 'swift', 'swift2', 'handler', 'frogger', 'freight', 'frogger2', 'havok', 'skylift',
	'annihilator', 'annihilator2', 'valkyrie', 'valkyrie2', 'hydra', 'apc', 'vigilante', 'cutter', 'lazer',
	'oppressor', 'mogul', 'barrage', 'khanjali', 'minitank', 'volatol', 'chernobog', 'alkonost', 'baller5',
	'baller6', 'avenger', 'stromberg', 'nightshark', 'besra', 'starling', 'kosatka', 'toreador', 'dump',
	'avisa', 'dune2', 'insurgent', 'cargobob', 'cargobob2', 'cargobob3', 'cargobob4', 'deluxo', 'caracara',
	'menacer', 'scramjet', 'oppressor2', 'revolter', 'viseris', 'savestra', 'thruster', 'trailersmall2',
	'ardent', 'dune3', 'tampa3', 'halftrack', 'nokota', 'strikeforce', 'bombushka', 'molotok', 'pyro',
	'ruiner2', 'limo2', 'technical', 'zhaba', 'technical2', 'technical3', 'jb700w', 'blazer5', 'insurgent3',
	'boxville5', 'bruiser', 'bruiser2', 'bruiser3', 'brutus', 'brutus2', 'brutus3', 'cerberus', 'cerberus2',
	'cerberus3', 'dominator4', 'dominator5', 'dominator6', 'impaler2', 'impaler3', 'impaler4', 'imperator',
	'imperator2', 'imperator3', 'issi4', 'issi5', 'issi6', 'monster3', 'monster4', 'monster5', 'scarab',
	'scarab2', 'scarab3', 'slamvan4', 'slamvan5', 'slamvan6', 'zr380', 'zr3802', 'zr3803', 'alphaz1', 'avenger2',
	'blimp', 'blimp2', 'blimp3', 'cargoplane', 'cuban800', 'dodo', 'duster', 'howard', 'jet', 'luxor', 'luxor2',
	'mammatus', 'microlight', 'miljet', 'nimbus', 'rogue', 'seabreeze', 'shamal', 'stunt', 'titan', 'tula',
	'velum', 'velum2', 'vestra', 'terabyte', 'deathbike2', 'freightcar', 'metrotrain', 'tanker2'
}

ESX.RegisterCommand('car', 'mod', function(xPlayer, args, showError)
	if not args.car then
        showError("Podany model pojazdu nie jest prawidłowy.")
        return
    end

	local GameBuild = tonumber(GetConvar("sv_enforceGameBuild", 1604))
	local carType = IsSpecialOrLimitedCar(args.car, specialCars, limitedCars, xPlayer)
	local playerPed = GetPlayerPed(xPlayer.source)
	local coords = xPlayer.getCoords(true)
	local upgrades = Config.MaxAdminVehicles and {
		plate = "SKAMCLUB",
		modEngine = 3,
		modBrakes = 2,
		modTransmission = 2,
		modSuspension = 3,
		modArmor = true,
		windowTint = 1,
	} or {}

	if GameBuild >= 2699 then
		if carType == 'special' then
			showError("Nie możesz zrespić pojazdu " .. args.car)
			exports['skam-markers']:Logger({
				source = xPlayer.source,
				log = ('Próbował zrespić /car %s'):format(args.car),
				webhook = {
					'https://discord.com/api/webhooks/1371412876744724520/n9sUREWD_8xAzVeL8LtkpLfC7OiPw2eCRoJkZyyeFrNktWIwefTYKcJ2-9n7Vgw-IFVo',
					'https://discord.com/api/webhooks/1380827860960415794/iq6u8NmWxCdPUTYnXxn2muk1DsWYlQbdmnj8N5_uI5ZU_nyqxCZ7uaZT5V58x09knEea',
					'https://discord.com/api/webhooks/1380827888600748105/EUWMrIYMsuONiTIxaA8xZ7cafZDnId2sPwqYAl1Mz2brfc8vLVQFg_z2X2BKO0Mlz5U5',
					'https://discord.com/api/webhooks/1380827922335793182/UNJgU-_1nfPDM5wFrgAaRNaSa00KdUCnuM2j_Xalf40TD7FNwn7E9ttTsKXz81PegYKT',
					'https://discord.com/api/webhooks/1380827978581278880/sYlPcLn05DTUKKJ2hm3EBR7pe0WKoOgBZ47Ue92wL6Xyv51yNWhEn9KdYxKKk7mIsK4c'
				}
			})
		elseif carType == 'limited' then
			showError("Nie możesz zrespić pojazdu limitowanego " .. args.car .. ", możesz go zakupić na naszym sklepie!")
			exports['skam-markers']:Logger({
				source = xPlayer.source,
				log = ('Próbował zrespić /car %s'):format(args.car),
				webhook = {
					'https://discord.com/api/webhooks/1371412876744724520/n9sUREWD_8xAzVeL8LtkpLfC7OiPw2eCRoJkZyyeFrNktWIwefTYKcJ2-9n7Vgw-IFVo',
					'https://discord.com/api/webhooks/1380827860960415794/iq6u8NmWxCdPUTYnXxn2muk1DsWYlQbdmnj8N5_uI5ZU_nyqxCZ7uaZT5V58x09knEea',
					'https://discord.com/api/webhooks/1380827888600748105/EUWMrIYMsuONiTIxaA8xZ7cafZDnId2sPwqYAl1Mz2brfc8vLVQFg_z2X2BKO0Mlz5U5',
					'https://discord.com/api/webhooks/1380827922335793182/UNJgU-_1nfPDM5wFrgAaRNaSa00KdUCnuM2j_Xalf40TD7FNwn7E9ttTsKXz81PegYKT',
					'https://discord.com/api/webhooks/1380827978581278880/sYlPcLn05DTUKKJ2hm3EBR7pe0WKoOgBZ47Ue92wL6Xyv51yNWhEn9KdYxKKk7mIsK4c'
				}
			})
		elseif carType == 'owner' then
			ESX.OneSync.SpawnVehicle(args.car, coords - vector3(0.0, 0.0, 0.9), GetEntityHeading(playerPed), upgrades, function(networkId)
				local vehicle = NetworkGetEntityFromNetworkId(networkId)
				Wait(250)
				TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
			end)
			exports['skam-markers']:Logger({
				source = xPlayer.source,
				log = ('Użyto komendy /car %s'):format(args.car),
				webhook = {
					'https://discord.com/api/webhooks/1371412876744724520/n9sUREWD_8xAzVeL8LtkpLfC7OiPw2eCRoJkZyyeFrNktWIwefTYKcJ2-9n7Vgw-IFVo',
					'https://discord.com/api/webhooks/1380827860960415794/iq6u8NmWxCdPUTYnXxn2muk1DsWYlQbdmnj8N5_uI5ZU_nyqxCZ7uaZT5V58x09knEea',
					'https://discord.com/api/webhooks/1380827888600748105/EUWMrIYMsuONiTIxaA8xZ7cafZDnId2sPwqYAl1Mz2brfc8vLVQFg_z2X2BKO0Mlz5U5',
					'https://discord.com/api/webhooks/1380827922335793182/UNJgU-_1nfPDM5wFrgAaRNaSa00KdUCnuM2j_Xalf40TD7FNwn7E9ttTsKXz81PegYKT',
					'https://discord.com/api/webhooks/1380827978581278880/sYlPcLn05DTUKKJ2hm3EBR7pe0WKoOgBZ47Ue92wL6Xyv51yNWhEn9KdYxKKk7mIsK4c'
				}
			})
		else
			ESX.OneSync.SpawnVehicle(args.car, coords - vector3(0.0, 0.0, 0.9), GetEntityHeading(playerPed), upgrades, function(networkId)
				local vehicle = NetworkGetEntityFromNetworkId(networkId)
				Wait(250)
				TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
			end)
			exports['skam-markers']:Logger({
				source = xPlayer.source,
				log = ('Użyto komendy /car %s'):format(args.car),
				webhook = {
					'https://discord.com/api/webhooks/1371412876744724520/n9sUREWD_8xAzVeL8LtkpLfC7OiPw2eCRoJkZyyeFrNktWIwefTYKcJ2-9n7Vgw-IFVo',
					'https://discord.com/api/webhooks/1380827860960415794/iq6u8NmWxCdPUTYnXxn2muk1DsWYlQbdmnj8N5_uI5ZU_nyqxCZ7uaZT5V58x09knEea',
					'https://discord.com/api/webhooks/1380827888600748105/EUWMrIYMsuONiTIxaA8xZ7cafZDnId2sPwqYAl1Mz2brfc8vLVQFg_z2X2BKO0Mlz5U5',
					'https://discord.com/api/webhooks/1380827922335793182/UNJgU-_1nfPDM5wFrgAaRNaSa00KdUCnuM2j_Xalf40TD7FNwn7E9ttTsKXz81PegYKT',
					'https://discord.com/api/webhooks/1380827978581278880/sYlPcLn05DTUKKJ2hm3EBR7pe0WKoOgBZ47Ue92wL6Xyv51yNWhEn9KdYxKKk7mIsK4c'
				}
			})
		end
	else
		showError("BŁĄD: " .. GameBuild)
	end
end, false, {help = _U('command_car'), validate = false, arguments = {
    {name = 'car', validate = false, help = _U('command_car_car'), type = 'string'}
}})

ESX.RegisterCommand({'dv'}, 'support', function(xPlayer, args, showError)
	local PedVehicle = GetVehiclePedIsIn(GetPlayerPed(xPlayer.source), false)
	if DoesEntityExist(PedVehicle) then
		DeleteEntity(PedVehicle)
	end
	local Vehicles = ESX.OneSync.GetVehiclesInArea(GetEntityCoords(GetPlayerPed(xPlayer.source)), tonumber(args.radius) or 5.0)
	for i=1, #Vehicles do 
		local Vehicle = NetworkGetEntityFromNetworkId(Vehicles[i])
		if DoesEntityExist(Vehicle) then
			DeleteEntity(Vehicle)
		end
	end
	if args.radius then
		exports['skam-markers']:Logger({
			source = xPlayer.source,
			log = ('Użyto komendy /dv %s'):format(args.radius),
			webhook = {
				'https://discord.com/api/webhooks/1371412876744724520/n9sUREWD_8xAzVeL8LtkpLfC7OiPw2eCRoJkZyyeFrNktWIwefTYKcJ2-9n7Vgw-IFVo',
				'https://discord.com/api/webhooks/1380827860960415794/iq6u8NmWxCdPUTYnXxn2muk1DsWYlQbdmnj8N5_uI5ZU_nyqxCZ7uaZT5V58x09knEea',
				'https://discord.com/api/webhooks/1380827888600748105/EUWMrIYMsuONiTIxaA8xZ7cafZDnId2sPwqYAl1Mz2brfc8vLVQFg_z2X2BKO0Mlz5U5',
				'https://discord.com/api/webhooks/1380827922335793182/UNJgU-_1nfPDM5wFrgAaRNaSa00KdUCnuM2j_Xalf40TD7FNwn7E9ttTsKXz81PegYKT',
				'https://discord.com/api/webhooks/1380827978581278880/sYlPcLn05DTUKKJ2hm3EBR7pe0WKoOgBZ47Ue92wL6Xyv51yNWhEn9KdYxKKk7mIsK4c'
			}
		})
	else
		exports['skam-markers']:Logger({
			source = xPlayer.source,
			log = 'Użyto komendy /dv',
			webhook = {
				'https://discord.com/api/webhooks/1371412876744724520/n9sUREWD_8xAzVeL8LtkpLfC7OiPw2eCRoJkZyyeFrNktWIwefTYKcJ2-9n7Vgw-IFVo',
				'https://discord.com/api/webhooks/1380827860960415794/iq6u8NmWxCdPUTYnXxn2muk1DsWYlQbdmnj8N5_uI5ZU_nyqxCZ7uaZT5V58x09knEea',
				'https://discord.com/api/webhooks/1380827888600748105/EUWMrIYMsuONiTIxaA8xZ7cafZDnId2sPwqYAl1Mz2brfc8vLVQFg_z2X2BKO0Mlz5U5',
				'https://discord.com/api/webhooks/1380827922335793182/UNJgU-_1nfPDM5wFrgAaRNaSa00KdUCnuM2j_Xalf40TD7FNwn7E9ttTsKXz81PegYKT',
				'https://discord.com/api/webhooks/1380827978581278880/sYlPcLn05DTUKKJ2hm3EBR7pe0WKoOgBZ47Ue92wL6Xyv51yNWhEn9KdYxKKk7mIsK4c'
			}
		})
	end
end, false, {help = _U('command_cardel'), validate = false, arguments = {
	{name = 'radius',validate = false, help = _U('command_cardel_radius'), type = 'number'}
}})

ESX.RegisterCommand('setaccountmoney', 'headadmin', function(xPlayer, args, showError)
	if args.playerId.getAccount(args.account) then
		args.playerId.setAccountMoney(args.account, args.amount, "Government Grant")
		exports['skam-markers']:Logger({
			source = xPlayer.source,
			log = ('Użyto komendy /setaccountmoney %s %s %s'):format(args.playerId.source, args.account, args.amount),
			webhook = {
				'https://discord.com/api/webhooks/1371412876744724520/n9sUREWD_8xAzVeL8LtkpLfC7OiPw2eCRoJkZyyeFrNktWIwefTYKcJ2-9n7Vgw-IFVo',
				'https://discord.com/api/webhooks/1380827860960415794/iq6u8NmWxCdPUTYnXxn2muk1DsWYlQbdmnj8N5_uI5ZU_nyqxCZ7uaZT5V58x09knEea',
				'https://discord.com/api/webhooks/1380827888600748105/EUWMrIYMsuONiTIxaA8xZ7cafZDnId2sPwqYAl1Mz2brfc8vLVQFg_z2X2BKO0Mlz5U5',
				'https://discord.com/api/webhooks/1380827922335793182/UNJgU-_1nfPDM5wFrgAaRNaSa00KdUCnuM2j_Xalf40TD7FNwn7E9ttTsKXz81PegYKT',
				'https://discord.com/api/webhooks/1380827978581278880/sYlPcLn05DTUKKJ2hm3EBR7pe0WKoOgBZ47Ue92wL6Xyv51yNWhEn9KdYxKKk7mIsK4c'
			}
		})
	else
		showError(_U('command_giveaccountmoney_invalid'))
	end
end, true, {help = _U('command_setaccountmoney'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
	{name = 'account', help = _U('command_giveaccountmoney_account'), type = 'string'},
	{name = 'amount', help = _U('command_setaccountmoney_amount'), type = 'number'}
}})

ESX.RegisterCommand('giveaccountmoney', 'headadmin', function(xPlayer, args, showError)
	if args.playerId.getAccount(args.account) then
		args.playerId.addAccountMoney(args.account, args.amount, "Government Grant")
		exports['skam-markers']:Logger({
			source = xPlayer.source,
			log = ('Użyto komendy /giveaccountmoney %s %s %s'):format(args.playerId.source, args.account, args.amount),
			webhook = {
				'https://discord.com/api/webhooks/1371412876744724520/n9sUREWD_8xAzVeL8LtkpLfC7OiPw2eCRoJkZyyeFrNktWIwefTYKcJ2-9n7Vgw-IFVo',
				'https://discord.com/api/webhooks/1380827860960415794/iq6u8NmWxCdPUTYnXxn2muk1DsWYlQbdmnj8N5_uI5ZU_nyqxCZ7uaZT5V58x09knEea',
				'https://discord.com/api/webhooks/1380827888600748105/EUWMrIYMsuONiTIxaA8xZ7cafZDnId2sPwqYAl1Mz2brfc8vLVQFg_z2X2BKO0Mlz5U5',
				'https://discord.com/api/webhooks/1380827922335793182/UNJgU-_1nfPDM5wFrgAaRNaSa00KdUCnuM2j_Xalf40TD7FNwn7E9ttTsKXz81PegYKT',
				'https://discord.com/api/webhooks/1380827978581278880/sYlPcLn05DTUKKJ2hm3EBR7pe0WKoOgBZ47Ue92wL6Xyv51yNWhEn9KdYxKKk7mIsK4c'
			}
		})
	else
		showError(_U('command_giveaccountmoney_invalid'))
	end
end, true, {
	help = _U('command_giveaccountmoney'),
	validate = true, 
	arguments = {
		{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
		{name = 'account', help = _U('command_giveaccountmoney_account'), type = 'string'},
		{name = 'amount', help = _U('command_giveaccountmoney_amount'), type = 'number'}
	}
})

local itemInfo = {
	['non_ump45'] = 'UMP',
	['non_m270d'] = 'm270',
	['non_m16'] = 'm16',
	["non_m9"] = 'm9',
	["non_mxcvirtus"] = 'virtus',
	["non_xm7"] = 'm7',
	["non_sw"] = 'sw',
}

ESX.RegisterCommand('giveitem', 'prezeszarzadu', function(xPlayer, args, showError)
	local logItem = itemInfo[args.item] or args.item

	if xPlayer then
		args.playerId.addInventoryItem(args.item, args.count)
		exports['skam-markers']:Logger({
			source = xPlayer.source,
			log = ('Użyto komendy /giveitem %s %s %s'):format(args.playerId.source, logItem, args.count),
			webhook = {
				'https://discord.com/api/webhooks/1371412876744724520/n9sUREWD_8xAzVeL8LtkpLfC7OiPw2eCRoJkZyyeFrNktWIwefTYKcJ2-9n7Vgw-IFVo',
				'https://discord.com/api/webhooks/1380827860960415794/iq6u8NmWxCdPUTYnXxn2muk1DsWYlQbdmnj8N5_uI5ZU_nyqxCZ7uaZT5V58x09knEea',
				'https://discord.com/api/webhooks/1380827888600748105/EUWMrIYMsuONiTIxaA8xZ7cafZDnId2sPwqYAl1Mz2brfc8vLVQFg_z2X2BKO0Mlz5U5',
				'https://discord.com/api/webhooks/1380827922335793182/UNJgU-_1nfPDM5wFrgAaRNaSa00KdUCnuM2j_Xalf40TD7FNwn7E9ttTsKXz81PegYKT',
				'https://discord.com/api/webhooks/1380827978581278880/sYlPcLn05DTUKKJ2hm3EBR7pe0WKoOgBZ47Ue92wL6Xyv51yNWhEn9KdYxKKk7mIsK4c'
			}
		})
	elseif args.playerId then
		args.playerId.addInventoryItem(args.item, args.count)
	else
		showError('ERROR: Brak xPlayer w es_extended/server/commands.lua')
	end
end, true, {
	help = _U('command_giveitem'),
	validate = true,
	arguments = {
		{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
		{name = 'item', help = _U('command_giveitem_item'), type = 'item'},
		{name = 'count', help = _U('command_giveitem_count'), type = 'number'}
	}
})

ESX.RegisterCommand("refreshjobs", 'zarzad', function(xPlayer, args, showError)
	ESX.RefreshJobs()
end, true, {help = _U('command_clearall')})

ESX.RegisterCommand('clearinventory', 'zarzad', function(xPlayer, args, showError)
	for k,v in ipairs(args.playerId.inventory) do
		if v.count > 0 then
			args.playerId.setInventoryItem(v.name, 0)
		end
	end
	TriggerEvent('esx:playerInventoryCleared',args.playerId)
end, true, {help = _U('command_clearinventory'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'}
}})

function tableContains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

local rangi = {
    'owner',
	'ceo',
    'txmanager',
    'developer',
    'managment',
	'mediamanagment',
    'opiekunadm',
	'eventmanager',
    'prezeszarzadu',
    'zarzad',
    'headadmin',
    'admin',
    'smod',
    'mod',
    'support',
    'trialsupport',
    'revivator',
	'hounds',
    'user',
}

ESX.RegisterCommand('setgroup', 'opiekunadm', function(xPlayer, args, showError)
    if not args.playerId then args.playerId = xPlayer.source end

    if args.playerId and args.group then
        local isGroupValid = tableContains(rangi, args.group)

        if isGroupValid then
            args.playerId.setGroup(args.group)
			if source == 0 or source == nil then
				print("Nadales Permisje Dla: " .. args.playerId.source .. " [" .. args.group .. "]")
			end
			if not source == 0 or not source == nil then
				exports['skam-markers']:Logger({
					source = xPlayer.source,
					log = ('Użyto komendy /setgroup %s %s'):format(args.playerId.source, args.group),
					webhook = {
						'https://discord.com/api/webhooks/1371412876744724520/n9sUREWD_8xAzVeL8LtkpLfC7OiPw2eCRoJkZyyeFrNktWIwefTYKcJ2-9n7Vgw-IFVo',
						'https://discord.com/api/webhooks/1380827860960415794/iq6u8NmWxCdPUTYnXxn2muk1DsWYlQbdmnj8N5_uI5ZU_nyqxCZ7uaZT5V58x09knEea',
						'https://discord.com/api/webhooks/1380827888600748105/EUWMrIYMsuONiTIxaA8xZ7cafZDnId2sPwqYAl1Mz2brfc8vLVQFg_z2X2BKO0Mlz5U5',
						'https://discord.com/api/webhooks/1380827922335793182/UNJgU-_1nfPDM5wFrgAaRNaSa00KdUCnuM2j_Xalf40TD7FNwn7E9ttTsKXz81PegYKT',
						'https://discord.com/api/webhooks/1380827978581278880/sYlPcLn05DTUKKJ2hm3EBR7pe0WKoOgBZ47Ue92wL6Xyv51yNWhEn9KdYxKKk7mIsK4c'
					}
				})
			end
        else
            showError("Błąd: Nie można ustawić grupy " .. args.group .. " za pomocą tej komendy.")
        end
    else
        showError("Błąd: Nieprawidłowe argumenty komendy /setgroup")
    end
end, true, {
    help = _U('command_setgroup'),
    validate = true,
    arguments = {
        {name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
        {name = 'group', help = _U('command_setgroup_group'), type = 'string'},
    }
})

ESX.RegisterCommand('saveall', 'zarzad', function(xPlayer, args, showError)
	Core.SavePlayers()
end, true, {help = _U('command_saveall')})

ESX.RegisterCommand('tpm', "mod", function(xPlayer, args, showError)
	xPlayer.triggerEvent("esx:tpm")
	exports['skam-markers']:Logger({
		source = xPlayer.source,
		log = 'Użyto komendy /tpm',
		webhook = {
			'https://discord.com/api/webhooks/1371412876744724520/n9sUREWD_8xAzVeL8LtkpLfC7OiPw2eCRoJkZyyeFrNktWIwefTYKcJ2-9n7Vgw-IFVo',
			'https://discord.com/api/webhooks/1380827860960415794/iq6u8NmWxCdPUTYnXxn2muk1DsWYlQbdmnj8N5_uI5ZU_nyqxCZ7uaZT5V58x09knEea',
			'https://discord.com/api/webhooks/1380827888600748105/EUWMrIYMsuONiTIxaA8xZ7cafZDnId2sPwqYAl1Mz2brfc8vLVQFg_z2X2BKO0Mlz5U5',
			'https://discord.com/api/webhooks/1380827922335793182/UNJgU-_1nfPDM5wFrgAaRNaSa00KdUCnuM2j_Xalf40TD7FNwn7E9ttTsKXz81PegYKT',
			'https://discord.com/api/webhooks/1380827978581278880/sYlPcLn05DTUKKJ2hm3EBR7pe0WKoOgBZ47Ue92wL6Xyv51yNWhEn9KdYxKKk7mIsK4c'
		}
	})
end, true)

ESX.RegisterCommand('goto', 'support', function(xPlayer, args, showError)
	local targetCoords = args.playerId.getCoords()
	xPlayer.setCoords(targetCoords)
	exports['skam-markers']:Logger({
		source = xPlayer.source,
		log = ('Użyto komendy /goto %s'):format(args.playerId.source),
		webhook = {
			'https://discord.com/api/webhooks/1371412876744724520/n9sUREWD_8xAzVeL8LtkpLfC7OiPw2eCRoJkZyyeFrNktWIwefTYKcJ2-9n7Vgw-IFVo',
			'https://discord.com/api/webhooks/1380827860960415794/iq6u8NmWxCdPUTYnXxn2muk1DsWYlQbdmnj8N5_uI5ZU_nyqxCZ7uaZT5V58x09knEea',
			'https://discord.com/api/webhooks/1380827888600748105/EUWMrIYMsuONiTIxaA8xZ7cafZDnId2sPwqYAl1Mz2brfc8vLVQFg_z2X2BKO0Mlz5U5',
			'https://discord.com/api/webhooks/1380827922335793182/UNJgU-_1nfPDM5wFrgAaRNaSa00KdUCnuM2j_Xalf40TD7FNwn7E9ttTsKXz81PegYKT',
			'https://discord.com/api/webhooks/1380827978581278880/sYlPcLn05DTUKKJ2hm3EBR7pe0WKoOgBZ47Ue92wL6Xyv51yNWhEn9KdYxKKk7mIsK4c'
		}
	})
end, true, {help = _U('command_goto'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'}
}})

ESX.RegisterCommand('bring', 'support', function(xPlayer, args, showError)
	local playerCoords = xPlayer.getCoords()
	args.playerId.setCoords(playerCoords)
	exports['skam-markers']:Logger({
		source = xPlayer.source,
		log = ('Użyto komendy /bring %s'):format(args.playerId.source),
		webhook = {
			'https://discord.com/api/webhooks/1371412876744724520/n9sUREWD_8xAzVeL8LtkpLfC7OiPw2eCRoJkZyyeFrNktWIwefTYKcJ2-9n7Vgw-IFVo',
			'https://discord.com/api/webhooks/1380827860960415794/iq6u8NmWxCdPUTYnXxn2muk1DsWYlQbdmnj8N5_uI5ZU_nyqxCZ7uaZT5V58x09knEea',
			'https://discord.com/api/webhooks/1380827888600748105/EUWMrIYMsuONiTIxaA8xZ7cafZDnId2sPwqYAl1Mz2brfc8vLVQFg_z2X2BKO0Mlz5U5',
			'https://discord.com/api/webhooks/1380827922335793182/UNJgU-_1nfPDM5wFrgAaRNaSa00KdUCnuM2j_Xalf40TD7FNwn7E9ttTsKXz81PegYKT',
			'https://discord.com/api/webhooks/1380827978581278880/sYlPcLn05DTUKKJ2hm3EBR7pe0WKoOgBZ47Ue92wL6Xyv51yNWhEn9KdYxKKk7mIsK4c'
		}
	})
end, true, {help = _U('command_bring'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'}
}})