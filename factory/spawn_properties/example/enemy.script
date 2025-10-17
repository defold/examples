-- Define different properties of the script:
go.property("sprite", hash("ufoGreen"))
go.property("health_points", 1)
go.property("speed", vmath.vector3(100, 100, 0))
go.property("is_random", true)

function init(self)

	-- Set animation of the sprite to the one defined by its property self.sprite:
	sprite.play_flipbook("#sprite", self.sprite)

	-- Add randomness to horizontal direction - this way enemy horizontal speed may be inverted or cleared:
	-- -1 * self.speed.x - inverted direction
	--  0 * self.speed.x - cleared direction
	--  1 * self.speed.x - regular direction
	self.speed.x = math.random(-1, 1) * self.speed.x

	-- If self.is_random boolean property is true:
	if self.is_random then
		-- add a timer to randomly switch horizontal speed every second:
		timer.delay(1, true, function()
			self.speed.x = math.random(-1, 1) * self.speed.x
		end)
	end
end

function update(self, dt)
	-- Update enemy position based on its current speed:
	local pos = go.get_position()
	pos = pos + self.speed * dt
	go.set_position(pos)

	-- Bounce enemy off "walls":
	if pos.x > 600 or pos.x < 50 then
		self.speed.x = -self.speed.x
	end

	-- Remove enemy if it goes out of screen:
	if pos.y < -50 then
		go.delete()
	end
end

function on_message(self, message_id, message, sender)

	-- React to collision with bullet:
	if message_id == hash("trigger_response") and message.enter then

		-- Remove one health point
		self.health_points = self.health_points - 1

		-- Play particlefx for damage taken:
		particlefx.play("#boom")

		-- When no health points left - remove this ship
		if self.health_points <= 0 then
			go.delete()
		end
	end
end
