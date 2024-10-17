local ZOOM_SPEED = 0.2
local ROTATION_SPEED = 0.5

function init(self)
	msg.post("@render:", "use_camera_projection")
	msg.post(".", "acquire_input_focus")

	self.yaw         = go.get(".", "euler.y") -- for camera rotation
	self.pitch       = go.get(".", "euler.x") -- for camera rotation
	self.offset      = go.get_position()
	self.zoom        = 3 -- default zoom
	self.zoom_offset = 0 -- modification from default zoom
	self.time        = 0 -- for pattern animation

	-- The model with the pattern - we enabled the effect, 0.5 is the intensity (alpha)
	go.set("/crate_selected#model", "pattern_opts.x", 0.5)
	-- + add 70 degrees to the rotation
	go.set("/crate_selected#model", "pattern_opts.w", math.rad(70))

	-- The normal model - the 0.0 value disables the effect
	go.set("/crate#model", "pattern_opts.x", 0)
end

function update(self, dt)
	-- Camera controls
	local camera_yaw      = vmath.quat_rotation_y(math.rad(self.yaw))
	local camera_pitch    = vmath.quat_rotation_x(math.rad(self.pitch))
	local camera_rot      = camera_yaw * camera_pitch
	local camera_position = self.offset + vmath.rotate(camera_rot, vmath.vector3(0, 0, self.zoom + self.zoom_offset))
	go.set_position(camera_position)
	go.set_rotation(camera_rot)

	-- Animate the pattern by changing the z value
	self.time = self.time - dt
	go.set("/crate_selected#model", "pattern_opts.z", self.time)

	-- The shader uses the screen size to calculate the aspect ratio.
	-- In a real game, you'd set this in the render script globally for all materials.
	local w, h = window.get_size()
	go.set("/crate_selected#model", "screen_size", vmath.vector4(w, h, 0, 0))
end

function on_input(self, action_id, action)
	if action_id == hash("touch") then
		self.yaw   = self.yaw   - action.dx * ROTATION_SPEED
		self.pitch = self.pitch + action.dy * ROTATION_SPEED
	elseif action_id == hash("wheel_up") then
		self.zoom_offset = self.zoom_offset - ZOOM_SPEED
	elseif action_id == hash("wheel_down") then
		self.zoom_offset = self.zoom_offset + ZOOM_SPEED
	end
end
