-- Half of the block size is needed for specifying where the weld will be
local BLOCK_HALF_SIZE = 40

-- Helper function to create a single weld joint between two bodies
local function create_weld(self, body_a, body_b, local_anchor_a, local_anchor_b)
	local joint = b2d.joint.create_weld(body_a, body_b, {
		-- Local anchors mark the touching edges that should stay locked together.
		local_anchor_a = local_anchor_a,
		local_anchor_b = local_anchor_b,

		-- The blocks start with the same rotation, so their desired relative angle is zero.
		reference_angle = 0.0,
		collide_connected = false,
	})

	-- We additionally store the created joints references in order to remove them later
	table.insert(self.joints, joint)
end

-- Helper function to create the 2 weld joints in the example
local function create_welds(self)
	-- Weld the right block to the center block at their shared vertical edge.
	create_weld(self, self.center, self.right, vmath.vector3(BLOCK_HALF_SIZE, 0, 0), vmath.vector3(-BLOCK_HALF_SIZE, 0, 0))

	-- Weld the lower block to the center block at their shared horizontal edge.
	create_weld(self, self.center, self.lower, vmath.vector3(0, -BLOCK_HALF_SIZE, 0), vmath.vector3(0, BLOCK_HALF_SIZE, 0))
end

function init(self)
	-- `b2d.get_body()` returns the native Box2D body created by the given collision object.
	self.center = b2d.get_body("/center#collisionobject")
	self.right = b2d.get_body("/right#collisionobject")
	self.lower = b2d.get_body("/lower#collisionobject")

	-- Create a table for joints references and then create weld joints in the example
	self.joints = {}
	create_welds(self)

	-- Acquire input focus to handle inputs
	msg.post(".", "acquire_input_focus")
end

local TOUCH = hash("touch")

function on_input(self, action_id, action)
	-- The built-in touch action also covers mouse clicks in the built-in all.input_binding.
	if action_id == TOUCH and action.pressed then
		-- The weld joints transfer this velocity change through the whole L-shaped cluster.
		b2d.body.set_linear_velocity(self.right, vmath.vector3(math.random(-300,300), 900, 0))
		b2d.body.set_angular_velocity(self.right, math.random(-10,10))
	end
end

function final(self)
	-- Joints created through b2d.joint should be explicitly destroyed.
	for _, joint in ipairs(self.joints) do
		b2d.joint.destroy(joint)
	end

	-- Release input focus
	msg.post(".", "release_input_focus")
end
