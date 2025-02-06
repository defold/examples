function init(self)
	msg.post(".", "acquire_input_focus") -- <1>
	self.message = "Duration: %f . Last duration: %f" -- <2>
	self.duration = 0
	self.last_duration = 0
end

local function update_text(self) -- <3>
	local msg = string.format(self.message, self.duration, self.last_duration) -- <4>
	label.set_text("#label", msg) -- <5>
end

function on_input(self, action_id, action)
	if action_id == hash("touch") then -- <6>
		if action.pressed then -- <7>
			self.is_start_timer = true -- <8>
		elseif action.released then -- <9>
			self.is_start_timer = false -- <10>
			self.last_duration = self.duration -- <11>
			self.duration = 0
			update_text(self) -- <12>
		end
	end
end

function update(self, dt)
	if self.is_start_timer then -- <13>
		self.duration = self.duration + dt -- <14>
		update_text(self) -- <15>
	end
end

--[[
1. Tell the engine that this object ("." is shorthand for the current game object) wants to receive input. The function `on_input()` will be called whenever input is received.
2. Prepare format of output including two float placeholders.
3. Create method for updating the text label.
4. Create a formatted string from the format and duration and last_duration arguments.
5. Set the label component to the stored text.
6. Check if we receive an input action named "touch".
7. Check if it is pressed then run the following.
8. Change flag for starting a timer.
9. Check if it is released then run the following.
10. Change flag for stopping a timer.
11. Save duration as last_duration.
12. Run method for updating text.
13. Check if timer is started.
14. Add dt (delta time from the last frame) to the duration variable.
15. Run method for updating text.
--]]
