fx_version 'adamant'
games { 'rdr3', 'gta5' }
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

author 'Murgator'
description 'Tip4serv'
version '3.0.1'

shared_script 'config.lua'

client_scripts {
    "client/client.lua"
}

server_scripts {
    "server/sha256.lua",
    "server/commands.lua",	
    "server/server.lua"
}
