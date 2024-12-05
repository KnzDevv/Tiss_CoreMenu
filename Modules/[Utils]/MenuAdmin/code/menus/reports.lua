function MenuReportsMain()
    if Reports then
        RageUI.Checkbox("Cacher les pris en charge", nil, adminReportsWaiting, {}, {
            onSelected = function(Index)
                adminReportsWaiting = Index
            end,
        })
        RageUI.Separator('Reports actifs : '..c..''..ReportsInfos.Waiting..' ~c~|~s~ Reports en charge : '..c..''..ReportsInfos.Taked)
        if ReportsInfos.Waiting == 0 and ReportsInfos.Taked == 0 then
            RageUI.Separator('')
            RageUI.Separator('~g~Aucun report actuellement actif !')
            RageUI.Separator('')
        else
            for k, v in pairs(Reports) do
                if adminReportsWaiting then
                    if v.state == 'waiting' then
                        RageUI.Button('~r~[ATTENTE] ~s~'..v.id..' → '..v.name.." ~c~("..v.source..")~s~", "Crée a "..c..""..v.heure.."~s~\nAuteur du report : "..c..""..v.name.."~s~\nRaison : "..c..""..v.raison, {RightLabel = YveltConfig.RightLabel}, true, {
                            onSelected = function()
                                selectedReport = v
                            end		
                        }, adminReportsActions)
                    elseif v.takedBy == GetPlayerName(PlayerId()) then
                        RageUI.Button(v.id..' → '..v.name.." ~c~("..v.source..")~s~", "Crée a "..c..""..v.heure.."~s~\nAuteur du report : "..c..""..v.name.."~s~\nRaison : "..c..""..v.raison.."~s~\nPris en charge par "..c..""..v.takedBy, {RightBadge = RageUI.BadgeStyle.Alert}, true, {
                            onSelected = function()
                                selectedReport = v
                            end		
                        }, adminReportsActions)
                    end
                else
                    if v.state == 'waiting' then
                        RageUI.Button('~r~[ATTENTE] ~s~'..v.id..' → '..v.name.." ~c~("..v.source..")~s~", "Crée a "..c..""..v.heure.."~s~\nAuteur du report : "..c..""..v.name.."~s~\nRaison : "..c..""..v.raison, {RightLabel = YveltConfig.RightLabel}, true, {
                            onSelected = function()
                                selectedReport = v
                            end		
                        }, adminReportsActions)
                    elseif v.state == 'taked' then
                        RageUI.Button(v.id..' → '..v.name.." ~c~("..v.source..")~s~", "Crée a "..c..""..v.heure.."~s~\nAuteur du report : "..c..""..v.name.."~s~\nRaison : "..c..""..v.raison.."~s~\nPris en charge par "..c..""..v.takedBy, {RightLabel = YveltConfig.RightLabel}, true, {
                            onSelected = function()
                                selectedReport = v
                            end		
                        }, adminReportsActions)
                    end
                end
            end
        end
    else
        RageUI.Separator('')
        RageUI.Separator('~r~Chargement des reports en cours...')
        RageUI.Separator('')
    end
end

function MenuReportsActions()
    selectedPlayer = selectedReport
    s = selectedReport
    if s then
        if s.state == 'waiting' then
            Separator('Gestion de ce report')
            RageUI.Button('Prendre en charge ce report', nil, {RightLabel = YveltConfig.RightLabel}, true, {
                onSelected = function()
                    s.state = 'taked'
                    s.takedBy = GetPlayerName(PlayerId())
                    TriggerServerEvent('Yvelt:updateReport', 'taked', s)
                end		
            })
            RageUI.Button('Cloturer le report', nil, {RightBadge = RageUI.BadgeStyle.Alert}, true, {
                onSelected = function()
                    s.state = 'finish'
                    s.takedBy = GetPlayerName(PlayerId())
                    TriggerServerEvent('Yvelt:updateReport', 'finish', s)
                    RageUI.GoBack()
                end		
            })
        elseif s.state == 'taked' then
            RageUI.Button('Cloturer le report', nil, {RightBadge = RageUI.BadgeStyle.Alert}, true, {
                onSelected = function()
                    s.state = 'finish'
                    s.takedBy = GetPlayerName(PlayerId())
                    TriggerServerEvent('Yvelt:updateReport', 'finish', s)
                    RageUI.GoBack()
                end		
            })
            --RageUI.Separator('Pseudo : ~g~'..s.name..' ~c~('..s.source..')~s~ | ID Report : ~o~'..s.id)
            -- RageUI.List("Téléporte le joueur", YveltTeleportation, (YveltTeleportation.Index or 1), false, {}, true, {
            --     onListChange = function(Index)
            --         YveltTeleportation.Index = Index
            --     end,
            --     onSelected = function(Index)
            --         if YveltTeleportation.Index == 1 then
            --             ExecuteCommand('goto '..s.source)
            --         else
            --             ExecuteCommand('bring '..s.source)
            --         end
            --     end
            -- })
            -- RageUI.List("Action sur le joueurs", YveltAction, (YveltAction.Index or 1), false, {}, true, {
            --     onListChange = function(Index)
            --         YveltAction.Index = Index
            --     end,
            --     onSelected = function(Index)
            --         if YveltAction.Index == 1 then
            --             ExecuteCommand('revive '..s.source)
            --         elseif YveltAction.Index == 2 then
            --             ExecuteCommand('heal '..s.source)
            --         elseif YveltAction.Index == 3 then
            --             ExecuteCommand('slay '..s.source)
            --         elseif YveltAction.Index == 4 then
            --             local YveltRaison = KeyboardInput('YveltMsg', "Entrez la "..c.."raison~s~ du kick", '', 60)
            --             local YveltConfirm = KeyboardInput('YveltMsg', "Entrez \""..c.."oui~s~\" pour confirmer le kick", '', 3)
            --             if YveltConfirm == 'oui' then
            --                 if YveltRaison ~= '' or YveltRaison ~= nil then
            --                     ExecuteCommand('kick '..s.source..' '..YveltRaison)
            --                 else
            --                     ExecuteCommand('kick '..s.source.. ' Aucune raison spécifié')
            --                 end
            --             else
            --                 YveltHelper:clientNotification('~g~Vous avez annulé le kick !')
            --             end
            --         end
            --     end
            -- })
            if colorsText[s.rankColor] then
                RageUI.Separator(s.name..' ~s~'..colorsText[s.rankColor]..''..s.rankLabel)
                RageUI.Separator('ID Temporaire : '..c..''..s.source..'~s~ | ID Unique : '..c..''..s.uid..'') 
            else
                RageUI.Separator(s.name..' ~s~[Joueur]')
                RageUI.Separator('ID Temporaire : '..c..''..s.source..'~s~ | ID Unique : '..c..''..s.uid..'') 
            end
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
            RageUI.List('Téléportations rapide', YveltConfig.FastTravel, IndexFasttravel, nil, {}, true, {
                onListChange = function(Index, Item)
                    IndexFasttravel = Index;
                end,
                onSelected = function(Index, Item)
                    --SetEntityCoords(PlayerPedId(), Item.Position)
                    TriggerServerEvent('Yvelt:SetPedToCoords', GetPlayerServerId(PlayerId()), s.source, Item.Position)
                end
            })
            Separator('Options utilitaire')
            RageUI.Checkbox("Spectate le joueur", nil, spectate, {}, {
                onSelected = function(Index)
                    spectate = Index
                end,
                onChecked = function()
                    spectate = true
                    boolSpect(s.source, selectedPlayer, s.name)
                end,
                onUnChecked = function()
                    spectate = false
                end
            })
            RageUI.Button('Donner un véhicule au joueur', nil, {RightBadge = RageUI.BadgeStyle.Car}, true, {
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
            RageUI.Button('Sanction(s) du joueur', nil, {RightLabel = YveltConfig.RightLabel}, true, {
                onSelected = function()
                    sanctionSelectedId = s.source
                    sanctionSelectedName = s.name
                    Callback.triggerServerCallback('YveltAdmin:getSanctionsOfPlayer', function(list)
                        adminSanctions = list
                    end, s.uid)
                end		
            }, adminGestPlayerSanctions)
            Separator('Gestion avancé')
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
            YveltHelper:CustomMenuPlayers(selectedPlayer)
            for k, v in pairs(YveltMenus.players) do
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
    else
        RageUI.Separator('')
        RageUI.Separator('~r~Vérification des informations...')
        RageUI.Separator('')
    end
end