local isShooting = false

Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        
        if IsPedShooting(playerPed) then
            if not isShooting then
                isShooting = true

                ResetPedMovementClipset(playerPed, 0)
                ResetPedWeaponMovementClipset(playerPed)
                ResetPedStrafeClipset(playerPed)

            end
        else
            isShooting = false
        end

        Wait(100) 
    end
end)