function init(self)
	msg.post(".", "acquire_input_focus") -- <1>
	self.message = "" -- <2>
end

function on_input(self, action_id, action)
	if action_id == hash("type") then
		self.message = self.message .. action.text -- <3>
		label.set_text("#label", self.message) -- <4>
	elseif action_id == hash("backspace") and action.repeated then
		local l = string.len(self.message)
		self.message = string.sub(self.message, 0, l-1) -- <5>
		label.set_text("#label", self.message) -- <6>
	end
end

--[[
1. Tell the engine that this object ("." is shorthand for the current game object) wants to receive input. The function `on_input()` will be called whenever input is received.
2. Store a variable in the script component with the text that the user types.
3. If the "type" text trigger action is sent, add the typed text to the variable `message` that stores the text.
4. Set the label component to the stored text.
5. If the user presses <kbd>backspace</kbd>, set the stored text to a substring starting at the beginning of the stored text and ending at the length of the stored text minus 1. This erases the last character from the stored text.
6. Set the label component to the stored text.
--]]