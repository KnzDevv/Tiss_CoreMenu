ESX = exports["es_extended"]:getSharedObject()

local player, distance = ESX.Game.GetClosestPlayer()
local check = false
local slider = 0

--- Menu / Sous Menu
local mainmenu_admin = tiss_menu.create("fb", "Melrose FA", { subtitle = "", description = "MENU ADMINISTRATION", itemsPerPage = 10 })
local sub_admininv = tiss_menu.create("fb", "Melrose FA", { subtitle = "", description = "GESTION INVENTAIRE", itemsPerPage = 10 })

function main_adminmod()
    tiss_menu.render(mainmenu_admin, function()
        addButton("👜 Gestion Inventaire", { rightLabel = ">>>", description = "" }, {
            onSelected = function()
                sub_gesinventaire()
            end
        })


    





        onClosed(function()
            print("Menu Fermé.")            
        end)
    end)
end

function sub_gesinventaire()
    tiss_menu.render(sub_admininv, function()
    addButton("🔎 Chercher un item", { rightLabel = ">>>", description = "" }, {
        onSelected = function()
            --local searcher = exports["input"]:ShowSync("Entrez le nom de votre item", true, 100, "text")
            local itemNames = {}
            for item, data in pairs(exports.ox_inventory:Items()) do
            itemNames[item] = data.label
            end
        end
    })
    
    
    
    
    
    end)
end