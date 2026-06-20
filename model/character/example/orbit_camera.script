go.property("zoom", 3) -- <1>
go.property("min_zoom", 3) -- <2>
go.property("max_zoom", 20) -- <3>
go.property("zoom_speed", 0.1) -- <4>
go.property("rotation_speed", 0.5) -- <5>
go.property("offset", vmath.vector3(0, 0, 0)) -- <6>

local function clamp_zoom(self)
	self.zoom_offset = math.min(math.max(self.zoom + self.zoom_offset, self.min_zoom), self.max_zoom) - self.zoom
end

function init(self)
	msg.post(".", "acquire_input_focus") -- <7>

	self.yaw = go.get(".", "euler.y") -- <8>
	self.pitch = go.get(".", "euler.x")
	self.zoom_offset = 0
	clamp_zoom(self)
	self.current_yaw = self.yaw
	self.current_pitch = self.pitch
	self.current_zoom = self.zoom_offset
end

function update(self, dt)
	self.current_yaw = vmath.lerp(0.15, self.current_yaw, self.yaw) -- <9>
	self.current_pitch = vmath.lerp(0.15, self.current_pitch, self.pitch)
	self.current_zoom = vmath.lerp(0.15, self.current_zoom, self.zoom_offset)

	local camera_yaw = vmath.quat_rotation_y(math.rad(self.current_yaw))
	local camera_pitch = vmath.quat_rotation_x(math.rad(self.current_pitch))
	local camera_rotation = camera_yaw * camera_pitch
	local camera_position = self.offset + vmath.rotate(camera_rotation, vmath.vector3(0, 0, self.zoom + self.current_zoom))

	go.set_position(camera_position) -- <10>
	go.set_rotation(camera_rotation)
end

function on_input(self, action_id, action)
	if action_id == hash("touch") and not action.pressed then
		self.yaw = self.yaw - action.dx * self.rotation_speed -- <11>
		self.pitch = self.pitch + action.dy * self.rotation_speed
	elseif action_id == hash("mouse_wheel_up") then
		self.zoom_offset = self.zoom_offset - self.zoom * self.zoom_speed -- <12>
		clamp_zoom(self)
	elseif action_id == hash("mouse_wheel_down") then
		self.zoom_offset = self.zoom_offset + self.zoom * self.zoom_speed -- <13>
		clamp_zoom(self)
	end
end

--[[
1. Default zoom distance from the model.
2. Minimum allowed zoom distance.
3. Maximum allowed zoom distance.
4. Zoom speed multiplier for the mouse wheel.
5. Rotation speed multiplier for drag and touch input.
6. Camera offset from the model origin.
7. Enable input so drag, touch, and wheel events reach the script.
8. Store the starting camera angles from the current game object rotation.
9. Smooth the camera toward the target rotation and zoom.
10. Apply the computed camera position every frame.
11. Drag or touch rotates the camera around the model.
12. Mouse wheel up zooms in, then clamps the zoom distance.
13. Mouse wheel down zooms out, then clamps the zoom distance.
]]
