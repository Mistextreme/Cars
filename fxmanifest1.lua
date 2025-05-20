fx_version 'cerulean'
game 'gta5'

author 'SeuNomeAqui'
description 'Modulo de Customização de Veículos para ESX Legacy'
version '1.0.0'

ui_page 'nui/index.html'

client_scripts {
    '@es_extended/locale.lua', -- Inclui o sistema de localização do ESX
    'locales/br.lua', -- Arquivo de tradução (opcional, ajuste conforme necessário)
    'config.lua', -- Configurações do script
    'client/main.lua' -- Código principal do cliente
}

server_scripts {
    '@es_extended/locale.lua', -- Inclui o sistema de localização do ESX
    'locales/br.lua', -- Arquivo de tradução (opcional, ajuste conforme necessário)
    'config.lua', -- Configurações do script
    'server/main.lua' -- Código principal do servidor
}

files {
    'nui/index.html', -- Página NUI principal
    'nui/style.css', -- Estilo CSS da interface NUI
    'nui/script.js', -- Script JavaScript da interface NUI
    'nui/imgs/*', -- Imagens usadas na interface NUI
    'nui/sounds/*' -- Sons usados na interface NUI
}

dependencies {
    'es_extended' -- Dependência principal do ESX
}