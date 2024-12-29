ESX = exports["es_extended"]:getSharedObject()


RegisterNetEvent('Tissbshotnord1:annonce:fermer')
AddEventHandler('Tissbshotnord1:annonce:fermer', function()
    local _scr = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Annonce Entreprise', 'B.Shot Nord', '~r~Fermeture~s~ du Burger Shot Nord', 'CHAR_CARSITE3')
        end
end)

RegisterNetEvent('Tissbshotnord1:annonce:ouvert')
AddEventHandler('Tissbshotnord1:annonce:ouvert', function()
    local _scr = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Annonce Entreprise', 'B.Shot Nord', '~g~Ouverture~s~ du Burger Shot Nord', 'CHAR_CARSITE3')
        end
end)

RegisterNetEvent('Tissbshotnord1:annonce:personnalisee')
AddEventHandler('Tissbshotnord1:annonce:personnalisee', function(anounce)
    local _scr = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Annonce Entreprise', 'B.Shot Nord', anounce, 'CHAR_CARSITE3')
        end
end)
