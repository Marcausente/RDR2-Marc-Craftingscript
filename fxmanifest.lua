fx_version 'cerulean'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
game 'rdr3'

name 'marc_crafting'
description 'Sistema de crafting avanzado con múltiples estaciones de trabajo.'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
}

server_scripts {
    'server.lua',
}

client_scripts {
    'client.lua',
}

dependencies {
    'rsg-core',
    'ox_lib',
    'ox_target',
    'rsg-inventory',
}

lua54 'yes'
