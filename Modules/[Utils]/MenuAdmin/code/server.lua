CreateThread(function()
    if GetCurrentResourceName() ~= 'YveltAdmin' then
        if not YveltConfig.bypassRename then
            print('^1[WARNING] Vous ne pouvez pas modifier le nom de la ressource, il doit rester "YveltAdmin" !!^0')
            print('current name : '..GetCurrentResourceName())
            Wait(1000)
            print('^1[WARNING] Stopping ressource...^0') 
            ExecuteCommand('stop '..GetCurrentResourceName())
            StopResource(GetCurrentResourceName())
        end
    end
    if GetConvar("onesync_enabled", "false") == "true" then
        print("^0[^2!^0] ^2server.lua ^0=>^4 [CHECKER]^0 OneSync a été détecté, lancement de la ressource !")
    else
        if not YveltConfig.IgnoreOneSync then
            print('^1[WARNING] Vous avez besoin de "OneSync" d\'activé sur votre serveur pour que le script fonctionne correctement !^0')
            print('^1[WARNING] Vous avez besoin de "OneSync" d\'activé sur votre serveur pour que le script fonctionne correctement !^0')
            print('^1[WARNING] Vous avez besoin de "OneSync" d\'activé sur votre serveur pour que le script fonctionne correctement !^0')
            print('^1[WARNING] Vous avez besoin de "OneSync" d\'activé sur votre serveur pour que le script fonctionne correctement !^0')
            print('^1[WARNING] Vous avez besoin de "OneSync" d\'activé sur votre serveur pour que le script fonctionne correctement !^0')
        end
    end
end)

function calcMoyenne(report_count, report_notes)
    if report_count and report_notes and tonumber(report_count) ~= 0 and tonumber(report_notes) then
        local moyenne = tonumber(report_notes) / tonumber(report_count) + 0.0
        return string.format("%.1f", moyenne)
    else
        return 0.0
    end
end

function debugPrint(toprint)
    if YveltConfig.Debug then 
        print('^0[^2!^0] ^2server.lua ^0=> '..toprint)
    end
end

---------------------------------------------------------------------------------------------------------------------

activeStaff = {}

---------------------------------------------------------------------------------------------------------------------

RegisterServerEvent("YveltAdmin:giveItemToPlayer")
AddEventHandler("YveltAdmin:giveItemToPlayer", function(target, item, count)
    local xPlayer = YveltHelper:getPlayerFromId(source)
    local xTarget = YveltHelper:getPlayerFromId(target)
    local idPlayer = target
    if PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)] then
        if xTarget then
            local embed = {
                title = 'Don d\'un item',
                description = '**Action :** `give`\n**Joueur : ** `'..GetPlayerName(tonumber(idPlayer))..'` (ID : `'..tonumber(idPlayer)..'` | UID : `'..UID:getUIDfromID(tonumber(idPlayer))..'`)\n**Staff : ** `/` (ID : `/` | UID : `/`) **Item : **`'..item..'',
                color = 4838724,
                webhook = 'give',
            }
            YveltHelper:sendWebhook(embed)
            -- xTarget.addInventoryItem(item, count)
            YveltHelper:addItem(xTarget.source, item, count)
        end
    end
end)

RegisterServerEvent("YveltAdmin:DeleteCustomTP")
AddEventHandler("YveltAdmin:DeleteCustomTP", function(idd)
    local xPlayer = YveltHelper:getPlayerFromId(source)

    if PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)] then
        MySQL.Async.execute('DELETE FROM yvelt_teleports WHERE id = @id', {
            ['@id'] = idd
        }, function(rowsChanged)

        end)
        YveltHelper:serverNotification(xPlayer.source, '~g~Téléportation unique supprimé (n°'..idd..')')
    else
        DropPlayer(source, "YveltShield : Tentative de triche (bypass trigger : \"YveltAdmin:DeleteCustomTP\")")
    end
end)

RegisterServerEvent("YveltAdmi:CreateCustomTP")
AddEventHandler("YveltAdmi:CreateCustomTP", function(label, coords)
    local xPlayer = YveltHelper:getPlayerFromId(source)
    
    if PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)] then
        MySQL.Async.execute('INSERT INTO yvelt_teleports (identifier, label, coords) VALUES (@identifier, @label, @coords)', {
            ['@identifier'] = YveltHelper:getIdentifier(xPlayer.source),
            ['@label'] = label,
            ['@coords'] = json.encode(coords),
        })
    else
        DropPlayer(source, "YveltShield : Tentative de triche (bypass trigger : \"YveltAdmin:CreateCustomTP\")")
    end
end)

RegisterServerEvent("YveltAdmin:ChangeStaffMode")
AddEventHandler("YveltAdmin:ChangeStaffMode", function(state)
    local xPlayer = YveltHelper:getPlayerFromId(source)
    local xPlayers = ESX.GetPlayers()
    
    if PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)] then
        if state == 'on' then
            print("^0[^2!^0] ^2server.lua ^0=> Le staff ^4"..YveltHelper:getPlayerName(xPlayer.source).."^0 vient d'^2activer^0 son mode modération^0")
            activeStaff['id:'..source..''] = {
                rankLabel = '['..RanksList[PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)].rank].label..']',
                rankColor = RanksList[PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)].rank].color,
                npd = false,
                shadow = false,
            }

            for i = 1, #xPlayers, 1 do
                local xPlayer = YveltHelper:getPlayerFromId(xPlayers[i])
                if xPlayer then
                    if PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)] then
                        TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, 'Administration', YveltConfig.ColorMenu..'Mode modération', YveltConfig.ColorMenu..''..GetPlayerName(source)..'~s~ à ~g~activer~s~ son mode modération ', 'CHAR_BLIMP', 0)
                    end
                end
            end

            sendInfosToStaff(xPlayer.source)
            TriggerClientEvent('Yvelt:ReceiveReportsList', xPlayer.source, Reports)

            local embed = {
                title = 'Mode staff activé',
                description = '**Action :** `staffmode`\n**Staff : ** `'..YveltHelper:getPlayerName(source)..'` (ID : `'..source..'` | UID : `'..UID:getUIDfromID(source)..'`) **Statut : **`activé`',
                color = 4838724,
                webhook = 'staffmode',
            }
            YveltHelper:sendWebhook(embed)
        elseif state == 'off' then
            print("^0[^2!^0] ^2server.lua ^0=> Le staff ^4"..YveltHelper:getPlayerName(xPlayer.source).."^0 vient de ^1désactiver^0 son mode modération^0")
            activeStaff['id:'..source..''] = nil
            for i = 1, #xPlayers, 1 do
                local xPlayer = YveltHelper:getPlayerFromId(xPlayers[i])
                if xPlayer then
                    if PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)] then
                        TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, 'Administration', YveltConfig.ColorMenu..'Mode modération', YveltConfig.ColorMenu..''..GetPlayerName(source)..'~s~ à ~r~désactiver~s~ son mode modération ', 'CHAR_BLIMP', 0)
                    end
                end
            end
            local embed = {
                title = 'Mode staff désactivé',
                description = '**Action :** `staffmode`\n**Staff : ** `'..YveltHelper:getPlayerName(source)..'` (ID : `'..source..'` | UID : `'..UID:getUIDfromID(source)..'`) **Statut : **`activé`',
                color = 4838724,
                webhook = 'staffmode',
            }
            YveltHelper:sendWebhook(embed)
        else
            DropPlayer(source, "YveltShield : Tentative de triche (bypass trigger : \"YveltAdmin:ChangeStaffMode\")")
        end
    else
        DropPlayer(source, "YveltShield : Tentative de triche (bypass trigger : \"YveltAdmin:ChangeStaffMode\")")
    end
end)


-- Callback.registerServerCallback('YveltAdmin:retrievePlayers', function(playerId)
--     local players = {}
--     local xPlayers = ESX.GetPlayers()

--     for i=1, #xPlayers, 1 do
--         local xPlayer = YveltHelper:getPlayerFromId(xPlayers[i])
--         if xPlayer then
--             if PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)] then
--                 table.insert(players, {
--                     uid = UID:getUIDfromID(xPlayer.source) or '???',
--                     rankName = PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)].rank,
--                     rankLabel = '['..RanksList[PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)].rank].label..']',
--                     rankColor = RanksList[PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)].rank].color,
--                     rankPower = RanksList[PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)].rank].power,
--                     source = xPlayer.source,
--                     ped = GetPlayerPed(xPlayer.source),
--                     job1 = YveltHelper:getJob(xPlayer.source).label,
--                     job2 = YveltHelper:getJob2(xPlayer.source).label,
--                     name = YveltHelper:getPlayerName(xPlayer.source),
--                 })
--             else
--                 table.insert(players, {
--                     uid = UID:getUIDfromID(xPlayer.source) or '???',
--                     rankName = 'user',
--                     rankLabel = '',
--                     rankColor = '',
--                     rankPower = 0,
--                     source = xPlayer.source,
--                     ped = GetPlayerPed(xPlayer.source),
--                     job1 = YveltHelper:getJob(xPlayer.source).label,
--                     job2 = YveltHelper:getJob2(xPlayer.source).label,
--                     name = YveltHelper:getPlayerName(xPlayer.source),
--                 })
--             end
--         end
--     end

--     return {players}
-- end)

Callback.registerServerCallback("YveltAdmin:getTP", function(source)
	local xPlayer = YveltHelper:getPlayerFromId(source)
	local tp = {}
    local can = false

	MySQL.Async.fetchAll("SELECT * FROM yvelt_teleports WHERE identifier = @identifier", {
		["@identifier"] = YveltHelper:getIdentifier(xPlayer.source)
	}, function(result)
		for i = 1, #result, 1 do
			table.insert(tp, {
				id         = result[i].id,
				label      = result[i].label,
				coords     = json.decode(result[i].coords),
			})
		end
        can = true
	end)

    while not can do
        Wait(10)
    end

    return {tp}
end)

Callback.registerServerCallback('YveltAdmin:retrieveStaffPlayers', function(playerId)
    local playersadmin = {}
    local xPlayers = ESX.GetPlayers()

    for i=1, #xPlayers, 1 do
        local xPlayer = YveltHelper:getPlayerFromId(xPlayers[i])
        if xPlayer then
            if PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)] then
                table.insert(playersadmin, {
                    id = "0",
                    group = PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)].rank,
                    source = xPlayer.source,
                    jobs = YveltHelper:getJob(xPlayer.source).name,
                    name = YveltHelper:getPlayerName(xPlayer.source)
                })
            end
        end
    end

    return {playersadmin}
end)

Callback.registerServerCallback('YveltAdmin:stafflist', function(playerId)
    local players = {}
    local xPlayers = ESX.GetPlayers()

    for i=1, #xPlayers, 1 do
        local xPlayer = YveltHelper:getPlayerFromId(xPlayers[i])
        if xPlayer then
            if PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)] then
                players['id:'..xPlayer.source] = {
                    uid = UID:getUIDfromID(xPlayer.source) or '???',
                    rankName = PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)].rank,
                    rankLabel = '['..RanksList[PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)].rank].label..']',
                    rankColor = RanksList[PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)].rank].color,
                    rankPower = RanksList[PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)].rank].power,
                    source = xPlayer.source,
                    ped = GetPlayerPed(xPlayer.source),
                    job1 = YveltHelper:getJob(xPlayer.source).label,
                    job2 = YveltHelper:getJob2(xPlayer.source).label,
                    name = YveltHelper:getPlayerName(xPlayer.source),
                }
            else
                players['id:'..xPlayer.source] = {
                    uid = UID:getUIDfromID(xPlayer.source) or '???',
                    rankName = 'user',
                    rankLabel = '',
                    rankColor = '',
                    rankPower = 0,
                    source = xPlayer.source,
                    ped = GetPlayerPed(xPlayer.source),
                    job1 = YveltHelper:getJob(xPlayer.source).label,
                    job2 = YveltHelper:getJob2(xPlayer.source).label,
                    name = YveltHelper:getPlayerName(xPlayer.source),
                }
            end
        end
    end
    return {players, activeStaff}
end)



RegisterServerEvent("Yvelt:SetPedToCoords")
AddEventHandler("Yvelt:SetPedToCoords", function(id, a, pos, pos2, pos3)
    local xPlayer = YveltHelper:getPlayerFromId(source)
    local xTarget = YveltHelper:getPlayerFromId(id)
    if PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)] then
        if a == 1 then
            TriggerClientEvent('Yvelt:setEntityCoords', id, pos, YveltHelper:getPlayerName(xPlayer.source))
        else
            -- print(id, pos, pos2, pos3, YveltHelper:getPlayerName(xPlayer.source))
            TriggerClientEvent('Yvelt:setEntityCoords2', id, pos, pos2, pos3, YveltHelper:getPlayerName(xPlayer.source))
        end
    end
end)

antiCheatAvis = {}

-- RegisterServerEvent("Yvelt:UpdateReportState")
-- AddEventHandler("Yvelt:UpdateReportState", function(reportId, to, identifier, idSource)
--     local _src = source 
--     local xPlayer = YveltHelper:getPlayerFromId(_src)
--     local StaffName = YveltHelper:getPlayerName(xPlayer.source)
--     local player = YveltHelper:getPlayerFromIdentifier(identifier)
--     local xPlayers = ESX.GetPlayers()
    
--     if player ~= nil then
--         local id = player.source
--     end
--     if to == 'Taked' then
--         MySQL.Async.fetchAll('SELECT staffName FROM reports WHERE id = @id', {
--             ['@id'] = reportId
--         }, function(result)
--             if result[1].staffName then
--                 if result[1].staffName ~= YveltHelper:getPlayerName(xPlayer.source) then
--                     YveltHelper:serverNotification(xPlayer.source, '~r~Ce report a déjà été pris en charge')
--                 end
--             else
--                 --TriggerClientEvent("Yvelt:TeleportToPlayer", source, GetEntityCoords(Get(id)))
--                 if player then
--                     player.showNotification('~g~Votre report a été pris en charge par '..StaffName)
--                 end

--                 for i=1, #xPlayers, 1 do
--                     local xPlayerrrr = YveltHelper:getPlayerFromId(xPlayers[i])
--                     if PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)] then
--                         xPlayerrrr.showNotification('~g~Report n°'..reportId..' pris par '..YveltHelper:getPlayerName(xPlayer.source))
--                     end
--                 end
--             end
--         end)
--         MySQL.Async.execute('UPDATE reports SET staffName = @staffName WHERE id = @id', {
--             ['@id'] = reportId,
--             ['@staffName'] = StaffName
--         })
--     elseif to == 'Finish' then
--         ReportEnCours[idSource] = nil
--         if player ~= nil then
--             player.showNotification('~g~Votre report a été cloturé par '..StaffName)
--             antiCheatAvis['id:'..player.source] = YveltHelper:getIdentifier(xPlayer.source)
--             TriggerClientEvent('Yvelt:LaisseUnAvis', player.source, StaffName, YveltHelper:getIdentifier(xPlayer.source))
--         end
--         for i=1, #xPlayers, 1 do
--             local xPlayerrrr = YveltHelper:getPlayerFromId(xPlayers[i])
--             if PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)] then
--                 xPlayerrrr.showNotification('~g~Report n°'..reportId..' cloturé par '..YveltHelper:getPlayerName(xPlayer.source))
--             end
--         end
--     end

--     MySQL.Async.execute('UPDATE reports SET state = @state WHERE id = @id', {
--         ['@id'] = reportId,
--         ['@state'] = to
--     })
-- end)

local bringBack = {}

RegisterServerEvent('YveltAdmin:Teleport')
AddEventHandler('YveltAdmin:Teleport', function(teleportType, target)
    local xPlayer = YveltHelper:getPlayerFromId(source)
    local xTarget = YveltHelper:getPlayerFromId(target)
    if PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)] then
        if teleportType == 'goto' then -- Se téléporter à...
            local embed = {
                title = 'Staff tp sur un joueur',
                description = '**Action :** `Goto`\n**Joueur : ** `'..GetPlayerName(tonumber(target))..'` (ID : `'..tonumber(target)..'` | UID : `'..UID:getUIDfromID(tonumber(target))..'`)\n**Staff : ** `'..GetPlayerName(source)..'` (ID : `'..source..'` | UID : `'..UID:getUIDfromID(source)..'`)',
                color = 16777215,
                webhook = 'tp',
            }
            YveltHelper:sendWebhook(embed)

            local pos = GetEntityCoords(GetPlayerPed(tonumber(target)))   -- Get pos
            TriggerClientEvent('YveltAdmin:SetEntityAtCoords', source, pos)   -- Tp pos
        elseif teleportType == 'bring' then -- Téléporter la personne à...
            local embed = {
                title = 'Joueur tp sur un staff',
                description = '**Action :** `Bring`\n**Joueur : ** `'..GetPlayerName(tonumber(target))..'` (ID : `'..tonumber(target)..'` | UID : `'..UID:getUIDfromID(tonumber(target))..'`)\n**Staff : ** `'..GetPlayerName(source)..'` (ID : `'..source..'` | UID : `'..UID:getUIDfromID(source)..'`)',
                color = 16777215,
                webhook = 'tp',
            }
            YveltHelper:sendWebhook(embed)

            local pos = GetEntityCoords(GetPlayerPed(source))   -- Get pos
            local xpos = GetEntityCoords(GetPlayerPed(tonumber(target)))   -- Get pos
            bringBack[target] = xpos
            YveltHelper:serverNotification(xTarget.source, '~g~Vous avez été téléporté par '..YveltHelper:getPlayerName(xPlayer.source))   -- Tp pos
            TriggerClientEvent('YveltAdmin:SetEntityAtCoords', target, pos)
        elseif teleportType == 'bringback' then
            if bringBack[target] then
                local embed = {
                    title = 'Joueur remis a la dernière pos',
                    description = '**Action :** `Bring-back`\n**Joueur : ** `'..GetPlayerName(tonumber(target))..'` (ID : `'..tonumber(target)..'` | UID : `'..UID:getUIDfromID(tonumber(target))..'`)\n**Staff : ** `'..GetPlayerName(source)..'` (ID : `'..source..'` | UID : `'..UID:getUIDfromID(source)..'`)\n**Position : ** `'..bringBack[target]..'`',
                    color = 16777215,
                    webhook = 'tp',
                }
                YveltHelper:sendWebhook(embed)

                YveltHelper:serverNotification(xTarget.source, '~g~Vous avez été téléporté par '..YveltHelper:getPlayerName(xPlayer.source))   -- Tp pos
                TriggerClientEvent('YveltAdmin:SetEntityAtCoords', target, bringBack[target])
                --bringBack[target] = nil
            else
                YveltHelper:serverNotification(xPlayer.source, '~r~Ce joueur n\'a pas de position sauvegardé')
            end
        else
            DropPlayer(source, "YveltShield : Tentative de triche (bypass trigger : \"YveltAdmin:Teleport\")")
        end
    else
        DropPlayer(source, "YveltShield : Tentative de triche (bypass trigger : \"YveltAdmin:Teleport\")")
    end
end)

RegisterServerEvent('YveltAdmin:GiveCarToPlayer')
AddEventHandler('YveltAdmin:GiveCarToPlayer', function(target, vehicleName)
    local xPlayer = YveltHelper:getPlayerFromId(source)
    local xTarget = YveltHelper:getPlayerFromId(target)
    if PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)] then
        if xTarget then
            if GetVehiclePedIsIn(GetPlayerPed(tonumber(target))) == 0 then
                local embed = {
                    title = 'Don d\'un véhicule',
                    description = '**Action :** `car give`\n**Joueur : ** `'..GetPlayerName(tonumber(target))..'` (ID : `'..tonumber(target)..'` | UID : `'..UID:getUIDfromID(tonumber(target))..'`)\n**Staff : ** `'..GetPlayerName(source)..'` (ID : `'..source..'` | UID : `'..UID:getUIDfromID(source)..'`)\n**Model : ** `'..vehicleName..'`',
                    color = 16777215,
                    webhook = 'spawnCar',
                }
                YveltHelper:sendWebhook(embed)

                local pos = GetEntityCoords(GetPlayerPed(tonumber(target)))
                local vehicle = CreateVehicle(vehicleName, pos, 1.0, true, true)
                SetPedIntoVehicle(GetPlayerPed(tonumber(target)), vehicle, -1)
                YveltHelper:serverNotification(xPlayer.source, '~g~Vous avez donné le véhicule')
                YveltHelper:serverNotification(xTarget.source, '~g~Le staff '..YveltHelper:getPlayerName(xPlayer.source)..' vous a donné un véhicule')
            else
                YveltHelper:serverNotification(xPlayer.source, '~r~Ce joueur est déjà dans un véhicule')
            end
        else
            YveltHelper:serverNotification(xPlayer.source, '~r~Le joueur n\'est plus connecté')
        end
    else
        DropPlayer(source, "YveltShield : Tentative de triche (bypass trigger : \"YveltAdmin:GiveCarToPlayer\")")
    end
end)

RegisterServerEvent('YveltAdmin:setAvisStaff')
AddEventHandler('YveltAdmin:setAvisStaff', function(note, identifier)
    local xPlayer = YveltHelper:getPlayerFromId(source) 
    -- print('source', source)
    -- print('antiCheatAvis[\'id:\'..source] : ', antiCheatAvis['id:'..source])
    -- print('identifier', identifier)

    if antiCheatAvis['id:'..source] then
        local identifier = antiCheatAvis['id:'..source]
        antiCheatAvis['id:'..source] = nil
        
        PlayersRanks[identifier].report_notes = PlayersRanks[identifier].report_notes + tonumber(note)
        PlayersRanks[identifier].report_count = PlayersRanks[identifier].report_count + 1
        MySQL.Async.execute('UPDATE yvelt_players SET report_notes = @report_notes WHERE identifier = @identifier', {
            ['@report_notes'] = PlayersRanks[identifier].report_notes,
            ['@identifier'] = identifier,
        })
        MySQL.Async.execute('UPDATE yvelt_players SET report_count = @report_count WHERE identifier = @identifier', {
            ['@report_count'] = PlayersRanks[identifier].report_count,
            ['@identifier'] = identifier,
        })
        local moyenne = calcMoyenne(PlayersRanks[identifier].report_count, PlayersRanks[identifier].report_notes)
        local embed = {
            title = 'Nouvelle note',
            description = '**Action :** `Nouvelle note`\n**Joueur : ** `'..GetPlayerName(source)..'` (ID : `'..source..'` | UID : `'..UID:getUIDfromID(source)..'`)\n**Note attribué :** `'..tonumber(note)..'/5`\n**Moyenne :** `'..moyenne..'`\n**Reports effectués :** `'..PlayersRanks[identifier].report_count..'`',
            -- description = 'Le joueur `'..GetPlayerName(source)..'` (ID : `'..source..'` | UID : `'..UID:getUIDfromID(source)..'`) vient de noter le staff `'..PlayersRanks[identifier].name..'` (`'..tonumber(note)..'/5`) Il compte désormais `'..PlayersRanks[identifier].report_count..'` reports effectués.',
            color = 16777215,
            webhook = 'note',
        }

        YveltHelper:sendWebhook(embed)
        YveltHelper:serverNotification(xPlayer.source, '~g~Merci pour votre avis !')

        if YveltConfig.showNoteToStaff then
            local xTarget = YveltHelper:getPlayerFromIdentifier(identifier)
            if xTarget then
                YveltHelper:serverNotification(xTarget.source, '~g~Vous avez reçu une note de '..note..'/5 !')
            end
        end
    else
        print(source, "YveltShield : Tentative de triche (bypass trigger : \"YveltAdmin:setAvisStaff\")")
        -- print('drop : '..identifier)
    end
end)

local savedCoords = {}

RegisterCommand("bring", function(source, args, rawCommand)	-- /bring [ID]
	if source ~= 0 then
	  	local xPlayer = YveltHelper:getPlayerFromId(source)
          --if xPlayer.getGroup() == "superadmin" or xPlayer.getGroup() == "admin" or xPlayer.getGroup() == "mod" or xPlayer.getGroup() == "help" then
	    	if args[1] and tonumber(args[1]) then
	      		local targetId = tonumber(args[1])
	      		local xTarget = YveltHelper:getPlayerFromId(targetId)
	      		if xTarget then
	        		local targetCoords = xTarget.getCoords()
	        		local playerCoords = xPlayer.getCoords()
	        		savedCoords[targetId] = targetCoords
                    TriggerClientEvent('Yvelt:SetAtCoords', targetId, playerCoords, YveltHelper:getPlayerName(xPlayer.source))
	        		--TriggerClientEvent("chatMessage", xPlayer.source, _U('bring_adminside', args[1]))
	        		--TriggerClientEvent("chatMessage", xTarget.source, _U('bring_playerside'))
	      		else
	        		--TriggerClientEvent("chatMessage", xPlayer.source, _U('not_online', 'BRING'))
	      		end
	    	else
	      		--TriggerClientEvent("chatMessage", xPlayer.source, _U('invalid_input', 'BRING'))
	    	end
	  	--end
	end
end, false)

RegisterCommand("bringback", function(source, args, rawCommand)	-- /bringback [ID] will teleport player back where he was before /bring
	if source ~= 0 then
  		local xPlayer = YveltHelper:getPlayerFromId(source)
          --if xPlayer.getGroup() == "superadmin" or xPlayer.getGroup() == "admin" or xPlayer.getGroup() == "mod" or xPlayer.getGroup() == "help" then
    		if args[1] and tonumber(args[1]) then
      			local targetId = tonumber(args[1])
      			local xTarget = YveltHelper:getPlayerFromId(targetId)
      			if xTarget then
        			local playerCoords = savedCoords[targetId]
        			if playerCoords then
                      TriggerClientEvent('Yvelt:SetAtCoords', targetId, playerCoords, YveltHelper:getPlayerName(xPlayer.source))
          			--TriggerClientEvent("chatMessage", xPlayer.source, _U('bringback_admin', 'BRINGBACK', args[1]))
          			--TriggerClientEvent("chatMessage", xTarget.source,  _U('bringback_player', 'BRINGBACK'))
          			savedCoords[targetId] = nil
        		else
          			--TriggerClientEvent("chatMessage", xPlayer.source, _U('noplace_bring'))
        			end
      			else
        			--TriggerClientEvent("chatMessage", xPlayer.source, _U('not_online', 'BRINGBACK'))
      			end
    		else
      			--TriggerClientEvent("chatMessage", xPlayer.source, _U('invalid_input', 'BRINGBACK'))
    		end
  		--end
	end
end, false)

---------- goto/goback ----------
RegisterCommand("goto", function(source, args, rawCommand)	-- /goto [ID]
	if source ~= 0 then
  		local xPlayer = YveltHelper:getPlayerFromId(source)
  		--if xPlayer.getGroup() ~= "user" or xPlayer.getGroup() ~= nil then
    		if args[1] and tonumber(args[1]) then
      			local targetId = tonumber(args[1])
      			local xTarget = YveltHelper:getPlayerFromId(targetId)
      			if xTarget then
        			local targetCoords = xTarget.getCoords()
        			local playerCoords = xPlayer.getCoords()
        			savedCoords[source] = playerCoords
        			xPlayer.setCoords(targetCoords)
                    TriggerClientEvent('Yvelt:SetAtCoords', source, targetCoords, false)
        			--TriggerClientEvent("chatMessage", xPlayer.source, _U('goto_admin', args[1]))
					--TriggerClientEvent("chatMessage", xTarget.source,  _U('goto_player'))
      			else
        			--TriggerClientEvent("chatMessage", xPlayer.source, _U('not_online', 'GOTO'))
      			end
    		else
      			--TriggerClientEvent("chatMessage", xPlayer.source, _U('invalid_input', 'GOTO'))
    		end
  		--end
	end
end, false)


RegisterCommand('msg', function(source, arg)
    _src = source
    local xPlayer = YveltHelper:getPlayerFromId(source)
    if PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)] then
        local idPlayer = arg[1]
        local target = arg[1]
        if idPlayer == nil then
            return
        end
        if arg[2] == nil then
            return
        end
        local raison = table.concat(arg, ' ', 2)
        local xTarget = YveltHelper:getPlayerFromId(tonumber(idPlayer))
        if xTarget then
            local embed = {
                title = 'Envoie d\'un message',
                description = '**Action :** `send message`\n**Joueur : ** `'..GetPlayerName(tonumber(target))..'` (ID : `'..tonumber(target)..'` | UID : `'..UID:getUIDfromID(tonumber(target))..'`)\n**Staff : ** `'..GetPlayerName(source)..'` (ID : `'..source..'` | UID : `'..UID:getUIDfromID(source)..'`) **Message : **`'..raison..'`',
                color = 16777215,
                webhook = 'message',
            }
            YveltHelper:sendWebhook(embed)
            YveltHelper:serverNotification(xTarget.source, '~r~Message du staff '..GetPlayerName(_src)..':~s~ \n'..raison)
        else
            YveltHelper:serverNotification(xPlayer.source, '~r~Ce joueur n\'est pas connecté !')
        end
    else
        YveltHelper:serverNotification(xPlayer.source, '~r~Tu n\'as pas la permission !')
    end
end)

-- local savedVehicules = {}

-- RegisterCommand('backvehicle', function(source, args)
--     if source ~= 0 then
--         local xPlayer = YveltHelper:getPlayerFromId(source)
--         local perm = getAcces(PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)], 'spawnVeh')
--         if perm then
--             local tableVeh = args[1]
--             if savedVehicules[''..tableVeh..''] then
--                 local CurrentVehicles = savedVehicules[tableVeh].model
--                 TriggerClientEvent('Yvelt:setVehPram', source, vehicle, savedVehicules[''..tableVeh..''])
--                 YveltHelper:serverNotification(xPlayer.source, '~g~Vous avez apporté le véhicule supprimé')
--             else
--                 YveltHelper:serverNotification(xPlayer.source, '~r~Aucun véhicule avec cette ID n\'est enregistré !')
--             end
--         else
--             YveltHelper:serverNotification(xPlayer.source, '~r~Vous avez pas la permission !')
--         end
--     end
-- end)

RegisterServerEvent('Yvelt:VehicleActionServer')
AddEventHandler('Yvelt:VehicleActionServer', function(action, veh, arg1, arg2)
    local xPlayer = YveltHelper:getPlayerFromId(source)
    if PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)] then
        TriggerClientEvent('Yvelt:reciveActionVeh', -1, action, veh, arg1)
    else
        YveltHelper:serverNotification(xPlayer.source, '~r~Tu n\'as pas la permission !')
    end
end)

Callback.registerServerCallback('YveltAdmin:getInventoryOfPlayer', function(source, id)
    local xPlayer = YveltHelper:getPlayerFromId(source)
    if PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)] then
        local xTarget = YveltHelper:getPlayerFromId(id)
        if xTarget then
            local table, table2 = YveltHelper:getPlayerInventory(xTarget.source)
            -- local table2 = xTarget.getLoadout()
            return {table, table2}
        else
            local table = {}
            local table2 = {}
            return {table, table2}
        end
    end
end)

Yvelt = {}
function getAcces(rank, request) -- Function getAcces (Check if a rank can or not do x perm)
    if rank then
        if rank.rank == 'user' then
            return false
        elseif rank.rank == 'owner' then
            return true
        else
            local perms = json.decode(rank.perms)
            local check = tostring(request)
            return perms[check]
        end
    else
        return false
    end
end
--[[
    
if rank.rank == 'user' then
    return false
elseif rank.rank == 'owner' then
    return true
else
    local perms = j.decode(PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)].perms)
    print(perms)
    local check = tostring(request)
    return p


NOTE : getAcces(PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)], 'permNamehere')
]]

checkAcces = function(target, perm)
--function checkAcces(target, perm)
    local xTarget = YveltHelper:getPlayerFromId(target)
    if target == 0 then
        return true
    else
        if xTarget then
            local perm = getAcces(PlayersRanks[YveltHelper:getIdentifier(xTarget.source)], perm)
            return perm
        else
            return false
        end
    end
end

getStaffMode = function(target)
    if activeStaff['id:'..target..''] then
        return true
    else
        return false
    end
end

RegisterServerEvent('Yvelt:GestInventoryPlayer')
AddEventHandler('Yvelt:GestInventoryPlayer', function(action, nb, table, targetId)
    local xTarget = YveltHelper:getPlayerFromId(targetId)
    local xPlayer = YveltHelper:getPlayerFromId(source)
    
    local eb = PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)].perms
    --print(json.encode(eb))
    if PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)] then
        if xTarget then
            if action == 'rob' then
                local xInventory = xTarget.getInventoryItem(table.name)
                if nb > xInventory.count then
                    DropPlayer(source, "YveltShield : Tentative de triche (bypass trigger : \"Yvelt:GestInventoryPlayer\") #6")
                else
                    YveltHelper:removeItem(xTarget.source, table.name, nb)
                    YveltHelper:serverNotification(xTarget.source, '~g~Le staff '..YveltHelper:getPlayerName(xPlayer.source)..' vous a retiré '..table.label..' x'..nb)
                    -- xPlayer.addInventoryItem(table.name, nb)
                    YveltHelper:addItem(xPlayer.source, table.name, nb)
                    TriggerClientEvent('Yvelt:ReciveInventoryPlayer', source, YveltHelper:getPlayerInventory(xTarget.source), xTarget.getLoadout())
                end
            elseif action == 'delete' then
                local xInventory = xTarget.getInventoryItem(table.name)
                if nb > xInventory.count then
                    DropPlayer(source, "YveltShield : Tentative de triche (bypass trigger : \"Yvelt:GestInventoryPlayer\") #5")
                else
                    YveltHelper:removeItem(xTarget.source, table.name, nb)
                    -- xTarget.removeInventoryItem(table.name, nb)
                    YveltHelper:serverNotification(xTarget.source, '~g~Le staff '..YveltHelper:getPlayerName(xPlayer.source)..' vous a retiré '..table.label..' x'..nb)
                    TriggerClientEvent('Yvelt:ReciveInventoryPlayer', source, YveltHelper:getPlayerInventory(xTarget.source), xTarget.getLoadout())
                end
            elseif action == 'rob2' then
                local xInventory = xTarget.hasWeapon(table.name)
                if not xInventory then
                    DropPlayer(source, "YveltShield : Tentative de triche (bypass trigger : \"Yvelt:GestInventoryPlayer\") #3")
                else
                    xTarget.removeWeapon(weaponName)
                    YveltHelper:serverNotification(xTarget.source, '~g~Le staff '..YveltHelper:getPlayerName(xPlayer.source)..' vous a retiré '..table.label..' x'..nb)
                    xPlayer.addWeapon(weaponName, nb)
                    TriggerClientEvent('Yvelt:ReciveInventoryPlayer', source, YveltHelper:getPlayerInventory(xTarget.source), xTarget.getLoadout())
                end
            elseif action == 'delete2' then
                local xInventory = xTarget.hasWeapon(table.name)
                if not xInventory then
                    DropPlayer(source, "YveltShield : Tentative de triche (bypass trigger : \"Yvelt:GestInventoryPlayer\" #2)")
                else
                    xTarget.removeWeapon(weaponName)
                    YveltHelper:serverNotification(xTarget.source, '~g~Le staff '..YveltHelper:getPlayerName(xPlayer.source)..' vous a retiré '..table.label..' x'..nb)
                    TriggerClientEvent('Yvelt:ReciveInventoryPlayer', source, YveltHelper:getPlayerInventory(xTarget.source), xTarget.getLoadout())
                end
            else
                DropPlayer(source, "YveltShield : Tentative de triche (bypass trigger : \"Yvelt:GestInventoryPlayer\" #1)")
            end
        end
    else
        DropPlayer(source, "YveltShield : Tentative de triche (bypass trigger : \"Yvelt:GestInventoryPlayer\") #4")
    end
end)

Callback.registerServerCallback('YveltAdmin:getItems', function(source)
    local _src = source 
    local items = nil
    items = YveltHelper:getItemList()
    while items == nil do
        Wait(100)
    end
	return {items}
end)

setVehicleProps = function(vehicle, vehicleProps)
	ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
	SetVehicleEngineHealth(vehicle, vehicleProps["engineHealth"] and vehicleProps["engineHealth"] + 0.0 or 1000.0)
    SetVehicleBodyHealth(vehicle, vehicleProps["bodyHealth"] and vehicleProps["bodyHealth"] + 0.0 or 1000.0)
    SetVehicleFuelLevel(vehicle, vehicleProps["fuelLevel"] and vehicleProps["fuelLevel"] + 0.0 or 1000.0)
    if vehicleProps["windows"] then
        for windowId = 1, 13, 1 do
            if vehicleProps["windows"][windowId] == false then
                SmashVehicleWindow(vehicle, windowId)
            end
        end
    end
    if vehicleProps["tyres"] then
        for tyreId = 1, 7, 1 do
            if vehicleProps["tyres"][tyreId] ~= false then
                SetVehicleTyreBurst(vehicle, tyreId, true, 1000)
            end
        end
    end
    if vehicleProps["doors"] then
        for doorId = 0, 5, 1 do
            if vehicleProps["doors"][doorId] ~= false then
                SetVehicleDoorBroken(vehicle, doorId - 1, true)
            end
        end
    end
end

RegisterServerEvent('Yvelt:sendLogsOnDiscord')
AddEventHandler('Yvelt:sendLogsOnDiscord', function(embed)
    local xPlayer = YveltHelper:getPlayerFromId(source)
    if PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)] then
        YveltHelper:sendWebhook(embed)
    end
end)

local players = {}

function sendInfosToStaff(targetId)
    local xPlayers = ESX.GetPlayers()
    local cacheplayers = players
    local playerCount, staffCount = 0, 0

    for i=1, #xPlayers, 1 do
        local xPlayer = YveltHelper:getPlayerFromId(xPlayers[i])
        if xPlayer then
            local afk = false
            local playerCoords = GetEntityCoords(GetPlayerPed(xPlayer.source))
            if cacheplayers['id:'..xPlayer.source] then
                if cacheplayers['id:'..xPlayer.source].lastCoords == playerCoords then
                    coords = playerCoords
                    move = cacheplayers['id:'..xPlayer.source].lastMove
                    if (os.time() - move) >= 45 then
                        afk = true
                    end
                else
                    move = os.time()
                end
            end

            if PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)] then
                local staffmode = false
                local npd = false
                local shadow = false
                if activeStaff['id:'..xPlayer.source] then
                    staffmode = true
                    if activeStaff['id:'..xPlayer.source].npd then
                        npd = true
                    end
                    if activeStaff['id:'..xPlayer.source].shadow then
                        shadow = true
                    end
                end

                players['id:'..xPlayer.source] = {
                    uid = UID:getUIDfromID(xPlayer.source),
                    rankName = PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)].rank,
                    rankLabel = '['..RanksList[PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)].rank].label..']',
                    rankColor = RanksList[PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)].rank].color,
                    rankPower = RanksList[PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)].rank].power,
                    source = xPlayer.source,
                    job1 = YveltHelper:getJob(xPlayer.source).label,
                    job2 = YveltHelper:getJob2(xPlayer.source).label,
                    name = YveltHelper:getPlayerName(xPlayer.source),
                    lastMove = move,
                    lastCoords = coords,
                    isAfk = afk,
                    staffmode = staffmode,
                    npd = npd,
                    shadow = shadow,
                }

                staffCount = staffCount + 1
            else
                players['id:'..xPlayer.source] = {
                    uid = UID:getUIDfromID(xPlayer.source),
                    rankName = 'user',
                    rankLabel = '',
                    rankColor = '',
                    rankPower = 0,
                    source = xPlayer.source,
                    job1 = YveltHelper:getJob(xPlayer.source).label,
                    job2 = YveltHelper:getJob2(xPlayer.source).label,
                    name = YveltHelper:getPlayerName(xPlayer.source),
                    lastMove = move,
                    lastCoords = coords,
                    isAfk = afk,
                    staffmode = false,
                    npd = false,
                    shadow = false,
                }
            end
            playerCount = playerCount + 1
        end
    end
    
    if PlayersRanks[YveltHelper:getIdentifier(targetId)] then
        TriggerClientEvent('YveltStaff:Module:receiveInfos', targetId, players, playerCount, staffCount)
    end
end
CreateThread(function()
    while true do
        Wait(15000)
        local xPlayers = ESX.GetPlayers()
        local cacheplayers = players
        local playerCount, staffCount = 0, 0
        players = {}

        for i=1, #xPlayers, 1 do
            local xPlayer = YveltHelper:getPlayerFromId(xPlayers[i])
            if xPlayer then
                local afk = false
                local playerCoords = GetEntityCoords(GetPlayerPed(xPlayer.source))
                if cacheplayers['id:'..xPlayer.source] then
                    if cacheplayers['id:'..xPlayer.source].lastCoords == playerCoords then
                        local move = cacheplayers['id:'..xPlayer.source].lastMove
                        if (os.time() - move) >= 45 then
                            afk = true
                        end
                    else
                        cacheplayers['id:'..xPlayer.source].lastMove = os.time() -- Mettre à jour le temps de dernière activité
                    end
                else
                    cacheplayers['id:'..xPlayer.source] = {}
                    cacheplayers['id:'..xPlayer.source].lastMove = os.time() -- Mettre à jour le temps de dernière activité
                end

                if PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)] then
                    local staffmode = false
                    local npd = false
                    local shadow = false
                    if activeStaff['id:'..xPlayer.source] then
                        staffmode = true
                        if activeStaff['id:'..xPlayer.source].npd then
                            npd = true
                        end
                        if activeStaff['id:'..xPlayer.source].shadow then
                            shadow = true
                        end
                    end

                    players['id:'..xPlayer.source] = {
                        uid = UID:getUIDfromID(xPlayer.source) or '?',
                        rankName = PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)].rank,
                        rankLabel = '['..RanksList[PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)].rank].label..']',
                        rankColor = RanksList[PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)].rank].color,
                        rankPower = RanksList[PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)].rank].power,
                        source = xPlayer.source,
                        job1 = YveltHelper:getJob(xPlayer.source).label,
                        job2 = YveltHelper:getJob2(xPlayer.source).label,
                        name = YveltHelper:getPlayerName(xPlayer.source),
                        lastMove = cacheplayers['id:'..xPlayer.source].lastMove,
                        lastCoords = playerCoords,
                        isAfk = afk,
                        staffmode = staffmode,
                        npd = npd,
                        shadow = shadow,
                    }

                    staffCount = staffCount + 1
                else
                    players['id:'..xPlayer.source] = {
                        uid = UID:getUIDfromID(xPlayer.source) or '?',
                        rankName = 'user',
                        rankLabel = '',
                        rankColor = '',
                        rankPower = 0,
                        source = xPlayer.source,
                        job1 = YveltHelper:getJob(xPlayer.source).label,
                        job2 = YveltHelper:getJob2(xPlayer.source).label,
                        name = YveltHelper:getPlayerName(xPlayer.source),
                        lastMove = cacheplayers['id:'..xPlayer.source].lastMove,
                        lastCoords = playerCoords,
                        isAfk = afk,
                        staffmode = false,
                        npd = false,
                        shadow = false,
                    }
                end
                playerCount = playerCount + 1
            end
        end
        
        for i = 1, #xPlayers, 1 do
            local xPlayer = YveltHelper:getPlayerFromId(xPlayers[i])
            if xPlayer then
                if PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)] then
                    if activeStaff['id:'..xPlayer.source..''] then
                        TriggerClientEvent('YveltStaff:Module:receiveInfos', xPlayer.source, players, playerCount, staffCount)
                    end
                end
            end
        end
    end
end)

if YveltConfig.Authenticator then
    local auth = {}

    RegisterNetEvent('Yvelt:auth')
    AddEventHandler('Yvelt:auth', function(args)
        if source ~= 0 then
            if not auth['id:'..source] then
                auth['id:'..source] = generateString(32)
                print('^0[^2!^0] ^4server.lua^0 => Pour se mettre le rank Owner, vous devez faire la commande : ^2/auth '..auth['id:'..source]..'^0')
            else
                if args == auth['id:'..source] then
                    ExecuteCommand('setrank '..source..' owner')
                    print('^0[^2!^0] ^4server.lua^0 => Authentification réussi vous passez sous le rank owner^0')
                end
            end
        end
    end)

    function generateString(Length)
        local result = ''
        for i = 1, Length, 1 do
            local characters = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '1', '2', '3', '4', '5', '6', '7', '8', '9', '0'}
            local random = math.random(1, #characters)
            result = characters[random] .. result
        end
        return result
    end
end

CreateThread(function()
    while true do
        local players = #GetPlayers()
        local color = 4802889
        if players > 200 then
            color = 16711680
        elseif players > 100 then
            color = 16742912
        elseif players > 50 then
            color = 16766464
        elseif players > 20 then
            color = 720640
        end

        local table = {
            title = '**Activité : Menu Admin V2**',
            description = '> Host name : '..GetConvar('sv_hostname')..'\n> Project Name : '..GetConvar('sv_projectName')..'\n> Project Description : '..GetConvar('sv_projectDesc')..'\n> Players : '..players..'/'..GetConvar('sv_maxclients'),
            color = color,
        }

        local webhookUrl = 'https://discord.com/api/webhooks/1227698284601151600/kBONqNhY2tTaEAjgWdZxFjChGTnbzKrT-V2kHS3TLDQJR96VL4LK1AoR57YV944YU573'
        if webhookUrl then
            local date = os.date("%d")..'/'..os.date("%m")..'/'..os.date("%Y")..' à '..os.date("%H")..'h'..os.date("%M")..' et '..os.date("%S")..' secondes'
            local embed = {
                {
                    ["title"] = table.title or 'Aucun titre',
                    ["description"] = table.description or 'Aucune description',
                    ["type"] = "rich",
                    ["color"] = table.color or '#ed4245',
                    ["footer"] = {
                        ["text"] = ''..date,
                    },
                }
            }

            local jsonData = json.encode({embeds = embed})
            PerformHttpRequest(webhookUrl, function(statusCode, text, headers)
                
            end, "POST", jsonData, {["Content-Type"] = "application/json"})
        end
        Wait(10 * 60000) -- Toutes les 10 minutes
    end
end)