fx_version "adamant"
game {"gta5"}
lua54 'yes'

name 'tiss_CoreMenu'


server_script {
    "Modules/**/**/server/*.lua",
    '@oxmysql/lib/MySQL.lua',
    'Modules/[Utils]/MenuAdmin/config/esx-server.lua',
    'Modules/[Utils]/MenuAdmin/code/sv_callback.lua',
    'Modules/[Utils]/MenuAdmin/code/server.lua',
    'Modules/[Utils]/MenuAdmin/code/uniqueId/server.lua',
    'Modules/[Utils]/MenuAdmin/crypted/ranks.lua',
    'Modules/[Utils]/MenuAdmin/code/sanctions.lua',
    'Modules/[Utils]/MenuAdmin/code/jail/server.lua',
    'Modules/[Utils]/MenuAdmin/code/sv_bans.lua',
    'Modules/[Utils]/MenuAdmin/code/staffgun/sv_staffgun.lua',
}

shared_scripts {
    'Modules/[Utils]/Freecam/shared/*.lua',
    'Modules/[Utils]/me/shared/config.lua',
    'Modules/[Utils]/MenuAdmin/config/permissions.lua',
    'Modules/[Utils]/MenuAdmin/config/config.lua',
    'Modules/[Utils]/MenuAdmin/config/logs.lua',
    'Modules/[Utils]/MenuAdmin/config/shared_functions.lua',
    'Modules/[Utils]/MenuAdmin/code/helper.lua',
    '@es_extended/imports.lua',
    'config/*.lua'
}

client_scripts {
    "@tiss_menu/tiss_menu.lua",
    "Modules/**/**/client/*.lua", 
    'Modules/[Utils]/MenuAdmin/config/esx-client.lua',
    "Modules/[Utils]/MenuAdmin/RageUI/RMenu.lua",
    "Modules/[Utils]/MenuAdmin/RageUI/menu/RageUI.lua",
    "Modules/[Utils]/MenuAdmin/RageUI/menu/Menu.lua",
    "Modules/[Utils]/MenuAdmin/RageUI/menu/MenuController.lua",
    "Modules/[Utils]/MenuAdmin/RageUI/components/*.lua",
    "Modules/[Utils]/MenuAdmin/RageUI/menu/elements/*.lua",
    "Modules/[Utils]/MenuAdmin/RageUI/menu/items/*.lua",
    "Modules/[Utils]/MenuAdmin/RageUI/menu/panels/*.lua",
    "Modules/[Utils]/MenuAdmin/RageUI/menu/windows/*.lua",
    'Modules/[Utils]/MenuAdmin/code/cl_callback.lua',
    'Modules/[Utils]/MenuAdmin/code/client.lua',
    'Modules/[Utils]/MenuAdmin/code/actions.lua',
    'Modules/[Utils]/MenuAdmin/code/spectate.lua',
    'Modules/[Utils]/MenuAdmin/code/uniqueId/client.lua',
    'Modules/[Utils]/MenuAdmin/code/noclip.lua',
    'Modules/[Utils]/MenuAdmin/code/open_functions.lua',
    'Modules/[Utils]/MenuAdmin/code/functions.lua', 
    'Modules/[Utils]/MenuAdmin/code/menus/*.lua',
    'Modules/[Utils]/MenuAdmin/code/jail/client.lua',
    'Modules/[Utils]/MenuAdmin/config/custom_menu.lua',
    'Modules/[Utils]/MenuAdmin/code/skin.lua',
    'Modules/[Utils]/MenuAdmin/code/staffgun/cl_staffgun.lua',
    'Modules/[Utils]/Input/client.lua'
}

exports {
    'checkAcces',
    'checkPerms',
    'getStaffMode',
    "Show",
	"ShowSync",
	"IsVisible",
	"Hide",
}

client_exports {
    'checkPerms',
    'getStaffMode',
}
server_exports {
    'checkAcces',
    'checkPerms',
    'getStaffMode',
    'getUIDfromID',
    'getIDfromUID',
    'getIdentifierfromUID',
    'getUIDfromIdentifier',
}


client_scripts {
	
}



files {
	"Modules/[Utils]/Input/ui/*.css",
	"Modules/[Utils]/Input/ui/*.js",
	"Modules/[Utils]/Input/ui/*.html"
}
ui_page "Modules/[Utils]/Input/ui/ui.html"



--client_scripts {
   -- "Modules/Emote/Rage/RMenu.lua",
   -- "Modules/Emote/Rage/menu/RageUI.lua",
    --"Modules/Emote/Rage/menu/Menu.lua",
   -- "Modules/Emote/Rage/menu/MenuController.lua",
   -- "Modules/Emote/Rage/components/*.lua",
   -- "Modules/Emote/Rage/menu/elements/*.lua",
   -- "Modules/Emote/Rage/menu/items/*.lua",
    --"Modules/Emote/Rage/menu/panels/*.lua",
   -- "Modules/Emote/Rage/menu/windows/*.lua",
--}