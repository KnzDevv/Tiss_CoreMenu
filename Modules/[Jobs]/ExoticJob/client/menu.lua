ESX = exports["es_extended"]:getSharedObject()

--- Sous Menu exoticnord ---  
--- 
--- 
--- 
local player, distance = ESX.Game.GetClosestPlayer()

local check = false
local slider = 0

local main_exoticnord1 = tiss_menu.create("fb", Config.ServerName, { subtitle = "", description = "Exotic Boat", itemsPerPage = 10 })
local sub_exoticnord11 = tiss_menu.create("fb", Config.ServerName, { subtitle = "", description = "Annonce Exotic Boat", itemsPerPage = 10 })
print("Ouuuuuu")

function main_exoticnord()
    tiss_menu.render(main_exoticnord1, function()
    
    addButton("📢 Annonce", { rightLabel = ">>>", description = "" }, {
        onSelected = function()
            sub_annonceexoticnord()
        end
    })
    addButton("📜 Faire une Facture", { rightLabel = ">>>", description = "" }, {
        onSelected = function()
            local price = exports["input"]:ShowSync("Entrez un Nombre", true, 100, "number")
            local reason = exports["input"]:ShowSync("Entrez une raison", true, 100, "small_text")
            if distance ~= -1 and distance <= 3.0 then
            TriggerServerEvent("okokBilling:CreateCustomInvoice", GetPlayerServerId(PlayerId()), price, reason, "exoticnord", "exoticnord", "exoticnord")
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


function sub_annonceexoticnord()
    tiss_menu.render(sub_exoticnord11, function()
    
    addButton("🟢 Annonce - Ouvert", { rightLabel = ">>>", description = "" }, {
        onSelected = function()
            TriggerServerEvent('Tissexoticnord1:annonce:ouvert')
        end
    })
    addButton("🔴 Annonce - Fermer", { rightLabel = ">>>", description = "" }, {
        onSelected = function()
            TriggerServerEvent('Tissexoticnord1:annonce:fermer')
        end
    })    
    addButton("⚪ Annonce - Personnalisée", { rightLabel = ">>>", description = "" }, {
        onSelected = function()
            tiss_menu.close(sub_exoticnord11.id)
            print("Lancement...")
            local anounce = exports["input"]:ShowSync("Entrez un chiffre", true, 100, "text")
            TriggerServerEvent('Tissexoticnord1:annonce:personnalisee', anounce)
        end
    })    
        onClosed(function()
        main_exoticnord()
        end)    
    end)
end




RegisterCommand('exoticnord1main', function()
    if ESX.PlayerData.job and ESX.PlayerData.job.name == "exoticnord" then
    main_exoticnord()
    end
end)


RegisterNetEvent("Tissmey:Jobs:exoticnord")
AddEventHandler("Tissmey:Jobs:exoticnord", function()
    main_exoticnord()
end)
