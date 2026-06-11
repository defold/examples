local BALL_START = vmath.vector3(650, 545, 0)
local BALL_VELOCITY = vmath.vector3(-140, 0, 0)
local CHAIN_COLOR = vmath.vector4(0.1, 0.8, 0.9, 1.0)
local PREV_GHOST_VERTEX = vmath.vector3(715, 505, 0)
local NEXT_GHOST_VERTEX = vmath.vector3(35, 235, 0)

local TERRAIN_VERTICES = {
	vmath.vector3(650, 480, 0),
	vmath.vector3(560, 455, 0),
	vmath.vector3(470, 395, 0),
	vmath.vector3(380, 380, 0),
	vmath.vector3(300, 315, 0),
	vmath.vector3(210, 275, 0),
	vmath.vector3(95, 265, 0),
}

local function draw_line(from, to, color)
	msg.post("@render:", "draw_line", { start_point = from, end_point = to, color = color }) -- <1>
end

local function get_major_version()
	local version = b2d.get_version()
	if type(version) == "table" then
		return version.major
	end
	return tonumber(string.match(version, "^(%d+)"))
end

local function clear_shapes(body)
	local shapes = b2d.body.get_shapes(body) -- <2>
	for i = #shapes, 1, -1 do
		b2d.body.destroy_shape(body, shapes[i].index) -- <3>
	end
end

local function create_chain(body)
	clear_shapes(body)

	return b2d.body.create_chain(body, {
		vertices = TERRAIN_VERTICES,
		prev_vertex = PREV_GHOST_VERTEX,
		next_vertex = NEXT_GHOST_VERTEX,
		friction = 0.65,
		restitution = 0.2,
	}) -- <4>
end

local function delete_ball(self)
	if self.ball_id then
		go.delete(self.ball_id)
	end
end

local function spawn_ball(self)
	delete_ball(self)
	self.ball_id = factory.create("#ball_factory", BALL_START) -- <5>

	local ball_body = b2d.get_body(msg.url(nil, self.ball_id, "collisionobject"))
	if b2d.body.set_active then
		b2d.body.set_active(ball_body, true) -- <6>
	end
	b2d.body.set_linear_velocity(ball_body, BALL_VELOCITY) -- <7>
	b2d.body.set_angular_velocity(ball_body, -4.0)
end

local function draw_chain()
	for i = 1, #TERRAIN_VERTICES - 1 do
		draw_line(TERRAIN_VERTICES[i], TERRAIN_VERTICES[i + 1], CHAIN_COLOR) -- <8>
	end
end

local function start_reset_timer(self)
	self.reset_timer = timer.delay(2.5, true, function() spawn_ball(self) end) -- <9>
end

local function cancel_reset_timer(self)
	if self.reset_timer then
		timer.cancel(self.reset_timer)
		self.reset_timer = nil
	end
end

function init(self)
	self.active = get_major_version() == 3 -- <10>

	if not self.active then -- <11>
		return
	end

	msg.post(".", "acquire_input_focus")
	local terrain_body = b2d.get_body(msg.url(nil, "terrain", "collisionobject")) -- <12>
	self.chain, self.chain_segments = create_chain(terrain_body) -- <13>
	label.set_text("#label", "Box2D V3 chain\nClick or touch to reset")
	spawn_ball(self)
	start_reset_timer(self)
end

function update(self, dt)
	if self.active then
		draw_chain()
	end
end

local TOUCH = hash("touch")

function on_input(self, action_id, action)
	if not self.active then
		return
	end

	if action_id == TOUCH and action.pressed then -- <14>
		spawn_ball(self)
		cancel_reset_timer(self) -- <15>
		start_reset_timer(self)
	end
end

function final(self)
	if not self.active then
		return
	end

	delete_ball(self)
	cancel_reset_timer(self)
	msg.post(".", "release_input_focus")
end

--[[
1. Draw each terrain segment through the render socket. The lines are transient, so the chain is redrawn every frame.
2. Read the existing Box2D V3 shapes from the placeholder body.
3. Remove the placeholder shape before creating the V3 chain.
4. Create V3 chain terrain with `b2d.body.create_chain()` so ghost vertices are preserved.
5. Spawn one dynamic ball from the local factory at the start of the chain.
6. Explicitly activate the spawned body on backends that expose body activation.
7. Give the ball an initial velocity so it rolls across the terrain immediately.
8. Draw the runtime terrain again each frame because the render line messages do not persist.
9. Replay the ball automatically so the example stays active without input.
10. Detect whether the running engine uses the Box2D V3 backend. The helper accepts both table and string version formats.
11. Leave this script as a no-op when the project uses another backend.
12. Get the Box2D body owned by the hidden `terrain` collision object in the collection.
13. Build the V3 chain terrain and keep both returned handles alive.
14. Clicks and taps reset the ball manually.
15. Reset the repeating timer after manual input so the next automatic reset waits for a full interval.
]]
