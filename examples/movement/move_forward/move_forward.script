go.property("acceleration", 100)
go.property("deceleration", 200)
go.property("max_speed", 400)
go.property("rotation_speed", 180)

-- unit vector pointing up
local UP = vmath.vector3(0, 1, 0)

function init(self)
	-- make sure the script will receive user input
	msg.post(".", "acquire_input_focus")

	-- movement input
	self.input = vmath.vector3()

	-- the current speed (pixels/second)
	self.speed = 0
end

function update(self, dt)
	-- accelerating?
	if self.input.y > 0 then
		-- increase speed
		self.speed = self.speed + self.acceleration * dt
		-- cap speed
		self.speed = math.min(self.speed, self.max_speed)
	else
		-- decrease speed when not accelerating
		self.speed = self.speed - self.deceleration * dt
		self.speed = math.max(self.speed, 0)
	end

	-- apply rotation based on self.input.x (left/right)
	local rot = go.get_rotation()
	-- amount to rotate (in radians)
	local rot_amount = math.rad(self.rotation_speed * self.input.x * dt)
	-- apply rotation as a quaternion created from a rotation of 'rot_amount' degrees around the z-axis
	rot = rot * vmath.quat_rotation_z(rot_amount)
	go.set_rotation(rot)

	-- move the game object
	local p = go.get_position()
	-- amount to move (pixels)
	local move_amount = UP * self.speed * dt
	-- apply rotation to movement vector to move game object in the direction of rotation
	p = p + vmath.rotate(rot, move_amount)
	go.set_position(p)

	-- reset input
	self.input = vmath.vector3()
end

function on_input(self, action_id, action)
	-- update direction of movement based on currently pressed keys
	if action_id == hash("up") then
		self.input.y = 1
	elseif action_id == hash("down") then
		self.input.y = -1
	elseif action_id == hash("left") then
		self.input.x = 1
	elseif action_id == hash("right") then
		self.input.x = -1
	end
end