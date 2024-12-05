local edition = nil
local permissions = nil
local first = true
local saved = false
local colorToNb = {
    ['red'] = 1,
    ['orange'] = 2,
    ['yellow'] = 3,
    ['green'] = 4,
    ['blue'] = 5,
    ['purple'] = 6,
    ['gray'] = 7,
    ['white'] = 8,
    ['black'] = 9,
}

RegisterNetEvent('Yvelt:refreshClientSideRanks')
AddEventHandler('Yvelt:refreshClientSideRanks', function(refreshTable)
    RanksList = refreshTable
end)

function MenuRank()
    RageUI.Button('Crée un nouveau rank', nil, { RightLabel = YveltConfig.RightLabel }, true, {
        onSelected = function()
            first = false
            edition = nil
        end,
    }, adminRankscreate)
    Separator('Gestion des ranks')
    if j.encode(RanksList) == '[]' then
        RageUI.Separator()
        RageUI.Separator('~r~Chargement des ranks...')
        RageUI.Separator()
    else
        for x, b in pairs(RanksList) do
            if b.rank == 'owner' then
                RageUI.Button(''..colorsText[b.color]..'['..b.label..']~s~', 'Impossible de modifier ou de supprimer\nNom du rank : '..colorsText[b.color]..''..b.rank..'\n~s~Power du rank : '..colorsText[b.color]..''..b.power..'', { RightLabel = YveltConfig.RightLabel }, false, {})
            else
                RageUI.Button(''..colorsText[b.color]..'['..b.label..']~s~', 'Nom du rank : '..colorsText[b.color]..''..b.rank..'\n~s~Power du rank : '..colorsText[b.color]..''..b.power..'~s~', { RightLabel = 'Modifier '..YveltConfig.RightLabel }, true, {
                    onSelected = function()
                        first = true
                        edition = b
                        permissions = j.decode(b.perms)
                        paramRank = {
                            rank = b.rank,
                            label = b.label,
                            power = b.power,
                            color = b.color,
                        }
                        paraColorList.Index = colorToNb[b.color]
                    end,
                }, adminRankscreate)
            end
        end
    end
end

function MenuCreateRank()
    RageUI.Button('Restaurer les paramètres', nil, {RightLabel = "🗑"}, true, {
        onSelected = function()
            for k, v in pairs(paramList) do
                v.default = false
            end
            paramRank = {
                rank = nil,
                label = nil,
                power = nil,
                perms = nil,
                color = 'red',
            }
        end
    })
    if not edition then
        if paramRank.rank ~= nil and paramRank.label ~= nil and paramRank.power ~= nil then
            RageUI.Button('Créer le nouveau rank', nil, {RightBadge = RageUI.BadgeStyle.Tick}, true, {
                onSelected = function()
                    TriggerServerEvent('Yvelt:createNewRank', paramRank, paramList)
                end
            })
        else
            RageUI.Button('Créer le nouveau rank', nil, {RightBadge = RageUI.BadgeStyle.Tick}, false, {})
        end
        Separator('Créer un nouveau rank')
    else
        RageUI.Button('~g~Enregistrer les modifications', nil, {RightBadge = RageUI.BadgeStyle.Alert}, true, {
            onSelected = function()
                YveltHelper:clientNotification('~g~Modifications sauvegardés')
                TriggerServerEvent('Yvelt:saveRank', paramRank, permissions)
            end
        })
        RageUI.Button('~r~Supprimer ce rank', nil, {RightBadge = RageUI.BadgeStyle.Alert}, true, {
            onSelected = function()
                local text = KeyboardInput('YVELT', "Entrez \"~r~confirmer~s~\" pour supprimer le rank", '', 20)
                if text == 'confirmer' then
                    YveltHelper:clientNotification('~g~Suppression effectué !')
                    TriggerServerEvent('Yvelt:deleteRank', edition.rank)
                    RageUI.GoBack()
                else
                    YveltHelper:clientNotification('~r~Vous avez annulé la supression')
                end
            end
        })
        Separator('Édition du rank : '..edition.label)
    end
    if paramRank.rank then
        if not edition then
            RageUI.Button('Définir le nom du rank', nil, {RightLabel = paramRank.rank}, true, {
                onSelected = function()
                    paramRank.rank = KeyboardInput('YveltMsg', "Entrez le ~r~nom~s~ du rank ~c~(Pas de maj, pas d'espace)", '', 16)
                end
            })
        else
            RageUI.Button('Définir le nom du rank', 'Impossible de modifier le nom du rank', {RightLabel = YveltConfig.RightLabel}, false, {})
        end
    else
        if not edition then
            RageUI.Button('Définir le nom du rank', nil, {RightLabel = YveltConfig.RightLabel}, true, {
                onSelected = function()
                    paramRank.rank = KeyboardInput('YveltMsg', "Entrez le ~r~nom~s~ du rank ~c~(Pas de maj, pas d'espace)", '', 16)
                end
            })
        else
            RageUI.Button('Définir le nom du rank', 'Impossible de modifier le nom du rank', {RightLabel = YveltConfig.RightLabel}, false, {})
        end
    end
    if paramRank.label then
        RageUI.Button('Définir le label du rank', nil, {RightLabel = paramRank.label}, true, {
            onSelected = function()
                paramRank.label = KeyboardInput('YveltMsg', "Entrez le ~r~label~s~ du rank", '', 32)
            end
        })
    else
        RageUI.Button('Définir le label du rank', nil, {RightLabel = YveltConfig.RightLabel}, true, {
            onSelected = function()
                paramRank.label = KeyboardInput('YveltMsg', "Entrez le ~r~label~s~ du rank", '', 32)
            end
        })
    end
    if paramRank.power then
        RageUI.Button('Définir le power du rank', nil, {RightLabel = paramRank.power}, true, {
            onSelected = function()
                paramRank.power = KeyboardInput('YveltMsg', "Entrez le ~r~power~s~ du rank ~c~(1 - 99)", '', 2)
                if tonumber(paramRank.power) > 100 then
                    paramRank.power = nil
                    YveltHelper:clientNotification('~r~Le grade le plus haut doit être owner !')
                else
                    if tonumber(paramRank.power) == 0 then
                        paramRank.power = nil
                        YveltHelper:clientNotification('~r~Le minimum de power est de 1 !')
                    end
                end
            end
        })
    else
        RageUI.Button('Définir le power du rank', nil, {RightLabel = YveltConfig.RightLabel}, true, {
            onSelected = function()
                paramRank.power = KeyboardInput('YveltMsg', "Entrez le ~r~power~s~ du rank ~c~(1 - 99)", '', 2)
                if tonumber(paramRank.power) then
                    if tonumber(paramRank.power) > 100 then
                        paramRank.power = nil
                        YveltHelper:clientNotification('~r~Le grade le plus haut doit être owner !')
                    else
                        if tonumber(paramRank.power) == 0 then
                            paramRank.power = nil
                            YveltHelper:clientNotification('~r~Le minimum de power est de 1 !')
                        end
                    end
                else
                    paramRank.power = nil
                end
            end
        })
    end
    RageUI.List("Attribuer la couleur", paraColorList, (paraColorList.Index or 1), false, {}, true, {
        onListChange = function(Index)
            paraColorList.Index = Index
            paramRank.color = colorsNb[''..Index..''] -- en anglais
            print(paramRank.color)
        end,
        onSelected = function(Index)
        end
    })
    Separator('Gestion des permissions')
    if not edition then
        RageUI.Button('Attribuer toutes les permissions', nil, {RightBadge = RageUI.BadgeStyle.Alert}, true, {
            onSelected = function()
                for k, v in pairs(paramList) do
                    v.default = true
                end
            end
        })
    else
        RageUI.Button('Attribuer toutes les permissions', nil, {RightBadge = RageUI.BadgeStyle.Alert}, true, {
            onSelected = function()
                for k, v in pairs(paramList) do
                    permissions[v.name] = true
                end
            end
        })
    end
    if not edition then
        for k, v in pairs(paramList) do
            if v.label ~= nil then
                if v.default then
                    RageUI.Checkbox('~g~'..v.label, nil, v.default, {}, {
                        onSelected = function(Index)
                            v.default = Index
                        end
                    })
                else
                    RageUI.Checkbox(v.label, nil, v.default, {}, {
                        onSelected = function(Index)
                            v.default = Index
                        end
                    })
                end
            end
        end
    else
        for k, v in pairs(paramList) do
            if permissions then
                if v.label ~= nil then
                    local request = v.name
                    local check = tostring(request)
                    if permissions[check] then
                        RageUI.Checkbox('~g~'..v.label, nil, permissions[check], {}, {
                            onSelected = function(Index)
                                permissions[check] = Index
                            end
                        })
                    else
                        RageUI.Checkbox(v.label, nil, permissions[check], {}, {
                            onSelected = function(Index)
                                permissions[check] = Index
                            end
                        })
                    end
                end
            end
        end
    end
    --[[
            paramRank = {
                rank = nil,
                label = nil,
                power = nil,
                perms = nil,
                color = 'red',
            }
    ]]
    if not edition then
        if paramRank.rank ~= nil and paramRank.label ~= nil and paramRank.power ~= nil then
            RageUI.Button('Créer le nouveau rank', nil, {RightBadge = RageUI.BadgeStyle.Tick}, true, {
                onSelected = function()
                    TriggerServerEvent('Yvelt:createNewRank', paramRank, paramList)
                end
            })
        else
            RageUI.Button('Créer le nouveau rank', nil, {RightBadge = RageUI.BadgeStyle.Tick}, false, {})
        end
    else
        RageUI.Button('~r~Enregistrer les modifications', nil, {RightBadge = RageUI.BadgeStyle.Alert}, true, {
            onSelected = function()
                YveltHelper:clientNotification('~g~Modifications sauvegardés')
                TriggerServerEvent('Yvelt:saveRank', paramRank, paramList)
            end
        })
    end
end