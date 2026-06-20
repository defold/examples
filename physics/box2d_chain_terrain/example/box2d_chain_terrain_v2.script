local BALL_START_POSITION = vmath.vector3(650, 545, 0)
local BALL_VELOCITY = vmath.vector3(-140, 0, 0)
local CHAIN_COLOR = vmath.vector4(0.1, 0.8, 0.9, 1.0)
local PREV_GHOST_VERTEX = vmath.vector3(715, 505, 0) -- <1>
local NEXT_GHOST_VERTEX = vmath.vector3(35, 235, 0) -- <2>

local TERRAIN_VERTICES = { -- <3>
	vmath.vector3(650, 480, 0),
	vmath.vector3(560, 455, 0),
	vmath.vector3(470, 395, 0),
	vmath.vector3(380, 380, 0),
	vmath.vector3(300, 315, 0),
	vmath.vector3(210, 275, 0),
	vmath.vector3(95, 265, 0),
}

local function create_chain(body)
	return b2d.body.create_fixture(body, { -- <4>
		density = 0.0,
		friction = 0.65,
		restitution = 0.2,
		shape = {
			type = b2d.shape.SHAPE_TYPE_CHAIN, -- <5>
			vertices = TERRAIN_VERTICES,
			prev_vertex = PREV_GHOST_VERTEX,
			next_vertex = NEXT_GHOST_VERTEX,
		},
	})
end

local function delete_ball(self)
	if self.ball_id then -- <6>
		go.delete(self.ball_id)
		self.ball_id = nil
	end
end

local function spawn_ball(self)
	delete_ball(self) -- <7>

	self.ball_id = factory.create("#ball_factory", BALL_START_POSITION) -- <8>

	local ball_body = b2d.get_body(msg.url(nil, self.ball_id, "collisionobject")) -- <9>
	if b2d.body.set_active then -- <10>
		b2d.body.set_active(ball_body, true) -- <11>
	end
	b2d.body.set_linear_velocity(ball_body, BALL_VELOCITY) -- <12>
	b2d.body.set_angular_velocity(ball_body, -4.0) -- <13>
end

local function start_reset_timer(self)
	if self.reset_timer then -- <14>
		timer.cancel(self.reset_timer)
	end

	self.reset_timer = timer.delay(2.5, true, function() -- <15>
		spawn_ball(self)
	end)
end

function init(self)
	local b2d_version = b2d.get_version() -- <16>
	self.active = b2d_version.major == 2 -- <17>

	if not self.active then -- <18>
		return
	end

	msg.post(".", "acquire_input_focus") -- <19>
	label.set_text("#label", "Box2D V2 chain terrain\nClick or touch to reset") -- <20>

	local terrain_body = b2d.get_body(msg.url(nil, "terrain", "collisionobject")) -- <21>
	self.chain = create_chain(terrain_body) -- <22>

	spawn_ball(self)
	start_reset_timer(self)
end

-------------------
-- Input handling:

local TOUCH = hash("touch")

function on_input(self, action_id, action)
	if not self.active then	 -- <23>
		return
	end

	if action_id == TOUCH and action.pressed then -- <24>
		spawn_ball(self)
		start_reset_timer(self) -- <25>
	end
end

-------------------
-- Debug draw only:

local function draw_line(from, to, color)
	msg.post("@render:", "draw_line", { start_point = from, end_point = to, color = color }) -- <26>
end

local function draw_chain()
	for i = 1, #TERRAIN_VERTICES - 1 do -- <27>
		draw_line(TERRAIN_VERTICES[i], TERRAIN_VERTICES[i + 1], CHAIN_COLOR)
	end
end

function update(self, dt)
	if self.active then
		draw_chain()	-- <28>
	end
end

--[[
1. Defines the ghost vertex before the first chain vertex. Box2D uses it to calculate smoother contacts at the open start of the chain.
2. Defines the ghost vertex after the last chain vertex. It helps avoid unwanted edge catching at the open end of the chain.
3. Defines the terrain path. The same points are used for the Box2D chain shape and the debug line visualization.
4. Creates a Box2D V2 fixture on the terrain body. In Box2D V2, a fixture attaches a collision shape and material properties to a body.
5. Selects a chain shape. A chain is an open sequence of connected line segments, useful for terrain collision.
6. Checks whether a previously spawned ball exists before deleting it.
7. Removes the previous ball before spawning a new one, so the example only has one active ball at a time.
8. Spawns a new ball from the factory at the configured start position.
9. Gets the Box2D body from the spawned ball’s `collisionobject` component.
10. Checks whether this Box2D V2 build exposes explicit body activation.
11. Activates the spawned body through the Box2D V2 API when `set_active()` is available.
12. Sets the ball’s linear velocity through the Box2D V2 body API.
13. Sets the ball’s angular velocity through the Box2D V2 body API so it starts spinning.
14. Cancels the previous reset timer before creating a new one. This prevents multiple repeating timers from running at the same time.
15. Starts a repeating timer that respawns the ball, so the chain interaction keeps replaying without input.
16. Reads the active Box2D backend version.
17. Enables this example only when the project is running the Box2D V2 backend.
18. Stops the script early when Box2D V2 is not active, because the example uses V2-specific API calls.
19. Acquires input focus so this script can receive click or touch input.
20. Updates the label with a short description and reset instruction.
21. Gets the Box2D body from the `terrain` collision object placed in the collection.
22. Adds the runtime chain fixture to the terrain body.
23. Skips input handling if this script is inactive.
24. Handles a click or touch press and uses it as a manual reset for the ball.
25. Restarts the repeating timer after manual input, so the next automatic reset waits for a full interval.
26. Draws one debug line through the render socket. These lines are temporary and must be sent every frame.
27. Draws each segment of the terrain path as a debug line so the invisible chain shape is visible.
28. If this script is active, draws the chain each frame.
]]