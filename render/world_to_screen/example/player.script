go.property("camera_url", msg.url("/camera#camera"))
go.property("hud_url", msg.url("/ui#hud"))
go.property("angle", -45) -- we use this property to animate the rotation of the player around the center of the scene

--- Converts a world position to screen coordinates.
-- This function transforms a 3D world position to 2D screen coordinates using the camera's
-- view and projection matrices. The resulting coordinates are in screen space where (0,0)
-- is the bottom-left corner of the screen.
--
-- @param world_position vector3 The world position to convert.
-- @param camera_url url|string The camera component URL to use for the transformation.
-- @return number screen_x The X coordinate in screen space.
-- @return number screen_y The Y coordinate in screen space.
-- @return number screen_z Always returns 0 (depth information is not preserved).
local function world_to_screen(world_position, camera_url)
	local proj = camera.get_projection(camera_url)
	local view = camera.get_view(camera_url)

	local view_proj = proj * view
	local scr_coord = view_proj * vmath.vector4(world_position.x, world_position.y, world_position.z, 1)
	local w, h = window.get_size()
	scr_coord.x = (scr_coord.x / scr_coord.w + 1) * 0.5 * w
	scr_coord.y = (scr_coord.y / scr_coord.w + 1) * 0.5 * h

	return vmath.vector3(scr_coord.x, scr_coord.y, 0)
end

function init(self)
	-- Get the IDs of the player view and UI objects
	self.player_view_id = go.get_id("player_view")
	self.player_ui_id = go.get_id("player_ui")

	-- Animate vertical position of the body
	local new_pos_y = go.get(self.player_view_id, "position.y") + 0.2
	go.animate(self.player_view_id, "position.y", go.PLAYBACK_LOOP_PINGPONG, new_pos_y, go.EASING_INOUTSINE, 2)

	-- Get the base position
	self.base_pos = go.get_position()

	-- Animate the angle to rotate the player around the center of the scene
	go.animate("#", "angle", go.PLAYBACK_LOOP_FORWARD, -3600 + self.angle, go.EASING_LINEAR, 200)
end

function final(self)
end

function update(self, dt)
	-- Update the position of the player based on the angle and the base position
	local radius = self.base_pos.z
	go.set_position(vmath.vector3(radius * math.sin(math.rad(self.angle)), self.base_pos.y, radius * math.cos(math.rad(self.angle))))
	-- Update the rotation of the player based on the angle
	go.set(".", "euler.y", self.angle + 90)

	-- Update the world transform of the player UI object and convert the world position to screen coordinates
	go.update_world_transform(self.player_ui_id)
	local world_pos = go.get_world_position(self.player_ui_id)
	local screen_pos = world_to_screen(world_pos, self.camera_url)
	-- Send the screen position to the HUD script
	msg.post(self.hud_url, "update_data", { screen_position = screen_pos })
end
