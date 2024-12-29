ESX = exports["es_extended"]:getSharedObject()

--- Sous Menu bshotsud ---  
--- 
--- 
--- 
local player, distance = ESX.Game.GetClosestPlayer()

local check = false
local slider = 0

local main_bshotsud1 = tiss_menu.create("fb", Config.ServerName, { subtitle = "", description = "Burger Shot Sud", itemsPerPage = 10 })
local sub_bshotsud11 = tiss_menu.create("fb", Config.ServerName, { subtitle = "", description = "Annonce B.Shot Sud", itemsPerPage = 10 })
print("Ouuuuuu")

function main_bshotsud()
    tiss_menu.render(main_bshotsud1, function()
    
    addButton("📢 Annonce", { rightLabel = ">>>", description = "" }, {
        onSelected = function()
            sub_annoncebshotsud()
        end
    })
    addButton("📜 Faire une Facture", { rightLabel = ">>>", description = "" }, {
        onSelected = function()
            local price = exports["input"]:ShowSync("Entrez un Nombre", true, 100, "number")
            local reason = exports["input"]:ShowSync("Entrez une raison", true, 100, "small_text")
            if distance ~= -1 and distance <= 3.0 then
            TriggerServerEvent("okokBilling:CreateCustomInvoice", GetPlayerServerId(PlayerId()), price, reason, "bshotsud", "bshotsud", "bshotsud")
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


function sub_annoncebshotsud()
    tiss_menu.render(sub_bshotsud11, function()
    
    addButton("🟢 Annonce - Ouvert", { rightLabel = ">>>", description = "" }, {
        onSelected = function()
            TriggerServerEvent('Tissbshotsud1:annonce:ouvert')
        end
    })
    addButton("🔴 Annonce - Fermer", { rightLabel = ">>>", description = "" }, {
        onSelected = function()
            TriggerServerEvent('Tissbshotsud1:annonce:fermer')
        end
    })    
    addButton("⚪ Annonce - Personnalisée", { rightLabel = ">>>", description = "" }, {
        onSelected = function()
            tiss_menu.close(sub_bshotsud11.id)
            print("Lancement...")
            local anounce = exports["input"]:ShowSync("Entrez un chiffre", true, 100, "text")
            TriggerServerEvent('Tissbshotsud1:annonce:personnalisee', anounce)
        end
    })    
        onClosed(function()
        main_bshotsud()
        end)    
    end)
end




RegisterCommand('bshotsud1main', function()
    if ESX.PlayerData.job and ESX.PlayerData.job.name == "bshotsud" then
    main_bshotsud()
    end
end)


RegisterNetEvent("Tissmey:Jobs:bshotsud")
AddEventHandler("Tissmey:Jobs:bshotsud", function()
    main_bshotsud()
end)
