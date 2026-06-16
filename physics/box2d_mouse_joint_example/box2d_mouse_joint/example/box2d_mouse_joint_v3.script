local TOUCH = hash("touch")

local START_TARGET = vmath.vector3(360, 420, 0)
local SOFT_START = vmath.vector3(270, 310, 0)
local TIGHT_START = vmath.vector3(450, 310, 0)

local SOFT_LINE_COLOR = vmath.vector4(1.0, 0.65, 0.22, 1.0)
local TIGHT_LINE_COLOR = vmath.vector4(0.35, 0.85, 1.0, 1.0)
local TARGET_LINE_COLOR = vmath.vector4(0.45, 1.0, 0.65, 1.0)

local function draw_line(from, to, color)
	-- <1> Draw a debug/helper line through the render socket.
	-- These lines are not persistent scene objects. They exist for one frame,
	-- so the script redraws them every update.
	msg.post("@render:", "draw_line", {
		start_point = from,
		end_point = to,
		color = color
	})
end

local function set_target(self, position)
	-- <2> Store the current mouse-joint target as a world-space position.
	-- The mouse joint does not connect to a real "mouse body". It tracks this
	-- world point, which we later pass to b2d.joint.set_mouse_target().
	self.target = vmath.vector3(position.x, position.y, 0)

	-- <3> Move the visible target marker so users can see what point the
	-- mouse joints are trying to follow.
	go.set_position(self.target, self.target_url)
end

local function reset_body(body, position)
	-- <4> Teleport the physics body to a known start position.
	-- b2d.body.set_transform() directly sets the Box2D body's world transform.
	-- This is useful for setup/reset, but should generally not be used every
	-- frame for normal gameplay motion because it bypasses physical simulation.
	b2d.body.set_transform(body, position, 0)

	-- <5> Clear leftover motion so both bodies start the example cleanly.
	b2d.body.set_linear_velocity(body, vmath.vector3())
	b2d.body.set_angular_velocity(body, 0)

	-- <6> Wake the body so Box2D immediately simulates it after the reset.
	-- This is safer here than relying on b2d.joint.wake_bodies(), which may not
	-- be available in all beta/V2 runtime builds.
	b2d.body.set_awake(body, true)
end

local function setup_body(body)
	-- <7> Disable gravity for this body.
	-- A mouse joint is easiest to understand when the only visible force is the
	-- spring-like pull toward the target, not gravity pulling the body downward.
	b2d.body.set_gravity_scale(body, 0)

	-- <8> Prevent rotation.
	-- This keeps the demo visually focused on mouse-joint translation/stretching
	-- instead of the boxes spinning while they follow the target.
	b2d.body.set_fixed_rotation(body, true)

	-- <9> Add linear damping.
	-- This damps velocity over time and helps the bodies settle instead of
	-- sliding forever after the target moves.
	b2d.body.set_linear_damping(body, 1.5)
end

local function create_mouse_joints(self)
	-- <10> Get native Box2D body handles from Defold collision object components.
	-- b2d.get_body() takes a collision object URL and returns the b2Body handle
	-- used by the new Box2D scripting API.
	local anchor_body = b2d.get_body(msg.url(nil, "target", "collisionobject"))
	self.soft_body = b2d.get_body(msg.url(nil, "soft_body", "collisionobject"))
	self.tight_body = b2d.get_body(msg.url(nil, "tight_body", "collisionobject"))

	setup_body(self.soft_body)
	setup_body(self.tight_body)

	reset_body(self.soft_body, SOFT_START)
	reset_body(self.tight_body, TIGHT_START)

	-- <11> Create the softer mouse joint.
	-- A mouse joint connects two Box2D bodies, but its main job is to make body_b
	-- follow a world-space target point. Here the target object acts as the
	-- static reference body, and soft_body is the dynamic body being pulled.
	self.soft_joint = b2d.joint.create_mouse(anchor_body, self.soft_body, {
		-- <12> Initial world target. This will be updated every frame later.
		target = self.target,

		-- <13> Maximum force the joint is allowed to apply.
		-- Lower values make the body lag behind more because the joint cannot
		-- instantly pull it to the target.
		max_force = 850,

		-- <14> Spring frequency in Box2D V3 terms.
		-- Lower hertz means a softer, slower spring.
		hertz = 1.5,

		-- <15> Damping ratio controls how much oscillation is removed.
		-- Lower damping allows more elastic movement and visible overshoot.
		damping_ratio = 0.35,

		-- <16> The connected bodies should not collide with each other.
		-- This is usually what you want for a joint demonstration.
		collide_connected = false,
	})

	-- <17> Create the tighter mouse joint.
	-- It follows the same target, but with much stronger spring settings.
	self.tight_joint = b2d.joint.create_mouse(anchor_body, self.tight_body, {
		target = self.target,

		-- <18> Higher max_force lets the joint pull harder.
		max_force = 6500,

		-- <19> Higher hertz means the spring reacts faster and feels stiffer.
		hertz = 8.0,

		-- <20> Higher damping removes oscillation, so the body follows in a
		-- tighter, more controlled way.
		damping_ratio = 0.9,

		collide_connected = false,
	})
end

local function update_auto_target(self, dt)
	if self.user_control then
		return
	end

	-- <21> Animate the target before the user touches/clicks.
	-- This keeps the example alive on the website even without interaction.
	self.time = self.time + dt

	set_target(self, vmath.vector3(
	360 + math.cos(self.time * 1.35) * 170,
	395 + math.sin(self.time * 1.10) * 95,
	0
))
end

local function update_joints(self)
-- <22> Update both mouse joints with the current target.
-- This is the key runtime control call. The joint was created once in init(),
-- but its target can be changed every frame.
b2d.joint.set_mouse_target(self.soft_joint, self.target)
b2d.joint.set_mouse_target(self.tight_joint, self.target)

-- <23> Make sure the bodies are awake when the target moves.
-- Sleeping bodies may not visibly react until woken by the simulation.
b2d.body.set_awake(self.soft_body, true)
b2d.body.set_awake(self.tight_body, true)
end

local function draw_connections(self)
-- <24> Query the current simulated body positions from Box2D.
-- We draw lines from the target to each body to visualize the stretch of
-- each mouse joint.
local soft_position = b2d.body.get_position(self.soft_body)
local tight_position = b2d.body.get_position(self.tight_body)

draw_line(self.target, soft_position, SOFT_LINE_COLOR)
draw_line(self.target, tight_position, TIGHT_LINE_COLOR)

-- <25> Draw a small cross at the target point so the user can clearly see
-- what the bodies are following.
draw_line(self.target + vmath.vector3(-18, 0, 0), self.target + vmath.vector3(18, 0, 0), TARGET_LINE_COLOR)
draw_line(self.target + vmath.vector3(0, -18, 0), self.target + vmath.vector3(0, 18, 0), TARGET_LINE_COLOR)
end

function init(self)
-- <26> Run this script only when the active Box2D backend is V3.
-- The same collection can include both V2 and V3 scripts, but only one
-- should initialize depending on the current app manifest/backend.
self.active = b2d.get_version().major == 3

if not self.active then
	return
end

self.target_url = msg.url(nil, "target", nil)
self.time = 0
self.user_control = false

set_target(self, START_TARGET)
create_mouse_joints(self)

-- <27> Show which backend-specific script is active.
label.set_text("/info#version_label", "Box2D V3 mouse joint")

-- <28> Acquire input focus so this script receives mouse/touch input in
-- on_input().
msg.post(".", "acquire_input_focus")
end

function update(self, dt)
if not self.active then
	return
end

update_auto_target(self, dt)
update_joints(self)
draw_connections(self)
end

function on_input(self, action_id, action)
if not self.active then
	return
end

-- <29> Mouse input commonly arrives with action_id == nil, while touch input
-- uses the "touch" binding. Both provide screen-space x/y coordinates here.
if (action_id == TOUCH or action_id == nil) and action.x and action.y then
	self.user_control = true
	set_target(self, vmath.vector3(action.x, action.y, 0))
end
end

function final(self)
if not self.active then
	return
end

-- <30> Destroy scripted joints explicitly when the script is finalized.
-- This keeps the example clean when the collection is unloaded or hot-reloaded.
b2d.joint.destroy(self.soft_joint)
b2d.joint.destroy(self.tight_joint)

msg.post(".", "release_input_focus")
end

--[[
1. `@render:` is Defold's render socket. The "draw_line" message draws a temporary helper line.
2. A mouse joint follows a world-space target point. It does not require the mouse itself to be a physics body.
3. The target marker is only visual. Moving it makes the invisible target position understandable.
4. `b2d.body.set_transform()` directly sets the Box2D body position and angle. Good for reset/setup, not for continuous gameplay movement.
5. Clearing velocity prevents the reset state from inheriting old momentum.
6. `b2d.body.set_awake()` forces the body to participate in simulation immediately.
7. `b2d.body.set_gravity_scale(body, 0)` disables gravity for this body only.
8. `b2d.body.set_fixed_rotation(body, true)` prevents the body from rotating, keeping the example readable.
9. `b2d.body.set_linear_damping()` makes velocity decay over time, reducing endless drift.
10. `b2d.get_body()` converts a Defold collision object component URL into a native Box2D body handle.
11. `b2d.joint.create_mouse()` creates a mouse joint between two bodies. The second body is the one visibly pulled toward the target.
12. `target` is the initial world-space point the mouse joint tries to follow.
13. `max_force` caps the force used by the joint. Too low = very stretchy; higher = stronger pull.
14. `hertz` is the V3 spring frequency. Lower values feel softer, higher values feel tighter.
15. `damping_ratio` controls oscillation. Lower values bounce more; higher values settle faster.
16. `collide_connected = false` prevents the two bodies connected by the joint from colliding.
17. The tight joint uses the same API but different parameters, demonstrating how tuning changes the feel.
18. Higher `max_force` allows stronger correction toward the target.
19. Higher `hertz` makes the constraint respond faster.
20. Higher `damping_ratio` removes more bounce.
21. Automatic target motion makes the example self-demonstrating.
22. `b2d.joint.set_mouse_target()` updates the world target of an existing mouse joint every frame.
23. Waking bodies avoids cases where sleeping physics bodies do not react immediately to the changed target.
24. `b2d.body.get_position()` reads the current simulated world position from Box2D.
25. The target cross is a visual helper, not part of the physics simulation.
26. `b2d.get_version().major` lets one shared collection choose the correct backend-specific script.
27. `label.set_text()` updates the on-screen backend label.
28. `acquire_input_focus` is required before this script receives `on_input()` callbacks.
29. Pointer input takes over from automatic motion and drives the mouse-joint target directly.
30. `b2d.joint.destroy()` removes joints created through the scripted joint API.
]]