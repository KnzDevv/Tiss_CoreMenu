ESX = exports["es_extended"]:getSharedObject()


RegisterNetEvent('TissunicornJob:annonce:fermer')
AddEventHandler('TissunicornJob:annonce:fermer', function()
    local _scr = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Annonce Entreprise', 'Unicorn', '~r~Fermeture~s~ du unicorn', 'CHAR_CARSITE3')
        end
end)

RegisterNetEvent('TissunicornJob:annonce:ouvert')
AddEventHandler('TissunicornJob:annonce:ouvert', function()
    local _scr = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Annonce Entreprise', 'Unicorn', '~g~Ouverture~s~ du unicorn', 'CHAR_CARSITE3')
        end
end)

RegisterNetEvent('TissunicornJob:annonce:personnalisee')
AddEventHandler('TissunicornJob:annonce:personnalisee', function(anounce)
    local _scr = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Annonce Entreprise', 'Unicorn', anounce, 'CHAR_CARSITE3')
        end
end)
