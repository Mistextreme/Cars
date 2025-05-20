ESX = exports["es_extended"]:getSharedObject()

Config = Config or {}

-- Função para verificar permissões
RegisterServerEvent('zo_cars:checkPermission')
AddEventHandler('zo_cars:checkPermission', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if Config.permissaoParaInstalar.existePermissao then
        for _, group in ipairs(Config.permissaoParaInstalar.permissoes) do
            if xPlayer.getGroup() == group or xPlayer.hasPermission(group) then
                TriggerClientEvent('zo_cars:permissionResult', _source, true)
                return
            end
        end
    else
        TriggerClientEvent('zo_cars:permissionResult', _source, true)
        return
    end
    TriggerClientEvent('zo_cars:permissionResult', _source, false)
end)

-- Função para verificar permissões na loja
RegisterServerCallback('zo_cars:checkPermissionShop', function(source, cb, perms)
    local xPlayer = ESX.GetPlayerFromId(source)
    for _, perm in ipairs(perms) do
        if xPlayer.getGroup() == perm or xPlayer.hasPermission(perm) then
            cb(true)
            return
        end
    end
    cb(false)
end)

-- Função para instalar módulo de Xenon
RegisterServerEvent('zo_cars:installXenon')
AddEventHandler('zo_cars:installXenon', function(vehicle)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)

    if xPlayer.getInventoryItem("moduloxenon").count >= 1 then
        xPlayer.removeInventoryItem("moduloxenon", 1)
        local customData = GetCustomVehicleData(vehicleProps.plate)
        customData.xenonControl = 1
        SaveCustomVehicleData(vehicleProps.plate, customData)
        TriggerClientEvent('esx:showNotification', _source, "Módulo de Xenon instalado no veículo!")
    else
        TriggerClientEvent('esx:showNotification', _source, "Você não possui um módulo de Xenon.")
    end
end)

-- Função para verificar se o veículo tem Xenon
RegisterServerCallback('zo_cars:checkXenon', function(source, cb, vehicle)
    local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
    local customData = GetCustomVehicleData(vehicleProps.plate)
    cb(customData and customData.xenonControl == 1)
end)

-- Função para instalar módulo de Neon
RegisterServerEvent('zo_cars:installNeon')
AddEventHandler('zo_cars:installNeon', function(vehicle)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)

    if xPlayer.getInventoryItem("moduloneon").count >= 1 then
        xPlayer.removeInventoryItem("moduloneon", 1)
        local customData = GetCustomVehicleData(vehicleProps.plate)
        customData.neonControl = 1
        SaveCustomVehicleData(vehicleProps.plate, customData)
        TriggerClientEvent('esx:showNotification', _source, "Módulo de Neon instalado no veículo!")
    else
        TriggerClientEvent('esx:showNotification', _source, "Você não possui um módulo de Neon.")
    end
end)

-- Função para verificar se o veículo tem Neon
RegisterServerCallback('zo_cars:checkNeon', function(source, cb, vehicle)
    local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
    local customData = GetCustomVehicleData(vehicleProps.plate)
    cb(customData and customData.neonControl == 1)
end)

-- Função para instalar suspensão a ar
RegisterServerEvent('zo_cars:installSuspension')
AddEventHandler('zo_cars:installSuspension', function(vehicle)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)

    if xPlayer.getInventoryItem("suspensaoar").count >= 1 then
        xPlayer.removeInventoryItem("suspensaoar", 1)
        local customData = GetCustomVehicleData(vehicleProps.plate)
        customData.suspensaoAr = 1
        SaveCustomVehicleData(vehicleProps.plate, customData)
        TriggerClientEvent('esx:showNotification', _source, "Suspensão a ar instalada no veículo!")
    else
        TriggerClientEvent('esx:showNotification', _source, "Você não possui um Kit de Suspensão a Ar.")
    end
end)

-- Função para verificar se o veículo tem suspensão a ar
RegisterServerCallback('zo_cars:checkSuspension', function(source, cb, vehicle)
    local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
    local customData = GetCustomVehicleData(vehicleProps.plate)
    cb(customData and customData.suspensaoAr == 1)
end)

-- Função para salvar preset da suspensão
RegisterServerEvent('zo_cars:setPreset')
AddEventHandler('zo_cars:setPreset', function(value, vehicle)
    local _source = source
    local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
    local customData = GetCustomVehicleData(vehicleProps.plate)
    customData.presetSuspe = value
    SaveCustomVehicleData(vehicleProps.plate, customData)
end)

-- Função para retornar o preset da suspensão
RegisterServerCallback('zo_cars:returnPreset', function(source, cb, vehicle)
    local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
    local customData = GetCustomVehicleData(vehicleProps.plate)
    cb(customData and customData.presetSuspe or 0)
end)

-- Função para retornar os parâmetros do preset
RegisterServerCallback('zo_cars:returnPresetParameters', function(source, cb, vname, placa)
    local customData = GetCustomVehicleData(placa)
    cb(customData and customData.presetSuspe or 0)
end)

-- Função para sincronizar a altura da suspensão
RegisterServerEvent('tryzosuspe')
AddEventHandler('tryzosuspe', function(vehicle, pAlturaAtual, pAlturaAnterior, variacao, type)
    local vehicleNet = tonumber(vehicle)
    local vehicleEntity = NetToVeh(vehicleNet)
    if DoesEntityExist(vehicleEntity) then
        local altura = pAlturaAnterior
        if type == "subir" then
            while altura > pAlturaAtual do
                altura = altura - variacao
                TriggerClientEvent("synczosuspe", -1, vehicle, altura)
                Citizen.Wait(1)
            end
        elseif type == "descer" then
            while altura < pAlturaAtual do
                altura = altura + variacao
                TriggerClientEvent("synczosuspe", -1, vehicle, altura)
                Citizen.Wait(1)
            end
        end
    end
end)

-- Função para comprar itens na loja
RegisterServerEvent('departamento-comprar')
AddEventHandler('departamento-comprar', function(item)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    for k, v in pairs(Config.valores) do
        if item == v.item then
            if xPlayer.canCarryItem(v.item, v.quantidade) then
                if xPlayer.getMoney() >= v.compra then
                    xPlayer.removeMoney(v.compra)
                    xPlayer.addInventoryItem(v.item, v.quantidade)
                    TriggerClientEvent('esx:showNotification', _source, 'Comprou ~g~' .. v.quantidade .. 'x ' .. v.item .. '~w~ por ~g~$' .. v.compra .. '.')
                else
                    TriggerClientEvent('esx:showNotification', _source, 'Dinheiro insuficiente.')
                end
            else
                TriggerClientEvent('esx:showNotification', _source, 'Espaço insuficiente no inventário.')
            end
        end
    end
end)

-- Função para obter os dados personalizados do veículo
function GetCustomVehicleData(plate)
    local result = MySQL.Sync.fetchScalar('SELECT tuning_data FROM owned_vehicles WHERE plate = ?', { plate })
    if result then
        return json.decode(result) or {}
    end
    return {}
end

-- Função para salvar os dados personalizados do veículo
function SaveCustomVehicleData(plate, data)
    MySQL.Async.execute('UPDATE owned_vehicles SET tuning_data = ? WHERE plate = ?', { json.encode(data), plate })
end