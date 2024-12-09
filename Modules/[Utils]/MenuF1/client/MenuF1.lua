ESX = exports["es_extended"]:getSharedObject()




local check = false
local slider = 0

local mainmenu = tiss_menu.create("fb", "Melrose FA", { subtitle = "", description = "MENU PRINCIPAL", itemsPerPage = 10 })
---- Portefeuille
local submenu1_portefeuille = tiss_menu.create("fb", "Melrose FA", { subtitle = "", description = "Porte-Feuille", itemsPerPage = 10 })
local submenu1_portefeuillecdi = tiss_menu.create("fb", "Melrose FA", { subtitle = "", description = "CDI", itemsPerPage = 10 })
local submenu1_portefeuillepdc = tiss_menu.create("fb", "Melrose FA", { subtitle = "", description = "Permis de Conduire", itemsPerPage = 10 })
---- Options Diverses 
local submenu2_optionsdiverses = tiss_menu.create("fb", "Melrose FA", { subtitle = "", description = "Options Diverses", itemsPerPage = 10 })
---- Vehicule 
local submenu3_vehicule1 = tiss_menu.create("fb", "Melrose FA", { subtitle = "", description = "Options Diverses", itemsPerPage = 10 })
--- Player
local player, distance = ESX.Game.GetClosestPlayer()

function main()
    tiss_menu.render(mainmenu, function()

    -- Bouton Boutique 
        addButton("💰 Boutique", { rightLabel = ">>>", description = "" }, {
            onSelected = function()
            
            end
        })
    -- Bouton Portefeuille
        addButton("👜 Portefeuille", { rightLabel = ">>>", description = "" }, {
            onSelected = function()
                submenu_portefeuille()
            end
        })

        -- Bouton Options Diverses
        addButton("🔡 Options Diverses", { rightLabel = ">>>", description = "" }, {
            onSelected = function()
                submenu2_options()
            end
        })
        if ESX.PlayerData.job and ESX.PlayerData.job.name == "taxi" then
            addButton("🚖 Taxi", { rightLabel = ">>>", description =""}, {
                onSelected = function()
                    TriggerEvent("Tissmey:Jobs:Taxi")
                end
            })
        end
        if ESX.PlayerData.job and ESX.PlayerData.job.name == "unicorn" then
            addButton("🦩 Unicorn", { rightLabel = ">>>", description =""}, {
                onSelected = function()
                    TriggerEvent("Tissmey:Jobs:Unicorn")
                end
            })
        end
        -- Bouton Animation
        addButton("💃 Animation", { rightLabel = ">>>", description = "" }, {
            onSelected = function()
                TriggerEvent("Tissmey:OuvrirMenuAnim")
                tiss_menu.close(mainmenu.id) -- Fermeture du menu principal
            end
        })

        -- Bouton Véhicules (Conditionnel)
        if IsPedInAnyVehicle(PlayerPedId(), false) then
            addButton("🚘 Véhicules", { rightLabel = ">>>", description = "" }, {
                onSelected = function()
                    submenu3_vehicule()
                end
            })
        end
        RegisterNetEvent('receivePlayerGroup')
        AddEventHandler('receivePlayerGroup', function(group)
        if group == "admin" then
            addButton("💃 Administrateur Admin", { rightLabel = ">>>", description = "" }, {
                onSelected = function()
                    TriggerEvent("Tissmey:OuvrirMenuAnim")
                    tiss_menu.close(mainmenu.id) -- Fermeture du menu principal
                end
            })
        elseif group == "user" then
            addButton("💃 Administrateur", { rightLabel = "🔒", description = "" }, {
                onSelected = function()
                end
            })   
    end
end)
        -- Gestion de la fermeture du menu
        onClosed(function()
            print("Menu fermé.")
        end)
    end)
end



--- Porte-Feuille 

function submenu_portefeuille()
    tiss_menu.render(submenu1_portefeuille, function()
    addButton("📁 Carte d'identité", { rightLabel = ">>>", description = "" }, {
        onSelected = function()
            submenu_portefeuillebis1()
        end
    })
    addButton("📁 Permis de Conduire", { rightLabel = ">>>", description = "" }, {
        onSelected = function()
            submenu_portefeuillebis2()
        end
    })
    end)
end
function submenu_portefeuillebis1()
    tiss_menu.render(submenu1_portefeuillecdi, function()
    addButton("Voir ma carte d'identité", { rightLabel = ">>>", description = "" }, {
        onSelected = function()
            TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))
        end
    })
    addButton("Montrer ma carte d'identité", { rightLabel = ">>>", description = "" }, {
        onSelected = function()
            if distance ~= -1 and distance <= 3.0 then
                TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player))
              
              end
        end
    })
        onClosed(function()
        submenu_portefeuille()
        end)
    end)
end
function submenu_portefeuillebis2()
    tiss_menu.render(submenu1_portefeuillepdc, function()
    addButton("Voir mon permis de conduire", { rightLabel = ">>>", description = "" }, {
        onSelected = function()
            TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'driver')
        end
    })
    addButton("Montrer mon permis de Conduire", { rightLabel = ">>>", description = "" }, {
        onSelected = function()
            if distance ~= -1 and distance <= 3.0 then
                TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), 'driver')
              else
                ESX.ShowNotification('No players nearby')
              end
        end
    })
        onClosed(function()
        submenu_portefeuille()
        end)
    end)
end
--- Options ---
function submenu2_options()
    tiss_menu.render(submenu2_optionsdiverses, function()
    addCheckbox("Activer le Mode UI", check, { description = "Bientôt Disponible !!" }, {})
    addCheckbox("Mode FPS Boost", check, { description = "Bientôt Disponible !!" }, {})
    end)        
end
---- Vehicle
local engineState = false -- État initial du moteur
local check = false       -- État initial de la case à cocher

function submenu3_vehicule()
    tiss_menu.render(submenu3_vehicule1, function()
        addCheckbox("Activer/Désactiver le moteur", check, {}, {
            onChange = function(value)
                check = value -- Met à jour l'état de la case
                local playerPed = PlayerPedId()
                local vehicle = GetVehiclePedIsIn(playerPed, false)

                if vehicle ~= 0 then
                    -- Alterne l'état du moteur
                    engineState = not engineState
                    SetVehicleEngineOn(vehicle, engineState, false, true)

                    if engineState then
                        print("Moteur activé.")
                    else
                        print("Moteur désactivé.")
                    end
                else
                    print("Vous n'êtes pas dans un véhicule.")
                end
            end
        })
    end)
end



RegisterCommand('tiss_menu', function()
    main()
end)

RegisterKeyMapping('tiss_menu', '', 'keyboard', 'F1')

