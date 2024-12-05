function MenuPlayers()
    if YveltHelper:getAcces(player, 'subStaffs') then
        RageUI.Button('Voir la liste des staffs', nil, { RightLabel = YveltConfig.RightLabel }, true, {
            onSelected = function()
                Callback.triggerServerCallback('YveltAdmin:getStaffs', function(cb, cb2)
                    StaffListtt = cb
                    Identifier = cb2
                end)
            end
        }, adminStaffs)
    end
    RageUI.Checkbox("Restreindre à ma zone", nil, YveltShowInZone, {}, {
        onSelected = function(Index)
            YveltShowInZone = Index
        end
    })
    RageUI.Checkbox("Afficher uniquement les staffs", nil, YveltShowStaff, {}, {
        onSelected = function(Index)
            YveltShowStaff = Index
        end
    })
    RageUI.List("Rechercher un joueur par", YveltRechercheSys, YveltRechercheSysIndex, nil, {RightLabel = ""}, true, {
        onListChange = function(Index)
            YveltRechercheSysIndex = Index
            YveltRecherche = YveltRechercheSysIndex
        end,
        onSelected = function(Index)
            --{"Pseudo", "ID", "Prénom", "Nom"}   
            if YveltRecherche == 1 then
                YveltRechercheEcrit = KeyboardInput('YVELT_RECHERCHE_SYS', "Entrez le ~r~pseudo~s~ du joueur que vous souhaitez rechercher", '', 20)
            elseif YveltRecherche == 2 then
                YveltRechercheEcrit = KeyboardInput('YVELT_RECHERCHE_SYS', "Entrezr le ~r~l'id~s~ du joueur que vous souhaitez rechercher", '', 20)
            elseif YveltRecherche == 3 then
                YveltRechercheEcrit = KeyboardInput('YVELT_RECHERCHE_SYS', "Entrezr le ~r~métier~s~ du joueur que vous souhaitez rechercher", '', 20)
            elseif YveltRecherche == 4 then
                YveltRechercheEcrit = KeyboardInput('YVELT_RECHERCHE_SYS', "Entrezr le ~r~l'id unique~s~ du joueur que vous souhaitez rechercher", '', 20)
            end
            if not YveltRechercheEcrit then
                YveltRechercheEcrit = nil
                YveltHelper:clientNotification('~g~La recherche a été annulé !')
            end
            if YveltRechercheEcrit ~= nil then
                YveltHelper:clientNotification('~g~Recherche configuré sur "'..YveltRechercheEcrit..'"')
            end
        end
    })
    if YveltRechercheEcrit then
        RageUI.Button('~r~Annuler la recherche', nil, {RightBadge = RageUI.BadgeStyle.Alert}, true, {
            onSelected = function()
                YveltRechercheEcrit = nil
            end		
        })
    end
    if YveltRechercheEcrit then
        RageUI.Separator("      Joueurs en ligne")
    elseif YveltShowStaff then
        RageUI.Separator("      Joueurs en ligne")
    else
        RageUI.Separator("      Joueurs en ligne")
    end
    if PlayersList then
        for k, v in pairs(PlayersList) do
            if YveltShowInZone then
                for _, player in ipairs(GetActivePlayers()) do
                    if GetPlayerServerId(player) == v.source then
                        if YveltRechercheEcrit then
                            if YveltRecherche == 1 then
                                if string.find(v.name, YveltRechercheEcrit) then
                                    if colorsText[v.rankColor] then
                                        RageUI.Button(v.name..' '..colorsText[v.rankColor]..''..v.rankLabel, 'Métier : '..c..''..v.job1..'~s~\nOrganisation : '..c..''..v.job2..'~s~\nUnique ID : '..c..''..v.uid..'', {RightLabel = v.source..' '..YveltConfig.RightLabel}, true, {
                                            onSelected = function()
                                                selectedPlayer = k
                                            end
                                        }, adminGestPlayer)
                                    else
                                        RageUI.Button(v.name..' '..v.rankLabel, 'Métier : '..c..''..v.job1..'~s~\nOrganisation : '..c..''..v.job2..'~s~\nUnique ID : '..c..''..v.uid..'', {RightLabel = v.source..' '..YveltConfig.RightLabel}, true, {
                                            onSelected = function()
                                                selectedPlayer = k
                                            end
                                        }, adminGestPlayer)
                                    end
                                end
                            elseif YveltRecherche == 2 then
                                if string.find(v.source, YveltRechercheEcrit) then
                                    if colorsText[v.rankColor] then
                                        RageUI.Button(v.name..' '..colorsText[v.rankColor]..''..v.rankLabel, 'Métier : '..c..''..v.job1..'~s~\nOrganisation : '..c..''..v.job2..'~s~\nUnique ID : '..c..''..v.uid..'', {RightLabel = v.source..' '..YveltConfig.RightLabel}, true, {
                                            onSelected = function()
                                                selectedPlayer = k
                                            end
                                        }, adminGestPlayer)
                                    else
                                        RageUI.Button(v.name..' '..v.rankLabel, 'Métier : '..c..''..v.job1..'~s~\nOrganisation : '..c..''..v.job2..'~s~\nUnique ID : '..c..''..v.uid..'', {RightLabel = v.source..' '..YveltConfig.RightLabel}, true, {
                                            onSelected = function()
                                                selectedPlayer = k
                                            end
                                        }, adminGestPlayer)
                                    end
                                end
                            elseif YveltRecherche == 3 then
                                if string.find(v.job1, YveltRechercheEcrit) then
                                    if colorsText[v.rankColor] then
                                        RageUI.Button(v.name..' '..colorsText[v.rankColor]..''..v.rankLabel, 'Métier : '..c..''..v.job1..'~s~\nOrganisation : '..c..''..v.job2..'~s~\nUnique ID : '..c..''..v.uid..'', {RightLabel = v.source..' '..YveltConfig.RightLabel}, true, {
                                            onSelected = function()
                                                selectedPlayer = k
                                            end
                                        }, adminGestPlayer)
                                    else
                                        RageUI.Button(v.name..' '..v.rankLabel, 'Métier : '..c..''..v.job1..'~s~\nOrganisation : '..c..''..v.job2..'~s~\nUnique ID : '..c..''..v.uid..'', {RightLabel = v.source..' '..YveltConfig.RightLabel}, true, {
                                            onSelected = function()
                                                selectedPlayer = k
                                            end
                                        }, adminGestPlayer)
                                    end
                                end
                            elseif YveltRecherche == 4 then
                                if string.find(v.uid, YveltRechercheEcrit) then
                                    if colorsText[v.rankColor] then
                                        RageUI.Button(v.name..' '..colorsText[v.rankColor]..''..v.rankLabel, 'Métier : '..c..''..v.job1..'~s~\nOrganisation : '..c..''..v.job2..'~s~\nUnique ID : '..c..''..v.uid..'', {RightLabel = v.source..' '..YveltConfig.RightLabel}, true, {
                                            onSelected = function()
                                                selectedPlayer = k
                                            end
                                        }, adminGestPlayer)
                                    else
                                        RageUI.Button(v.name..' '..v.rankLabel, 'Métier : '..c..''..v.job1..'~s~\nOrganisation : '..c..''..v.job2..'~s~\nUnique ID : '..c..''..v.uid..'', {RightLabel = v.source..' '..YveltConfig.RightLabel}, true, {
                                            onSelected = function()
                                                selectedPlayer = k
                                            end
                                        }, adminGestPlayer)
                                    end
                                end
                            end
                        else
                            if colorsText[v.rankColor] then
                                RageUI.Button(v.name..' '..colorsText[v.rankColor]..''..v.rankLabel, 'Métier : '..c..''..v.job1..'~s~\nOrganisation : '..c..''..v.job2..'~s~\nUnique ID : '..c..''..v.uid..'', {RightLabel = v.source..' '..YveltConfig.RightLabel}, true, {
                                    onSelected = function()
                                        selectedPlayer = k
                                    end
                                }, adminGestPlayer)
                            else
                                RageUI.Button(v.name..' '..v.rankLabel, 'Métier : '..c..''..v.job1..'~s~\nOrganisation : '..c..''..v.job2..'~s~\nUnique ID : '..c..''..v.uid..'', {RightLabel = v.source..' '..YveltConfig.RightLabel}, true, {
                                    onSelected = function()
                                        selectedPlayer = k
                                    end
                                }, adminGestPlayer)
                            end
                        end
                    end
                end
            elseif YveltShowStaff then
                if YveltRechercheEcrit then
                    if YveltRecherche == 1 then
                        if string.find(v.name, YveltRechercheEcrit) then
                            if colorsText[v.rankColor] then
                                if v.rankName ~= 'user' then
                                    RageUI.Button(v.name..' '..colorsText[v.rankColor]..''..v.rankLabel, 'Métier : '..c..''..v.job1..'~s~\nOrganisation : '..c..''..v.job2..'~s~\nUnique ID : '..c..''..v.uid..'', {RightLabel = v.source..' '..YveltConfig.RightLabel}, true, {
                                        onSelected = function()
                                            selectedPlayer = k
                                        end
                                    }, adminGestPlayer)
                                end
                            else
                                if v.rankName ~= 'user' then
                                    RageUI.Button(v.name..' '..v.rankLabel, 'Métier : '..c..''..v.job1..'~s~\nOrganisation : '..c..''..v.job2..'~s~\nUnique ID : '..c..''..v.uid..'', {RightLabel = v.source..' '..YveltConfig.RightLabel}, true, {
                                        onSelected = function()
                                            selectedPlayer = k
                                        end
                                    }, adminGestPlayer)
                                end
                            end
                        end
                    elseif YveltRecherche == 2 then
                        if string.find(v.source, YveltRechercheEcrit) then
                            if colorsText[v.rankColor] then
                                if v.rankName ~= 'user' then
                                    RageUI.Button(v.name..' '..colorsText[v.rankColor]..''..v.rankLabel, 'Métier : '..c..''..v.job1..'~s~\nOrganisation : '..c..''..v.job2..'~s~\nUnique ID : '..c..''..v.uid..'', {RightLabel = v.source..' '..YveltConfig.RightLabel}, true, {
                                        onSelected = function()
                                            selectedPlayer = k
                                        end
                                    }, adminGestPlayer)
                                end
                            else
                                if v.rankName ~= 'user' then
                                    RageUI.Button(v.name..' '..v.rankLabel, 'Métier : '..c..''..v.job1..'~s~\nOrganisation : '..c..''..v.job2..'~s~\nUnique ID : '..c..''..v.uid..'', {RightLabel = v.source..' '..YveltConfig.RightLabel}, true, {
                                        onSelected = function()
                                            selectedPlayer = k
                                        end
                                    }, adminGestPlayer)
                                end
                            end
                        end
                    elseif YveltRecherche == 3 then
                        if string.find(v.job1, YveltRechercheEcrit) then
                            if colorsText[v.rankColor] then
                                if v.rankName ~= 'user' then
                                    RageUI.Button(v.name..' '..colorsText[v.rankColor]..''..v.rankLabel, 'Métier : '..c..''..v.job1..'~s~\nOrganisation : '..c..''..v.job2..'~s~\nUnique ID : '..c..''..v.uid..'', {RightLabel = v.source..' '..YveltConfig.RightLabel}, true, {
                                        onSelected = function()
                                            selectedPlayer = k
                                        end
                                    }, adminGestPlayer)
                                end
                            else
                                if v.rankName ~= 'user' then
                                    RageUI.Button(v.name..' '..v.rankLabel, 'Métier : '..c..''..v.job1..'~s~\nOrganisation : '..c..''..v.job2..'~s~\nUnique ID : '..c..''..v.uid..'', {RightLabel = v.source..' '..YveltConfig.RightLabel}, true, {
                                        onSelected = function()
                                            selectedPlayer = k
                                        end
                                    }, adminGestPlayer)
                                end
                            end
                        end
                    elseif YveltRecherche == 4 then
                        if string.find(v.uid, YveltRechercheEcrit) then
                            if colorsText[v.rankColor] then
                                if v.rankName ~= 'user' then
                                    RageUI.Button(v.name..' '..colorsText[v.rankColor]..''..v.rankLabel, 'Métier : '..c..''..v.job1..'~s~\nOrganisation : '..c..''..v.job2..'~s~\nUnique ID : '..c..''..v.uid..'', {RightLabel = v.source..' '..YveltConfig.RightLabel}, true, {
                                        onSelected = function()
                                            selectedPlayer = k
                                        end
                                    }, adminGestPlayer)
                                end
                            else
                                if v.rankName ~= 'user' then
                                    RageUI.Button(v.name..' '..v.rankLabel, 'Métier : '..c..''..v.job1..'~s~\nOrganisation : '..c..''..v.job2..'~s~\nUnique ID : '..c..''..v.uid..'', {RightLabel = v.source..' '..YveltConfig.RightLabel}, true, {
                                        onSelected = function()
                                            selectedPlayer = k
                                        end
                                    }, adminGestPlayer)
                                end
                            end
                        end
                    end
                else
                    if colorsText[v.rankColor] then
                        if v.rankName ~= 'user' then
                            RageUI.Button(v.name..' '..colorsText[v.rankColor]..''..v.rankLabel, 'Métier : '..c..''..v.job1..'~s~\nOrganisation : '..c..''..v.job2..'~s~\nUnique ID : '..c..''..v.uid..'', {RightLabel = v.source..' '..YveltConfig.RightLabel}, true, {
                                onSelected = function()
                                    selectedPlayer = k
                                end
                            }, adminGestPlayer)
                        end
                    else
                        if v.rankName ~= 'user' then
                            RageUI.Button(v.name..' '..v.rankLabel, 'Métier : '..c..''..v.job1..'~s~\nOrganisation : '..c..''..v.job2..'~s~\nUnique ID : '..c..''..v.uid..'', {RightLabel = v.source..' '..YveltConfig.RightLabel}, true, {
                                onSelected = function()
                                    selectedPlayer = k
                                end
                            }, adminGestPlayer)
                        end
                    end
                end
            else
                if YveltRechercheEcrit then
                    if YveltRecherche == 1 then
                        if string.find(v.name, YveltRechercheEcrit) then
                            if colorsText[v.rankColor] then
                                RageUI.Button(v.name..' '..colorsText[v.rankColor]..''..v.rankLabel, 'Métier : '..c..''..v.job1..'~s~\nOrganisation : '..c..''..v.job2..'~s~\nUnique ID : '..c..''..v.uid..'', {RightLabel = v.source..' '..YveltConfig.RightLabel}, true, {
                                    onSelected = function()
                                        selectedPlayer = k
                                    end
                                }, adminGestPlayer)
                            else
                                RageUI.Button(v.name..' '..v.rankLabel, 'Métier : '..c..''..v.job1..'~s~\nOrganisation : '..c..''..v.job2..'~s~\nUnique ID : '..c..''..v.uid..'', {RightLabel = v.source..' '..YveltConfig.RightLabel}, true, {
                                    onSelected = function()
                                        selectedPlayer = k
                                    end
                                }, adminGestPlayer)
                            end
                        end
                    elseif YveltRecherche == 2 then
                        if string.find(v.source, YveltRechercheEcrit) then
                            if colorsText[v.rankColor] then
                                RageUI.Button(v.name..' '..colorsText[v.rankColor]..''..v.rankLabel, 'Métier : '..c..''..v.job1..'~s~\nOrganisation : '..c..''..v.job2..'~s~\nUnique ID : '..c..''..v.uid..'', {RightLabel = v.source..' '..YveltConfig.RightLabel}, true, {
                                    onSelected = function()
                                        selectedPlayer = k
                                    end
                                }, adminGestPlayer)
                            else
                                RageUI.Button(v.name..' '..v.rankLabel, 'Métier : '..c..''..v.job1..'~s~\nOrganisation : '..c..''..v.job2..'~s~\nUnique ID : '..c..''..v.uid..'', {RightLabel = v.source..' '..YveltConfig.RightLabel}, true, {
                                    onSelected = function()
                                        selectedPlayer = k
                                    end
                                }, adminGestPlayer)
                            end
                        end
                    elseif YveltRecherche == 3 then
                        if string.find(v.job1, YveltRechercheEcrit) then
                            if colorsText[v.rankColor] then
                                RageUI.Button(v.name..' '..colorsText[v.rankColor]..''..v.rankLabel, 'Métier : '..c..''..v.job1..'~s~\nOrganisation : '..c..''..v.job2..'~s~\nUnique ID : '..c..''..v.uid..'', {RightLabel = v.source..' '..YveltConfig.RightLabel}, true, {
                                    onSelected = function()
                                        selectedPlayer = k
                                    end
                                }, adminGestPlayer)
                            else
                                RageUI.Button(v.name..' '..v.rankLabel, 'Métier : '..c..''..v.job1..'~s~\nOrganisation : '..c..''..v.job2..'~s~\nUnique ID : '..c..''..v.uid..'', {RightLabel = v.source..' '..YveltConfig.RightLabel}, true, {
                                    onSelected = function()
                                        selectedPlayer = k
                                    end
                                }, adminGestPlayer)
                            end
                        end
                    elseif YveltRecherche == 4 then
                        if string.find(v.uid, YveltRechercheEcrit) then
                            if colorsText[v.rankColor] then
                                RageUI.Button(v.name..' '..colorsText[v.rankColor]..''..v.rankLabel, 'Métier : '..c..''..v.job1..'~s~\nOrganisation : '..c..''..v.job2..'~s~\nUnique ID : '..c..''..v.uid..'', {RightLabel = v.source..' '..YveltConfig.RightLabel}, true, {
                                    onSelected = function()
                                        selectedPlayer = k
                                    end
                                }, adminGestPlayer)
                            else
                                RageUI.Button(v.name..' '..v.rankLabel, 'Métier : '..c..''..v.job1..'~s~\nOrganisation : '..c..''..v.job2..'~s~\nUnique ID : '..c..''..v.uid..'', {RightLabel = v.source..' '..YveltConfig.RightLabel}, true, {
                                    onSelected = function()
                                        selectedPlayer = k
                                    end
                                }, adminGestPlayer)
                            end
                        end
                    end
                else
                    if colorsText[v.rankColor] then
                        RageUI.Button(v.name..' '..colorsText[v.rankColor]..''..v.rankLabel, 'Métier : '..c..''..v.job1..'~s~\nOrganisation : '..c..''..v.job2..'~s~\nUnique ID : '..c..''..v.uid..'', {RightLabel = v.source..' '..YveltConfig.RightLabel}, true, {
                            onSelected = function()
                                selectedPlayer = k
                            end
                        }, adminGestPlayer)
                    else
                        RageUI.Button(v.name..' '..v.rankLabel, 'Métier : '..c..''..v.job1..'~s~\nOrganisation : '..c..''..v.job2..'~s~\nUnique ID : '..c..''..v.uid..'', {RightLabel = v.source..' '..YveltConfig.RightLabel}, true, {
                            onSelected = function()
                                selectedPlayer = k
                            end
                        }, adminGestPlayer)
                    end
                end
            end
        end
    end
end

function menuGestPlayer()
    local s = PlayersList[selectedPlayer]
    if s then
        RageUI.List("Action sur le joueur", YveltAction, (YveltAction.Index or 1), false, {}, true, {
            onListChange = function(Index)
                YveltAction.Index = Index
            end,
            onSelected = function(Index)
                if YveltAction.Index == 1 then
                    YveltHelper:revivePlayer(s.source, s.name)
                elseif YveltAction.Index == 2 then
                    YveltHelper:healPlayer(s.source, s.name)
                end
            end
        })
        if YveltHelper:getAcces(player, 'teleportation') then
            RageUI.List("Téléportation", YveltTeleportation, (YveltTeleportation.Index or 1), false, {}, true, {
                onListChange = function(Index)
                    YveltTeleportation.Index = Index
                end,
                onSelected = function(Index)
                    if YveltTeleportation.Index == 1 then
                        TriggerServerEvent('YveltAdmin:Teleport', 'goto', s.source)
                    elseif YveltTeleportation.Index == 2 then
                        TriggerServerEvent('YveltAdmin:Teleport', 'bring', s.source)
                    else
                        TriggerServerEvent('YveltAdmin:Teleport', 'bringback', s.source)
                    end
                end
            })
            -- RageUI.Button('Bring back', nil, { RightLabel = YveltConfig.RightLabel }, true, {
            --     onSelected = function()
            --         TriggerServerEvent('YveltAdmin:Teleport', 'bringback', s.source)
            --     end
            -- })
        else
            -- RageUI.Button('Téléportation', nil, {}, false, {})
        end
        RageUI.Separator("   Gestion Joueur")
        if YveltHelper:getAcces(player, 'spectate') then
            RageUI.Checkbox("Spectate le joueur", nil, spectate, {}, {
                onSelected = function(Index)
                    spectate = Index
                end,
                onChecked = function()
                    spectate = true
                    boolSpect(s.source, PlayersList[selectedPlayer], s.name)
                end,
                onUnChecked = function()
                    spectate = false
                end
            })
        else
            RageUI.Button('Spectate le joueur', nil, {}, false, {})
        end
        -- if YveltHelper:getAcces(player, 'spawnVeh') then
        --     local ped = GetPlayerPed(s.source)
        --     print(ped)
        -- else
        --     RageUI.Button('Supprime son véhicule', nil, {}, false, {})
        -- end
        if YveltHelper:getAcces(player, 'spawnVeh') then
            RageUI.Button('Donner un véhicule au joueur', nil, {RightLabel = YveltConfig.RightLabel}, true, {
                onSelected = function()
                    local car = KeyboardInput('YveltMsg', "Entrez le "..c.."nom~s~ du véhicule", '', 32)
                    if car and car ~= '' then
                        if not IsModelInCdimage(car) then
                            YveltHelper:clientNotification('~r~Ce véhicule n\'existe pas !')
                        else
                            TriggerServerEvent('YveltAdmin:GiveCarToPlayer', s.source, car)
                        end
                    else
                        YveltHelper:clientNotification('~r~Vous avez annulé l\'action')
                    end
                end		
            })
        else
            RageUI.Button('Donner un véhicule au joueur', nil, {}, false, {})
        end
        if YveltHelper:getAcces(player, 'sendMsg') then
            RageUI.Button('Envoyer un message', nil, {RightLabel = YveltConfig.RightLabel}, true, {
                onSelected = function()
                    local YveltMsg = KeyboardInput('YveltMsg', "Entrez le "..c.."message~s~ que vous souhaitez envoyer", '', 70)
                    if YveltMsg and YveltMsg ~= '' then
                        ExecuteCommand('msg '..s.source..' '..YveltMsg)
                    else
                        YveltHelper:clientNotification('~r~Vous avez annulé l\'action')
                    end
                end		
            })
        else
            RageUI.Button('Envoyer un message', nil, {}, false, {})
        end
        RageUI.Button('Sanction(s) du joueur', nil, {RightLabel = YveltConfig.RightLabel}, true, {
            onSelected = function()
                sanctionSelectedId = s.source
                sanctionSelectedName = s.name
                Callback.triggerServerCallback('YveltAdmin:getSanctionsOfPlayer', function(list)
                    adminSanctions = list
                end, s.uid)
            end		
        }, adminGestPlayerSanctions)
        RageUI.Separator("  Item du joueur")
        RageUI.Button('Voir l\'inventaire du joueur', nil, {RightLabel = YveltConfig.RightLabel}, true, {
            onSelected = function()
                sanctionSelectedId = s.source
                sanctionSelectedName = s.name
                Callback.triggerServerCallback('YveltAdmin:getInventoryOfPlayer', function(list, list2)
                    adminInventory = list
                    adminInventory2 = list2
                end, s.source)
            end		
        }, adminGestPlayerInventory)
        if YveltHelper:getAcces(player, 'give') then
            RageUI.Button('Donner un item au joueur', nil, {RightLabel = YveltConfig.RightLabel}, true, {
                onSelected = function()
                    sanctionSelectedId = s.source
                    sanctionSelectedName = s.name
                    Callback.triggerServerCallback('YveltAdmin:getItems', function(list)
                        itemsList = list
                    end)
                    -- local YveltMsg = KeyboardInput('YveltMsg', "Entrez le "..c.."nom~s~ de l", '', 70)
                    -- local YveltMsg2 = KeyboardInput('YveltMsg', "Entrez le "..c.."message~s~ que vous souahitez envoyer", '', 70)
                    -- givePlayer(s.source, YveltMsg, YveltMsg2)
                end		
            }, adminGestPlayerItems)
        else
            RageUI.Button('Donner un item au joueur', nil, {}, false, {})
        end
        YveltHelper:CustomMenuPlayers(PlayersList[selectedPlayer])
        for k, v in pairs(YveltMenus.players) do
            if v.type == 'button' then
                if v.perm then
                    if YveltHelper:getAcces(player, v.perm) then
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
    else
        RageUI.Separator()
    end
end

function menuGestPlayerItems()
    if YveltHelper:getAcces(player, 'give') then
        RageUI.Button('Donner un item au joueur', nil, {RightLabel = YveltConfig.RightLabel}, true, {
            onSelected = function()
                local YveltMsg = KeyboardInput('YveltMsg', "Entrez le "..c.."nom~s~ de l'item", '', 20)
                local YveltMsg2 = KeyboardInput('YveltMsg', "Entrez la "..c.."quantité~s~ que vous souhaitez give", '', 3)
                givePlayer(sanctionSelectedId, YveltMsg, YveltMsg2)
            end		
        })
        if itemsList then
            RageUI.List("Filtrer par lettre", LettresItems, LettresItemsIndex, nil, {}, true, {
                onListChange = function(Index)
                    LettresItemsIndex = Index
                end
            })
            RageUI.Separator('')
            if LettresItemsIndex == 1 then
                for k, v in pairs(itemsList) do
                    RageUI.Button(v.label..' ~c~('..v.name..')', nil, {RightLabel = YveltConfig.RightLabel}, true, {
                        onSelected = function()
                            local YveltMsg2 = KeyboardInput('YveltMsg', "Entrez la "..c.."quantité~s~ que vous souhaitez give", '', 3)
                            givePlayer(sanctionSelectedId, v.name, YveltMsg2)
                        end
                    })
                end
            else
                for k, v in pairs(itemsList) do
                    local premierCaractere = string.sub(v.label, 1, 1)
                    if string.lower(premierCaractere) == LettresItems[LettresItemsIndex] then
                        RageUI.Button(v.label..' ~c~('..v.name..')', nil, {RightLabel = YveltConfig.RightLabel}, true, {
                            onSelected = function()
                                local YveltMsg2 = KeyboardInput('YveltMsg', "Entrez la "..c.."quantité~s~ que vous souhaitez give", '', 3)
                                givePlayer(sanctionSelectedId, v.name, YveltMsg2)
                            end
                        })
                    end
                end 
            end
        else
            RageUI.Button('Filtrer par lettre', nil, {}, false, {})
            RageUI.Separator('')
        end
    else
    end
end

function menuGestPlayerInventory()
    local s = PlayersList[selectedPlayer]
    if s then
        if colorsText[s.rankColor] then
        else
        end
        -- Separator('Inventaire du joueur')
        if adminInventory and adminInventory2 then
            for k, v in pairs(adminInventory) do
                if v.count ~= 0 then
                    RageUI.List(v.label..' '..c..'x'..v.count..' ~c~('..v.name..')', YveltGestinventory, (YveltGestinventory.Index or 1), false, {}, true, {
                        onListChange = function(Index)
                            YveltGestinventory.Index = Index
                        end,
                        onSelected = function(Index)
                            if YveltGestinventory.Index == 1 then
                                if YveltHelper:getAcces(player, 'prendre') then
                                    -- prendre
                                    local YveltInventory = KeyboardInput('YveltMsg', "Entrez le "..c.."nombre~s~ de "..v.label.." que vous voulez prendre", '', 5)
                                    if tonumber(YveltInventory) then
                                        if tonumber(YveltInventory) > v.count then
                                            YveltHelper:clientNotification('~r~Impossible de prendre plus de '..v.label)
                                        else
                                            TriggerServerEvent('Yvelt:GestInventoryPlayer', 'rob', tonumber(YveltInventory), v, sanctionSelectedId)
                                        end
                                    else
                                        YveltHelper:clientNotification('~r~Vous devez entrer un nombre !')
                                    end
                                else
                                    YveltHelper:clientNotification('~r~Vous avez pas la permission !')
                                end
                            else
                                if YveltHelper:getAcces(player, 'delete') then
                                    -- suppr
                                    local YveltInventory = KeyboardInput('YveltMsg', "Entrez le "..c.."nombre~s~ de "..v.label.." que vous voulez supprimer", '', 5)
                                    if tonumber(YveltInventory) then
                                        if tonumber(YveltInventory) > v.count then
                                            YveltHelper:clientNotification('~r~Impossible de prendre plus de '..v.label)
                                        else
                                            TriggerServerEvent('Yvelt:GestInventoryPlayer', 'delete', tonumber(YveltInventory), v, sanctionSelectedId)
                                        end
                                    else
                                        YveltHelper:clientNotification('~r~Vous devez entrer un nombre !')
                                    end
                                else
                                    YveltHelper:clientNotification('~r~Vous avez pas la permission !')
                                end
                            end
                        end
                    })
                end
            end
            for k, v in pairs(adminInventory2) do
                if v.name then
                    RageUI.List(v.label..' '..c..'x'..v.ammo..' ~c~('..v.name..')', YveltGestinventory, (YveltGestinventory.Index or 1), false, {}, true, {
                        onListChange = function(Index)
                            YveltGestinventory.Index = Index
                        end,
                        onSelected = function(Index)
                            if YveltGestinventory.Index == 1 then
                                -- prendre
                                if YveltHelper:getAcces(player, 'prendre') then
                                    TriggerServerEvent('Yvelt:GestInventoryPlayer', 'rob2', v.ammo, v, sanctionSelectedId)
                                else
                                    YveltHelper:clientNotification('~r~Vous avez pas la permission !')
                                end
                                -- local YveltInventory = KeyboardInput('YveltMsg', "Entrez le "..c.."nombre~s~ de "..v.label.." que vous voulez prendre", '', 5)
                                -- if tonumber(YveltInventory) then
                                --     if tonumber(YveltInventory) > v.count then
                                --         YveltHelper:clientNotification('~r~Impossible de prendre plus de '..v.label)
                                --     else
                                --         TriggerServerEvent('Yvelt:GestInventoryPlayer', 'rob', tonumber(YveltInventory), v, sanctionSelectedId)
                                --     end
                                -- else
                                --     YveltHelper:clientNotification('~r~Vous devez entrer un nombre !')
                                -- end
                            else
                                -- suppr
                                if YveltHelper:getAcces(player, 'delete') then
                                    TriggerServerEvent('Yvelt:GestInventoryPlayer', 'delete2', v.ammo, v, sanctionSelectedId)
                                else
                                    YveltHelper:clientNotification('~r~Vous avez pas la permission !')
                                end
                                -- local YveltInventory = KeyboardInput('YveltMsg', "Entrez le "..c.."nombre~s~ de "..v.label.." que vous voulez supprimer", '', 5)
                                -- if tonumber(YveltInventory) then
                                --     if tonumber(YveltInventory) > v.count then
                                --         YveltHelper:clientNotification('~r~Impossible de prendre plus de '..v.label)
                                --     else
                                --         TriggerServerEvent('Yvelt:GestInventoryPlayer', 'delete', tonumber(YveltInventory), v, sanctionSelectedId)
                                --     end
                                -- else
                                --     YveltHelper:clientNotification('~r~Vous devez entrer un nombre !')
                                -- end
                            end
                        end
                    })
                else
                    RageUI.Button('Arme inconnue ?', 'Cette arme n\'a pas été reconnu', {}, false, {})
                end
            end
        else
            RageUI.Separator()
            RageUI.Separator('~r~Chargement de l\'inventaire')
            RageUI.Separator()
        end
    else
        RageUI.Separator()
        RageUI.Separator('~r~Ce joueur n\'est plus connecté')
        RageUI.Separator()
    end
end