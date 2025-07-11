fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'
lua54 'yes'
game 'gta5'

name 'skam-itemshop'

shared_script {
    'config.lua',
    '@es_extended/imports.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    's.lua'
}

client_scripts {
    'c.lua'
}

dependencies {
    'es_extended',
}

ui_page {
	'html/index.html',
}

files {
	'html/index.html',
	'html/**/*'
}