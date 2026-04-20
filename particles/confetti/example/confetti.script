local function single_shot()
	particlefx.play("#confetti") -- <1>
end

function init(self)
	single_shot() -- <2>

	timer.delay(3, true, single_shot) -- <3>

	msg.post(".", "acquire_input_focus") -- <4>
end

function on_input(self, action_id, action)
	if action_id == hash("mouse_button_left") and action.pressed then -- <5>
		single_shot()
	end
end

--[[
1. Helper function `single_shot` starts playing the particle effect in component "confetti" in this game object.
2. Call it once in init.
3. Setup timer to do a single shot of confetti every 3 seconds.
4. Acquire input focus, so that we can detect clicks.
5. Play the effect when left mouse button (or touch) is pressed.
--]]
