local ESX = exports["es_extended"]:getSharedObject()

-- Création des menus
local main_policejob = tiss_menu.create("fb", Config.ServerName, { subtitle = "", description = "Police", itemsPerPage = 10 })

local sub_policejobinteractcitoyen = tiss_menu.create("fb", Config.ServerName, { subtitle = "", description = "Gestion des employés", itemsPerPage = 10 })

-- Variables d'état
local PoliceStatus = false -- État initial de prise de service
local check = false -- État initial de la checkbox

-- Fonction principale pour le menu police
function main_police()
    tiss_menu.render(main_policejob, function()
        -- Ajout de la checkbox pour la prise de service
        addCheckbox("Prendre son service", check, {}, {
            onChange = function(value)
                check = value
                PoliceStatus = value -- Met à jour l'état du service
                if PoliceStatus then
                    print("Webhook : Prise de service")
                    ESX.ShowAdvancedNotification('Central Police', 'Prise de Service', 'Tu as bien ~g~Pris ton service ~s~', "CHAR_CARSITE3", 1)
                else
                    print("Webhook : Fin de service")
                    ESX.ShowAdvancedNotification('Central Police', 'Prise de Service', 'Tu as bien pris ta ~r~Fin de service ~s~', "CHAR_CARSITE3", 1)
                end
            end
        })

        -- Vérification de l'état pour afficher les options
        if PoliceStatus then
            addButton("👮 Interactions Citoyens", { rightLabel = ">>>", description = "Gérer les banques" }, {
                onSelected = function()
                    sub_interactioncitoyen()
                end
            })
        end

        -- Gestion de la fermeture du menu
        onClosed(function()
            print("Menu police fermé.")
        end)
    end)
end



function sub_interactioncitoyen()
    tiss_menu.render(sub_policejobinteractcitoyen, function()
    if PoliceStatus then
        addButton("Fouiller", { rightLabel = ">>>", description = "Gérer les banques" }, {
            onSelected = function()

            end
        })
        addButton("Fouiller + Prendre Objet", { rightLabel = ">>>", description = "Gérer les banques" }, {
            onSelected = function()
                ExecuteCommand("steal "..targetServerId)
                ExecuteCommand("me fouille")
            end
        })
        addButton("Menotter / Demenotter", { rightLabel = ">>>", description = "Gérer les banques" }, {
            onSelected = function()
                
            end
        })
        addButton("Escorter", { rightLabel = ">>>", description = "Gérer les banques" }, {
            onSelected = function()
                
            end
        })
    end
        onClosed(function()
        main_police()
        end)
    end)
end





RegisterNetEvent("Tissmey:Jobs:Police")
AddEventHandler("Tissmey:Jobs:Police", function()
    main_police()
end)


RegisterCommand('policejobmain', function()
    if ESX.PlayerData.job and ESX.PlayerData.job.name == "police" then
    main_police()
    end
end)