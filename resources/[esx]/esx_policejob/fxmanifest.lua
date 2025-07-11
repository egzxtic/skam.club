fx_version 'adamant'
game 'gta5'
lua54 'yes'

shared_script '@es_extended/imports.lua'

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/*.lua',
	'config.lua',
	'server.lua'
}

client_scripts {
	'@skam-markers/imports.lua',
	'@es_extended/locale.lua',
	'locales/*.lua',
	'config.lua',
	'client.lua',
	'vehicle.lua'
}

files {
    'duty_hours.json'
}

dependencies {
	'es_extended',
	'skam-markers'
}

server_exports {
	'GetLoot',
	'SetLoot',
	'SetCanSearch'
}