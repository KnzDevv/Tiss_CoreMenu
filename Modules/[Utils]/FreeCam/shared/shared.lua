FreeCam = {}

FreeCam.MaxDistance = 30.0
FreeCam.MouseSensitivity = 10.0
FreeCam.warningDistance = 2.0

FreeCam.Fovs = {
    MinFov = 1.0,
    MaxFov = 100.0,
    ZoomSpeed = 5.0,
    ZoomSmoothness = 0.1,
    TargetFov = 90.0
}

-- Differents boutons qui sont affiché en bas à droite (Scaleform)
FreeCam.InstructionsButtons = {
    { button = "~INPUT_FRONTEND_RRIGHT~",   text = "Retour" },
    { button = "~INPUT_MOVE_UP_ONLY~",      text = "Avancer" },
    { button = "~INPUT_MOVE_DOWN_ONLY~",    text = "Reculer" },
    { button = "~INPUT_JUMP~",              text = "Monter" },
    { button = "~INPUT_DUCK~",              text = "Descendre" },
    { button = "~INPUT_WEAPON_WHEEL_PREV~", text = "Zoom avant" },
    { button = "~INPUT_WEAPON_WHEEL_NEXT~", text = "Zoom arrière" }
}

FreeCam.Groups = {
    admin = true,
    superadmin = true,
    user = true
}

FreeCam.Command = {
    active = true,
    name = "freecam"
}