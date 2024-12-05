YveltHelper = {} --- Ne pas toucher, don't touch
YveltHelper.staffsInfos = {} --- Ne pas toucher, don't touch
YveltHelper.staffsActive = {} --- Ne pas toucher, don't touch

--- Modifier les couleurs utilisé par les gamertags (Affichage des pseudos)
--- Documentation : https://docs.fivem.net/docs/game-references/hud-colors/
YveltHelper.colorsNames = {
    ["red"] = 6,
    ["orange"] = 148,
    ["yellow"] = 147,
    ["green"] = 18,
    ["blue"] = 26,
    ["purple"] = 49,
    ["gray"] = 62,
    ["white"] = 59,
    ["black"] = 63,
}

--- Permet de faire une action client lorsque le mode modération devient activé
function YveltHelper:onStaffModeON()
    TriggerEvent('Yvelt:onStaffMode', true, playerGroup)
    if YveltConfig.staffActive.setPed then
        local model = YveltConfig.staffActive.ped
        if IsModelInCdimage(model) and IsModelValid(model) then
            RequestModel(model)
            while not HasModelLoaded(model) do
                Wait(0)
            end
            SetPlayerModel(PlayerId(), model)
            SetModelAsNoLongerNeeded(model)
        end
    end
    if YveltConfig.staffActive.showInfos then
        adminHud = true
        boolHudInfos()
    end
    if YveltConfig.staffActive.showGamertags then
        adminPseudo = true
        YveltHelper:displayNames(true)
    end
    if YveltConfig.staffActive.showBlips then
        adminShowBlipsPlayers = true
        adminBlips()
    end
    if YveltConfig.staffActive.staffSkin then
        applySkin(playerGroup)
    end
    if YveltConfig.UseStaffGun then
        delGunStaffActive = true
        local Player = PlayerPedId()
        GiveWeaponToPed(Player, YveltConfig.StaffGunName, 255, false, true)
        GiveWeaponComponentToPed(Player, YveltConfig.StaffGunName, "COMPONENT_SNSPISTOL_MK2_CAMO_IND_01_SLIDE")
        GiveWeaponComponentToPed(Player, YveltConfig.StaffGunName, "COMPONENT_AT_PI_SUPP_02")
        GiveWeaponComponentToPed(Player, YveltConfig.StaffGunName, "COMPONENT_SNSPISTOL_MK2_CLIP_02")
        GiveWeaponComponentToPed(Player, YveltConfig.StaffGunName, "COMPONENT_AT_PI_RAIL_02")
        GiveWeaponComponentToPed(Player, YveltConfig.StaffGunName, "COMPONENT_AT_PI_FLSH_03")
        SetPedInfiniteAmmo(Player, true, YveltConfig.StaffGunName)
        boolStaffGun()
    end
end

--- Permet de faire une action client lorsque le mode modération devient désactivé
function YveltHelper:onStaffModeOFF()
    TriggerEvent('Yvelt:onStaffMode', false, playerGroup)
    if YveltConfig.staffActive.setPed then
        Callback.triggerServerCallback('esx_skin:getPlayerSkin', function(skin)
            local isMale = skin.sex == 0
            Callback.triggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                TriggerEvent('skinchanger:loadSkin', skin)
            end)
        end) 
    end
    if YveltConfig.UseStaffGun then
        delGunStaffActive = false
        local Player = PlayerPedId()
        SetPedInfiniteAmmo(Player, false, YveltConfig.StaffGunName)
        RemoveWeaponFromPed(Player, YveltConfig.StaffGunName)
    end
    if YveltConfig.staffActive.staffSkin then
        resetSkin()
    end
end

--- Permet de revive une personne (client)
---@param a number ID Temporaire d'un joueur
function YveltHelper:revivePlayer(targetId, playerName)
    if YveltHelper:getAcces(player, 'revive') then
        ExecuteCommand('revive '..targetId)
        local embed = {
            title = 'Revive',
            description = '**Action :** `Revive`\n**Joueur : ** `'..playerName..'` (ID : `'..targetId..'` | UID : `'..UID:getUIDfromID(targetId)..'`)\n**Staff : ** `'..GetPlayerName(PlayerId())..'` (ID : `'..GetPlayerServerId(PlayerId())..'` | UID : `'..UID:getUIDfromID(GetPlayerServerId(PlayerId()))..'`)',
            color = 16777215,
            webhook = 'actions',
        }
        TriggerServerEvent('Yvelt:sendLogsOnDiscord', embed)
    else
        YveltHelper:clientNotification('~r~Vous n\'avez pas la permission')
    end
end

--- Permet de heal une personne (client)
---@param a number ID Temporaire d'un joueur
function YveltHelper:healPlayer(targetId, playerName)
    if YveltHelper:getAcces(player, 'heal') then
        ExecuteCommand('heal '..targetId)
        local embed = {
            title = 'Heal',
            description = '**Action :** `Heal`\n**Joueur : ** `'..playerName..'` (ID : `'..targetId..'` | UID : `'..UID:getUIDfromID(targetId)..'`)\n**Staff : ** `'..GetPlayerName(PlayerId())..'` (ID : `'..GetPlayerServerId(PlayerId())..'` | UID : `'..UID:getUIDfromID(GetPlayerServerId(PlayerId()))..'`)',
            color = 16777215,
            webhook = 'actions',
        }
        TriggerServerEvent('Yvelt:sendLogsOnDiscord', embed)
    else
        YveltHelper:clientNotification('~r~Vous n\'avez pas la permission')
    end
end

--- Permet de créer un véhicule (client)
function YveltHelper:spawnVehicle(modelName)
    if not IsModelInCdimage(modelName) then
        YveltHelper:clientNotification('~r~Ce véhicule n\'existe pas !')
    else
        local pos = GetEntityCoords(PlayerPedId())
        local heading = GetEntityHeading(PlayerPedId())
        local vehicle = nil
        RequestModel(modelName)
        while not HasModelLoaded(modelName) do
            --- Chargement du véhicule
            Wait(10)
        end 
        local vehicle = CreateVehicle(modelName, pos, heading, true, true)
        SetPedIntoVehicle(PlayerPedId(), vehicle, -1)
    end
end

--- Permet d'avoir l'identifiant rockstar d'un joueur
---@param a number ID Temporaire d'un joueur
---@return string License du joueur avec l'ID indiqué en @param a 
function YveltHelper:getIdentifier(targetId)
    for k,v in ipairs(GetPlayerIdentifiers(targetId)) do
        if string.match(v, 'license:') then
            return v
        end
    end
    return nil
end

--- Permet d'afficher une notitication a un joueur (client)
---@param a string Texte affiché lors de la notification
function YveltHelper:clientNotification(text)
    ESX.ShowNotification(text)
end

--- Permet d'afficher une notitication a un joueur (server)
---@param a string Texte affiché lors de la notification
function YveltHelper:serverNotification(targetId, text)
    if targetId and targetId ~= 0 then
        local xPlayer = YveltHelper:getPlayerFromId(targetId)
        if xPlayer then
            TriggerClientEvent('esx:showNotification', xPlayer.source, text)
        end
    end
end

--- Permet de get le joueur grâce a ESX avec son ID Temporaire
---@param a number ID Temporaire d'un joueur
function YveltHelper:getPlayerFromId(targetId)
    local GetPlayerFromId = ESX.GetPlayerFromId(targetId)
    return GetPlayerFromId
end

--- Permet de get le joueur grâce a ESX avec sa license rockstar (=> YveltHelper.getIdentifier)
---@param a number ID Temporaire d'un joueur
function YveltHelper:getPlayerFromIdentifier(targetId)
    local GetPlayerFromIdentifier = ESX.GetPlayerFromIdentifier(targetId)
    return GetPlayerFromIdentifier
end

--- Permet de refresh les ID uniques coté client
function YveltHelper:getUniqueId()
    while true do
        Wait(0)
        if NetworkIsPlayerActive(PlayerId()) then
            TriggerServerEvent('YveltAdmin:GetInfoUniqueId')
            break
        end
    end
end

--- Permet d'obtenir le pseudo d'un joueur
---@param a number ID Temporaire d'un joueur
function YveltHelper:getPlayerName(targetId)
    if targetId == 0 then
        return 'Console'
    else
        return GetPlayerName(targetId) or 'Inconnue'
    end
end

--- Permet d'avoir la liste des items (requires : name, label)
function YveltHelper:getItemList()
    local items = nil
    MySQL.Async.fetchAll('SELECT * FROM items', {}, function(results)
		items = results
    end)
    while not items do
        Wait(1)
    end
    return items
end

--- Permet d'avoir le power de X rank
exports('checkPerms', checkPerms)
checkPerms = function(perm)
    return YveltHelper:getAcces(player, perm)
end

--- Permet de savoir si X rank a accès ou non a X perm
exports('checkPower', checkPower)
checkPower = function(perm)
    return YveltHelper:getPower(player)
end

--- Permet de savoir si le joueur a le mode staff d'activé ou non (Client)
getStaffMode = function()
    return YveltStaffMode
end

--- Permet d'avoir le power de X rank
---@param a table Rank du joueur
function YveltHelper:getPower(rank)
    if rank.power == 'user' then
        return 0
    elseif rank.power == 'owner' then
        return 100
    else
        local power = rank.power
        if power then
            return power
        else
            Callback.triggerServerCallback('YveltAdmin:getRank', function(group)
                playerGroup = group
                player = playerGroup
            end)
            while playerGroup == nil do
                Wait(1)
            end
            rank = player
            if rank.power == 'user' then
                return 0
            elseif rank.power == 'owner' then
                return 100
            else
                local power = rank.power
                if power then
                    return power
                end
            end
        end
    end
end

--- Permet de savoir si X rank a accès ou non a X perm
---@param a table Rank du joueur
---@param b string La permission a check
function YveltHelper:getAcces(rank, request)
    if rank.rank == 'user' then
        return false
    elseif rank.rank == 'owner' then
        return true
    else
        local perms = j.decode(rank.perms)
        local check = tostring(request)
        if perms then
            return perms[check]
        else
            Callback.triggerServerCallback('YveltAdmin:getRank', function(group)
                playerGroup = group
                player = playerGroup
            end)
            while playerGroup == nil do
                Wait(1)
            end
            rank = player
            if rank.rank == 'user' then
                return false
            elseif rank.rank == 'owner' then
                return true
            else
                local perms = j.decode(rank.perms)
                local check = tostring(request)
                if perms[check] then
                    return perms[check]
                end
            end
        end
    end
end

--- Permet d'affciher les pseudos et informations des joueurs
---@param a boolean Activer la boucle
function YveltHelper:displayNames(bool)
    isNameShown = bool
    _cacheGamertags = {}
    if isNameShown then
        CreateThread(function()
            while isNameShown do
                local playerPos = GetEntityCoords(PlayerPedId())
                local _players = GetActivePlayers()
                for _, player in pairs(_players) do
                    local ped = GetPlayerPed(player)
                    -- if ped ~= PlayerPedId() then
                        if #(playerPos - GetEntityCoords(ped)) < 100.0 then
                            local playerRank = ''
                            local shadowMode = false
                            if PlayersList['id:'..GetPlayerServerId(player)] then
                                shadowMode = PlayersList['id:'..GetPlayerServerId(player)].shadow
                                if PlayersList['id:'..GetPlayerServerId(player)].rankLabel then
                                    playerRank = PlayersList['id:'..GetPlayerServerId(player)].rankLabel
                                end
                            end
                            
                            if not shadowMode then

                                if PlayersList['id:'..GetPlayerServerId(player)] then
                                    local name = ('%s - %s | %s'):format(PlayersList['id:'..GetPlayerServerId(player)].uid or '?', GetPlayerServerId(player) or '?', PlayersList['id:'..GetPlayerServerId(player)].name or GetPlayerName(player) or 'Chargement...')
                                    if name ~= _cacheGamertags[player] then
                                        _cacheGamertags[player] = name
                                        RemoveMpGamerTag(gamerTags[player])
                                        Wait(100)
                                    end      
                                    gamerTags[player] = CreateFakeMpGamerTag(ped, name, false, false, '', 0)                          
                                end

                                SetMpGamerTagAlpha(gamerTags[player], 0, 255)
                                SetMpGamerTagAlpha(gamerTags[player], 2, 255)
                                SetMpGamerTagAlpha(gamerTags[player], 4, 255)
                                SetMpGamerTagAlpha(gamerTags[player], 7, 255)
                                SetMpGamerTagVisibility(gamerTags[player], 0, true)
                                SetMpGamerTagVisibility(gamerTags[player], 2, true)
                                SetMpGamerTagVisibility(gamerTags[player], 4, NetworkIsPlayerTalking(player))
                                SetMpGamerTagVisibility(gamerTags[player], 8, GetPedInVehicleSeat(GetVehiclePedIsIn(ped), -1))
                                SetMpGamerTagVisibility(gamerTags[player], 7, DecorExistOn(ped, "staffl") and DecorGetInt(ped, "staffl") > 0)
                                SetMpGamerTagColour(gamerTags[player], 7, 55)
                                if PlayersList['id:'..GetPlayerServerId(player)] then
                                    if PlayersList['id:'..GetPlayerServerId(player)].staffmode then
                                        SetMpGamerTagVisibility(gamerTags[player], 14, true)
                                        if PlayersList['id:'..GetPlayerServerId(player)].npd then
                                            SetMpGamerTagVisibility(gamerTags[player], 19, true)
                                        else
                                            SetMpGamerTagVisibility(gamerTags[player], 19, false)
                                        end
                                    else
                                        SetMpGamerTagVisibility(gamerTags[player], 14, false)
                                    end

                                    if PlayersList['id:'..GetPlayerServerId(player)].isAfk then
                                        SetMpGamerTagVisibility(gamerTags[player], 6, true)
                                    else
                                        SetMpGamerTagVisibility(gamerTags[player], 6, false)
                                    end
                                end

                                if NetworkIsPlayerTalking(player) then
                                    -- SetMpGamerTagHealthBarColour(gamerTags[player], 1)
                                    SetMpGamerTagColour(gamerTags[player], 4, 141)
                                    SetMpGamerTagHealthBarColour(gamerTags[player], 141)
                                    -- SetMpGamerTagColour(gamerTags[player], 0, 1)
                                else
                                    if playerRank then
                                        if playerRank ~= '' then
                                            SetMpGamerTagHealthBarColour(gamerTags[player], 0)
                                            SetMpGamerTagColour(gamerTags[player], 4, YveltHelper.colorsNames[PlayersList['id:'..GetPlayerServerId(player)].rankColor])
                                            SetMpGamerTagColour(gamerTags[player], 0, YveltHelper.colorsNames[PlayersList['id:'..GetPlayerServerId(player)].rankColor])
                                        else
                                            SetMpGamerTagHealthBarColour(gamerTags[player], 0)
                                            SetMpGamerTagColour(gamerTags[player], 4, 0)
                                            SetMpGamerTagColour(gamerTags[player], 0, 0)
                                        end
                                    else
                                        SetMpGamerTagHealthBarColour(gamerTags[player], 0)
                                        SetMpGamerTagColour(gamerTags[player], 4, 0)
                                        SetMpGamerTagColour(gamerTags[player], 0, 0)
                                    end
                                end
                            end
                        else
                            RemoveMpGamerTag(gamerTags[player])
                            gamerTags[player] = nil
                        end
                    -- end
                end
                Wait(100)
            end
            for k,v in pairs(gamerTags) do
                RemoveMpGamerTag(v)
            end
            gamerTags = {}
        end)
    end
end

function YveltHelper:getJob(targetId)
    if YveltConfig.UseJob1 then
        if targetId and targetId ~= 0 then
            local xPlayer = YveltHelper:getPlayerFromId(targetId)
            if xPlayer then
                return xPlayer.getJob()
            end
        end
    else
        return {label = 'Inconnu', name = 'Inconnu'}
    end
end

function YveltHelper:getJob2(targetId)
    if YveltConfig.UseJob2 then
        if targetId and targetId ~= 0 then
            local xPlayer = YveltHelper:getPlayerFromId(targetId)
            if xPlayer then
                return xPlayer.getJob2()
            end
        end
    else
        return {label = 'Inconnu', name = 'Inconnu'}
    end
end

function YveltHelper:addItem(targetId, item, count)
    local xPlayer = YveltHelper:getPlayerFromId(targetId)
    return xPlayer.addInventoryItem(item, count)
end

function YveltHelper:removeItem(targetId, item, count)
    local xPlayer = YveltHelper:getPlayerFromId(targetId)
    return xPlayer.removeInventoryItem(item, count)
end

function YveltHelper:getPlayerInventory(targetId)
    local xPlayer = YveltHelper:getPlayerFromId(targetId)
    local table = xPlayer.getInventory()
    local table2 = xPlayer.getLoadout()
    return table, table2
end

--- Permet de send un webhook
---@param a number ID Temporaire d'un joueur
function YveltHelper:sendWebhook(table)
    if YveltLogs.Enable then
        local webhookUrl = YveltLogs.LogsWebhook[table.webhook]
        if webhookUrl then
            local date = os.date("%d")..'/'..os.date("%m")..'/'..os.date("%Y")..' à '..os.date("%H")..'h'..os.date("%M")..' et '..os.date("%S")..' secondes'
            local embed = {
                {
                    ["title"] = table.title or 'Aucun titre',
                    ["description"] = table.description or 'Aucune description',
                    ["type"] = "rich",
                    ["color"] = table.color or '#ed4245',
                    ["footer"] = {
                        ["text"] = YveltConfig.ServerTitle..'・'..date,
                    },
                }
            }

            local jsonData = json.encode({embeds = embed})
            PerformHttpRequest(webhookUrl, function(statusCode, text, headers)
                if statusCode == 204 then
                    print("Message avec embed envoyé avec succès au webhook!")
                else
                    print("Erreur lors de l'envoi du message au webhook - Code de statut : " .. statusCode)
                end
            end, "POST", jsonData, {["Content-Type"] = "application/json"})
        else
            print('ERREUR : webhookUrl n\'exiset pas !')
        end
    end
end

function YveltHelper:getTextFromAscii(ascii)
    local string = ""

    for k, v in ipairs(ascii) do
        string = string .. string.char(v)
    end

    return string
end