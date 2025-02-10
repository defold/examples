function init(self)
	gui.animate(gui.get_node("logo1"), gui.PROP_COLOR, vmath.vector4(1, 0, 0, 1), gui.EASING_INOUTQUAD, 3, 0, nil, gui.PLAYBACK_LOOP_PINGPONG) -- <1>
	gui.animate(gui.get_node("logo2"), "color.x", 0, gui.EASING_INOUTQUAD, 3, 0, nil, gui.PLAYBACK_LOOP_PINGPONG) -- <2>
	gui.animate(gui.get_node("bg"), "color.w", 0, gui.EASING_INOUTQUAD, 4, 0, nil, gui.PLAYBACK_LOOP_PINGPONG) -- <3>
	
	gui.set_color(gui.get_node("logo3"), vmath.vector4(1, 0, 0, 1)) -- <4>

end

--[[
1. x,y,z,w -> r,g,b,a. Keep read and alpha. Animate green and blue to 0.
2. x = red. Animate the red color component to 0.
3. w = alpha. Animate the alpha color component to 0. All children which inherit alpha will be affected.
4. Set the color of the node.
--]]