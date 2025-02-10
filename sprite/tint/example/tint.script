function init(self)
	go.set("logo1#sprite", "tint", vmath.vector4(1, 0, 0, 1)) -- <1>
	go.set("logo2#sprite", "tint.x", 0) -- <2>
	go.set("logo3#sprite", "tint.w", 0.3) -- <3>
	go.animate("logo4#sprite", "tint", go.PLAYBACK_LOOP_PINGPONG, vmath.vector4(0, 0.5, 0.8, 1), go.EASING_INOUTQUAD, 2) -- <4>
	go.animate("logo5#sprite", "tint.w", go.PLAYBACK_LOOP_PINGPONG, 0, go.EASING_INOUTQUAD, 3) -- <4>
end

--[[
1. x,y,z,w -> r,g,b,a. Keep red and alpha. Remove green and blue.
2. x = red. Remove the red color component completely
3. w = alpha. Make the sprite semi-transparent
4. The tint property can be animated, either as a whole or each individual value
--]]
