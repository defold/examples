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
	return b2d.body.create_chain(body, { -- <4>
		vertices = TERRAIN_VERTICES,
		prev_vertex = PREV_GHOST_VERTEX,
		next_vertex = NEXT_GHOST_VERTEX,
		friction = 0.65,
		restitution = 0.2,
	})
end

local function delete_ball(self)
	if self.ball_id then -- <5>
		go.delete(self.ball_id)
		self.ball_id = nil
	end
end

local function spawn_ball(self)
	delete_ball(self) -- <6>

	self.ball_id = factory.create("#ball_factory", BALL_START_POSITION) -- <7>

	local ball_body = b2d.get_body(msg.url(nil, self.ball_id, "collisionobject")) -- <8>
	if b2d.body.set_active then -- <9>
		b2d.body.set_active(ball_body, true) -- <10>
	end
	b2d.body.set_linear_velocity(ball_body, BALL_VELOCITY) -- <11>
	b2d.body.set_angular_velocity(ball_body, -4.0) -- <12>
end

local function start_reset_timer(self)
	if self.reset_timer then -- <13>
		timer.cancel(self.reset_timer)
	end

	self.reset_timer = timer.delay(2.5, true, function() -- <14>
		spawn_ball(self)
	end)
end

function init(self)
	local b2d_version = b2d.get_version() -- <15>
	self.active = b2d_version.major == 3 -- <16>

	if not self.active then -- <17>
		return
	end

	msg.post(".", "acquire_input_focus") -- <18>
	label.set_text("#label", "Box2D V3 chain terrain\nClick or touch to reset") -- <19>

	local terrain_body = b2d.get_body(msg.url(nil, "terrain", "collisionobject")) -- <20>
	self.chain, self.chain_segments = create_chain(terrain_body) -- <21>

	spawn_ball(self)
	start_reset_timer(self)
end

-------------------
-- Input handling:

local TOUCH = hash("touch")

function on_input(self, action_id, action)
	if not self.active then -- <22>
		return
	end

	if action_id == TOUCH and action.pressed then -- <23>
		spawn_ball(self)
		start_reset_timer(self) -- <24>
	end
end

-------------------
-- Debug draw only:

local function draw_line(from, to, color)
	msg.post("@render:", "draw_line", { start_point = from, end_point = to, color = color }) -- <25>
end

local function draw_chain()
	for i = 1, #TERRAIN_VERTICES - 1 do -- <26>
		draw_line(TERRAIN_VERTICES[i], TERRAIN_VERTICES[i + 1], CHAIN_COLOR)
	end
end

function update(self, dt)
	if self.active then
		draw_chain() -- <27>
	end
end

--[[
1. Defines the ghost vertex before the first chain vertex. Box2D uses it to calculate smoother contacts at the open start of the chain.
2. Defines the ghost vertex after the last chain vertex. It helps avoid unwanted edge catching at the open end of the chain.
3. Defines the terrain path. The same points are used for the Box2D chain and the debug line visualization.
4. Creates a Box2D V3 chain on the terrain body. In V3, the chain is created directly on the body instead of being added as a V2 fixture.
5. Checks whether a previously spawned ball exists before deleting it.
6. Removes the previous ball before spawning a new one, so the example only has one active ball at a time.
7. Spawns a new ball from the factory at the configured start position.
8. Gets the Box2D body from the spawned ball’s `collisionobject` component.
9. Checks whether this Box2D build exposes explicit body activation.
10. Activates the spawned body through the Box2D body API when `set_active()` is available.
11. Sets the ball’s linear velocity through the Box2D body API.
12. Sets the ball’s angular velocity through the Box2D body API so it starts spinning.
13. Cancels the previous reset timer before creating a new one. This prevents multiple repeating timers from running at the same time.
14. Starts a repeating timer that respawns the ball, so the chain interaction keeps replaying without input.
15. Reads the active Box2D backend version.
16. Enables this example only when the project is running the Box2D V3 backend.
17. Stops the script early when Box2D V3 is not active, because the example uses V3-specific API calls.
18. Acquires input focus so this script can receive click or touch input.
19. Updates the label with a short description and reset instruction.
20. Gets the Box2D body from the `terrain` collision object placed in the collection.
21. Adds the runtime V3 chain to the terrain body and keeps the returned chain handles alive.
22. Skips input handling if this script is inactive.
23. Handles a click or touch press and uses it as a manual reset for the ball.
24. Restarts the repeating timer after manual input, so the next automatic reset waits for a full interval.
25. Draws one debug line through the render socket. These lines are temporary and must be sent every frame.
26. Draws each segment of the terrain path as a debug line so the invisible chain is visible.
27. If this script is active, draws the chain each frame.
]]