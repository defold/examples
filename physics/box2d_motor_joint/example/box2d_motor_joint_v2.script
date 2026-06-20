local TOUCH = hash("touch")
local MOTOR_SPEED = 1.5
local MAX_MOTOR_TORQUE = 50000

local function update_label(self)
	local direction = self.direction > 0 and "counter-clockwise" or "clockwise"
	label.set_text("#label", string.format("Box2D V2 motor joint\nMotor: %s\nClick or touch to reverse", direction)) -- <1>
end

local function set_motor_speed(self)
	b2d.joint.set_motor_speed(self.joint, self.direction * MOTOR_SPEED) -- <2>
	update_label(self)
end

local function reverse_motor(self)
	self.direction = -self.direction -- <3>
	set_motor_speed(self)
end

function init(self)
	self.direction = -1

	local b2d_version = b2d.get_version() -- <4>
	self.active = b2d_version.major == 2 -- <5>

	if not self.active then -- <6>
		return
	end

	msg.post(".", "acquire_input_focus") -- <7>

	local pivot_position = go.get_position("pivot") -- <8>
	local arm_position = go.get_position("arm")
	local pivot = b2d.get_body(msg.url(nil, "pivot", "collisionobject")) -- <9>
	local arm = b2d.get_body(msg.url(nil, "arm", "collisionobject")) -- <10>
	b2d.body.set_gravity_scale(arm, 0.0) -- <11>

	local arm_anchor = vmath.vector3(
		pivot_position.x - arm_position.x,
		pivot_position.y - arm_position.y,
		pivot_position.z - arm_position.z
	) -- <12>

	self.joint = b2d.joint.create_revolute(pivot, arm, { -- <13>
		local_anchor_a = vmath.vector3(),
		local_anchor_b = arm_anchor,
		enable_motor = true,
		max_motor_torque = MAX_MOTOR_TORQUE,
		motor_speed = self.direction * MOTOR_SPEED,
		collide_connected = false,
	})

	update_label(self)
end

-------------------
-- Input handling:

function on_input(self, action_id, action)
	if not self.active then -- <14>
		return
	end

	if action_id == TOUCH and action.pressed then -- <15>
		reverse_motor(self)
	end
end

function final(self)
	if not self.active then
		return
	end

	if self.joint then
		b2d.joint.destroy(self.joint) -- <16>
		self.joint = nil
	end

	msg.post(".", "release_input_focus") -- <17>
end

--[[
1. Updates the label with the active backend and the current motor direction.
2. Sets the motor speed on the revolute joint through the Box2D joint API.
3. Reverses the stored motor direction before applying the new speed.
4. Reads the active Box2D backend version.
5. Enables this script only when the project is running the Box2D V2 backend.
6. Stops the script early when Box2D V2 is not active.
7. Acquires input focus so this script can receive click or touch input.
8. Reads the editor-placed pivot and arm positions used to calculate the local joint anchor.
9. Gets the Box2D body from the static `pivot` collision object.
10. Gets the Box2D body from the dynamic `arm` collision object.
11. Disables gravity on the arm body so the example focuses on the joint motor.
12. Converts the pivot world position into the arm's local space using the editor positions. This keeps the arm rotating around the visible pivot.
13. Creates a revolute joint with its motor enabled. The revolute joint provides the pivot, while the motor drives the rotation.
14. Skips input handling if this script is inactive.
15. Handles a click or touch press and uses it to reverse the motor direction.
16. Destroys the runtime-created joint during cleanup.
17. Releases input focus when the script or collection is unloaded.
]]
