function MenuPersonnalMain()
    RageUI.Separator("    Administrations")
    if YveltHelper:getAcces(player, 'noclip') then
        RageUI.Checkbox("Activer le mode vole", nil, noclipActive, {}, {
            onChecked = function()
                ExecuteCommand('YveltNoclip')
            end,
            onUnChecked = function()
                ExecuteCommand('YveltNoclip')
            end
        })
    else
        RageUI.Button('Activer le mode vole', nil, {}, false, {})
    end
    if YveltHelper:getAcces(player, 'pseudos') then
        RageUI.Checkbox("Affichage des pseudos", nil, adminPseudo, {}, {
            onSelected = function(Index)
                adminPseudo = Index
            end,
            onChecked = function()
                YveltHelper:displayNames(true)
            end,
            onUnChecked = function()
                YveltHelper:displayNames(false)
            end
        })	
    else
        RageUI.Button('Affichage des pseudos', nil, {}, false, {})
    end
    if YveltHelper:getAcces(player, 'blips') then
        RageUI.Checkbox("Afficher les blips", nil, adminShowBlipsPlayers, { }, {
            onSelected = function(Index)
                adminShowBlipsPlayers = Index
            end,
            onChecked = function()
                adminBlips()
            end,
            onUnChecked = function()
                adminBlips()
            end
        })
    else
        RageUI.Button('Afficher les blips', nil, {}, false, {})
    end
    if YveltHelper:getAcces(player, 'invisible') then
        RageUI.Checkbox("Se rendre invisible", nil, adminInvisibility, { }, {
            onSelected = function(Index)
                adminInvisibility = Index
                if adminInvisibility then
                    SetEntityVisible(PlayerPedId(), false)
                else
                    SetEntityVisible(PlayerPedId(), true)
                end
            end
        })
    else
        RageUI.Button('Se rendre invisible', nil, {}, false, {})
    end
    if YveltHelper:getAcces(player, 'invincible') then
        RageUI.Checkbox("Se rendre invincible", nil, adminInvinsible, { }, {
            onSelected = function(Index)
                adminInvinsible = Index
            end,
            onChecked = function()
                boolInvincibleyvelt()
            end,
            onUnChecked = function()
                boolInvincible = false
            end
        })
    else
        RageUI.Button('Se rendre invincible', nil, {}, false, {})
    end
    RageUI.Checkbox("Afficher les informations", nil, adminHud, { }, {
        onSelected = function(Index)
            adminHud = Index
        end,
        onChecked = function()
            boolHudInfos()
        end,
        onUnChecked = function()
            boolHud = false
        end
    })
    if YveltHelper:getAcces(player, 'superpower') then
        RageUI.Checkbox("Activer le super saut", nil, adminJump, { }, {
            onSelected = function(Index)
                adminJump = Index
            end,
            onChecked = function()
                boolSuperjumpyvelt()
            end,
            onUnChecked = function()
                boolSuperjump = false
            end
        })
    else
        RageUI.Button('Activer le super saut', nil, {}, false, {})
    end
    if YveltHelper:getAcces(player, 'superpower') then
        RageUI.Checkbox("Activer le super sprint", nil, adminSprint, { }, {
            onSelected = function(Index)
                adminSprint = Index
            end,
            onChecked = function()
                boolSupersprintyvelt()
            end,
            onUnChecked = function()
                boolSupersprint = false
            end
        })
    else
        RageUI.Button('Activer le super sprint', nil, {}, false, {})
    end
    -- if YveltHelper:getAcces(player, 'delgun') then
    --     RageUI.Checkbox("Delgun", nil, delgun, { }, {
    --         onSelected = function(Index)
    --             delgun = Index
    --         end,
    --         onChecked = function()
    --             boolDelgunyvelt()
    --         end,
    --         onUnChecked = function()
    --             boolDelgun = false
    --         end
    --     })
    -- else
    --     RageUI.Button('Delgun', nil, {}, false, {})
    -- end
    if YveltHelper:getAcces(player, 'coords') then
        RageUI.Checkbox("Afficher les coordonnées", nil, adminCoords, { }, {
            onSelected = function(Index)
                adminCoords = Index
            end,
            onChecked = function()
                boolCoordsyvelt()
            end,
            onUnChecked = function()
                boolCoords = false
            end
        })
    else
        RageUI.Button('Afficher les coordonnées', nil, {}, false, {})
    end
    RageUI.Separator("  Téléportations")
    if YveltHelper:getAcces(player, 'teleportation') then
        RageUI.Button('Se téléporer au marker', nil, { RightLabel = YveltConfig.RightLabel }, true, {
            onSelected = function()
                plyPed = PlayerPedId()
                local waypointHandle = GetFirstBlipInfoId(8)

                if DoesBlipExist(waypointHandle) then
                    Citizen.CreateThread(function()
                        local waypointCoords = GetBlipInfoIdCoord(waypointHandle)
                        local foundGround, zCoords, zPos = false, -500.0, 0.0

                        while not foundGround do
                            zCoords = zCoords + 10.0
                            RequestCollisionAtCoord(waypointCoords.x, waypointCoords.y, zCoords)
                            Wait(10)
                            foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords.x, waypointCoords.y, zCoords)

                            if not foundGround and zCoords >= 2000.0 then
                                foundGround = true
                            end
                        end

                        SetPedCoordsKeepVehicle(plyPed, waypointCoords.x, waypointCoords.y, zPos)
                        YveltHelper:clientNotification("~g~Vous avez été téléporté !")
                    end)
                else
                    YveltHelper:clientNotification("~r~Aucun marker sur la carte !")
                end
            end
        })
        RageUI.List('Téléportations rapide', YveltConfig.FastTravel, IndexFasttravel, nil, {}, true, {
            onListChange = function(Index, Item)
                IndexFasttravel = Index;
            end,
            onSelected = function(Index, Item)
                SetEntityCoords(PlayerPedId(), Item.Position)
            end
        })    
    else
        RageUI.Button('Se téléporer au marker', nil, {}, false, {})
        RageUI.Button('Téléportations rapide', nil, {}, false, {})
    end
end