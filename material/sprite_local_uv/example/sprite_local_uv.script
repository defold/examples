function init(self)
	-- get the sprite size from the sprite component propertry 'size'
	local size = go.get("#sprite", "size")

	-- set the size on the sprite material in the custom vertex attribute 'sprite_size'
	go.set("#sprite", "sprite_size", size)

	-- rotate the sprite
	go.animate(".", "euler.z", go.PLAYBACK_LOOP_FORWARD, 360, go.EASING_LINEAR, 5)
end
