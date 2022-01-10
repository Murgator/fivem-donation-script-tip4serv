fx_version 'adamant'
games { 'gta5' }

author 'Murgator'
description 'Tip4serv'
version '1.0.5'

shared_script 'config.lua'

server_scripts {
    '@async/async.lua',
    'server/sha256.lua',
    'server/server.lua'
}
