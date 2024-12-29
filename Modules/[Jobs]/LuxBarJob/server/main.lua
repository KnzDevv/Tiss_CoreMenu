ESX = exports["es_extended"]:getSharedObject()


RegisterNetEvent('TissLuxbarJob:annonce:fermer')
AddEventHandler('TissLuxbarJob:annonce:fermer', function()
    local _scr = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Annonce Entreprise', 'Lux Bar', '~r~Fermeture~s~ du Lux', 'CHAR_CARSITE3')
        end
end)

RegisterNetEvent('TissLuxbarJob:annonce:ouvert')
AddEventHandler('TissLuxbarJob:annonce:ouvert', function()
    local _scr = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Annonce Entreprise', 'Lux Bar', '~g~Ouverture~s~ du Lux', 'CHAR_CARSITE3')
        end
end)

RegisterNetEvent('TissLuxbarJob:annonce:personnalisee')
AddEventHandler('TissLuxbarJob:annonce:personnalisee', function(anounce)
    local _scr = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Annonce Entreprise', 'Lux Bar', anounce, 'CHAR_CARSITE3')
        end
end)
