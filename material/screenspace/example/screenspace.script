function init(self)
	self.time = 0 -- for pattern animation

	-- The model with the pattern - we enabled the effect, 0.5 is the intensity (alpha)
	go.set("/crate_selected#model", "pattern_opts.x", 0.5)
	-- + add 70 degrees to the rotation
	go.set("/crate_selected#model", "pattern_opts.w", math.rad(70))

	-- The normal model - the 0.0 value disables the effect
	go.set("/crate#model", "pattern_opts.x", 0)
end

function update(self, dt)
	-- Animate the pattern by changing the z value
	self.time = self.time - dt
	go.set("/crate_selected#model", "pattern_opts.z", self.time)

	-- The shader uses the screen size to calculate the aspect ratio.
	-- In a real game, you'd set this in the render script globally for all materials.
	local w, h = window.get_size()
	go.set("/crate_selected#model", "screen_size", vmath.vector4(w, h, 0, 0))
end
