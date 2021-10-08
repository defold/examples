function init(self)
	msg.post(".", "acquire_input_focus") -- <1>
	-- Get the current value on component "sprite"
	self.duration = 0 -- <2>
end

function on_input(self, action_id, action)
	if action_id == hash("touch") and action.pressed then -- <3>
		self.duration = self.duration + 1 -- <4>
		if self.duration > 3 then  -- <5>
			self.duration = 0
		end
		label.set_text("#info", "Cursor animation duration: "..self.duration)  -- <6>
		go.cancel_animations("#sprite", "cursor")  -- <7>
		go.set("#sprite", "cursor", 0.0)  -- <8>
		go.animate("#sprite", "cursor", go.PLAYBACK_LOOP_FORWARD, 1, go.EASING_LINEAR, self.duration) -- <9>
	end
end

--[[
1. Tell the engine that this object ("." is shorthand for the current game object) should listen to input. Any input will be received in the `on_input()` function.
2. Store a duration time used in this example (for defining how long the cursor animation should take) in self reference.
3. If we receive input (touch or mouse click) we change the duration of the cursor animation.
4. Increase the duration.
5. If the duration is larger than 3, set it back to 0 to make a circular change of the duration.
6. Set the text of the label with id `info` to show the current duration of the animation to user.
7. Cancel previous animation on cursor value.
8. Reset cursor value to 0.
9. Start new animation of cursor value with playback set to be looped and in foward direction (increasing cursor value), linear easing and new duration.
--]]
