ESX = exports["es_extended"]:getSharedObject()


RegisterNetEvent('TissTaxiJob:annonce:fermer')
AddEventHandler('TissTaxiJob:annonce:fermer', function()
    local _scr = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Annonce Entreprise', 'Taxi', '~r~Fermeture~s~ du Taxi', 'CHAR_CARSITE3')
        end
end)

RegisterNetEvent('TissTaxiJob:annonce:ouvert')
AddEventHandler('TissTaxiJob:annonce:ouvert', function()
    local _scr = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Annonce Entreprise', 'Taxi', '~g~Ouverture~s~ du Taxi', 'CHAR_CARSITE3')
        end
end)

RegisterNetEvent('TissTaxiJob:annonce:personnalisee')
AddEventHandler('TissTaxiJob:annonce:personnalisee', function(anounce)
    local _scr = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Annonce Entreprise', 'Taxi', anounce, 'CHAR_CARSITE3')
        end
end)
