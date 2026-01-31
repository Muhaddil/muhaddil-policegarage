fx_version 'cerulean'
game 'gta5'

author 'Muhaddil'
description 'Un sistema de garajes para facciones.'
version 'v1.0.0'

ui_page 'html/index.html'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client/*'
}

server_scripts {
    'server/*'
}

files {
    'html/*'
}

dependencies {
    'ox_lib',
}
