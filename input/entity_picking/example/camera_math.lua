local M = {}

--- Convert a point from 2D screen space to 3D world space. Supports only perspective.
-- @param x number X coordinate on screen.
-- @param y number Y coordinate on screen.
-- @param z number The distance from the camera in world space to create the new point.
-- @param camera_id url The camera URL to get params from.
-- @return vector3 The world coordinate.
function M.screen_to_world(x, y, z, camera_id)
	-- Camera properties
	local projection = camera.get_projection(camera_id)
	assert(projection.m33 == 0.0, "Camera must be in perspective mode")

	local cw, ch = window.get_size()
	local aspect_ratio = cw / ch
	local near_z = camera.get_near_z(camera_id)
	local fov = camera.get_fov(camera_id)
	local inv_view = vmath.inv(camera.get_view(camera_id))

	-- Calculate the screen click as a point on the far plane of the normalized device coordinate 'box' (z=1)
	local ndc_x = x / cw * 2 - 1
	local ndc_y = y / ch * 2 - 1

	-- Calculate perspective projection matrix half size at the near plane
	local half_size = vmath.vector4(0, 0, -near_z, 1)
	local h = near_z * math.tan(fov / 2)
	half_size.x = h * aspect_ratio * ndc_x
	half_size.y = h * ndc_y

	-- Transform to world space
	local point = inv_view * half_size

	-- Move to distance z from the camera
	local world_coord = vmath.normalize(vmath.vector3(point.x - inv_view.m03, point.y - inv_view.m13, point.z - inv_view.m23))
	world_coord.x = world_coord.x * z + inv_view.m03
	world_coord.y = world_coord.y * z + inv_view.m13
	world_coord.z = world_coord.z * z + inv_view.m23

	return world_coord
end

return M