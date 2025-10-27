-- First-person 3D camera controller

-- Tuning parameters
local look_sensitivity = 0.15 -- degrees of camera rotation per 1 pixel of mouse movement
local move_speed = 0.5        -- world units per second for camera movement on XZ plane
local move_limit = 1.25       -- bounds (half-size) for camera movement on XZ to keep it in a square area

function init(self)
	-- Acquire input focus to receive input events from the engine
	msg.post(".", "acquire_input_focus")

	-- Mouse lock state: when true, mouse deltas rotate the camera
	self.mouse_locked = false

	-- Initialize yaw/pitch from current rotation (stored in degrees in Defold)
	self.yaw = go.get(".", "euler.y")
	self.pitch = go.get(".", "euler.x")

	-- Input state for continuous movement (WASD)
	self.input = {
		forward = false,
		backward = false,
		left = false,
		right = false,
	}
end

function update(self, dt)
	-- Clamp pitch to avoid flipping the camera upside down
	if self.pitch > 89 then self.pitch = 89 end
	if self.pitch < -89 then self.pitch = -89 end

	-- Apply rotation directly via Euler angles (in degrees)
	go.set(".", "euler", vmath.vector3(self.pitch, self.yaw, 0))

	-- Build desired movement direction on XZ plane from input flags
	local x = (self.input.right and 1 or 0) - (self.input.left and 1 or 0)
	local z = (self.input.backward and 1 or 0) - (self.input.forward and 1 or 0)

	-- If there is any movement input, move the camera
	if x ~= 0 or z ~= 0 then
		-- Local space direction (camera space)
		local local_dir = vmath.vector3(x, 0, z)
		local len = math.sqrt(local_dir.x * local_dir.x + local_dir.z * local_dir.z)

		if len > 0 then
			-- Normalize to keep speed consistent diagonally
			local_dir.x = local_dir.x / len
			local_dir.z = local_dir.z / len

			-- Convert the yaw to a quaternion
			local q_yaw = vmath.quat_rotation_y(math.rad(self.yaw))

			-- Convert local movement to world space using current yaw
			local world_dir = vmath.rotate(q_yaw, local_dir)

			-- Get the current position of the character
			local pos = go.get_position()

			-- Integrate the position
			pos.x = pos.x + world_dir.x * move_speed * dt
			pos.z = pos.z + world_dir.z * move_speed * dt

			-- Clamp the position within the square bounds
			if pos.x > move_limit then pos.x = move_limit end
			if pos.x < -move_limit then pos.x = -move_limit end
			if pos.z > move_limit then pos.z = move_limit end
			if pos.z < -move_limit then pos.z = -move_limit end

			-- Set the new position
			go.set_position(pos)
		end
	end
end

-- Pre-hashed input action ids (must match project input bindings)
local KEY_W = hash("key_w")
local KEY_S = hash("key_s")
local KEY_A = hash("key_a")
local KEY_D = hash("key_d")
local KEY_ESC = hash("key_esc")
local TOUCH = hash("touch")
local MOUSE_BUTTON_1 = hash("mouse_button_1")

function on_input(self, action_id, action)
	-- Mouse look when locked: engine provides action.dx/dy even while cursor is locked
	if self.mouse_locked and (action.dx or action.dy) then
		-- Rotate the camera based on the mouse movement
		self.yaw = self.yaw - (action.dx or 0) * look_sensitivity
		self.pitch = self.pitch + (action.dy or 0) * look_sensitivity
	end

	-- Lock on first click (touch or left mouse button)
	if not self.mouse_locked and action.pressed
		and (action_id == TOUCH or action_id == MOUSE_BUTTON_1) then
		-- Lock the mouse
		window.set_mouse_lock(true)
		self.mouse_locked = true
	end

	-- WSAD - Continuous movement input state (pressed/released)
	if action_id == KEY_W then
		-- Set the forward input flag to true if the W key is pressed
		if action.pressed then self.input.forward = true end
		if action.released then self.input.forward = false end
	end
	if action_id == KEY_S then
		-- Set the backward input flag to true if the S key is pressed
		if action.pressed then self.input.backward = true end
		if action.released then self.input.backward = false end
	end
	if action_id == KEY_A then
		-- Set the left input flag to true if the A key is pressed
		if action.pressed then self.input.left = true end
		if action.released then self.input.left = false end
	end
	if action_id == KEY_D then
		-- Set the right input flag to true if the D key is pressed
		if action.pressed then self.input.right = true end
		if action.released then self.input.right = false end
	end

	-- ESC unlocks the mouse so the cursor is free again
	if action_id == KEY_ESC and action.pressed then
		-- Unlock the mouse
		window.set_mouse_lock(false)
		self.mouse_locked = false
	end
end
