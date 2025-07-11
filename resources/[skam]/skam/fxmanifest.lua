fx_version 'cerulean'
game 'gta5'
lua54 'yes'
author 'skam.club'

escrow_ignore {
    'server.lua',
    'modules/**/server.lua',
}

dependencies {
    'skam-markers'
}

shared_scripts {
    '@es_extended/imports.lua',
    'config.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'config.lua',
    'server.lua',
    'modules/**/server.lua',
    'modules/ban/functions.lua',
    'modules/discord/log.lua',
}

client_scripts {
    '@skam-markers/imports.lua',
    'config.lua',
    'client.lua',
    'anims.lua',
    'modules/**/client.lua',
    'modules/admin/gui.lua',
}

files {
    'loading/index.html',
    'loading/*.png',
    'stream/**/*.ytd',
    'stream/**/*.ydd',
    'stream/**/*.gfx',
}

loadscreen_cursor 'yes'
loadscreen 'loading/index.html'
loadscreen_manual_shutdown 'yes'

data_file 'DLC_ITYP_REQUEST' 'stream/mads_no_exp_pumps.ytyp'
data_file 'SCALEFORM_DLC_FILE' 'stream/**/int3232302352.gfx'