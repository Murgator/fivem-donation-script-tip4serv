fx_version 'adamant'
games { 'gta5' }

author 'Murgator'
description 'Tip4serv'
version '1.0.0'

server_scripts {
	'@async/async.lua',
	'@mysql-async/lib/MySQL.lua',
    "server/sha256.lua",
    "server/server.lua"
}

dependencies {
	'es_extended',
	'async'
}
