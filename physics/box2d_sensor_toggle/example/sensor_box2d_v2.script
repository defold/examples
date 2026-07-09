-- Helper function to convert a collision object to a sensor (trigger) for scripting
local function enable_sensor_fixture()
	-- `b2d.get_body()` returns the native Box2D body created by this collision object.
	local body = b2d.get_body("#collisionobject")

	-- In Box2D V2, collision geometry and material data live in fixtures.
	-- The collection-authored fixture starts solid, so the ball would collide with it.
	local fixture = b2d.body.get_fixtures(body)[1]

	-- Turning the fixture into a sensor disables physical collision response.
	-- Box2D still reports trigger-style enter/exit interactions for overlaps.
	b2d.fixture.set_sensor(body, fixture.index, true)
end

function init(self)
	-- This script uses the Box2D V2 fixture API.
	self.active = b2d.get_version().major == 2

	-- If Box2D V2 is not used, skip further processing
	if not self.active then
		return
	end

	enable_sensor_fixture()
	self.overlaps = {}
end

local NORMAL_SCALE = vmath.vector3(1.0)
local LARGER_SCALE = vmath.vector3(1.1)

function on_message(self, message_id, message, sender)
	-- If Box2D V2 is not used, skip further processing
	if not self.active then
		return
	end

	-- Defold sends `trigger_response` when a sensor fixture starts or stops
	-- overlapping another collision object allowed by the collision mask.
	if message_id == hash("trigger_response") then

		-- Store overlaps in a table or clear those that exited the sensor
		if message.enter then
			self.overlaps[message.other_id] = true
		else
			self.overlaps[message.other_id] = nil
		end

		-- Count overlaps
		local count = 0
		for i,v in pairs(self.overlaps) do count = count + 1 end

		-- Set the sprite scale to indicate the overlapping visually
		if count > 0 then
			go.set("#sprite", "scale", LARGER_SCALE)
		else
			go.set("#sprite", "scale", NORMAL_SCALE)
		end

		-- Update the label text to show the amount of overlaps
		label.set_text("#label", "Overlaps: " .. count)
	end
end
