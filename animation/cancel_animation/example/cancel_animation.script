function init(self)
	msg.post(".", "acquire_input_focus") -- <1>
	go.animate(".", "position.x", go.PLAYBACK_ONCE_FORWARD, 600, go.EASING_INOUTSINE, 5.0) -- <2>
end

function on_input(self, action_id, action)
	if (action_id == hash("mouse_button_left") or action_id == hash("touch")) and action.pressed then -- <3>
		go.cancel_animations(".", "position") -- <4>
		go.animate(".", "position.x", go.PLAYBACK_ONCE_FORWARD, action.x, go.EASING_INOUTSINE, 1.2) -- <5>
	end
end

--[[
1. Acquire input focus so the script receives mouse clicks and touch presses.
2. Start with a long horizontal animation toward x = 600 so there is something to interrupt.
3. React to either a left mouse click or a touch press.
4. Cancel the running position animation. Defold keeps the property at its current value when the animation is canceled.
5. Start a new animation from that current x position toward the clicked x coordinate.
]]
