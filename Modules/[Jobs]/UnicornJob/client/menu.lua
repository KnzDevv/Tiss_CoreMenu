ESX = exports["es_extended"]:getSharedObject()

--- Sous Menu unicorn ---  
--- 
--- 
--- 
local player, distance = ESX.Game.GetClosestPlayer()

local check = false
local slider = 0

local main_unicornjob = tiss_menu.create("fb", "Melrose FA", { subtitle = "", description = "Unicorn", itemsPerPage = 10 })
local sub_unicornjob1 = tiss_menu.create("fb", "Melrose FA", { subtitle = "", description = "Annonce Unicorn", itemsPerPage = 10 })
print("Ouuuuuu")

function main_unicorn()
    tiss_menu.render(main_unicornjob, function()
    
    addButton("📢 Annonce", { rightLabel = ">>>", description = "" }, {
        onSelected = function()
            sub_annonceUnicorn()
        end
    })
    addButton("📜 Faire une Facture", { rightLabel = ">>>", description = "" }, {
        onSelected = function()
            local price = exports["input"]:ShowSync("Entrez un Nombre", true, 100, "number")
            local reason = exports["input"]:ShowSync("Entrez une raison", true, 100, "small_text")
            if distance ~= -1 and distance <= 3.0 then
            TriggerServerEvent("okokBilling:CreateCustomInvoice", GetPlayerServerId(PlayerId()), price, reason, "unicorn", "unicorn", "unicorn")
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


function sub_annonceUnicorn()
    tiss_menu.render(sub_unicornjob1, function()
    
    addButton("🟢 Annonce - Ouvert", { rightLabel = ">>>", description = "" }, {
        onSelected = function()
            TriggerServerEvent('TissunicornJob:annonce:ouvert')
        end
    })
    addButton("🔴 Annonce - Fermer", { rightLabel = ">>>", description = "" }, {
        onSelected = function()
            TriggerServerEvent('TissunicornJob:annonce:fermer')
        end
    })    
    addButton("⚪ Annonce - Personnalisée", { rightLabel = ">>>", description = "" }, {
        onSelected = function()
            tiss_menu.close(sub_unicornjob1.id)
            print("Lancement...")
            local anounce = exports["input"]:ShowSync("Entrez un chiffre", true, 100, "text")
            TriggerServerEvent('TissunicornJob:annonce:personnalisee', anounce)
        end
    })    
        onClosed(function()
        main_unicorn()
        end)    
    end)
end




RegisterCommand('unicornjobmain', function()
    if ESX.PlayerData.job and ESX.PlayerData.job.name == "unicorn" then
    main_unicorn()
    end
end)


RegisterNetEvent("Tissmey:Jobs:Unicorn")
AddEventHandler("Tissmey:Jobs:Unicorn", function()
    main_unicorn()
end)
