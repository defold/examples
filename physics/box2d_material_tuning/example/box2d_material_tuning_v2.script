go.property("material", hash("Material")) -- <1>
go.property("density", 1.0)
go.property("friction", 0.2)
go.property("restitution", 0.2)
go.property("velocity", vmath.vector3())
go.property("spin", 0.0)
go.property("tint", vmath.vector4(1, 1, 1, 1))

local MATERIAL_NAMES = {
	[hash("Ice")] = "Ice",
	[hash("Rubber")] = "Rubber",
	[hash("Gold")] = "Gold",
}

local function label_text(self, density, friction, restitution)
	local name = MATERIAL_NAMES[self.material] or "Material"
	return string.format("%s V2\nDensity: %.1f\nFriction: %.2f\nRestit.: %.2f", name, density, friction, restitution)
end

local function configure_material(self)
	local body = b2d.get_body(msg.url(nil, self.ball_id, "collisionobject")) -- <2>
	local fixture = b2d.body.get_fixtures(body)[1] -- <3>
	b2d.fixture.set_density(body, fixture.index, self.density, true) -- <4>
	b2d.fixture.set_friction(body, fixture.index, self.friction) -- <5>
	b2d.fixture.set_restitution(body, fixture.index, self.restitution) -- <6>

	local density = b2d.fixture.get_density(body, fixture.index) -- <7>
	local friction = b2d.fixture.get_friction(body, fixture.index) -- <8>
	local restitution = b2d.fixture.get_restitution(body, fixture.index) -- <9>
	label.set_text("#label", label_text(self, density, friction, restitution)) -- <10>

	return body
end

local function delete_ball(self)
	if self.ball_id then -- <11>
		go.delete(self.ball_id)
		self.ball_id = nil
	end
end

local function respawn_ball(self)
	delete_ball(self) -- <12>

	self.ball_id = factory.create("#ball_factory", go.get_position()) -- <13>
	go.set(msg.url(nil, self.ball_id, "sprite"), "tint", self.tint) -- <14>

	local body = configure_material(self)
	if b2d.body.set_active then -- <15>
		b2d.body.set_active(body, true) -- <16>
	end
	b2d.body.set_linear_velocity(body, self.velocity) -- <17>
	b2d.body.set_angular_velocity(body, self.spin) -- <18>
end

function init(self)
	local b2d_version = b2d.get_version() -- <19>
	self.active = b2d_version.major == 2 -- <20>

	if not self.active then -- <21>
		return
	end

	msg.post(".", "acquire_input_focus") -- <22>
	respawn_ball(self)
end

-------------------
-- Input handling:

local TOUCH = hash("touch")

function on_input(self, action_id, action)
	if not self.active then -- <23>
		return
	end

	if action_id == TOUCH and action.pressed then -- <24>
		respawn_ball(self) -- <25>
	end
end

--[[
1. Exposes the material settings as script properties. Each spawner overrides these values in the collection.
2. Gets the Box2D body from this spawner's current factory-created ball.
3. Gets the first fixture from the ball body. In Box2D V2, a fixture attaches the collision shape and material properties to a body.
4. Sets the fixture density and updates the body mass from the new density.
5. Sets the fixture friction. Low values slide more; high values grip more.
6. Sets the fixture restitution. Low values absorb impact; high values bounce more.
7. Reads the applied density back from the V2 fixture.
8. Reads the applied friction back from the V2 fixture.
9. Reads the applied restitution back from the V2 fixture.
10. Updates the label with the values currently applied to this ball.
11. Checks whether a previously spawned ball exists before deleting it.
12. Removes the previous ball before spawning a new one, so each spawner controls one active ball.
13. Spawns a new ball from the local factory at the spawner's position.
14. Applies this spawner's tint to the spawned ball sprite.
15. Checks whether this Box2D build exposes explicit body activation.
16. Activates the spawned body through the Box2D body API when `set_active()` is available.
17. Sets the ball's linear velocity through the Box2D body API.
18. Sets the ball's angular velocity through the Box2D body API.
19. Reads the active Box2D backend version.
20. Enables this script only when the project is running the Box2D V2 backend.
21. Stops the script early when Box2D V2 is not active, because the example uses V2 fixture API calls.
22. Acquires input focus so this script can receive click or touch input.
23. Skips input handling if this script is inactive.
24. Handles a click or touch press and uses it as a manual reset for the ball.
25. Respawns the ball and reapplies the V2 material settings.
]]
