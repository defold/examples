local up_down -- <1>
local left_right
	
function up_down(self) -- <2>
	go.animate(".", "position.y", go.PLAYBACK_ONCE_PINGPONG, 624, go.EASING_INOUTSINE, 2, 0, left_right)
end

function left_right(self) -- <3>
	go.animate(".", "position.x", go.PLAYBACK_ONCE_PINGPONG, 660, go.EASING_INOUTSINE, 2, 0, up_down)	
end

function init(self)
	up_down(self) -- <4>
    go.animate(".", "scale.y", go.PLAYBACK_LOOP_PINGPONG, 0.5, go.EASING_INOUTSINE, 1) -- <5>
    go.animate("#sprite", "tint.x", go.PLAYBACK_LOOP_PINGPONG, 0.0, go.EASING_INOUTSINE, 1.5) -- <6>
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