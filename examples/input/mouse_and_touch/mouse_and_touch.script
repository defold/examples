function init(self)
	msg.post(".", "acquire_input_focus") -- <1>
	self.state = "-"
end

function on_input(self, action_id, action)
	local pos = vmath.vector3(action.x, action.y, 0) -- <2>
	if action_id == hash("touch") then  -- <3>
		if action.pressed then -- <4>
			self.state = "pressed"
		elseif action.released then -- <5>
			self.state = "-"
		end
	end
	local text = ("x: %d y: %d state: %s"):format(pos.x, pos.y, self.state)
	label.set_text("#label", text)
end

--[[
1. Tell the engine that this object ("." is shorthand for the current game object) wants to receive input. The function `on_input()` will be called whenever input is received.
2. Read the position of the mouse pointer or touch event
3. The left mouse button in the input bindings will also be used for touch events on a phone/tablet
4. The 'pressed' state will be true on the frame when the mouse button/finger is pressed
5. The 'released' state will be true on the frame when the mouse button/finger is released
--]]
