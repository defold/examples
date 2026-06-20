local TOUCH = hash("touch")
local MOTOR_SPEED = 1.5
local MAX_MOTOR_TORQUE = 50000

local function update_label(self)
	local direction = self.direction > 0 and "counter-clockwise" or "clockwise"
	label.set_text("#label", string.format("Box2D V3 motor joint\nMotor: %s\nClick or touch to reverse", direction)) -- <1>
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
	self.active = b2d_version.major == 3 -- <5>

	if not self.active then -- <6>
		return
	end

	msg.post(".", "acquire_input_focus") -- <7>

	local world = b2d.get_world() -- <8>
	b2d.world.set_gravity(world, vmath.vector3()) -- <9>
	b2d.world.set_joint_tuning(world, 60, 1.0) -- <10>

	local pivot_position = go.get_position("pivot") -- <11>
	local pivot = b2d.get_body(msg.url(nil, "pivot", "collisionobject")) -- <12>
	local arm = b2d.get_body(msg.url(nil, "arm", "collisionobject")) -- <13>
	b2d.body.set_gravity_scale(arm, 0.0) -- <14>

	local arm_anchor = b2d.body.get_local_point(arm, pivot_position) -- <15>

	self.joint = b2d.joint.create_revolute(pivot, arm, { -- <16>
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
	if not self.active then -- <17>
		return
	end

	if action_id == TOUCH and action.pressed then -- <18>
		reverse_motor(self)
	end
end

function final(self)
	if not self.active then
		return
	end

	if self.joint then
		b2d.joint.destroy(self.joint) -- <19>
		self.joint = nil
	end

	msg.post(".", "release_input_focus") -- <20>
end

--[[
1. Updates the label with the active backend and the current motor direction.
2. Sets the motor speed on the revolute joint through the Box2D joint API.
3. Reverses the stored motor direction before applying the new speed.
4. Reads the active Box2D backend version.
5. Enables this script only when the project is running the Box2D V3 backend.
6. Stops the script early when Box2D V3 is not active.
7. Acquires input focus so this script can receive click or touch input.
8. Gets the current Box2D world handle.
9. Clears world gravity so the arm stays in the editor-placed setup.
10. Tunes the Box2D V3 joint solver used by the motorized joint.
11. Reads the editor-placed pivot position, which is the world point the arm should rotate around.
12. Gets the Box2D body from the static `pivot` collision object.
13. Gets the Box2D body from the dynamic `arm` collision object.
14. Disables gravity on the arm body so the example focuses on the joint motor.
15. Converts the pivot world position into the arm's local space using the V3 body helper. This keeps the arm rotating around the visible pivot.
16. Creates a revolute joint with its motor enabled. The revolute joint provides the pivot, while the motor drives the rotation.
17. Skips input handling if this script is inactive.
18. Handles a click or touch press and uses it to reverse the motor direction.
19. Destroys the runtime-created joint during cleanup.
20. Releases input focus when the script or collection is unloaded.
]]
