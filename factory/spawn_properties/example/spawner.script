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

function init(self)
	-- Acquire input focus here, so we can handle inputs:
	msg.post(".", "acquire_input_focus")
end

-- Helper function to spawn given enemy by its type:
local function spawn_enemy(enemy_type)

	-- Select properties of the enemy by type:
	local properties = ENEMY_TYPES[enemy_type]

	-- Set initial position of the spawned ship.
	local position = go.get_position()

	-- This will make the position one out of (-180, -90, 0, 90, 180):
	position.x = position.x + math.random(-2,2) * 90

	-- Create enemy with passed properties
	factory.create("#enemyfactory", position, nil, properties)
end

function on_input(self, action_id, action)

	-- React to different key presses with spawning different enemies:
	if action_id == hash("key_1") and action.released then
		spawn_enemy("random")
	elseif action_id == hash("key_2") and action.released then
		spawn_enemy("diagonal")
	elseif action_id == hash("key_3") and action.released then
		spawn_enemy("straight")
	end
end
