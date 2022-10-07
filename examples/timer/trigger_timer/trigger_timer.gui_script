function init(self)
	self.count = 0			-- <1>
	local interval = 1		-- <2>
	local repeating = true	-- <3>

	self.timer = timer.delay(interval, repeating, function()	-- <4>
		self.count = self.count + 1								-- <5>
		local node = gui.get_node("counter")					-- <6>
		gui.set_text(node, self.count)							-- <7>
	end)

	msg.post(".", "acquire_input_focus")	-- <8>
end

function on_input(self, action_id, action)
	if action_id == hash("touch") and action.pressed then	-- <9>
		timer.trigger(self.timer)							-- <10>
	end
end

--[[
1. Start the count with value 0.
2. We will use interval of 1 [s].
3. We will be repeating the timer endlessly.
4. Start the timer with interval (1s) and repeating (true) and pass a callback function.
	Store the handle to the timer in self.timer.
5. The function will be called every 1s, so increase the count by 1 each time.
6. Get the counter text node.
7. Update the counter text node with an increased count.
8. Tell the engine that this game object wants to receive input.
9. If the user clicks.
10. Trigger the timer's callback function asynchronously using the saved self.timer handle.
--]]