ESX = exports["es_extended"]:getSharedObject()

--- Sous Menu Luxbar ---  
local player, distance = ESX.Game.GetClosestPlayer()

local check = false
local slider = 0

local main_LuxbarJob = tiss_menu.create("fb", Config.ServerName, { subtitle = "", description = "Luxbar", itemsPerPage = 10 })
local sub_LuxbarJob1 = tiss_menu.create("fb", Config.ServerName, { subtitle = "", description = "Annonce Luxbar", itemsPerPage = 10 })
print("Ouuuuuu")

function main_Luxbar()
    tiss_menu.render(main_LuxbarJob, function()
    
    addButton("📢 Annonce", { rightLabel = ">>>", description = "" }, {
        onSelected = function()
            sub_annonceLuxbar()
        end
    })
    addButton("📜 Faire une Facture", { rightLabel = ">>>", description = "" }, {
        onSelected = function()
            local price = exports["input"]:ShowSync("Entrez un Nombre", true, 100, "number")
            local reason = exports["input"]:ShowSync("Entrez une raison", true, 100, "small_text")
            if distance ~= -1 and distance <= 3.0 then
            TriggerServerEvent("okokBilling:CreateCustomInvoice", GetPlayerServerId(PlayerId()), price, reason, "Luxbar", "Luxbar", "Luxbar")
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


function sub_annonceLuxbar()
    tiss_menu.render(sub_LuxbarJob1, function()
    
    addButton("🟢 Annonce - Ouvert", { rightLabel = ">>>", description = "" }, {
        onSelected = function()
            TriggerServerEvent('TissLuxbarJob:annonce:ouvert')
        end
    })
    addButton("🔴 Annonce - Fermer", { rightLabel = ">>>", description = "" }, {
        onSelected = function()
            TriggerServerEvent('TissLuxbarJob:annonce:fermer')
        end
    })    
    addButton("⚪ Annonce - Personnalisée", { rightLabel = ">>>", description = "" }, {
        onSelected = function()
            tiss_menu.close(sub_LuxbarJob1.id)
            print("Lancement...")
            local anounce = exports["input"]:ShowSync("Entrez un chiffre", true, 100, "text")
            TriggerServerEvent('TissLuxbarJob:annonce:personnalisee', anounce)
        end
    })    
        onClosed(function()
        main_Luxbar()
        end)    
    end)
end




RegisterCommand('LuxbarJobmain', function()
    if ESX.PlayerData.job and ESX.PlayerData.job.name == "luxbar" then
    main_Luxbar()
    end
end)


RegisterNetEvent("Tissmey:Jobs:Luxbar")
AddEventHandler("Tissmey:Jobs:Luxbar", function()
    main_Luxbar()
end)
