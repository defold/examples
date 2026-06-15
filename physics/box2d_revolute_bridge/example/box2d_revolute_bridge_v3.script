local TOUCH = hash("touch")
local MOUSE_BUTTON_LEFT = hash("mouse_button_left")
local SEGMENT_HALF_WIDTH = 24
local START_BALL_POSITION = vmath.vector3(360, 610, 0)

local SEGMENTS = {
	"segment_01",
	"segment_02",
	"segment_03",
	"segment_04",
	"segment_05",
	"segment_06",
	"segment_07",
	"segment_08",
	"segment_09",
	"segment_10",
}

local function body(id)
	return b2d.get_body(msg.url(nil, id, "collisionobject")) -- <1>
end

local function create_joint(self, body_a, body_b, local_anchor_a, local_anchor_b)
	local joint = b2d.joint.create_revolute(body_a, body_b, { -- <2>
		local_anchor_a = local_anchor_a,
		local_anchor_b = local_anchor_b,
		collide_connected = false,
	})
	table.insert(self.joints, joint)
end

local function reset_body(body, position)
	b2d.body.set_transform(body, position, 0) -- <3>
	b2d.body.set_linear_velocity(body, vmath.vector3())
	b2d.body.set_angular_velocity(body, 0)
	b2d.body.set_awake(body, true)
end

local function reset_ball(self)
	go.set_position(START_BALL_POSITION, msg.url(nil, "ball", nil)) -- <4>
	reset_body(self.ball, START_BALL_POSITION) -- <5>
	b2d.body.set_linear_velocity(self.ball, vmath.vector3(0, -80, 0)) -- <6>
end

local function create_bridge(self)
	self.joints = {}

	local previous = body("left_anchor")
	for index, segment_id in ipairs(SEGMENTS) do
		local current = body(segment_id)

		local anchor_a = index == 1 and vmath.vector3() or vmath.vector3(SEGMENT_HALF_WIDTH, 0, 0)
		create_joint(self, previous, current, anchor_a, vmath.vector3(-SEGMENT_HALF_WIDTH, 0, 0)) -- <7>
		previous = current
	end

	create_joint(self, previous, body("right_anchor"), vmath.vector3(SEGMENT_HALF_WIDTH, 0, 0), vmath.vector3()) -- <8>
	self.ball = body("ball")
end

function init(self)
	self.active = b2d.get_version().major == 3 -- <9>
	if not self.active then
		return
	end

	label.set_text("#title", "Box2D V3 revolute bridge")
	create_bridge(self)
	reset_ball(self)
	msg.post(".", "acquire_input_focus") -- <10>
end

function on_input(self, action_id, action)
	if self.active and (action_id == TOUCH or action_id == MOUSE_BUTTON_LEFT) and action.pressed then -- <11>
		reset_ball(self)
	end
end

function final(self)
	if not self.active then
		return
	end

	for _, joint in ipairs(self.joints) do
		b2d.joint.destroy(joint) -- <12>
	end
	msg.post(".", "release_input_focus")
end

--[[
1. Get the native Box2D body owned by a Defold collision object in the collection.
2. Create one revolute joint. The local anchors define the hinge point on each connected body.
3. Reset a dynamic body to a known transform and clear its previous motion.
4. Move the visible ball game object back above the bridge so the reset is immediate.
5. Move the Box2D body to the same position and clear old motion.
6. Give the ball a small downward velocity so the reset immediately drops it onto the bridge.
7. Connect each segment to the previous body. The first segment connects to the left static anchor.
8. Connect the last segment to the right static anchor, completing the bridge.
9. Run this script only when the active Box2D backend is V3.
10. Acquire input so a click or touch can reset the ball.
11. Reset the ball when the user clicks or taps. The built-in input binding may send mouse clicks as `mouse_button_left` or `touch`.
12. Destroy the scripted joints when the collection is finalized.
]]
