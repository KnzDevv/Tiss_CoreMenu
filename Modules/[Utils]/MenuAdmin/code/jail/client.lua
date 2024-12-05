Citizen.CreateThread(function()
	while true do
		Wait(0)
		if NetworkIsPlayerActive(PlayerId()) then
            Callback.triggerServerCallback('Yvelt:getJail', function(table)
                if table then
                    openjailMenu(table)
                end
            end)
            break
		end
	end
end)

local jail = {
    open = false,
}

mainMenujail = RageUI.CreateMenu('Jail', 'MENU DE PRISON')
mainMenujail.Closable = false

RegisterNetEvent('Yvelt:SendClientToJail')
AddEventHandler('Yvelt:SendClientToJail', function(table)
    openjailMenu(table)
end)

local time = 999999999 

function boolCountjailTime(timeGet)
    time = timeGet / 60
    CreateThread(function()
        while jail.open do
            Wait(1000 * 60)
            if time == 0 then
                jail.open = false
            else
                time = time - 1
            end
            TriggerServerEvent('Yvelt:updatejailTime')
        end
    end)
end

RegisterNetEvent('Yvelt:finishjailTime')
AddEventHandler('Yvelt:finishjailTime', function(table)
    jail.open = false
    RageUI.CloseAll()
    Wait(100)
    SetEntityCoords(PlayerPedId(), YveltConfig.PrisonExit)
    if YveltConfig.GiveVehicleOnExit then
        YveltHelper:spawnVehicle(YveltConfig.GiveVehicleOnExit)
    end
end)

function openjailMenu(table)
    jail.open = false
    RageUI.CloseAll()
    Wait(100)
    SetEntityCoords(PlayerPedId(), YveltConfig.PrisonPos)
    boolCountjailTime(tonumber(table.time))
    jail.open = true
    RageUI.Visible(mainMenujail, true)
    CreateThread(function()
        while jail.open do
            Wait(1)
            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), YveltConfig.PrisonPos, true) > YveltConfig.Distance then
                SetEntityCoords(PlayerPedId(), YveltConfig.PrisonPos)
            end
            RageUI.IsVisible(mainMenujail, function()
                RageUI.Separator('↓ Vous êtes actellement en prison ↓')
                if time == 1 then
                    RageUI.Button(("Temps restant :"), 'Pour contester une sanction, merci de se rendre dans le salon vocal besoin d\'aide sur le Discord du serveur', {RightLabel = ''..time..' minute'}, true, {})
                else
                    RageUI.Button(("Temps restant :"), 'Pour contester une sanction, merci de se rendre dans le salon vocal besoin d\'aide sur le Discord du serveur', {RightLabel = ''..time..' minutes'}, true, {})
                end
                RageUI.Button(("Jail par :"), 'Pour contester une sanction, merci de se rendre dans le salon vocal besoin d\'aide sur le Discord du serveur', {RightLabel = ''..table.staffName..''}, true, {})
                RageUI.Button(("Raison du jail :"), 'Pour contester une sanction, merci de se rendre dans le salon vocal besoin d\'aide sur le Discord du serveur', {RightLabel = ''..table.raison..''}, true, {})
                RageUI.Separator('↓ Pour contester une sanction ↓')
            end)
        end
    end)
end