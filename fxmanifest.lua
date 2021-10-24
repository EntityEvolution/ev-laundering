fx_version 'cerulean'
game 'gta5'

lua54 'yes'
use_fxv2_oal 'yes'

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/CircleZone.lua',
	'@PolyZone/ComboZone.lua',
    'config/config_cl.lua',
    'client/cl.lua'
}
server_script 'server/sv.lua'

ui_page 'ui/index.html'

files {
    'ui/index.html',
    'ui/css/style.css',
    'ui/js/*.js',
    'ui/fonts/*.ttf'
}

dependency 'PolyZone'