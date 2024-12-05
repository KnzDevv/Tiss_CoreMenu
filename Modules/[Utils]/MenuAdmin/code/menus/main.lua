function MenuMain()
    RageUI.Checkbox("Activer le mode modération", nil, adminStaffmode, {}, {
        onSelected = function(Index)
            adminStaffmode = Index
        end,
        onChecked = function()
            -- functionBoolRefresh()
            YveltStaffMode = true
            TriggerServerEvent('YveltAdmin:ChangeStaffMode', 'on')
            YveltHelper:onStaffModeON()
        end,
        onUnChecked = function()
            YveltHelper:onStaffModeOFF()
            if noclipActive then
                ExecuteCommand('YveltNoclip')
            end
            YveltStaffMode = false
            isNameShown = false
            TriggerServerEvent('YveltAdmin:ChangeStaffMode', 'off')
            adminPseudo = false
            boolPseudo = false
            for i, v in pairs(YVELT.GamerTags) do
                RemoveMpGamerTag(v.tags)
            end
            YVELT.GamerTags = {};
            SetEntityVisible(PlayerPedId(), true)
            boolHud = false
            boolInvincible = false
            boolSuperjump = false
            boolCoords = false
            boolSupersprint = false
        end
    })
    if adminStaffmode then
        if YveltHelper:getAcces(player, 'subPlayers') then
            RageUI.Button('Liste des joueurs', nil, {RightLabel = YveltConfig.RightLabel}, true, {
                onSelected = function()
                    -- YveltAdmin:retrievePlayers OLD
                end
            }, adminPlayers)
        else
            RageUI.Button('Liste des joueurs', nil, {}, false, {})
        end
        if YveltHelper:getAcces(player, 'subPersonnel') then
            RageUI.Button('Gestion personnel', nil, { RightLabel = YveltConfig.RightLabel }, true, {}, adminPerso)
        else
            RageUI.Button('Gestion personnel', nil, {}, false, {})
        end
        if YveltHelper:getAcces(player, 'subVehicle') then
            RageUI.Button('Gestion vehicule(s)', nil, { RightLabel = YveltConfig.RightLabel }, true, {}, adminVehicle)
        else
            RageUI.Button('Gestion vehicule(s)', nil, {}, false, {})
        end
        
        if player.rank == 'owner' then
            RageUI.Button('Gérer les ranks', nil, { RightLabel = YveltConfig.RightLabel }, true, {
                onSelected = function()
                    Callback.triggerServerCallback('YveltAdmin:getRanksList', function(ranks)
                        RanksList = ranks
                    end)
                end
            }, adminRanks)
        else
            RageUI.Button('Gérer les ranks', nil, {}, false, {})
        end
    end
end
