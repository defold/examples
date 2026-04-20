function init(self)
	particlefx.play("#fountain") -- <1>
	msg.post(".", "acquire_input_focus") -- <2>
end

function on_input(self, action_id, action)
	if action_id == hash("mouse_button_left") and action.pressed then -- <3>
		particlefx.stop("#fountain", {clear = true}) -- <4>
		particlefx.play("#fountain") -- <5>
	end
end

--[[
1. Start playing the particle effect in component "fountain" in this game object.
2. Acquire input focus, so that we can detect clicks.
3. When the left mouse button (or touch) is pressed:
4. Stop the currently played "fountain" particle FX with option `clear` set to true to remove all emitted particles.
5. Play the effect again.
]]