jail = {}
playerInjail = {}
local antispamJail = {}

Callback.registerServerCallback('Yvelt:getJail', function(source)
    return {jail[YveltHelper:getIdentifier(source)]}
end)

RegisterNetEvent('Yvelt:updatejailTime')
AddEventHandler('Yvelt:updatejailTime', function()
    local _src = source
    if jail[YveltHelper:getIdentifier(_src)] then
        local time = tonumber(jail[YveltHelper:getIdentifier(_src)].time)
        local result = time - 60.0

        if not antispamJail['id:'.._src] then
            antispamJail['id:'.._src] = true
            Citizen.SetTimeout(56000, function() antispamJail['id:'.._src] = nil end)
        else
            DropPlayer(source, "YveltShield : Tentative de triche (bypass trigger : \"YveltAdmin:updatejailTime\")")
        end

        if 60.0 >= result then
            jail[YveltHelper:getIdentifier(_src)] = nil 
            local identifier = YveltHelper:getIdentifier(_src)
            MySQL.Async.execute('DELETE FROM yvelt_jail WHERE identifier = @identifier', {
                ['@identifier'] = identifier,
            }, function(rowsChanged)
                YveltHelper:serverNotification(_src, '~g~Vous êtes sorti de jail !')
                print('^0[^2!^0] ^2server.lua ^0=> Le joueur ^4'..YveltHelper:getPlayerName(_src)..'^0 vient de ^1sortir^0 de jail')
                TriggerClientEvent('Yvelt:finishjailTime', _src)
            end)
        else
            MySQL.Async.execute('UPDATE yvelt_jail SET time = @time WHERE identifier = @identifier', {
                ['@time'] = ""..result.."",
                ['@identifier'] = YveltHelper:getIdentifier(_src),
            })
        end
    end
end)

RegisterCommand('unjail', function(source, arg)
    local _src = source
    local idPlayer = tonumber(arg[1])
    if source == 0 then
        if idPlayer then
            local xTarget = YveltHelper:getPlayerFromId(idPlayer)
            if xTarget then
                local identifier = YveltHelper:getIdentifier(xTarget.source)
                if jail[identifier] then
                    jail[identifier] = nil
                    TriggerClientEvent('Yvelt:finishjailTime', idPlayer)
                    YveltHelper:serverNotification(idPlayer, '~g~Vous avez été unjail par '..GetPlayerName(idPlayer)..' !')
                    MySQL.Async.execute('DELETE FROM yvelt_jail WHERE identifier = @identifier', {
                        ['@identifier'] = YveltHelper:getIdentifier(xTarget.source),
                    })
                else
                    print('^2La personne n\'est pas en jail !')
                end
            else
                print('^2Ce joueur n\'est pas connecté !')
            end
        else
            print('^2Précisez l\'ID de la personne a unjail !')
        end
    else
        local xPlayer = YveltHelper:getPlayerFromId(source)
        if xPlayer then
            local permission = exports.YveltAdmin:checkAcces(source, 'jail')
            if permission then
                local idPlayer = tonumber(arg[1])

                local xTarget = YveltHelper:getPlayerFromId(idPlayer)
                if xTarget then
                    local identifier = YveltHelper:getIdentifier(xTarget.source)
                    if jail[identifier] then
                        jail[identifier] = nil
                        TriggerClientEvent('Yvelt:finishjailTime', idPlayer)
                        YveltHelper:serverNotification(idPlayer, '~g~Vous avez été unjail par '..GetPlayerName(idPlayer)..' !')
                        MySQL.Async.execute('DELETE FROM yvelt_jail WHERE identifier = @identifier', {
                            ['@identifier'] = YveltHelper:getIdentifier(xTarget.source),
                        })
                        YveltHelper:serverNotification(xPlayer.source, '~g~Le joueur a été unjail !')
                    else
                        YveltHelper:serverNotification(xPlayer.source, '~r~La personne n\'est pas en jail !')
                    end
                else
                    YveltHelper:serverNotification(xPlayer.source, '~r~Ce joueur n\'est pas connecté !')
                end
            else
                YveltHelper:serverNotification(xPlayer.source, '~r~Tu n\'as pas la permission !')
            end
        end
    end
end)

RegisterCommand('jail', function(source, arg)
    local _src = source
    if source == 0 then
        local idPlayer = tonumber(arg[1])
        local xTarget = YveltHelper:getPlayerFromId(idPlayer)
        local time = tonumber(arg[2])
        local raison = table.concat(arg, ' ', 3)
        if xTarget then
            if time then
                local date = os.date("%d")..'/'..os.date("%m")..'/'..os.date("%Y")..' à '..os.date("%H")..'h'..os.date("%M")..' et '..os.date("%S")..' secondes'
                if raison then
                    setInJail(_src, xTarget, 'Console', time * 60, date, raison)
                else
                    setInJail(_src, xTarget, 'Console', time * 60, date, 'Aucune raison indiqué')
                end
            else
                print('^2Veuillez préciser un temps en minute')
            end
        else
            print('^2Ce joueur n\'est pas connecté !')
        end
    else
        local xPlayer = YveltHelper:getPlayerFromId(source)
        if PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)] then
            local idPlayer = tonumber(arg[1])
            local xTarget = YveltHelper:getPlayerFromId(idPlayer)
            local time = tonumber(arg[2])
            local raison = table.concat(arg, ' ', 3)
            if xTarget then
                if time then
                    local date = os.date("%d")..'/'..os.date("%m")..'/'..os.date("%Y")..' à '..os.date("%H")..'h'..os.date("%M")..' et '..os.date("%S")..' secondes'
                    if raison then
                        setInJail(_src, xTarget, YveltHelper:getPlayerName(xPlayer.source), time * 60, date, raison)
                    else
                        setInJail(_src, xTarget, YveltHelper:getPlayerName(xPlayer.source), time * 60, date, 'Aucune raison indiqué')
                    end
                else
                    YveltHelper:serverNotification(xPlayer.source, '~r~Veuillez préciser un temps en minute')
                end
            else
                YveltHelper:serverNotification(xPlayer.source, '~r~Ce joueur n\'est pas connecté !')
            end
        else
            YveltHelper:serverNotification(xPlayer.source, '~r~Tu n\'as pas la permission !')
        end
    end
end)

function setInJail(src, xTargett, staffName, time, date, raison)
    local xTarget = xTargett
    local identifier = YveltHelper:getIdentifier(xTarget.source)
    if jail[identifier] then
        if src == 0 then
            print('^2Ce joueur été déjà en jail ! Son temps de jail a été mis a jour')
        else
            YveltHelper:serverNotification(src, '~r~Ce joueur été déjà en jail ! Son temps de jail a été mis a jour')
        end
    end
    jail[identifier] = {
        identifier = identifier,
        staffName = staffName,
        time = time,
        date = date,
        raison = raison,
    }
    TriggerClientEvent('Yvelt:SendClientToJail', xTarget.source, jail[identifier])
    MySQL.Async.execute('INSERT INTO yvelt_jail (identifier, staffName, time, date, raison) VALUES (@identifier, @staffName, @time, @date, @raison)', {
        ['@identifier'] = jail[identifier].identifier,
        ['@staffName'] = jail[identifier].staffName,
        ['@time'] = jail[identifier].time,
        ['@date'] = jail[identifier].date,
        ['@raison'] = jail[identifier].raison,
    })
    print('^0[^2!^0] ^2server.lua ^0=> Le joueur ^4'..YveltHelper:getPlayerName(xTarget.source)..'^0 a été mis en jail par ^1'..YveltHelper:getPlayerName(src))
    if src == 0 then
        print('^2Le joueur est désormais en jail')
    else
        YveltHelper:serverNotification(src, '~g~Le joueur est désormais en jail')
    end
end

function loadJail()
    MySQL.Async.fetchAll('SELECT * FROM yvelt_jail', {}, function(results)
        print('^0[^2!^0] ^2server.lua ^0=> La base de données a enregistré ^3' .. #results .. ' ^0personnes actuellement en jail')
		for k, v in pairs(results) do
            jail[v.identifier] = {
                identifier = v.identifier,
                staffName = YveltHelper:getTextFromAscii(v.staffName),
                time = v.time,
                date = v.date,
                raison = v.raison,
            }
        end
    end)
end

MySQL.ready(function()
    loadJail()
end)