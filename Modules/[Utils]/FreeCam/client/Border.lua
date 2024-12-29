warningColor = {r = 255, g = 0, b = 0, a = 50}

function DrawBoundaryZone(center, radius, isNearBoundary)
    local color = isNearBoundary and warningColor or {r = 0, g = 255, b = 0, a = 0}
    DrawMarker(
        1,
        center.x, center.y, center.z - 1.0,
        0.0, 0.0, 0.0,
        0.0, 0.0, 0.0,
        radius * 2, radius * 2, 100.0,
        color.r, color.g, color.b, color.a,
        false,
        false,
        2,
        false,
        nil,
        nil,
        false
    )
end