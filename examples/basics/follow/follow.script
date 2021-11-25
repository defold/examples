go.property("speed", 350) -- <1>

function init(self)
    msg.post(".", "acquire_input_focus") -- <2>
end

function on_input(self, action_id, action)
	if action_id == hash("touch") or not action_id then -- <3>
		local current_pos = go.get_position() -- <4>
		local target_pos = vmath.vector3(action.x, action.y, 0) -- <5>
		local distance = vmath.length(target_pos - current_pos) -- <6>
		local duration = distance / self.speed -- <7>
		go.animate(".", "position", go.PLAYBACK_ONCE_FORWARD, target_pos, go.EASING_LINEAR, duration, 0) -- <8>
	end
end

--[[
1. The speed of the game object in pixels/second
2. Tell the engine that this game object ("." is shorthand for the current game object) should listen to input. Any input will be received in the `on_input()` function.
3. Check if we received mouse movement (no action id) or an input action named "touch" (touch or mouse click)
4. Get the current position of the game object.
5. Set the target position to the position of the mouse or touch.
6. Calculate the distance (length) between the current and target position.
7. Calculate the time it takes to travel the distance given the speed of the game object.
8. Animate the game object's ("." is shorthand for the current game object) position to `target_pos`.
--]]
