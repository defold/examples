go.property("acceleration", 100)
go.property("deceleration", 200)
go.property("max_speed", 400)

function init(self)
	-- make sure the script will receive user input
	msg.post(".", "acquire_input_focus")

	-- movement input
	self.input = vmath.vector3()
	
	-- the current direction of movement
	self.direction = vmath.vector3()

	-- the current speed (pixels/second)
	self.speed = 0
end

function update(self, dt)
	-- is any key pressed?
	if self.input.x ~= 0 or self.input.y ~= 0 then
		-- set direction of travel from input
		self.direction = self.input
		-- increase speed
		self.speed = self.speed + self.acceleration * dt
		-- cap speed
		self.speed = math.min(self.speed, self.max_speed)
	else
		-- decrease speed when no key is pressed
		self.speed = self.speed - self.deceleration * dt
		self.speed = math.max(self.speed, 0)
	end

	-- move the game object
	local p = go.get_position()
	p = p + self.direction * self.speed * dt
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
		self.input.x = -1
	elseif action_id == hash("right") then
		self.input.x = 1
	end
end