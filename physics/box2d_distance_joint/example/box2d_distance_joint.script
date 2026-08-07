-- This example creates two pairs of distance joints at runtime. The left pair
-- keeps a fixed length, while the right pair is configured as a damped spring.

-- Centers of the two demonstrations and settings used when the balls are reset.
local RIGID_CENTER_X = 180
local SPRING_CENTER_X = 540
local BALL_START_Y = 400
local DROP_MAX_OFFSET_X = 80
local DROP_START_VELOCITY = -40
local DROP_INTERVAL = 5.5

-- Both joints attach near the upper corners of a platform. These coordinates
-- are local to the platform, so they rotate and move together with it.
local PLATFORM_ANCHOR_X = 90
local PLATFORM_ANCHOR_Y = 12
local JOINT_LENGTH = 226.56

-- Spring frequency controls stiffness. The damping ratio controls how quickly
-- the spring loses energy: 0 is undamped and 1 is critically damped.
local SPRING_HERTZ = 1.35
local SPRING_DAMPING_RATIO = 0.25

-- The joints have no visual component, so lines are drawn in different colors
-- to make the rigid and spring constraints visible.
local RIGID_LINE_COLOR = vmath.vector4(0.85, 0.9, 1.0, 1.0)
local SPRING_LINE_COLOR = vmath.vector4(1.0, 0.68, 0.2, 1.0)

-- Return the Box2D body handle belonging to a game object's collision object.
-- A body handle is required by the b2d body and joint APIs.
local function body(id)
	return b2d.get_body(msg.url(nil, id, "collisionobject"))
end

-- Ask the render script to draw a debug line for the current frame.
local function draw_line(from, to, color)
	msg.post("@render:", "draw_line", {
		start_point = from,
		end_point = to,
		color = color,
	})
end

-- Connect one static anchor body to one dynamic platform body.
-- `local_anchor` is the attachment point in the platform's local coordinates.
-- `spring` selects between a fixed-length constraint and a damped spring.
local function create_distance_joint(self, anchor, platform, local_anchor, spring)
	local joint = b2d.joint.create_distance(anchor, platform, {
		-- Attach body A at its origin and body B at one corner of the platform.
		local_anchor_a = vmath.vector3(),
		local_anchor_b = local_anchor,
		length = JOINT_LENGTH,
		-- A rigid distance joint solves toward one fixed length. Unlike a revolute
		-- joint, it does not force the two anchor points to occupy the same point.
		enable_spring = spring,
		-- Hertz controls how quickly the spring responds: higher values are stiffer.
		hertz = spring and SPRING_HERTZ or 0,
		-- Damping ratio removes oscillation; 0 has none and 1 is critically damped.
		damping_ratio = spring and SPRING_DAMPING_RATIO or 0,
		-- The connected bodies do not need to collide with each other.
		collide_connected = false,
	})

	-- Keep the handle for drawing the joint now and destroying it during cleanup.
	table.insert(self.connections, {
		joint = joint,
		color = spring and SPRING_LINE_COLOR or RIGID_LINE_COLOR,
	})
end

-- Build one suspended platform from the consistently named collection objects.
-- For example, the "rigid" prefix finds rigid_platform and both rigid anchors.
local function create_setup(self, prefix, spring)
	local platform = body(prefix .. "_platform")
	-- Negative and positive X values attach the joints on opposite sides.
	create_distance_joint(self, body(prefix .. "_left_anchor"), platform,
		vmath.vector3(-PLATFORM_ANCHOR_X, PLATFORM_ANCHOR_Y, 0), spring)
	create_distance_joint(self, body(prefix .. "_right_anchor"), platform,
		vmath.vector3(PLATFORM_ANCHOR_X, PLATFORM_ANCHOR_Y, 0), spring)
end

-- Reposition an existing ball instead of spawning a new one for every drop.
local function reset_body(body_handle, id, position)
	-- Update both the game object and its Box2D body to the same transform.
	go.set_position(position, msg.url(nil, id, nil))
	b2d.body.set_transform(body_handle, position, 0)
	-- Give each ball the same downward start and remove any previous spin.
	b2d.body.set_linear_velocity(body_handle, vmath.vector3(0, DROP_START_VELOCITY, 0))
	b2d.body.set_angular_velocity(body_handle, 0)
	-- A sleeping body must be awakened so that gravity and collisions affect it.
	b2d.body.set_awake(body_handle, true)
end

-- Drop both balls with the same randomly selected horizontal offset. Using the
-- same offset makes their impacts comparable while varying repeated drops.
local function drop_pair(self)
	-- math.random(-1, 1) selects -1, 0, or 1.
	local offset = DROP_MAX_OFFSET_X * math.random(-1, 1)
	reset_body(self.rigid_ball, "rigid_ball", vmath.vector3(RIGID_CENTER_X + offset, BALL_START_Y, 0))
	reset_body(self.spring_ball, "spring_ball", vmath.vector3(SPRING_CENTER_X + offset, BALL_START_Y, 0))
end

function init(self)
	-- Create the four joints and cache the two ball body handles once.
	self.connections = {}
	create_setup(self, "rigid", false)
	create_setup(self, "spring", true)
	self.rigid_ball = body("rigid_ball")
	self.spring_ball = body("spring_ball")

	-- Show the active Box2D major version and perform the first drop immediately.
	local major_b2d_version = b2d.get_version().major
	label.set_text("#title", "Box2D V" .. major_b2d_version .. " distance joint")
	drop_pair(self)

	-- Repeat the drop at a fixed interval. update() is only responsible for drawing.
	self.drop_timer = timer.delay(DROP_INTERVAL, true, function()
		drop_pair(self)
	end)
end

function update(self)
	-- Querying the joint anchors gives their current world-space positions, so
	-- each line stays attached while its platform translates and rotates.
	for _, connection in ipairs(self.connections) do
		draw_line(
			b2d.joint.get_anchor_a(connection.joint),
			b2d.joint.get_anchor_b(connection.joint),
			connection.color
		)
	end
end

function final(self)
	-- Stop the repeating callback before releasing the resources it uses.
	timer.cancel(self.drop_timer)

	-- Joints created through the runtime API must be explicitly destroyed when
	-- the script is removed or the collection is unloaded.
	for _, connection in ipairs(self.connections) do
		b2d.joint.destroy(connection.joint)
	end
end
