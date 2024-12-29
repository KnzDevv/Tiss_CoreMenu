ESX = exports["es_extended"]:getSharedObject()

--- Sous Menu Taxi ---  
--- 
--- 
--- 
local player, distance = ESX.Game.GetClosestPlayer()

local check = false
local slider = 0

local main_taxijob = tiss_menu.create("fb", Config.ServerName, { subtitle = "", description = "Taxi", itemsPerPage = 10 })
local sub_taxijob1 = tiss_menu.create("fb", Config.ServerName, { subtitle = "", description = "Annonce Taxi", itemsPerPage = 10 })
print("Ouuuuuu")

function main_taxi()
    tiss_menu.render(main_taxijob, function()
    
    addButton("📢 Annonce", { rightLabel = ">>>", description = "" }, {
        onSelected = function()
            sub_annonceTaxi()
        end
    })
    addButton("📜 Faire une Facture", { rightLabel = ">>>", description = "" }, {
        onSelected = function()
            local price = exports["input"]:ShowSync("Entrez un Nombre", true, 100, "number")
            local reason = exports["input"]:ShowSync("Entrez une raison", true, 100, "small_text")
            if distance ~= -1 and distance <= 3.0 then
            TriggerServerEvent("okokBilling:CreateCustomInvoice", GetPlayerServerId(PlayerId()), price, reason, "Taxi", "taxi", "Taxi")
                print("effectué")
        else
            ESX.ShowNotification('No players nearby')
            end
        end

    })
    
    
        onClosed(function()
        print("Menu fermé.")
        end)    
    end)
end


function sub_annonceTaxi()
    tiss_menu.render(sub_taxijob1, function()
    
    addButton("🟢 Annonce - Ouvert", { rightLabel = ">>>", description = "" }, {
        onSelected = function()
            TriggerServerEvent('TissTaxiJob:annonce:ouvert')
        end
    })
    addButton("🔴 Annonce - Fermer", { rightLabel = ">>>", description = "" }, {
        onSelected = function()
            TriggerServerEvent('TissTaxiJob:annonce:fermer')
        end
    })    
    addButton("⚪ Annonce - Personnalisée", { rightLabel = ">>>", description = "" }, {
        onSelected = function()
            tiss_menu.close(sub_taxijob1.id)
            print("Lancement...")
            local anounce = exports["input"]:ShowSync("Entrez un chiffre", true, 100, "text")
            TriggerServerEvent('TissTaxiJob:annonce:personnalisee', anounce)
        end
    })    
        onClosed(function()
        main_taxi()
        end)    
    end)
end


local main_patron = tiss_menu.create("fb", Config.ServerName, { subtitle = "", description = "Menu Patron", itemsPerPage = 10 })
local sub_patrongestion = tiss_menu.create("fb", Config.ServerName, { subtitle = "", description = "Gestion Personnelles", itemsPerPage = 10 })


function main_patronstructure()
    tiss_menu.render(main_patron, function()
    addButton("🟢 Annonce - Ouvert", { rightLabel = ">>>", description = "" }, {
        onSelected = function()
            TriggerServerEvent('TissTaxiJob:annonce:ouvert')
        end
    })

        onClosed(function()
        end)
    end)
end

RegisterCommand('taxijobmain', function()
    if ESX.PlayerData.job and ESX.PlayerData.job.name == "taxi" then
    main_taxi()
    end
end)

RegisterNetEvent("TIssmey:Jobs:Taxi")
AddEventHandler("Tissmey:Jobs:Taxi", function()
    main_taxi()
end)
