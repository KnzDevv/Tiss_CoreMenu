local inCamera = false
local camera = nil
local startPosition = nil
local originalPedCoords = nil
local originalPedHeading = nil
local currentFov = 90.0   -- FOV par default (Ne surtout pas le toucher)

RegisterNetEvent('admin:toggleCamera')
AddEventHandler('admin:toggleCamera', function(isAllowed)
    if not isAllowed then
        Notification('~r~Vous n\'avez pas la permission d\'utiliser la caméra admin.')
        return
    end

    if inCamera then return end
    inCamera = true
    
    local playerPed = PlayerPedId()
    originalPedCoords = GetEntityCoords(playerPed)
    originalPedHeading = GetEntityHeading(playerPed)
    startPosition = originalPedCoords
    
    FreezeEntityPosition(playerPed, true)
    SetEntityCoordsNoOffset(playerPed, originalPedCoords.x, originalPedCoords.y, originalPedCoords.z, true, true, true)
    SetEntityHeading(playerPed, originalPedHeading)
    
    camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamCoord(camera, originalPedCoords.x, originalPedCoords.y, originalPedCoords.z + 1.0)
    SetCamRot(camera, 0.0, 0.0, originalPedHeading, 2)
    SetCamFov(camera, currentFov)
    SetCamActive(camera, true)
    RenderScriptCams(true, false, 0, true, true)
    
    DisablePlayerFiring(PlayerId(), true)
    local controlsToDisable = {30, 31, 32, 33, 34, 35}
    for _, control in ipairs(controlsToDisable) do
        DisableControlAction(0, control, true)
    end
    
    local scaleform = RequestScaleformMovie("INSTRUCTIONAL_BUTTONS")
    while not HasScaleformMovieLoaded(scaleform) do Wait(0) end
    
    BeginScaleformMovieMethod(scaleform, "CLEAR_ALL")
    EndScaleformMovieMethod()
    
    for i, instruction in ipairs(FreeCam.InstructionsButtons) do
        BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
        ScaleformMovieMethodAddParamInt(i - 1)
        ScaleformMovieMethodAddParamPlayerNameString(instruction.button)
        ScaleformMovieMethodAddParamPlayerNameString(instruction.text)
        EndScaleformMovieMethod()
    end
    
    BeginScaleformMovieMethod(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    EndScaleformMovieMethod()
    
    local rotX = 0.0
    local rotZ = originalPedHeading
    
    Citizen.CreateThread(function()
        while inCamera do
            Wait(0)
            
            SetEntityCoordsNoOffset(playerPed, originalPedCoords.x, originalPedCoords.y, originalPedCoords.z, true, true, true)
            SetEntityHeading(playerPed, originalPedHeading)
            FreezeEntityPosition(playerPed, true)
            
            -- Gestion du zoom
            local zoomInput = 0
            if IsControlJustPressed(0, 14) then -- Molette vers le bas
                zoomInput = 1
            elseif IsControlJustPressed(0, 15) then -- Molette vers le haut
                zoomInput = -1
            end
            
            if zoomInput ~= 0 then
                FreeCam.Fovs.TargetFov = math.max(FreeCam.Fovs.MinFov, math.min(FreeCam.Fovs.MaxFov, FreeCam.Fovs.TargetFov + (zoomInput * FreeCam.Fovs.ZoomSpeed)))
            end
            
            if math.abs(currentFov - FreeCam.Fovs.TargetFov) > 0.01 then
                currentFov = currentFov + (FreeCam.Fovs.TargetFov - currentFov) * FreeCam.Fovs.ZoomSmoothness
                SetCamFov(camera, currentFov)
            end
            
            rotX = rotX - (GetControlNormal(0, 2) * FreeCam.MouseSensitivity)
            rotZ = rotZ - (GetControlNormal(0, 1) * FreeCam.MouseSensitivity)
            rotX = math.max(math.min(rotX, 89.0), -89.0)
            SetCamRot(camera, rotX, 0.0, rotZ, 2)
            
            local camCoord = GetCamCoord(camera)
            local speed = 1.0
            local newPos = vector3(camCoord.x, camCoord.y, camCoord.z)
            
            local function tryMove(testPos)
                local distance = GetDistance(testPos, startPosition)
                if distance <= FreeCam.MaxDistance then
                    return testPos
                end
                return newPos
            end
            
            if IsControlPressed(0, 32) then
                local forward = vector3(-math.sin(math.rad(rotZ)) * speed, math.cos(math.rad(rotZ)) * speed, 0.0)
                newPos = tryMove(vector3(camCoord.x + forward.x, camCoord.y + forward.y, camCoord.z))
            end
            
            if IsControlPressed(0, 33) then
                local backward = vector3(math.sin(math.rad(rotZ)) * speed, -math.cos(math.rad(rotZ)) * speed, 0.0)
                newPos = tryMove(vector3(camCoord.x + backward.x, camCoord.y + backward.y, camCoord.z))
            end
            
            if IsControlPressed(0, 35) then
                local left = vector3(math.cos(math.rad(rotZ)) * speed, math.sin(math.rad(rotZ)) * speed, 0.0)
                newPos = tryMove(vector3(camCoord.x + left.x, camCoord.y + left.y, camCoord.z))
            end
            
            if IsControlPressed(0, 34) then
                local right = vector3(-math.cos(math.rad(rotZ)) * speed, -math.sin(math.rad(rotZ)) * speed, 0.0)
                newPos = tryMove(vector3(camCoord.x + right.x, camCoord.y + right.y, camCoord.z))
            end
            
            if IsControlPressed(0, 22) then
                newPos = tryMove(vector3(camCoord.x, camCoord.y, camCoord.z + speed))
            end
            
            if IsControlPressed(0, 36) then
                newPos = tryMove(vector3(camCoord.x, camCoord.y, camCoord.z - speed))
            end
            
            SetCamCoord(camera, newPos.x, newPos.y, newPos.z)
            
            local currentDistance = GetDistance(newPos, startPosition)
            local isNearBoundary = (FreeCam.MaxDistance - currentDistance) <= FreeCam.warningDistance
            DrawBoundaryZone(startPosition, FreeCam.MaxDistance, isNearBoundary)
            
            DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
            
            if IsControlJustPressed(0, 177) then
                inCamera = false
            end
        end
        
        SetCamActive(camera, false)
        RenderScriptCams(false, false, 0, true, true)
        DestroyCam(camera, true)
        camera = nil
        
        EnableAllControlActions(0)
        FreezeEntityPosition(playerPed, false)
        
        startPosition, originalPedCoords, originalPedHeading = nil, nil, nil
    end)
end)