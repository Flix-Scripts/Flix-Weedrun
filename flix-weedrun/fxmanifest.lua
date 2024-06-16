fx_version('cerulean')
games({ 'gta5' })

client_scripts{
    'cl_*.lua'
}

server_scripts{
    'sv_*.lua'
}

shared_scripts{
    '@ox_lib/init.lua',
    'config.lua',
}

lua54 'yes'

author 'Flix(flixireielireiflix)'

version '1.0.0'