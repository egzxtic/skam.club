fx_version 'cerulean'
lua54 'yes'
game 'gta5'
author 'skam.club'

server_scripts {
   '@oxmysql/lib/MySQL.lua',
    'lua/server/**'
}

client_scripts {
    'lua/client/**'
}

shared_script 'lua/config.lua'
shared_script 'lua/shared/debug.lua'
ui_page 'web/countdown.html'
file 'web/**'