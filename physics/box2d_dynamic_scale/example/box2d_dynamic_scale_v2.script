function init(self)
	-- This script uses the Box2D V2 fixture API.
	self.active = b2d.get_version().major == 2

	-- If Box2D V2 is not used, skip further processing
	if not self.active then
		return
	end

	-- `b2d.get_body()` returns the native Box2D body created by the given collision object.
	self.body = b2d.get_body("#collisionobject")

	-- In Box2D V2, collision geometry and material data live in fixtures.
	self.fixture_index = b2d.body.get_fixtures(self.body)[1].index
	-- v3: 
	self.shape_id = b2d.body.get_shapes(self.body)[1].shape_id

	-- Acquire input focus to handle inputs
	msg.post(".", "acquire_input_focus")

	-- Initialize random number generator
	math.randomseed(os.time())
end

-- The built-in touch action also covers mouse clicks in the built-in all.input_binding.
local TOUCH = hash("touch")

-- Base size will be used to change the scale around the initial size
local BASE_SIZE = 80.0
local BASE_HALF_EXTENT = 40.0

-- Helper function to get a random scale with values in range 0.5-1.5
local function get_random_scale()
	local random_number = math.random(5,15)/10
	return vmath.vector3(random_number, random_number, 0)
end

local function resize_body(self, scale_vector)
	local half_extent = BASE_HALF_EXTENT * scale_vector.x

	-- The last parameter update_mass set to true will cause the mass to be updated.
	local update_mass = true

	-- Update a box shape using the polygon box convenience format.
	-- V2 collision geometry is addressed through fixtures attached to the body.
	-- The shape type must match the current fixture shape type.
	b2d.fixture.set_shape(self.body, self.fixture_index, {
		type = b2d.shape.SHAPE_TYPE_BOX,
		hx = half_extent,
		hy = half_extent,
	}, update_mass)

	-- Also change the vector size to match the new shape
	local size_vector = BASE_SIZE * scale_vector
	go.set("#sprite", "size", size_vector)
end

function on_input(self, action_id, action)
	-- If Box2D V2 is not used, skip further processing
	if not self.active then
		return
	end

	if action_id == TOUCH and action.pressed then
		-- When click or touch is pressed - change the scale randomly
		resize_body(self, get_random_scale())

		-- And apply a random impulse to the center of the body
		-- to notice mass differences applied
		local random_impulse_x = math.random(-400,400)
		local random_impulse_y = math.random(-400,400)
		local impulse = vmath.vector3(random_impulse_x, random_impulse_y, 0)
		b2d.body.apply_linear_impulse(self.body, impulse, b2d.body.get_world_center(self.body))
	end
end
