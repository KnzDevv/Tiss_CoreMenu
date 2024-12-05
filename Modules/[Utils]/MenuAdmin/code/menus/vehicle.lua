local colour_index= {
	primary = {1,5},
	secondary = {1,5}
}

local selectedPrimaryColor = {
	r = 0,
	g = 0,
	b = 0,
}

function MenuVehicle()
    if IsControlPressed(0, 19) then
        SetMouseCursorActiveThisFrame()
    end
    RageUI.Separator('      En vrai chez pas')
    if YveltHelper:getAcces(player, 'spawnVeh') then
        RageUI.Button("Spawn avec le nom", nil, {RightLabel = YveltConfig.RightLabel}, true, {
            onSelected = function()
                local modelName  = exports["input"]:ShowSync('Entrez le nom du véhicule :', false, 320., "small_text")
                YveltHelper:spawnVehicle(modelName)
            end
        })
    else
        RageUI.Button('Spawn avec le nom', nil, {}, false, {})
    end
    if YveltHelper:getAcces(player, 'delVeh') then
        RageUI.Button("Supprimer le véhicule", nil, {RightLabel = YveltConfig.RightLabel}, true, {
            onActive = function()
                local playerPed = PlayerPedId()
                local playerCoords = GetEntityCoords(playerPed)
                local vehicle = ESX.Game.GetClosestVehicle(playerCoords)
                local vehiclePos = GetEntityCoords(vehicle)
                DrawMarker(21, vehiclePos.x, vehiclePos.y, vehiclePos.z + 1.3, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.3,0.3, 0.3, 255, 0, 0, 255, true, true, p19, true)
            end,
            onSelected = function()
                local playerPed = PlayerPedId()
                local playerCoords = GetEntityCoords(playerPed)
                local vehicle = ESX.Game.GetClosestVehicle(playerCoords)

                if DoesEntityExist(vehicle) then
                    deleteVeh(vehicle)
                end
            end
        })
    else
        RageUI.Button('Supprimer le véhicule', nil, {}, false, {})
    end
    if YveltHelper:getAcces(player, 'repairVeh') then
        RageUI.Button("Réparer le véhicule", nil, {RightLabel = YveltConfig.RightLabel}, true, {
            onActive = function()
                local playerPed = PlayerPedId()
                local playerCoords = GetEntityCoords(playerPed)
                local vehicle = ESX.Game.GetClosestVehicle(playerCoords)
                local vehiclePos = GetEntityCoords(vehicle)
                DrawMarker(21, vehiclePos.x, vehiclePos.y, vehiclePos.z + 1.3, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.3,0.3, 0.3, 255, 0, 0, 255, true, true, p19, true)
            end,
            onSelected = function()
                local playerPed = PlayerPedId()
                local playerCoords = GetEntityCoords(playerPed)
                local vehicle = ESX.Game.GetClosestVehicle(playerCoords)

                if DoesEntityExist(vehicle) then
                    repairVeh(vehicle)
                end
            end
        })
    else
        RageUI.Button('Réparer le véhicule', nil, {}, false, {})
    end
    RageUI.Separator('  Modifications')
    if YveltHelper:getAcces(player, 'plateVeh') then
        RageUI.Button("Changer la plaque", nil, {RightLabel = YveltConfig.RightLabel}, true, {
            onActive = function()
                local playerPed = PlayerPedId()
                local playerCoords = GetEntityCoords(playerPed)
                local vehicle = ESX.Game.GetClosestVehicle(playerCoords)
                local vehiclePos = GetEntityCoords(vehicle)
                DrawMarker(21, vehiclePos.x, vehiclePos.y, vehiclePos.z + 1.3, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.3,0.3, 0.3, 255, 0, 0, 255, true, true, p19, true)
            end,
            onSelected = function()
                local playerPed = PlayerPedId()
                local playerCoords = GetEntityCoords(playerPed)
                local vehicle = ESX.Game.GetClosestVehicle(playerCoords)
                local modelName  = exports["input"]:ShowSync('Entrez la plaque du véhicule :', false, 320., "small_text")

                if DoesEntityExist(vehicle) then
                    plateVeh(vehicle, modelName)
                end
            end
        })
    else
        RageUI.Button('Changer la plaque', nil, {}, false, {})
    end
    if YveltHelper:getAcces(player, 'fuelVeh') then
        RageUI.Button("Faire le plein du véhicule", nil, {RightLabel = YveltConfig.RightLabel}, true, {
            onActive = function()
                local playerPed = PlayerPedId()
                local playerCoords = GetEntityCoords(playerPed)
                local vehicle = ESX.Game.GetClosestVehicle(playerCoords)
                local vehiclePos = GetEntityCoords(vehicle)
                DrawMarker(21, vehiclePos.x, vehiclePos.y, vehiclePos.z + 1.3, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.3,0.3, 0.3, 255, 0, 0, 255, true, true, p19, true)
            end,
            onSelected = function()
                local playerPed = PlayerPedId()
                local playerCoords = GetEntityCoords(playerPed)
                local vehicle = ESX.Game.GetClosestVehicle(playerCoords)
                --local modelName = KeyboardInput('YveltPlate', "Veuillez entrer la "..c.."plaque~s~ du véhicule", '', 8)

                if DoesEntityExist(vehicle) then
                    gazVeh(vehicle, modelName)
                end
            end
        })
    else
        RageUI.Button('Faire le plein du véhicule', nil, {}, false, {})
    end
    if YveltHelper:getAcces(player, 'retournerVeh') then
        RageUI.Button("Retourner le véhicule", nil, {RightLabel = YveltConfig.RightLabel}, true, {
            onActive = function()
                local playerPed = PlayerPedId()
                local playerCoords = GetEntityCoords(playerPed)
                local vehicle = ESX.Game.GetClosestVehicle(playerCoords)
                local vehiclePos = GetEntityCoords(vehicle)
                DrawMarker(21, vehiclePos.x, vehiclePos.y, vehiclePos.z + 1.3, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.3,0.3, 0.3, 255, 0, 0, 255, true, true, p19, true)
            end,
            onSelected = function()
                local playerPed = PlayerPedId()
                local playerCoords = GetEntityCoords(playerPed)
                local vehicle = ESX.Game.GetClosestVehicle(playerCoords)
                --local modelName = KeyboardInput('YveltPlate', "Veuillez entrer la "..c.."plaque~s~ du véhicule", '', 8)

                if DoesEntityExist(vehicle) then
                    retournerVeh(vehicle, modelName)
                end
            end
        })
    else
        RageUI.Button('Retourner le véhicule', nil, {}, false, {})
    end
    YveltHelper:CustomMenuVehicle()
    for k, v in pairs(YveltMenus.vehicle) do
        if v.type == 'button' then
            if perm then
                if YveltHelper:getAcces(player, perm) then
                    if subMenu then
                        RageUI.Button(v.name, v.desc, v.rightLabel, true, {
                            onActive = function()
                                v.onActive()
                            end,
                            onSelected = function()
                                v.onSelected()
                            end
                        }, subMenu)
                    else
                        RageUI.Button(v.name, v.desc, v.rightLabel, true, {
                            onActive = function()
                                v.onActive()
                            end,
                            onSelected = function()
                                v.onSelected()
                            end
                        })
                    end
                else
                    RageUI.Button(v.name, v.desc, {}, false, {})
                end
            else
                if subMenu then
                    RageUI.Button(v.name, v.desc, v.rightLabel, true, {
                        onActive = function()
                            v.onActive()
                        end,
                        onSelected = function()
                            v.onSelected()
                        end
                    }, subMenu)
                else
                    RageUI.Button(v.name, v.desc, v.rightLabel, true, {
                        onActive = function()
                            v.onActive()
                        end,
                        onSelected = function()
                            v.onSelected()
                        end
                    })
                end
            end
        elseif v.type == 'separator' then
            RageUI.Separator(v.name)
        else
            RageUI.Button('~r~Erreur de configuration', nil, {}, false, {})
        end
    end
end