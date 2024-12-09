ESX = exports["es_extended"]:getSharedObject()


-- Server-side
RegisterNetEvent('getPlayerGroup')
AddEventHandler('getPlayerGroup', function()
    local src = source -- ID du joueur qui a appelé l'événement
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer then
        local group = xPlayer.getGroup() -- Récupère le groupe
        TriggerClientEvent('receivePlayerGroup', src, group) -- Envoie au client
    end
end)
