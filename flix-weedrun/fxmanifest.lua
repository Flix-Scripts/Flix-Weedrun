fx_version('cerulean')
games({ 'gta5' })

client_scripts{
    'client.lua'
}

server_scripts{
    'server.lua'
}

shared_scripts{
    '@ox_lib/init.lua',
    'config.lua',
}

lua54 'yes'

author 'Flix(flixireielireiflix)'

version '1.0.0'