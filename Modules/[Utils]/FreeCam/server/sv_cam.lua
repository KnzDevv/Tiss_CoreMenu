ESX = exports['es_extended']:getSharedObject()

if FreeCam.Command.active then
    RegisterCommand(FreeCam.Command.name, function(source, args, rawCommand)
        local xPlayer = ESX.GetPlayerFromId(source)

        -- Verification du status du group dans le config savoir si celui-ci est en true ou false
        if FreeCam.Groups[xPlayer.getGroup()] then
            TriggerClientEvent('admin:toggleCamera', source, true)
        end
    end, false)
end