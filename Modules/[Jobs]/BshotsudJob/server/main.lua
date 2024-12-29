ESX = exports["es_extended"]:getSharedObject()


RegisterNetEvent('Tissbshotsud1:annonce:fermer')
AddEventHandler('Tissbshotsud1:annonce:fermer', function()
    local _scr = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Annonce Entreprise', 'B.Shot Sud', '~r~Fermeture~s~ du Burger Shot Sud', 'CHAR_CARSITE3')
        end
end)

RegisterNetEvent('Tissbshotsud1:annonce:ouvert')
AddEventHandler('Tissbshotsud1:annonce:ouvert', function()
    local _scr = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Annonce Entreprise', 'bshotsud', '~g~Ouverture~s~ du Burger Shot Sud', 'CHAR_CARSITE3')
        end
end)

RegisterNetEvent('Tissbshotsud1:annonce:personnalisee')
AddEventHandler('Tissbshotsud1:annonce:personnalisee', function(anounce)
    local _scr = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Annonce Entreprise', 'Burger Shot Sud', anounce, 'CHAR_CARSITE3')
        end
end)
