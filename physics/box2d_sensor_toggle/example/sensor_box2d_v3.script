-- Helper function to create a sensor from the collision object for scripting
local function create_sensor_shape()
	-- `b2d.get_body()` returns the native Box2D body created by this collision object.
	local body = b2d.get_body("#collisionobject")

	-- In Box2D V3, collision geometry is attached to a body as shapes.
	-- Read the first editor-authored shape so the runtime sensor keeps the same size.
	local shape = b2d.body.get_shapes(body)[1]
	local shape_definition = b2d.shape.get_shape(body, shape.index)

	-- The editor-authored shape is solid, so it would block the falling ball.
	-- Remove it before creating the replacement sensor shape.
	b2d.body.destroy_shape(body, shape.index)

	-- A sensor shape reports overlaps without producing collision response.
	-- The ball can pass through it, but Box2D still tracks which shapes overlap it.
	local sensor = b2d.body.create_shape(body, {
		shape = shape_definition,
		friction = 0.0,
		restitution = 0.0,
		sensor = true,
	})

	-- V3 sensor overlap polling is opt-in. Without this call,
	-- `get_sensor_overlaps()` would not return the current overlap list.
	b2d.shape.enable_sensor_events(sensor.shape_id, true)
	return sensor.shape_id
end

function init(self)
	-- This script uses the Box2D V3 shape API.
	self.active = b2d.get_version().major == 3

	-- If Box2D V3 is not used, skip further processing
	if not self.active then
		return
	end

	self.sensor_shape = create_sensor_shape()
	self.overlaps = {}
end

local NORMAL_SCALE = vmath.vector3(1.0)
local LARGER_SCALE = vmath.vector3(1.1)

function update(self, dt)
	-- If Box2D V3 is not used, skip further processing
	if not self.active then
		return
	end

	-- V3 returns the shapes currently overlapping this sensor shape.
	self.overlaps = b2d.shape.get_sensor_overlaps(self.sensor_shape)

	-- Set the sprite scale to indicate the overlapping visually
	if #self.overlaps > 0 then
		go.set("#sprite", "scale", LARGER_SCALE)
	else
		go.set("#sprite", "scale", NORMAL_SCALE)
	end

	-- Update the label text to show the amount of overlaps
	label.set_text("#label", "Overlaps: " .. #self.overlaps)
end
