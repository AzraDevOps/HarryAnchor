fx_version "cerulean"
game "gta5"
lua54 "yes"

author "Harry MEYERS#6408"
description "Anchor System"
version "2.0.0"	-- 14 january 2024

shared_scripts {
	'@es_extended/imports.lua',
	'@ox_lib/init.lua',
}

client_scripts {
	"client/harryanchor_client.lua"
}

-- server_scripts {}
-- ui_page ""
-- files {}
-- escrow_ignore {}
-- dependency ''