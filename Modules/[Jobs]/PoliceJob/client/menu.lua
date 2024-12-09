ESX = exports["es_extended"]:getSharedObject()


local main_policejob = tiss_menu.create("fb", "Melrose FA", { subtitle = "", description = "Police", itemsPerPage = 10 })
local PoliceStatus = false -- État initial du moteur
local servicecheck = false  
function main_police()
    tiss_menu.render(main_policejob, function()
    addCheckbox("Prendre son service", check, {}, {
            onChange = function(value)
                check = value -- Met à jour l'état de la case
             
            end
        })
    
    
    
            onClosed(function()
        end)
    end)
end


RegisterCommand('policejobmain', function()
    if ESX.PlayerData.job and ESX.PlayerData.job.name == "taxi" then
    main_police()
    end
end)