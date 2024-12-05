local colour_index= {
	primary = {1,5},
	secondary = {1,5}
}

local selectedPrimaryColor = {
	r = 0,
	g = 0,
	b = 0,
}

local function askForName(prompt, callback)
    local name = exports["input"]:ShowSync(prompt, false, 320., "small_text")
    if name and name ~= "" then
        callback(name)
    else
        print("Aucun nom n'a été entré.")
    end
end

function MenuGestStaff()
    if IsControlPressed(0, 19) then
        SetMouseCursorActiveThisFrame()
    end

RageUI.Button("~h~Spawn un véhicule ID", nil, {RightLabel = YveltConfig.RightLabel}, true, {
    onSelected = function()
        askForName('Indiquez la plque véhicule :', function(vehid)
            ExecuteCommand('spawnvehid ' .. vehid)
        end)
    end
})

RageUI.Button("~h~Sauvegarder tout les joueurs", nil, {RightLabel = YveltConfig.RightLabel}, true, {
    onSelected = function()
        ExecuteCommand('saveall')
    end
})

RageUI.Separator('Création builder')
RageUI.Button("~h~Créer un métier (farming)", nil, {RightLabel = YveltConfig.RightLabel}, true, {
    onSelected = function()
        ExecuteCommand('createjob')
        RageUI.CloseAll()
    end
})
RageUI.Button("~h~Modifier un métier (farming)", nil, {RightLabel = YveltConfig.RightLabel}, true, {
    onSelected = function()
        ExecuteCommand('gestionjob')
        RageUI.CloseAll()
    end
})
RageUI.Button("~h~Créer un point de drogue (sous licence)", nil, {RightLabel = YveltConfig.RightLabel}, true, {
    onSelected = function()
        ExecuteCommand('drugsbuilder')
        RageUI.CloseAll()
    end
})
RageUI.Button("~h~Créer un gang/orga", nil, {RightLabel = YveltConfig.RightLabel}, true, {
    onSelected = function()
        ExecuteCommand('jggangbuilder')
        RageUI.CloseAll()
    end
})
RageUI.Button("~h~Supprimer un gang/orga", nil, {RightLabel = YveltConfig.RightLabel}, true, {
    onSelected = function()
        local gangName = exports["input"]:ShowSync('Indiquez le nom à supprimer ', false, 320., "small_text")
        if gangName and gangName ~= "" then
            ExecuteCommand('jgremovegang ' .. gangName)
        else
        end
    end
})
RageUI.Separator('Côté serveur')


-- Give Argent
function giveMoneyToPlayer(playerId, accountType, amount)
    if not playerId or not accountType or not amount then
        return 
    end
    amount = tonumber(amount)
    if not amount or amount <= 0 then
        return 
    end
    local command = string.format("giveaccountmoney %s %s %d", playerId, accountType, amount)
    ExecuteCommand(command)
end

RageUI.Button("~h~Se donner de l\'argent", nil, {RightLabel = "→"}, true, {
    onSelected = function()
        askForName('Indiquez votre ID :', function(playerId)
            askForName('Indiquez le type de compte (cash/dirtymoney/bank) :', function(accountType)
                askForName('Indiquez le montant d\'argent :', function(amount)
                    giveMoneyToPlayer(playerId, accountType, amount)
                end)
            end)
        end)
    end
})

-- Supprimer Argent
function removeMoneyFromPlayer(playerId, accountType, amount)
    if not playerId or not accountType or not amount then
        return
    end
    amount = tonumber(amount)
    if not amount or amount <= 0 then
        return
    end
    local command = string.format("removeaccountmoney %s %s %d", playerId, accountType, amount)
    ExecuteCommand(command)
end

RageUI.Button("~h~Se retirer de l'argent", nil, {RightLabel = "→"}, true, {
    onSelected = function()
        askForName('Indiquez votre ID :', function(playerId)
            askForName('Indiquez le type de compte (cash/dirtymoney/bank) :', function(accountType)
                askForName('Indiquez le montant d\'argent :', function(amount)
                    removeMoneyFromPlayer(playerId, accountType, amount)
                end)
            end)
        end)
    end
})

RageUI.Button("~h~Refaire son register", nil, {RightLabel = YveltConfig.RightLabel}, true, {
    onSelected = function()
        askForName('Voulez-vous refaire votre register ? (Tapez "oui" ou "non")', function(response)
            if response:lower() == 'oui' then
                ExecuteCommand('register')
                RageUI.CloseAll()
            elseif response:lower() == 'non' then
            else
            end
        end)
    end
})

RageUI.Button("~h~Refaire son personnage", nil, {RightLabel = YveltConfig.RightLabel}, true, {
    onSelected = function()
        askForName('Voulez-vous refaire votre personnage ? (Tapez "oui" ou "non")', function(response)
            if response:lower() == 'oui' then
                ExecuteCommand('skin')
                RageUI.CloseAll()
            elseif response:lower() == 'non' then
            else
            end
        end)
    end
})

RageUI.Button("~h~Se setjob à un métier", nil, {RightLabel = "→"}, true, {
    onSelected = function()
        askForName('Indiquez votre ID (ou sinon mettez "me") :', function(id)
            askForName('Indiquez le nom du job (exemple : police, ambulance, mecano, mecano2, etc..) :', function(jobName)
                askForName('Indiquez le grade (exemple : 0,1,2,3,4 etc..):', function(grade)
                    ExecuteCommand('setjob ' .. id .. ' ' .. jobName .. ' ' .. grade)
                end)
            end)
        end)
    end
})

RageUI.Button("~h~Se retirer d\'un métier", nil, {RightLabel = "→"}, true, {
    onSelected = function()
        askForName('Voulez-vous vraiment vous retirer de votre job ? (Tapez "oui" ou "non")', function(response)
            if response:lower() == 'oui' then
                ExecuteCommand('setjob me unemployed 0')
                notify("Vous avez été retiré de votre job.")
            elseif response:lower() == 'non' then
                notify("Action annulée.")
            end
        end)
    end
})

RageUI.Button("~h~Se setjob à un gang/orga", nil, {RightLabel = "→"}, true, {
    onSelected = function()
        askForName('Indiquez votre ID (ou sinon mettez "me") :', function(id)
            askForName('Indiquez le nom du gang/orga (exemple : vagos, ballas, marabunta, families, etc..) :', function(gangName)
                askForName('Indiquez le grade (exemple : 0,1,2,3,4 etc..):', function(grade)
                    ExecuteCommand('setjob2 ' .. id .. ' ' .. gangName .. ' ' .. grade)
                end)
            end)
        end)
    end
})

RageUI.Button("~h~Se retirer d\'un gang/orga", nil, {RightLabel = "→"}, true, {
    onSelected = function()
        askForName('Voulez-vous vraiment vous retirer de votre gang/orga ? (Tapez "oui" ou "non")', function(response)
            if response:lower() == 'oui' then
                ExecuteCommand('setjob2 me unemployed 0')
                notify("Vous avez été retiré de votre job.")
            elseif response:lower() == 'non' then
                notify("Action annulée.")
            end
        end)
    end
})

RageUI.Button("~h~Donner un véhicule perm", nil, {RightLabel = YveltConfig.RightLabel}, true, {
    onSelected = function()
        askForName('Voulez-vous donner un véhicule perm ? (Tapez "oui" ou "non")', function(response)
            if response:lower() == 'oui' then
                askForName('Entrez le modèle du véhicule :', function(vehicleModel)
                    askForName('Entrez l\'ID du véhicule :', function(vehicleID)
                        local command = string.format('givecar %s %s', vehicleModel, vehicleID)
                        ExecuteCommand(command)
                    end)
                end)
            elseif response:lower() == 'non' then
            end
        end)
    end
})


RageUI.Separator('Réinitialiser')

RageUI.Button("~h~Réinitialiser un métier", nil, {RightLabel = YveltConfig.RightLabel}, true, {
    onSelected = function()
        askForName('Indiquez le nom du métier à réinitialiser', function(jobName)
            ExecuteCommand('resetjob ' .. jobName)
        end)
    end
})

RageUI.Button("~h~Réinitialiser un gang", nil, {RightLabel = YveltConfig.RightLabel}, true, {
    onSelected = function()
        askForName('Indiquez le nom du gang à réinitialiser', function(gangName)
            ExecuteCommand('resetgang ' .. gangName)
        end)
    end
})

RageUI.Separator('Météo')

RageUI.Button("~h~Changer l'heure du temps", nil, {RightLabel = YveltConfig.RightLabel}, true, {
    onSelected = function()
        askForName('Indiquez l\'heure : (exemple : 14 57)', function(temps)
            ExecuteCommand('time ' .. temps)
        end)
    end
})

RageUI.Button("~h~Changer la météo", nil, {RightLabel = YveltConfig.RightLabel}, true, {
    onSelected = function()
        askForName('Indiquez la météo : (exemple : extrasunny, clear, rain, overcast, xmas, etc..)', function(meteo)
            ExecuteCommand('weather ' .. meteo)
        end)
    end
})

---- NOT ACCESS - NO TOUCH

    YveltHelper:CustomMenuGestStaff()
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