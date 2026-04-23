local VALUES = { -- <1>
	0, 0, 0, 0, 0, 0,
	1, 1, 1, 1, 1, 1,
	1, 1, 1, 1, 1, 1,
	0, 0, 0, 0, 0, 0,
}
local SQUARE_EASING = vmath.vector(VALUES) -- <2>

function init(self)
	go.animate(".", "position.y", go.PLAYBACK_LOOP_FORWARD, 520, SQUARE_EASING, 4.0) -- <3>
end

--[[
1. This table defines a custom easing curve with normalized samples between 0 and 1. Repeating blocks of zeroes and ones create a square-wave pattern.
2. Convert the Lua table into a `vmath.vector`, which `go.animate()` accepts as a custom easing value.
3. Animate the current game object's `position.y` sub-property. The custom curve makes the sprite move between its starting y position and 520 instead with interpolated in-between positions.
]]
