ESX = exports["es_extended"]:getSharedObject()

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if instalando then
            DisableControlAction(0, 167, true) -- Desabilita ação de sair do veículo durante instalação
        end
    end
end)

Citizen.CreateThread(function()
    RegisterCommand(Config.comandoXenon, function(source, args, rawCommand)
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)
        if DoesEntityExist(vehicle) then
            ESX.TriggerServerCallback('zo_cars:checkXenon', function(hasXenon)
                if hasXenon then
                    local vehicleSpeed = math.ceil(GetEntitySpeed(vehicle) * 3.605936)
                    local cor = GetVehicleXenonLightsColour(vehicle)
                    if vehicleSpeed <= 25 then
                        ToggleVehicleMod(vehicle, 22, true)
                        SetNuiFocus(true, true)
                        SendNUIMessage({
                            type = 'openXenon',
                            color = cor
                        })
                    else
                        ESX.ShowNotification("Você está muito rápido!")
                    end
                else
                    ESX.ShowNotification("O veículo não possui o módulo de xenon.")
                end
            end, vehicle)
        else
            ESX.ShowNotification("Você não está em um veículo!")
        end
    end)

    RegisterCommand(Config.comandoNeon, function(source, args, rawCommand)
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)
        if DoesEntityExist(vehicle) then
            ESX.TriggerServerCallback('zo_cars:checkNeon', function(hasNeon)
                if hasNeon then
                    local vehicleSpeed = math.ceil(GetEntitySpeed(vehicle) * 3.605936)
                    local cor = { r = 255, g = 255, b = 255 }
                    if checkNeonIsEnable(vehicle) then
                        cor = GetVehicleNeonLightsColour(vehicle)
                    end
                    if vehicleSpeed <= 25 then
                        SetNuiFocus(true, true)
                        SendNUIMessage({
                            type = 'openNeon',
                            color = cor
                        })
                    else
                        ESX.ShowNotification("Você está muito rápido!")
                    end
                else
                    ESX.ShowNotification("O veículo não possui o módulo de neon.")
                end
            end, vehicle)
        else
            ESX.ShowNotification("Você não está em um veículo!")
        end
    end)

    RegisterCommand(Config.comandoSuspensao, function(source, args, rawCommand)
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)
        if DoesEntityExist(vehicle) then
            ESX.TriggerServerCallback('zo_cars:checkSuspension', function(hasSuspension)
                if hasSuspension then
                    local vehicleSpeed = math.ceil(GetEntitySpeed(vehicle) * 3.605936)
                    if vehicleSpeed <= 25 then
                        SetNuiFocus(true, true)
                        SendNUIMessage({ type = 'openControle' })
                    else
                        ESX.ShowNotification("Você está muito rápido!")
                    end
                else
                    ESX.ShowNotification("O veículo não possui suspensão a ar!")
                end
            end, vehicle)
        else
            ESX.ShowNotification("Você não está em um veículo!")
        end
    end)
end)

function checkNeonIsEnable(vehicle)
    local toggle = false
    local lados = { 0, 1, 2, 3 }
    for i, l in pairs(lados) do
        if IsVehicleNeonLightEnabled(vehicle, l) then
            toggle = true
        end
    end
    return toggle
end

RegisterNetEvent('zo_install_mod_xenon')
AddEventHandler('zo_install_mod_xenon', function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsUsing(ped)
    if DoesEntityExist(vehicle) then
        if ped == GetPedInVehicleSeat(vehicle, -1) then
            local vehicleSpeed = math.ceil(GetEntitySpeed(vehicle) * 3.605936)
            if vehicleSpeed == 0 then
                ESX.TriggerServerCallback('zo_cars:checkPermission', function(hasPermission)
                    if hasPermission then
                        ESX.TriggerServerCallback('zo_cars:checkXenon', function(hasXenon)
                            if not hasXenon then
                                SetVehicleEngineOn(vehicle, false, true, true)
                                TriggerServerEvent('zo_cars:installXenon', vehicle)
                            else
                                ESX.ShowNotification("Veículo já possui módulo de Xenon.")
                            end
                        end, vehicle)
                    else
                        ESX.ShowNotification("Você não possui permissão para instalar o módulo de Xenon!")
                    end
                end)
            else
                ESX.ShowNotification("O veículo deve estar parado!")
            end
        else
            ESX.ShowNotification("Você não é o motorista do veículo.")
        end
    else
        ESX.ShowNotification("Você não está em um veículo!")
    end
end)

RegisterNetEvent('zo_install_mod_neon')
AddEventHandler('zo_install_mod_neon', function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsUsing(ped)
    if DoesEntityExist(vehicle) then
        if ped == GetPedInVehicleSeat(vehicle, -1) then
            local vehicleSpeed = math.ceil(GetEntitySpeed(vehicle) * 3.605936)
            if vehicleSpeed == 0 then
                ESX.TriggerServerCallback('zo_cars:checkPermission', function(hasPermission)
                    if hasPermission then
                        ESX.TriggerServerCallback('zo_cars:checkNeon', function(hasNeon)
                            if not hasNeon then
                                SetVehicleEngineOn(vehicle, false, true, true)
                                TriggerServerEvent('zo_cars:installNeon', vehicle)
                            else
                                ESX.ShowNotification("Veículo já possui módulo de neon.")
                            end
                        end, vehicle)
                    else
                        ESX.ShowNotification("Você não possui permissão para instalar o módulo de neon!")
                    end
                end)
            else
                ESX.ShowNotification("O veículo deve estar parado!")
            end
        else
            ESX.ShowNotification("Você não é o motorista do veículo.")
        end
    else
        ESX.ShowNotification("Você não está em um veículo!")
    end
end)

RegisterNetEvent('zo_install_suspe_ar')
AddEventHandler('zo_install_suspe_ar', function()
    ESX.TriggerServerCallback('zo_cars:checkPermission', function(hasPermission)
        if hasPermission then
            local ped = PlayerPedId()
            local vehicle = GetVehiclePedIsUsing(ped)
            if DoesEntityExist(vehicle) then
                ESX.TriggerServerCallback('zo_cars:checkSuspension', function(hasSuspension)
                    if not hasSuspension then
                        local coords = GetEntityCoords(ped)
                        local partsProntas = {}
                        local parts = { "wheel_lf", "wheel_lr", "wheel_rf", "wheel_rr" }

                        for i, v in ipairs(parts) do
                            local bone = GetEntityBoneIndexByName(vehicle, v)
                            if bone ~= -1 then
                                local bonePos = GetWorldPositionOfEntityBone(vehicle, bone)
                                if bonePos then
                                    local len = #(coords - bonePos)
                                    if len < 5 then
                                        local x, y, z = table.unpack(bonePos)
                                        DrawMarker(
                                            1,
                                            x,
                                            y,
                                            z - 1.5,
                                            0,
                                            0,
                                            0,
                                            0,
                                            0,
                                            0,
                                            1.0,
                                            1.0,
                                            1.7,
                                            0,
                                            255,
                                            0,
                                            155,
                                            0,
                                            0,
                                            0,
                                            1
                                        )
                                        DrawText3D(x, y, z, "Pressione [~r~E~w~] para instalar a suspensão nesta roda.")
                                        if IsControlJustPressed(0, 38) then
                                            instalando = true
                                            Citizen.CreateThread(function()
                                                while true do
                                                    Citizen.Wait(2000)
                                                    local nearestVehicle = GetVehiclePedIsUsing(ped)
                                                    if not DoesEntityExist(nearestVehicle) or #partsProntas == 4 then
                                                        break
                                                    end
                                                end
                                            end)
                                            TriggerServerEvent('zo_cars:anim')
                                            partsProntas[v] = v
                                        end
                                    end
                                end
                            end
                        end

                        if #partsProntas == 4 then
                            TriggerServerEvent('zo_cars:setSuspensao', vehicle)
                            ESX.ShowNotification("Suspensão a ar instalada no veículo!")
                        end
                    else
                        ESX.ShowNotification("Veículo já possui suspensão a ar.")
                    end
                end, vehicle)
            else
                ESX.ShowNotification("Você não está próximo de um veículo!")
            end
        else
            ESX.ShowNotification("Você não possui permissão para instalar suspensão a ar!")
        end
    end)
end)

RegisterNetEvent('synczosuspe')
AddEventHandler('synczosuspe', function(vehicle, altura)
    if NetworkDoesNetworkIdExist(vehicle) then
        local veh = NetToVeh(vehicle)
        if DoesEntityExist(veh) then
            SetVehicleSuspensionHeight(veh, altura)
        end
    end
end)

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(true)
        AddTextComponentString(text)
        DrawText(_x, _y)
        local factor = (string.len(text)) / 370
        DrawRect(_x, _y + 0.0125, 0.003 + factor, 0.03, 41, 11, 41, 68)
    end
end

local menuactive = false

function ToggleActionMenu()
    menuactive = not menuactive
    if menuactive then
        SetNuiFocus(true, true)
        TransitionToBlurred(1000)
        SendNUIMessage({ showmenu = true })
    else
        SetNuiFocus(false, false)
        TransitionFromBlurred(1000)
        SendNUIMessage({ hidemenu = true })
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        for k, l in pairs(Config.blipsShopMec) do
            local loc = l.loc
            local ped = PlayerPedId()
            local pedCoords = GetEntityCoords(ped)
            local distance = #(pedCoords - vector3(loc.x, loc.y, loc.z))

            if distance < 5.1 then
                DrawMarker(
                    23,
                    loc.x,
                    loc.y,
                    loc.z - 0.99,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0.7,
                    0.7,
                    0.5,
                    136,
                    96,
                    240,
                    180,
                    0,
                    0,
                    0,
                    0
                )

                if distance < 2.1 and not menuactive then
                    DrawText3D(loc.x, loc.y, loc.z, "Pressione [~p~E~w~] para acessar a loja de peças.")
                end

                if distance <= 1.2 then
                    if IsControlJustPressed(0, 38) then
                        ESX.TriggerServerCallback('zo_cars:checkPermissionShop', function(hasPermission)
                            if hasPermission then
                                ToggleActionMenu()
                            else
                                ESX.ShowNotification("Você não possui permissão para acessar esta loja.")
                            end
                        end, l.perms)
                    end
                end
            end
        end
    end
end)

RegisterKeyMapping("suspe", "Controle suspensão", "keyboard", "6")
RegisterKeyMapping("neon", "Módulo do neon", "keyboard", "7")
RegisterKeyMapping("xenon", "Módulo do xenon", "keyboard", "8")

RegisterNUICallback("ButtonClick", function(data, cb)
    if data == "comprar-suspensao" then
        TriggerServerEvent("departamento-comprar", "suspensaoar")
    elseif data == "comprar-neon" then
        TriggerServerEvent("departamento-comprar", "moduloneon")
    elseif data == "comprar-xenon" then
        TriggerServerEvent("departamento-comprar", "moduloxenon")
    elseif data == "fechar" then
        ToggleActionMenu()
    end

    if data.action == "closeNuis" then
        SetNuiFocus(false, false)
        SendNUIMessage({ type = 'closeNuis' })
    end

    if data.action == "trocar-cor-xenon" then
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)
        if DoesEntityExist(vehicle) then
            SetVehicleXenonLightsColour(vehicle, data.cor)
        end
    end

    if data.action == "on-off-neon" then
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)
        if DoesEntityExist(vehicle) then
            local toggle = checkNeonIsEnable(vehicle)
            local lados = { 0, 1, 2, 3 }
            for i, l in pairs(lados) do
                SetVehicleNeonLightEnabled(vehicle, l, not toggle)
            end

            if not toggle then
                local r, g, b = GetVehicleNeonLightsColour(vehicle)
                SendNUIMessage({
                    type = 'setColorNeon',
                    color = {
                        r = r,
                        g = g,
                        b = b
                    }
                })
            end
        end
    end

    if data.action == "toggle-neon" then
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)
        if DoesEntityExist(vehicle) then
            SetVehicleNeonLightEnabled(vehicle, data.lado, not IsVehicleNeonLightEnabled(vehicle, data.lado))
        end
    end

    if data.action == "trocar-cor-neon" then
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)
        if DoesEntityExist(vehicle) then
            SetVehicleNeonLightsColour(vehicle, data.cor.r, data.cor.g, data.cor.b)
        end
    end

    if data.action == "savepreset" then
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)
        if DoesEntityExist(vehicle) then
            local alturaAtual = GetVehicleSuspensionHeight(vehicle)
            TriggerServerEvent('zo_cars:setPreset', alturaAtual)
            ESX.ShowNotification("Novo preset definido para suspensão!")
        end
    end

    if data.action == "useControl" then
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)
        if DoesEntityExist(vehicle) then
            local alturaAnterior = GetVehicleSuspensionHeight(vehicle)
            local alturaAtual = 0
            local variacao = 0.003
            local type = data.typeAction

            if type == 'max' then
                alturaAtual = tonumber(-0.09)
                variacao = 0.003
            elseif type == 'normal' then
                alturaAtual = tonumber(0.0)
                variacao = 0.003
            elseif type == 'low' then
                alturaAtual = tonumber(0.09)
                variacao = 0.003
            elseif type == 'up' then
                alturaAtual = alturaAnterior - tonumber(0.003)
                variacao = 0.0003
            elseif type == 'down' then
                alturaAtual = alturaAnterior + tonumber(0.003)
                variacao = 0.0003
            elseif type == 'preset' then
                variacao = 0.003
                alturaAtual = tonumber(ESX.TriggerServerCallback('zo_cars:returnPreset'))
            end

            if alturaAtual > tonumber(0.095) then
                ESX.ShowNotification("Altura máxima atingida!")
                return
            end

            if alturaAtual < tonumber(-0.095) then
                ESX.ShowNotification("Altura mínima atingida!")
                return
            end

            if alturaAnterior < alturaAtual then
                PlaySoundFrontend(-1, "esvaziar", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
                TriggerServerEvent("tryzosuspe", VehToNet(vehicle), alturaAtual, alturaAnterior, variacao, "descer")
            else
                PlaySoundFrontend(-1, "encher", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
                TriggerServerEvent("tryzosuspe", VehToNet(vehicle), alturaAtual, alturaAnterior, variacao, "subir")
            end
        end
    end
end)