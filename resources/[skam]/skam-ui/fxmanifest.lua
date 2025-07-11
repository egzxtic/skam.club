fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'skam.club'
ui_page_nui 'true'

shared_scripts {
    '@es_extended/imports.lua',
    'config.lua'
}

client_scripts {
    '@skam-markers/imports.lua',
    'lua/**/client.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'lua/**/server.lua',
}

ui_page 'dist/index.html'

files {
    'dist/**',
    'dist/items/*.png',
}