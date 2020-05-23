function init(self)
    local to = vmath.vector3(400, 400, 0)
    go.animate(".", "position", go.PLAYBACK_LOOP_PINGPONG, to, go.EASING_INOUTSINE, 2)
end

--[[
1. In Lua, local variables must be declared prior to their use.
   Since the functions `up_down()` and `left_right()` refer to 
   each other we "forward declare" the names `up_down` and 
   `left_right` before the function definitions.
2. This function animates the game object position's y component,
   then calls the function `left_right()` on completion.
3. This function animates the game object position's x component,
   then calls the function `up_down()` on completion.
4. Start by calling the `up_down()` function.
5. In parallell, tween the scale y component.
6. And the sprite's tint x component (which is the red value).
--]]