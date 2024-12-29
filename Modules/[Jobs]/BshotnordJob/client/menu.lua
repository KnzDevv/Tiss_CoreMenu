ESX = exports["es_extended"]:getSharedObject()

--- Sous Menu bshotnord ---  
--- 
--- 
--- 
local player, distance = ESX.Game.GetClosestPlayer()

local check = false
local slider = 0

local main_bshotnord1 = tiss_menu.create("fb", Config.ServerName, { subtitle = "", description = "B.Shot Nord", itemsPerPage = 10 })
local sub_bshotnord11 = tiss_menu.create("fb", Config.ServerName, { subtitle = "", description = "Annonce B.Shot Nord", itemsPerPage = 10 })
print("Ouuuuuu")

function main_bshotnord()
    tiss_menu.render(main_bshotnord1, function()
    
    addButton("📢 Annonce", { rightLabel = ">>>", description = "" }, {
        onSelected = function()
            sub_annoncebshotnord()
        end
    })
    addButton("📜 Faire une Facture", { rightLabel = ">>>", description = "" }, {
        onSelected = function()
            local price = exports["input"]:ShowSync("Entrez un Nombre", true, 100, "number")
            local reason = exports["input"]:ShowSync("Entrez une raison", true, 100, "small_text")
            if distance ~= -1 and distance <= 3.0 then
            TriggerServerEvent("okokBilling:CreateCustomInvoice", GetPlayerServerId(PlayerId()), price, reason, "bshotnord", "bshotnord", "bshotnord")
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


function sub_annoncebshotnord()
    tiss_menu.render(sub_bshotnord11, function()
    
    addButton("🟢 Annonce - Ouvert", { rightLabel = ">>>", description = "" }, {
        onSelected = function()
            TriggerServerEvent('Tissbshotnord1:annonce:ouvert')
        end
    })
    addButton("🔴 Annonce - Fermer", { rightLabel = ">>>", description = "" }, {
        onSelected = function()
            TriggerServerEvent('Tissbshotnord1:annonce:fermer')
        end
    })    
    addButton("⚪ Annonce - Personnalisée", { rightLabel = ">>>", description = "" }, {
        onSelected = function()
            tiss_menu.close(sub_bshotnord11.id)
            print("Lancement...")
            local anounce = exports["input"]:ShowSync("Entrez un chiffre", true, 100, "text")
            TriggerServerEvent('Tissbshotnord1:annonce:personnalisee', anounce)
        end
    })    
        onClosed(function()
        main_bshotnord()
        end)    
    end)
end




RegisterCommand('bshotnord1main', function()
    if ESX.PlayerData.job and ESX.PlayerData.job.name == "bshotnord" then
    main_bshotnord()
    end
end)


RegisterNetEvent("Tissmey:Jobs:bshotnord")
AddEventHandler("Tissmey:Jobs:bshotnord", function()
    main_bshotnord()
end)
