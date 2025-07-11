fx_version 'adamant'
game 'gta5'
lua54 'yes'

shared_script '@es_extended/imports.lua'

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	's.lua'
}

client_scripts {
	'c.lua'
}

dependencies {
	'es_extended',
	'skinchanger'
}