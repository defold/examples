-- The initial zoom level
go.property("zoom", 3)
-- The speed of the zoom
go.property("zoom_speed", 0.1)
-- The speed of the rotation
go.property("rotation_speed", 0.5)
-- The offset of the camera from the origin
go.property("offset", vmath.vector3(0, 0, 0))

function init(self)
	-- Acquire input focus to receive input events
	msg.post(".", "acquire_input_focus")

	-- Initialize start values
	self.yaw = go.get(".", "euler.y")
	self.pitch = go.get(".", "euler.x")
	self.zoom_offset = 0
	self.current_yaw = self.yaw
	self.current_pitch = self.pitch
	self.current_zoom = self.zoom_offset
end

function update(self, dt)
	-- Animate camera rotation and zoom
	self.current_yaw = vmath.lerp(0.15, self.current_yaw, self.yaw)
	self.current_pitch = vmath.lerp(0.15, self.current_pitch, self.pitch)
	self.current_zoom = vmath.lerp(0.15, self.current_zoom, self.zoom_offset)

	-- Calculate rotation and position
	local camera_yaw = vmath.quat_rotation_y(math.rad(self.current_yaw))
	local camera_pitch = vmath.quat_rotation_x(math.rad(self.current_pitch))
	local camera_rotation = camera_yaw * camera_pitch
	local camera_position = self.offset + vmath.rotate(camera_rotation, vmath.vector3(0, 0, self.zoom + self.current_zoom))

	-- Set camera position and rotation
	go.set_position(camera_position)
	go.set_rotation(camera_rotation)
end

function on_input(self, action_id, action)
	if action_id == hash("touch") and not action.pressed then
		self.yaw   = self.yaw   - action.dx * self.rotation_speed
		self.pitch = self.pitch + action.dy * self.rotation_speed
	elseif action_id == hash("wheel_up") then
		self.zoom_offset = self.zoom_offset - self.zoom * self.zoom_speed
	elseif action_id == hash("wheel_down") then
		self.zoom_offset = self.zoom_offset + self.zoom * self.zoom_speed
	end
end
