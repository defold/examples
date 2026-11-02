local MODEL_URL = "#turret"
local TOUCH = hash("touch")
local SHOOT = hash("shoot")

local function play_animation(animation_id)
	model.play_anim(MODEL_URL, animation_id, go.PLAYBACK_ONCE_FORWARD)
end

function init(self)
	msg.post(".", "acquire_input_focus")

	self.camera_url = nil
	self.mouse_x = 0
	self.mouse_y = 0
	self.has_mouse = false
end

function on_message(self, message_id, message, sender)
	if message_id == hash("register_camera") then
		self.camera_url = message.url
		pprint("Camera registered: " .. tostring(self.camera_url))
	end
end

function on_input(self, action_id, action)
	if action.screen_x and action.screen_y then
		self.mouse_x = action.screen_x
		self.mouse_y = action.screen_y
		self.has_mouse = true
		if action_id == TOUCH and action.pressed then
			play_animation(SHOOT)
		end
	end
end

function update(self, dt)
	if not self.camera_url or not self.has_mouse then
		return
	end

	-- Get two points on the cursor's line of sight (near and far planes)
	-- z = 0 -> near plane, z = 1 -> far plane (normalized depth, not world units)
	local p0 = camera.screen_to_world(
		vmath.vector3(self.mouse_x, self.mouse_y, 0),
		self.camera_url
	)

	local p1 = camera.screen_to_world(
		vmath.vector3(self.mouse_x, self.mouse_y, 1),
		self.camera_url
	)
	-- Ray direction: from near plane towards far plane
	local ray = p1 - p0

	-- Get the turret's current world position (with parent transforms applied)
	go.update_world_transform()
	local gun_pos = go.get_world_position()

	-- Ray is parallel to the horizontal plane - no intersection
	if math.abs(ray.y) < 0.00001 then
		return
	end
	-- Intersect the ray with the horizontal plane at the gun's height (y = gun_pos.y)
	local t = (gun_pos.y - p0.y) / ray.y
	local target = p0 + ray * t

	-- Horizontal vector from turret to target
	local dx = target.x - gun_pos.x
	local dz = target.z - gun_pos.z

	-- Target is directly under/above the turret - direction is undefined
	if math.abs(dx) + math.abs(dz) < 0.00001 then
		return
	end

	-- Yaw angle. atan2(dx, dz) assumes the model faces +Z at angle 0
	local angle = math.atan2(dx, dz)

	-- Rotate the turret around the Y axis
	go.set_rotation(
		vmath.quat_rotation_y(angle)
	)
end
