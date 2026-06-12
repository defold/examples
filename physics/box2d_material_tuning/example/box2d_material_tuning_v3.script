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
	return string.format("%s V3\nDensity: %.1f\nFriction: %.2f\nRestit.: %.2f", name, density, friction, restitution)
end

local function configure_material(self)
	local body = b2d.get_body(msg.url(nil, self.ball_id, "collisionobject")) -- <2>
	local shape = b2d.body.get_shapes(body)[1] -- <3>
	b2d.shape.set_density(body, shape.index, self.density) -- <4>
	b2d.body.reset_mass_data(body) -- <5>
	b2d.shape.set_friction(body, shape.index, self.friction) -- <6>
	b2d.shape.set_restitution(body, shape.index, self.restitution) -- <7>

	local density = b2d.shape.get_density(body, shape.index) -- <8>
	local friction = b2d.shape.get_friction(body, shape.index) -- <9>
	local restitution = b2d.shape.get_restitution(body, shape.index) -- <10>
	label.set_text("#label", label_text(self, density, friction, restitution)) -- <11>

	return body
end

local function delete_ball(self)
	if self.ball_id then -- <12>
		go.delete(self.ball_id)
		self.ball_id = nil
	end
end

local function respawn_ball(self)
	delete_ball(self) -- <13>

	self.ball_id = factory.create("#ball_factory", go.get_position()) -- <14>
	go.set(msg.url(nil, self.ball_id, "sprite"), "tint", self.tint) -- <15>

	local body = configure_material(self)
	if b2d.body.set_active then -- <16>
		b2d.body.set_active(body, true) -- <17>
	end
	b2d.body.set_linear_velocity(body, self.velocity) -- <18>
	b2d.body.set_angular_velocity(body, self.spin) -- <19>
end

function init(self)
	local b2d_version = b2d.get_version() -- <20>
	self.active = b2d_version.major == 3 -- <21>

	if not self.active then -- <22>
		return
	end

	msg.post(".", "acquire_input_focus") -- <23>
	respawn_ball(self)
end

-------------------
-- Input handling:

local TOUCH = hash("touch")

function on_input(self, action_id, action)
	if not self.active then -- <24>
		return
	end

	if action_id == TOUCH and action.pressed then -- <25>
		respawn_ball(self) -- <26>
	end
end

--[[
1. Exposes the material settings as script properties. Each spawner overrides these values in the collection.
2. Gets the Box2D body from this spawner's current factory-created ball.
3. Gets the first shape from the ball body. Box2D V3 uses shapes instead of the V2 fixture API.
4. Sets the shape density through the Box2D V3 shape API.
5. Recalculates the body mass so the new density affects the ball immediately.
6. Sets the shape friction. Low values slide more; high values grip more.
7. Sets the shape restitution. Low values absorb impact; high values bounce more.
8. Reads the applied density back from the V3 shape.
9. Reads the applied friction back from the V3 shape.
10. Reads the applied restitution back from the V3 shape.
11. Updates the label with the values currently applied to this ball.
12. Checks whether a previously spawned ball exists before deleting it.
13. Removes the previous ball before spawning a new one, so each spawner controls one active ball.
14. Spawns a new ball from the local factory at the spawner's position.
15. Applies this spawner's tint to the spawned ball sprite.
16. Checks whether this Box2D build exposes explicit body activation.
17. Activates the spawned body through the Box2D body API when `set_active()` is available.
18. Sets the ball's linear velocity through the Box2D body API.
19. Sets the ball's angular velocity through the Box2D body API.
20. Reads the active Box2D backend version.
21. Enables this script only when the project is running the Box2D V3 backend.
22. Stops the script early when Box2D V3 is not active, because the example uses V3 shape API calls.
23. Acquires input focus so this script can receive click or touch input.
24. Skips input handling if this script is inactive.
25. Handles a click or touch press and uses it as a manual reset for the ball.
26. Respawns the ball and reapplies the V3 material settings.
]]
