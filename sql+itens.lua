items = {
    ["suspensaoar"] = {
        label = "Kit de Suspensão a Ar",
        weight = 2000, -- em gramas (exemplo: 2kg)
        description = "Um kit avançado para instalar suspensão a ar em veículos.",
        stack = false, -- não empilhável
        close = true,
        client = {
            use = function(source, item) -- evento ao usar o item
                TriggerServerEvent('zo_cars:installSuspension', GetVehiclePedIsUsing(PlayerPedId()))
            end
        }
    },
    ["moduloneon"] = {
        label = "Módulo de Neon",
        weight = 500, -- em gramas (exemplo: 0.5kg)
        description = "Um módulo que permite instalar luzes neon em veículos.",
        stack = false, -- não empilhável
        close = true,
        client = {
            use = function(source, item) -- evento ao usar o item
                TriggerServerEvent('zo_cars:installNeon', GetVehiclePedIsUsing(PlayerPedId()))
            end
        }
    },
    ["moduloxenon"] = {
        label = "Módulo de Xenon",
        weight = 500, -- em gramas (exemplo: 0.5kg)
        description = "Um módulo que permite instalar faróis xenon em veículos.",
        stack = false, -- não empilhável
        close = true,
        client = {
            use = function(source, item) -- evento ao usar o item
                TriggerServerEvent('zo_cars:installXenon', GetVehiclePedIsUsing(PlayerPedId()))
            end
        }
    }
}


-- Adiciona a coluna 'tuning_data' à tabela 'owned_vehicles'
ALTER TABLE `owned_vehicles`
ADD COLUMN `tuning_data` LONGTEXT DEFAULT NULL;

-- Certifique-se de que a coluna suporta armazenamento de dados JSON
ALTER TABLE `owned_vehicles`
MODIFY COLUMN `tuning_data` LONGTEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL;