local TOUCH = hash("touch")
local MOUSE_WHEEL_UP = hash("mouse_wheel_up")
local MOUSE_WHEEL_DOWN = hash("mouse_wheel_down")

local ROTATION_SPEED = 0.8
local ZOOM_STEP = 0.35
local MIN_PITCH = -75
local MAX_PITCH = 75
local MIN_ZOOM = 3.0
local MAX_ZOOM = 8.0
local SMOOTHING = 0.15

local function clamp(value, min_value, max_value)
	return math.max(min_value, math.min(max_value, value))
end

local function apply_camera(self)
	local yaw = vmath.quat_rotation_y(math.rad(self.current_yaw)) -- <1>
	local pitch = vmath.quat_rotation_x(math.rad(self.current_pitch)) -- <2>
	local rotation = yaw * pitch -- <3>
	local position = vmath.rotate(rotation, vmath.vector3(0, 0, self.current_zoom)) -- <4>

	go.set_position(position) -- <5>
	go.set_rotation(rotation) -- <6>
end

function init(self)
	msg.post(".", "acquire_input_focus") -- <7>

	self.target_yaw = 0
	self.target_pitch = 0
	self.target_zoom = 5.0
	self.current_yaw = self.target_yaw
	self.current_pitch = self.target_pitch
	self.current_zoom = self.target_zoom

	apply_camera(self)
end

function update(self, dt)
	self.current_yaw = vmath.lerp(SMOOTHING, self.current_yaw, self.target_yaw) -- <8>
	self.current_pitch = vmath.lerp(SMOOTHING, self.current_pitch, self.target_pitch)
	self.current_zoom = vmath.lerp(SMOOTHING, self.current_zoom, self.target_zoom)

	apply_camera(self)
end

function on_input(self, action_id, action)
	if action_id == TOUCH and not action.pressed and not action.released then -- <9>
		self.target_yaw = self.target_yaw - action.dx * ROTATION_SPEED -- <10>
		self.target_pitch = clamp(self.target_pitch + action.dy * ROTATION_SPEED, MIN_PITCH, MAX_PITCH) -- <11>
	elseif action_id == MOUSE_WHEEL_UP then
		self.target_zoom = clamp(self.target_zoom - ZOOM_STEP, MIN_ZOOM, MAX_ZOOM) -- <12>
	elseif action_id == MOUSE_WHEEL_DOWN then
		self.target_zoom = clamp(self.target_zoom + ZOOM_STEP, MIN_ZOOM, MAX_ZOOM) -- <13>
	end
end

--[[
1. Create the horizontal orbit rotation from the smoothed yaw angle.
2. Create the vertical orbit rotation from the smoothed pitch angle.
3. Combine yaw and pitch into the camera rotation.
4. Rotate a forward offset to place the camera on an orbit around the logo.
5. Move the camera game object to the calculated orbit position.
6. Rotate the camera so it keeps looking at the logo.
7. Acquire input focus so drag and mouse wheel input reaches this script.
8. Smoothly blend the visible camera values toward the latest input targets.
9. Handle pointer movement after the initial press and before release.
10. Drag left and right to orbit around the vertical axis.
11. Drag up and down to pitch the camera, clamped so it cannot flip over.
12. Scroll up to zoom in, clamped to the closest useful distance.
13. Scroll down to zoom out, clamped so the logo remains visible.
]]
