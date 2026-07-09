-- Unit vector for a 45 degree rail. This is the same direction as the rail sprite.
local AXIS = vmath.vector3(0.70710678, 0.70710678, 0)

-- Prismatic translation is measured along `local_axis_a`, in project units.
-- Define farthest limits on both ends:
local LOWER_TRANSLATION = -110
local UPPER_TRANSLATION = 110

-- Define motor speed that will be used to move the slider
local MOTOR_SPEED = 50

-- Some maximum motor force allows to apply a force on the slider to push it
local MAX_MOTOR_FORCE = 1200

function init(self)
	-- This will be storing a current direction of the slider
	self.direction = 1

	-- Acquire input focus to handle inputs
	msg.post(".", "acquire_input_focus")

	-- `b2d.get_body()` returns the native Box2D body created by the given collision object.
	local slider = b2d.get_body("/slider#collisionobject")
	local anchor = b2d.get_body("/rail#collisionobject")

	-- This creates a prismatic joint in runtime between the 2 bodies - an anchor and a slider.
	-- The joint axis matches the visible diagonal rail in the collection.
	self.joint = b2d.joint.create_prismatic(anchor, slider, {
		-- Both bodies start at the same position, so zero local anchors share the same joint origin.
		local_anchor_a = vmath.vector3(),
		local_anchor_b = vmath.vector3(),

		-- The axis is local to body A, the static anchor.
		local_axis_a = AXIS,

		-- Limits keep the dynamic body between the two ends of the rail.
		enable_limit = true,
		lower_translation = LOWER_TRANSLATION,
		upper_translation = UPPER_TRANSLATION,

		-- The motor pushes the slider along the axis without extra forces in update().
		enable_motor = true,
		max_motor_force = MAX_MOTOR_FORCE,
		motor_speed = self.direction * MOTOR_SPEED,

		-- The connected bodies do not need to collide with each other in this example.
		collide_connected = false,
	})
end

-- Helper function to reverse the motor direction
local function reverse_motor(self)
	-- Assign a negative direction to the current direction variable
	self.direction = -self.direction

	-- Positive and negative speed move the slider in opposite directions along the axis.
	b2d.joint.set_motor_speed(self.joint, self.direction * MOTOR_SPEED)
end

function update(self, dt)
	-- The function returns a translation on the defined joint in project units
	local translation = b2d.joint.get_joint_translation(self.joint)

	-- Reverse automatically when the slider reaches either translation limit.
	if self.direction > 0 and translation > UPPER_TRANSLATION then
		reverse_motor(self)
	elseif self.direction < 0 and translation < LOWER_TRANSLATION then
		reverse_motor(self)
	end

	-- Create a string describing the current direction
	local direction_string = self.direction > 0 and "up-right" or "down-left"

	-- Update the information on the label
	label.set_text("#label", string.format("Motor: %s\nTranslation: %.0f", direction_string, translation))
end

function on_input(self, action_id, action)
	-- The built-in touch action also covers mouse clicks in the built-in all.input_binding.
	if action_id == hash("touch") and action.pressed then
		-- When click or touch is pressed we reverse the motor direction
		reverse_motor(self)
	end
end

function final(self)
	-- Joints created through b2d.joint should be explicitly destroyed.
	if self.joint then
		b2d.joint.destroy(self.joint)
		self.joint = nil
	end

	-- Release input focus
	msg.post(".", "release_input_focus")
end
