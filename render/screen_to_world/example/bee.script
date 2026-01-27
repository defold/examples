function init(self)
	-- send input events to this script
	msg.post(".", "acquire_input_focus")
end

function on_input(self, action_id, action)
	if action_id == hash("touch") and action.pressed then
		-- convert mouse/touch screen position to world position
		local screen = vmath.vector3(action.screen_x, action.screen_y, 0)
		local world = camera.screen_to_world(screen, "#camera")

		-- alternative using camera.screen_xy_to_world(x, y, camera)
		-- local world = camera.screen_xy_to_world(action.screen_x, action.screen_y, v)

		-- animate bee to new world position
		go.animate(".", "position", go.PLAYBACK_ONCE_FORWARD, world, go.EASING_LINEAR, 0.5, 0)
	end
end
