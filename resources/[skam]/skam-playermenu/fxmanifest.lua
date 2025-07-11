fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'skam.club'

shared_scripts {
    '@es_extended/imports.lua',
}

client_scripts {
    -- '@skam-markers/imports.lua',
    'lua/c.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'lua/s.lua'
}

ui_page 'build/dist/index.html'

files {
    'build/dist/**',
    --'web/items/*.png',
}