-- Pre-hash some strings string since they will be used a lot
local TRIGGER_EVENT = hash("trigger_event")
local GROUP_BULLET = hash("bullet")
local GROUP_ENEMY = hash("enemy")

-- Define different properties for different enemies:
local ENEMY_TYPES = {
	random = {
		sprite = hash("ufoGreen"),
		health_points = 1,
		speed = vmath.vector3(40, -100, 0),
		is_random = true
	},
	diagonal = {
		sprite = hash("enemyRed2"),
		health_points = 2,
		speed = vmath.vector3(120, -80, 0),
		is_random = false
	},
	straight = {
		sprite = hash("enemyBlue4"),
		health_points = 3,
		speed = vmath.vector3(0, -40, 0),
		is_random = false
	}
}

-- Helper function to spawn given enemy by its type:
local function spawn_enemy(self, enemy_type)

	-- Select properties of the enemy by type:
	local properties = ENEMY_TYPES[enemy_type]

	-- Set initial position of the spawned ship.
	local position = go.get_position()

	-- This will make the position one out of (-180, -90, 0, 90, 180):
	position.x = position.x + math.random(-2,2) * 90

	-- create enemy
	local id = factory.create("#enemyfactory", position)

	-- set animation of the sprite to the one defined by enemy properties
	local sprite_url = msg.url(nil, id, "sprite")
	sprite.play_flipbook(sprite_url, properties.sprite)

	-- Add randomness to horizontal direction - this way enemy horizontal speed may be inverted or cleared:
	-- -1 * self.speed.x - inverted direction
	--  0 * self.speed.x - cleared direction
	--  1 * self.speed.x - regular direction
	local speed = vmath.vector3(properties.speed)
	speed.x = speed.x * math.random(-1, 1)

	-- store enemy
	self.enemies[id] = {
		id = id,
		health = properties.health_points,
		speed = speed,
		is_random = properties.is_random,
		timer = 1
	}
end

function init(self)
	-- Acquire input focus here, so we can handle inputs:
	msg.post(".", "acquire_input_focus")
	self.enemies = {}

	-- listen to physics events
	-- in this case we care about trigger events between
	-- enemies and bullets
	physics.set_event_listener(function(self, events)
		for _,event in ipairs(events) do
			local event_type = event.type
			if event_type == TRIGGER_EVENT then
				-- get the bullet id and enemy id if the colliding objects belong to
				-- groups "bullet" and "enemy"
				-- this is the Lua way of writing a ternary operator
				local bullet_id = (event.a.group == GROUP_BULLET and event.a.id) or (event.b.group == GROUP_BULLET and event.b.id)
				local enemy_id = (event.a.group == GROUP_ENEMY and event.a.id) or (event.b.group == GROUP_ENEMY and event.b.id)

				-- not really necessary in this example but we might as well
				-- double-check that the detected collision was for a bullet and enemy
				if bullet_id and enemy_id then
					-- remove the bullet
					go.delete(bullet_id)

					-- get the enemy from the managed enemies list
					local enemy = self.enemies[enemy_id]

					-- Remove one health point
					enemy.health = enemy.health - 1

					-- When no health points left - remove this ship
					if enemy.health == 0 then
						go.delete(enemy_id)
						self.enemies[enemy_id] = nil

						-- Play particlefx for damage taken:
						particlefx.play(msg.url(nil, enemy_id, "boom"))
					end
				end
			end
		end
	end)
end


function update(self, dt)
	for id,enemy in pairs(self.enemies) do
		-- Update enemy position based on its current speed:
		local pos = go.get_position(id)
		pos = pos + enemy.speed * dt
		go.set_position(pos, id)

		-- Bounce enemy off "walls":
		if pos.x > 600 or pos.x < 50 then
			enemy.speed.x = -enemy.speed.x
		end

		-- Remove enemy if it goes out of screen:
		if pos.y < -50 then
			go.delete(id)
			self.enemies[id] = nil
		end

		-- If enemy has random movement decrease timer to
		-- randomly switch horizontal speed every second
		if enemy.is_random then
			enemy.timer = enemy.timer - dt
			if enemy.timer < 0 then
				enemy.timer = enemy.timer + 1
				enemy.speed.x = math.random(-1, 1) * enemy.speed.x
			end
		end
	end
end


function on_input(self, action_id, action)
	-- React to different key presses with spawning different enemies:
	if action_id == hash("key_1") and action.released then
		spawn_enemy(self, "random")
	elseif action_id == hash("key_2") and action.released then
		spawn_enemy(self, "diagonal")
	elseif action_id == hash("key_3") and action.released then
		spawn_enemy(self, "straight")
	end
end
