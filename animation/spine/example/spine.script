function init(self)
	msg.post(".", "acquire_input_focus") -- <1>
	self.state = "idle" -- <2>
end

function on_input(self, action_id, action)
	if action_id == hash("touch") and action.pressed then
		local properties = { blend_duration = 0.3 } -- <3>
		if self.state == "idle" then -- <4>
			spine.play_anim("#spinemodel", hash("run"), go.PLAYBACK_LOOP_FORWARD, properties)
			label.set_text("#label", "Click to idle...")
			self.state = "run"
		elseif self.state == "run" then -- <5>
			spine.play_anim("#spinemodel", hash("idle"), go.PLAYBACK_LOOP_FORWARD, properties)	
			label.set_text("#label", "Click to run...")
			self.state = "idle"
		end			
	end	
end

--[[
1. Tell the engine that this game object (".", which is shorthand for the current game object) should receive input.
2. Store state for this instance. Use a string that will be either "idle" or "run", reflecting the animation.
3. If user clicks, set up animation properties. Blend duration larger that 0 to get smoother transition between animations.
4. If state is currently "idle", play "run" animation, change text on label and change the state variable to "run".
5. If state is currently "run", play "idle" animation, change text on label and change the state variable to "idle".
--]]