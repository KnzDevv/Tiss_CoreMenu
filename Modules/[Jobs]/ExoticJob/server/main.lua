ESX = exports["es_extended"]:getSharedObject()


RegisterNetEvent('Tissexoticnord1:annonce:fermer')
AddEventHandler('Tissexoticnord1:annonce:fermer', function()
    local _scr = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Annonce Entreprise', 'Exotic Boat', '~r~Fermeture~s~ du Exotic Boat', 'CHAR_CARSITE3')
        end
end)

RegisterNetEvent('Tissexoticnord1:annonce:ouvert')
AddEventHandler('Tissexoticnord1:annonce:ouvert', function()
    local _scr = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Annonce Entreprise', 'Exotic Boat', '~g~Ouverture~s~ du Exotic Boat', 'CHAR_CARSITE3')
        end
end)

RegisterNetEvent('Tissexoticnord1:annonce:personnalisee')
AddEventHandler('Tissexoticnord1:annonce:personnalisee', function(anounce)
    local _scr = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Annonce Entreprise', 'Exotic Boat', anounce, 'CHAR_CARSITE3')
        end
end)
