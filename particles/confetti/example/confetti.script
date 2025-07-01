local function single_shot()
	particlefx.play("#particles") -- <1>
end

function init(self)
	single_shot()

	timer.delay(3, true, single_shot) -- <2>

	msg.post(".", "acquire_input_focus")
end

function on_input(self, action_id, action)
	if action_id == hash("mouse_button_left") and action.pressed then -- <3>
		single_shot()
	end
end

--[[
1. Start playing the particle effect in component "particles" in this game object.
2. Setup timer to do a single shot of confetti every 3 seconds.
3. Play the effect when left mouse button (or touch) is pressed.
--]]
