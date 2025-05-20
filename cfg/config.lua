cfg = {}

cfg.comandoXenon = "xenon"
cfg.comandoNeon = "neon"
cfg.comandoSuspensao = "suspe"

cfg.apenasDonoAcessaXenon = true
cfg.apenasDonoAcessaNeon = true
cfg.apenasDonoAcessaSuspensao = true

cfg.permissaoParaInstalar = { existePermissao = true, permissoes = { "mecanico.permissao", "dk.permissao" } }

cfg.blipsShopMec = {
	-- {name='ATM', id=277, x=822.4, y=-952.07, z=22.1},
    { loc = { x = 141.71, y = 6643.66, z = 19.1 }, perms = { "mecanico.permissao", "dk.permissao" } }
}

cfg.valores = {
	{ item = "suspensaoar", quantidade = 1, compra = 100000 },
	{ item = "moduloneon", quantidade = 1, compra = 80000 },
	{ item = "moduloxenon", quantidade = 1, compra = 80000 },
}
