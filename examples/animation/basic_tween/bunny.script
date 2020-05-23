function init(self)
    local to = vmath.vector3(400, 400, 0) -- <1>
    go.animate(".", "position", go.PLAYBACK_LOOP_PINGPONG, to, go.EASING_INOUTSINE, 2) -- <2>
end

--[[
1. The destination to move the game object to (x, y, z)
2. This function animates the game object position to the destination and back again repeatedly over a period of 2 seconds. The movement uses a sine-wave easing curve to slow down at the end points.
--]]
