local BLOCK_HALF_SIZE = 40

local function create_weld(self, body_a, body_b, local_anchor_a, local_anchor_b)
	local joint = b2d.joint.create_weld(body_a, body_b, {
		-- Local anchors mark the touching edges that should stay locked together.
		local_anchor_a = local_anchor_a,
		local_anchor_b = local_anchor_b,

		-- The blocks start with the same rotation, so their desired relative angle is zero.
		reference_angle = 0.0,
		collide_connected = false,
	})

	table.insert(self.joints, joint)
end

local function create_welds(self)
	-- Weld the right block to the center block at their shared vertical edge.
	create_weld(self, self.center, self.right, vmath.vector3(BLOCK_HALF_SIZE, 0, 0), vmath.vector3(-BLOCK_HALF_SIZE, 0, 0))

	-- Weld the lower block to the center block at their shared horizontal edge.
	create_weld(self, self.center, self.lower, vmath.vector3(0, -BLOCK_HALF_SIZE, 0), vmath.vector3(0, BLOCK_HALF_SIZE, 0))
end

function init(self)
	self.center = b2d.get_body("/center#collisionobject")
	self.right = b2d.get_body("/right#collisionobject")
	self.lower = b2d.get_body("/lower#collisionobject")

	self.joints = {}

	create_welds(self)

	msg.post(".", "acquire_input_focus")
end

function final(self)
	for _, joint in ipairs(self.joints) do
		b2d.joint.destroy(joint)
	end

	msg.post(".", "release_input_focus")
end

local TOUCH = hash("touch")

function on_input(self, action_id, action)
	if action_id == TOUCH and action.pressed then
		-- The welds transfer this velocity change through the whole L-shaped cluster.
		b2d.body.set_linear_velocity(self.right, vmath.vector3(math.random(-300,300), 900, 0))
		b2d.body.set_angular_velocity(self.right, math.random(-10,10))
	end
end
