Config = {}

-- Comandos para ativar os modulos
Config.comandoXenon = "xenon" -- Comando para controlar o módulo de Xenon
Config.comandoNeon = "neon" -- Comando para controlar o módulo de Neon
Config.comandoSuspensao = "suspe" -- Comando para controlar a suspensão a ar

-- Configuração de acesso apenas para o dono do veículo
Config.apenasDonoAcessaXenon = true -- Apenas o dono pode acessar o módulo de Xenon
Config.apenasDonoAcessaNeon = true -- Apenas o dono pode acessar o módulo de Neon
Config.apenasDonoAcessaSuspensao = true -- Apenas o dono pode acessar a suspensão a ar

-- Configuração de permissões para instalar modulos
Config.permissaoParaInstalar = {
    existePermissao = true, -- Define se é necessário ter permissão para instalar
    permissoes = { "mecanico.permissao", "dk.permissao" } -- Grupos que têm permissão para instalar
}

-- Blips das lojas de mecânica
Config.blipsShopMec = {
    { 
        loc = { x = 141.71, y = 6643.66, z = 19.1 }, -- Coordenadas do blip
        perms = { "mecanico.permissao", "dk.permissao" } -- Permissões necessárias para acessar
    }
}

-- Valores dos itens na loja
Config.valores = {
    { item = "suspensaoar", quantidade = 1, compra = 100000 }, -- Suspensão a ar
    { item = "moduloneon", quantidade = 1, compra = 80000 }, -- Módulo de Neon
    { item = "moduloxenon", quantidade = 1, compra = 80000 } -- Módulo de Xenon
}