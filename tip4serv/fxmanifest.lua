fx_version 'adamant'
games { 'gta5' }

author 'Murgator'
description 'Tip4serv'
version '2.0.1'

shared_script 'config.lua'

client_scripts {
    "client/client.lua"
}

server_scripts {
    "server/sha256.lua",
    "server/commands.lua",	
    "server/server.lua"
}
