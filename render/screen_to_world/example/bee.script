local DISPLAY_WIDTH = sys.get_config_int("display.width")
local DISPLAY_HEIGHT = sys.get_config_int("display.height")

-- function to convert screen (mouse/touch) coordinates to
-- world coordinates given a camera component
-- this function will use the camera view and projection to
-- translate the screen coordinates into world coordinates
local function screen_to_world(x, y, z, camera_id)
	local projection = camera.get_projection(camera_id)
	local view = camera.get_view(camera_id)
	local w, h = window.get_size()
	-- The window.get_size() function will return the scaled window size,
	-- ie taking into account display scaling (Retina screens on macOS for
	-- instance). We need to adjust for display scaling in our calculation.
	w = w / (w / DISPLAY_WIDTH)
	h = h / (h / DISPLAY_HEIGHT)

	-- https://defold.com/manuals/camera/#converting-mouse-to-world-coordinates
	local inv = vmath.inv(projection * view)
	x = (2 * x / w) - 1
	y = (2 * y / h) - 1
	z = (2 * z) - 1
	local x1 = x * inv.m00 + y * inv.m01 + z * inv.m02 + inv.m03
	local y1 = x * inv.m10 + y * inv.m11 + z * inv.m12 + inv.m13
	local z1 = x * inv.m20 + y * inv.m21 + z * inv.m22 + inv.m23
	return x1, y1, z1
end

function init(self)
	-- send input events to this script
	msg.post(".", "acquire_input_focus")
end

function on_input(self, action_id, action)
	if action_id == hash("touch") and action.pressed then
		-- convert mouse/touch screen position to world position
		local worldx, worldy = screen_to_world(action.x, action.y, 0, "#camera")
		local world = vmath.vector3(worldx, worldy, 0)
		go.animate(".", "position", go.PLAYBACK_ONCE_FORWARD, world, go.EASING_LINEAR, 0.5, 0, moved_to_position) -- <8>
	end
end