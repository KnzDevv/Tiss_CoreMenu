
RegisterCommand('ban', function(source, args)
    local _src = source 
    local xPlayer = YveltHelper:getPlayerFromId(_src)

    local xTarget = tonumber(args[1])
    local xPlayerTarget = YveltHelper:getPlayerFromId(xTarget)
    if not xPlayerTarget then
        if xPlayer then
            return YveltHelper:serverNotification(xPlayer.source, '~r~Ce joueur n\'est pas connecté !')
        else
            return print('Ce joueur n\'est pas connecté !')
        end
    end
    local Duree = ParseTime(args[2])
    if Duree > 0 then
        Duree = os.time() + ParseTime(args[2])
    end

    local Raison = table.concat(args, ' ', 3)
    local date = os.date("%d")..'/'..os.date("%m")..'/'..os.date("%Y")..' à '..os.date("%H")..'h'..os.date("%M")..' et '..os.date("%S")..' secondes'

    if source == 0 then
        if xTarget ~= nil then
            if Duree ~= nil then
                if Raison ~= nil then
                    local identifierToBan = YveltHelper:getIdentifier(xTarget)
                    if identifierToBan then
                        if bans[''..identifierToBan..''] then
                            return print('^0[^2!^0] ^4sv_bans.lua^0 => La personne est déjà banni !^0')
                        end
                        local auteur = YveltHelper:getPlayerName(source)
                        InsertLogsSanction(UID:getUIDfromID(tonumber(xTarget)), auteur, YveltHelper:getPlayerName(xPlayerTarget.source), 'Ban', Raison)
                        
                        local embed = {
                            title = 'Ban',
                            description = '**Action :** `ban`\n**Joueur : ** `'..GetPlayerName(tonumber(xTarget))..'` (ID : `'..tonumber(xTarget)..'` | UID : `'..UID:getUIDfromID(tonumber(xTarget))..'`)\n**Staff : ** `Console` (ID : `/` | UID : `/`) **Raison : **`'..Raison..'`**Temps :** `'..args[2]..'`',
                            color = 4838724,
                            webhook = 'ban',
                        }
                        YveltHelper:sendWebhook(embed)

                        MySQL.Async.execute('INSERT INTO yvelt_bans (identifier, date, raison, auteur, duree) VALUES (@identifier, @date, @raison, @auteur, @duree)', {
                            ['@identifier'] = identifierToBan,
                            ['@date'] = date,
                            ['@raison'] = Raison,
                            ['@auteur'] = auteur,
                            ['@duree'] = Duree,
                        }, function()
                            RefreshBanList()
                        end) 
                        print('^0[^2!^0] ^4sv_bans.lua^0 => Nouveau ban enregistré dans la base de données ^2('..YveltHelper:getPlayerName(xPlayerTarget.source)..' ['..xTarget..'])^0')

                        DropPlayer(xTarget, 'Vous avez été banni de '..YveltConfig.ServerTitle..' pour la raison suivante : "'..Raison..'" par Console')
                    else
                        print('Erreur lors du ban, ce joueur n\'est pas connecté !')
                    end
                else
                    print('ban ID DUREE RAISON')
                end
            else
                print('ban ID DUREE RAISON')
            end
        else
            print('ban ID DUREE RAISON')
        end
    else
        if not getAcces(PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)], 'ban') then 
            YveltHelper:serverNotification(xPlayer.source, '~r~Tu n\'as pas la permission !')
        else
            if xTarget ~= nil then
                if Duree ~= nil then
                    if Raison ~= nil then
                        if bans[''..YveltHelper:getIdentifier(xPlayerTarget.source)..''] then
                            return YveltHelper:serverNotification(xPlayer.source, '~r~La personne est déjà banni !')
                        end
                        
                        InsertLogsSanction(UID:getUIDfromID(tonumber(xTarget)), YveltHelper:getPlayerName(xPlayer.source), YveltHelper:getPlayerName(xPlayerTarget.source), 'Ban', Raison)
                        
                        local embed = {
                            title = 'Ban',
                            description = '**Action :** `ban`\n**Joueur : ** `'..GetPlayerName(tonumber(xTarget))..'` (ID : `'..tonumber(xTarget)..'` | UID : `'..UID:getUIDfromID(tonumber(xTarget))..'`)\n**Staff : ** `'..GetPlayerName(source)..'` (ID : `'..source..'` | UID : `'..UID:getUIDfromID(source)..'`) **Raison : **`'..Raison..'`**Temps :** `'..args[2]..'`',
                            color = 4838724,
                            webhook = 'ban',
                        }
                        YveltHelper:sendWebhook(embed)
                        
                        MySQL.Async.execute('INSERT INTO yvelt_bans (identifier, date, raison, auteur, duree) VALUES (@identifier, @date, @raison, @auteur, @duree)', {
                            ['@identifier'] = YveltHelper:getIdentifier(xPlayerTarget.source),
                            ['@date'] = date,
                            ['@raison'] = Raison,
                            ['@auteur'] = YveltHelper:getPlayerName(xPlayer.source),
                            ['@duree'] = Duree,
                        }, function()
                            RefreshBanList()
                        end) 
                        print('^0[^2!^0] ^4sv_bans.lua^0 => Nouveau ban enregistré dans la base de données ^2('..YveltHelper:getPlayerName(xPlayerTarget.source)..' ['..xTarget..'])^0')
                        
                        DropPlayer(xTarget, 'Vous avez été banni de '..YveltConfig.ServerTitle..' pour la raison suivante : "'..Raison..'" par '..YveltHelper:getPlayerName(xPlayer.source))
                    else
                        YveltHelper:serverNotification(xPlayer.source, '~r~/ban ID DUREE RAISON')
                    end
                else
                    YveltHelper:serverNotification(xPlayer.source, '~r~/ban ID DUREE RAISON')
                end
            else
                YveltHelper:serverNotification(xPlayer.source, '~r~/ban ID DUREE RAISON')
            end
        end
    end
end)

function ParseTime(input)
    if input ~= nil then 
        local value, unit = input:match("(%d+)(%a)")
        if value and unit then
            value = tonumber(value)
            if unit == "s" then
                return value
            elseif unit == "m" then
                return value * 60
            elseif unit == "h" then
                return value * 3600
            elseif unit == "j" then
                return value * 86400
            end
        end
        return 0
    else
        return 0
    end
end

local playerID = nil

RegisterCommand('banuid', function(source, args)
    local _src = source 
    local xPlayer = YveltHelper:getPlayerFromId(_src)

    local xTarget = tonumber(args[1])
    local Duree = ParseTime(args[2])
    if Duree > 0 then
        Duree = os.time() + ParseTime(args[2])
    end
    local Raison = table.concat(args, ' ', 3)
    local date = os.date("%d")..'/'..os.date("%m")..'/'..os.date("%Y")..' à '..os.date("%H")..'h'..os.date("%M")..' et '..os.date("%S")..' secondes'
    local identifier = nil
    local name = nil
    
    MySQL.Async.fetchAll('SELECT identifier, name FROM yvelt_uniqueid WHERE uid = @uid', {['@uid'] = xTarget}, function(players)
        if players[1] then
            identifierTarget = players[1].identifier
            nameTarget = YveltHelper:getTextFromAscii(players[1].name)
        end
        if _src == 0 then
            if xTarget ~= nil then
                if Duree ~= nil then
                    if Raison ~= nil then
                        --DropPlayer(xTarget, 'Vous avez été banni de '..YveltConfig.ServerTitle..' pour la raison suivante : "'..Raison..'" par '..YveltHelper:getPlayerName(xPlayer.source))
                        MySQL.Async.fetchAll('SELECT identifier FROM yvelt_uniqueid WHERE uid = @uid', {
                            ['@uid'] = xTarget
                        }, function(result)
                            if result[1].identifier then
                                identifier = result[1].identifier
                                
                                if bans[''..identifier..''] then
                                    return print('^0[^2!^0] ^4sv_bans.lua^0 => La personne est déjà banni !^0')
                                end

                                -- Boucle à travers tous les joueurs en ligne pour trouver le joueur avec l'identifiant spécifié
                                local players = {}
                                local xPlayers = ESX.GetPlayers()
                                local playerID = nil
                                for i=1, #xPlayers, 1 do
                                    local xPlayerrrrrr = YveltHelper:getPlayerFromId(xPlayers[i])
                                    if xPlayerrrrrr then
                                        if YveltHelper:getIdentifier(xPlayerrrrrr.source) == identifier then
                                            playerID = xPlayerrrrrr.source
                                        end
                                    end
                                end

                                if playerID then
                                    InsertLogsSanction(xTarget, 'Console', GetPlayerName(playerID), 'Ban', Raison)
                                else
                                    InsertLogsSanction(xTarget, 'Console', nameTarget, 'Ban', Raison)
                                end

                                if playerID ~= nil then
                                    print('^0[^2!^0] ^4sv_bans.lua^0 => La personne que vous souhaitez bannir était connecté^0')
                                    DropPlayer(playerID, 'Vous avez été banni de '..YveltConfig.ServerTitle..' pour la raison suivante : "'..Raison..'" par Console')
                                else
                                    print('^0[^2!^0] ^4sv_bans.lua^0 => La personne que vous souhaitez bannir n\'était pas connecté^0')
                                end
                                print('^0[^2!^0] ^4sv_bans.lua^0 => La personne a été banni => ^2ID Ban : '..xTarget..'^0')
                                MySQL.Async.execute('INSERT INTO yvelt_bans (identifier, date, raison, auteur, duree) VALUES (@identifier, @date, @raison, @auteur, @duree)', {
                                    ['@identifier'] = identifierTarget,
                                    ['@date'] = date,
                                    ['@raison'] = Raison,
                                    ['@auteur'] = 'Console',
                                    ['@duree'] = Duree,
                                }, function()
                                    RefreshBanList()
                                end) 
                            end
                        end)
                    end
                end
            end
        else
            if not getAcces(PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)], 'ban') then 
                YveltHelper:serverNotification(xPlayer.source, '~r~Tu n\'as pas la permission !')
            else
                if xTarget ~= nil then
                    if Duree ~= nil then
                        if Raison ~= nil then
                            local targetUIDid = UID:getIDfromUID(xTarget)

                            if bans[''..identifierTarget..''] then
                                return YveltHelper:serverNotification(xPlayer.source, '~r~La personne est déjà banni !')
                            end
                            

                            InsertLogsSanction(xTarget, YveltHelper:getPlayerName(xPlayer.source), nameTarget, 'Ban', Raison)
                            MySQL.Async.execute('INSERT INTO yvelt_bans (identifier, date, raison, auteur, duree) VALUES (@identifier, @date, @raison, @auteur, @duree)', {
                                ['@identifier'] = identifierTarget,
                                ['@date'] = date,
                                ['@raison'] = Raison,
                                ['@auteur'] = YveltHelper:getPlayerName(xPlayer.source),
                                ['@duree'] = Duree,
                            }, function()
                                RefreshBanList()
                            end) 
                            if targetUIDid then
                                DropPlayer(targetUIDid, 'Vous avez été banni de '..YveltConfig.ServerTitle..' pour la raison suivante : "'..Raison..'" par '..YveltHelper:getPlayerName(xPlayer.source))
                            end
                            print('^0[^2!^0] ^4sv_bans.lua^0 => Nouveau ban enregistré dans la base de données ^2('..nameTarget..' ['..xTarget..'])^0')
                        else
                            YveltHelper:serverNotification(xPlayer.source, '~r~/ban ID DUREE RAISON')
                        end
                    else
                        YveltHelper:serverNotification(xPlayer.source, '~r~/ban ID DUREE RAISON')
                    end
                else
                    YveltHelper:serverNotification(xPlayer.source, '~r~/ban ID DUREE RAISON')
                end
            end
        end
    end)
end)


RegisterCommand('banlist', function(source, args)
    if #bans2 == 0 then
        print('Aucun ban enregistré')
    else
        for k, v in pairs(bans2) do
            print('ID Ban : ^4'..v.id..'^0 banni pour ^2'..v.raison..'^0 le ^3'..v.date..'^0 par ^5'..v.auteur..'^0')
        end
    end
end)

RegisterCommand('unban', function(source, args)
    local _src = source 
    local xPlayer = YveltHelper:getPlayerFromId(_src)
    local id = tonumber(args[1])
    if _src == 0 then
        MySQL['Async']['execute']("DELETE FROM yvelt_bans WHERE id = @id", {['@id'] = id})
        print('^0[^2!^0] ^4sv_bans.lua^0 => La personne a été debanni => ^2ID Ban : '..id..'^0')
        Wait(3000)
        RefreshBanList()
    else
        if not getAcces(PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)], 'unban') then 
            MySQL['Async']['execute']("DELETE FROM yvelt_bans WHERE id = @id", {['@id'] = id})
            YveltHelper:serverNotification(xPlayer.source, '~g~La personne a été debanni !')
            Wait(3000)
            RefreshBanList()
            print('^0[^2!^0] ^4sv_bans.lua^0 => La personne a été debanni => ^2ID Ban : '..id..'^0')
        else
            YveltHelper:serverNotification(xPlayer.source, '~r~Tu n\'as pas la permission !')
        end
    end
end)


local prefix = '^0[^2Y^5v^4e^6l^1t^0]'
bans2 = {}
bans = {}


function RefreshBanList()
    bans = {}
    MySQL.Async.fetchAll('SELECT * FROM yvelt_bans', {}, function(results)
        for k, v in pairs(results) do
            bans[''..v.identifier..''] = {
              banned = true,
              id = v.id,
              date = v.date,
              raison = v.raison,
              auteur = YveltHelper:getTextFromAscii(v.auteur),
              duree = v.duree,
            }
            bans2[k] = {
                banned = true,
                id = v.id,
                date = v.date,
                raison = v.raison,
                auteur = YveltHelper:getTextFromAscii(v.auteur),
                duree = v.duree,
            }
        end
    end)
end

function estPseudoValide(pseudo)
    if string.len(pseudo) > 50 then
        return false
    else
        return true
    end
end

-- AddEventHandler('playerConnecting', function(name, skr, d)
--     local src = source
--     local passAuth = false
--     d.defer()
--     d.update("Bienvenue sur "..YveltConfig.ServerTitle.."\nFlashback: Vérification de votre pseudo...")
--     local valide = estPseudoValide(name)
--     Wait(1000)
--     if valide then
--         d.update("Bienvenue sur "..YveltConfig.ServerTitle.."\nFlashback: Vérification de vos sanctions en cours...")
--         if bans[''..YveltHelper:getIdentifier(src)..''] then
--             Wait(1000)
--             local v = bans[''..YveltHelper:getIdentifier(src)..'']
--             if os.time() > tonumber(v.duree) and tonumber(v.duree) ~= 0 then
--                 d.update("Bienvenue sur "..YveltConfig.ServerTitle.."\nFlashback: Vous avez fini votre temps de ban, bon jeu ! ✅")
--                 Wait(1000)
--                 MySQL['Async']['execute']("DELETE FROM yvelt_bans WHERE id = @id", {['@id'] = v.id})
--                 print('^0[^2!^0] ^4sv_bans.lua^0 => La personne a été debanni (fin du temps de ban) => ^2ID Ban : '..v.id..'^0')
--                 d.done()
--             else
--                 d.update('Vous avez été banni pour '..v.raison..' le '..v.date..' par '..v.auteur..'.\nFlashback: Il vous reste encore '..getBanTime(src)..' de bannisement\nFlashback: Votre ID Ban : '..v.id..'')
--                 -- displayScreen(name, skr, d, v, src)
--                 print('^0[^2!^0] ^2sv_bans.lua ^0=> Le joueur '..name..' tente de se connecter alors qu\'il est banni !')
--                 while true do
--                     Wait(1000)
--                     if getBanTime(src) then                        
--                         if os.time() > tonumber(v.duree) and tonumber(v.duree) ~= 0 then
--                             d.update("Bienvenue sur "..YveltConfig.ServerTitle.."\nFlashback: Vous avez fini votre temps de ban, bon jeu ! ✅")
--                             Wait(1000)
--                             MySQL['Async']['execute']("DELETE FROM yvelt_bans WHERE id = @id", {['@id'] = v.id})
--                             print('^0[^2!^0] ^4sv_bans.lua^0 => La personne a été debanni (fin du temps de ban) => ^2ID Ban : '..v.id..'^0')
--                             d.done()
--                         end
--                     else
--                         break
--                     end
--                 end
--             end
--         else
--             Wait(500)
--             d.update("Bienvenue sur "..YveltConfig.ServerTitle.."\nFlashback: Connexion en cours...")
--             Wait(500)
--             d.done()
--         end
--     else
--         displayScreen2(name, skr, sr, d)
--     end
-- end)

function getBanTime(id)
    if YveltHelper:getIdentifier(id) then 
        local v = bans[''..YveltHelper:getIdentifier(id)..'']
        if not v then
            return 'Inconnu'
        end
        if tonumber(v.duree) == 0 then
            return 'permanent (∞)'
        else
            local remainingTime = tonumber(v.duree) - os.time()
            
            local remainingDays = math.floor(remainingTime / (24 * 60 * 60))
            local remainingHours = math.floor((remainingTime % (24 * 60 * 60)) / (60 * 60))
            local remainingMinutes = math.floor((remainingTime % (60 * 60)) / 60)
            local remainingSeconds = remainingTime % 60

            local timeString = ''
            
            if remainingDays > 0 then
                timeString = timeString .. remainingDays .. ' jour(s) '
            
                if remainingHours > 0 then
                    timeString = timeString .. remainingHours .. ' heure(s) '
                end
            else
                if remainingHours > 0 then
                    timeString = timeString .. remainingHours .. ' heure(s) '

                    if remainingMinutes > 0 then
                        timeString = timeString .. remainingMinutes .. ' minute(s) '
                    end
                else
                    if remainingMinutes > 0 then
                        timeString = timeString .. remainingMinutes .. ' minute(s) '

                        if remainingSeconds > 0 then
                            timeString = timeString .. remainingSeconds .. ' seconde(s) '
                        end
                    else
                        if remainingSeconds > 0 then
                            timeString = timeString .. remainingSeconds .. ' seconde(s) '
                        end
                    end
                end
            end

            return timeString..'de ban'
        end
        return nil
    end
end



function displayScreen(name, skr, d, v, src)
    d.presentCard({
        type = "AdaptiveCard",
        ["$schema"] = "http://adaptivecards.io/schemas/adaptive-card.json",
        version = "1.5",
        body = { {
            type = "TextBlock",
            text = "Vous avez été banni de "..YveltConfig.ServerTitle.." !",
            wrap = true,
            color = 'WARNING',
            fontType = "Default",
            horizontalAlignment = "Center",
            size = "ExtraLarge"
        }, {
            type = "TextBlock",
            text = " ",
            wrap = true,
            size = "Large",
            isSubtle = false,
            weight = "Default",
            fontType = "Default",
            style = "default",
            horizontalAlignment = "Center"
        }, {
            type = "Image",
            url = YveltConfig.BanScreen.image,
        },{
            type = "TextBlock",
            text = " ",
            wrap = true,
            size = "Large",
            isSubtle = false,
            weight = "Default",
            fontType = "Default",
            style = "default",
            horizontalAlignment = "Center"
        },
        --  {
        --     type = "Image",
        --     url = "https://zupimages.net/up/22/50/ztwc.png"
        -- }, 
        {
            type = "TextBlock",
            text = 'Vous avez été banni pour la raison suivante : '..v.raison..' !\nBanni le '..v.date..' par '..v.auteur..'\nIl vous reste encore '..getBanTime(src)..'\n\nBan ID : '..v.id,
            wrap = true,
            size = "Large",
            isSubtle = false,
            weight = "Default",
            fontType = "Default",
            style = "default",
            horizontalAlignment = "Center"
        }, {
            type = "ActionSet",
            horizontalAlignment = "Center",
            spacing = "Medium",
            actions = { {
            type = "Action.OpenUrl",
            title = YveltConfig.BanScreen.bouton,
            url = YveltConfig.BanScreen.discord,
            } } }, {
            type = "TextBlock",
            text = text2,
            wrap = true,
            size = "Medium",
            spacing = "Large",
            separator = true,
            color = "Default",
            isSubtle = false,
            weight = "Default",
            fontType = "Default",
            style = "default",
            horizontalAlignment = "Center"
            }
        } 
    },
    function(data, rawData)

    end)
end


function displayScreen2(name, skr, src, d)
    d.presentCard({
        type = "AdaptiveCard",
        ["$schema"] = "http://adaptivecards.io/schemas/adaptive-card.json",
        version = "1.5",
        body = { {
            type = "TextBlock",
            text = "Des caractères spéciaux ont été détecté dans votre pseudo !",
            wrap = true,
            color = 'WARNING',
            fontType = "Default",
            horizontalAlignment = "Center",
            size = "ExtraLarge"
        }, {
            type = "TextBlock",
            text = " ",
            wrap = true,
            size = "Large",
            isSubtle = false,
            weight = "Default",
            fontType = "Default",
            style = "default",
            horizontalAlignment = "Center"
        }, {
            type = "Image",
            url = YveltConfig.BanScreen.image2,
        },{
            type = "TextBlock",
            text = "Des caractères invalide ont été détecté dans votre pseudo FiveM, rendez-vous dans vos réglages FiveM dans le menu principal avant de vous connecter au serveur, puis modifier le depuis les réglages qui se trouvent en haut a droite de votre écran. Votre pseudo peut seulement contenir des lettres et des chiffres.",
            wrap = true,
            size = "Large",
            isSubtle = false,
            weight = "Default",
            fontType = "Default",
            style = "default",
            horizontalAlignment = "Center"
        },
        {
            type = "TextBlock",
            text = '',
            wrap = true,
            size = "Large",
            isSubtle = false,
            weight = "Default",
            fontType = "Default",
            style = "default",
            horizontalAlignment = "Center"
        }, {
            type = "ActionSet",
            horizontalAlignment = "Center",
            spacing = "Medium",
            actions = { {
            type = "Action.OpenUrl",
            title = YveltConfig.BanScreen.bouton,
            url = YveltConfig.BanScreen.discord,
            } } }, {
            type = "TextBlock",
            text = text2,
            wrap = true,
            size = "Medium",
            spacing = "Large",
            separator = true,
            color = "Default",
            isSubtle = false,
            weight = "Default",
            fontType = "Default",
            style = "default",
            horizontalAlignment = "Center"
            }
        } 
    },
    function(data, rawData)

    end)
end

MySQL.ready(function()
    MySQL.Async.fetchAll('SELECT * FROM yvelt_bans', {}, function(results)
        print('^0[^2!^0] ^2sv_bans.lua ^0=> La base de données a enregistré ^3' .. #results .. ' ^0personnes bannis')
        for k, v in pairs(results) do
            bans[''..v.identifier..''] = {
              banned = true,
              id = v.id,
              date = v.date,
              raison = v.raison,
              auteur = YveltHelper:getTextFromAscii(v.auteur),
              duree = v.duree,
            }
            bans2[k] = {
                banned = true,
                id = v.id,
                date = v.date,
                raison = v.raison,
                auteur = YveltHelper:getTextFromAscii(v.auteur),
                duree = v.duree,
            }
        end
    end)
end)