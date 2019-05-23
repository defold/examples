function init(self)
	msg.post(".", "acquire_input_focus") -- <1>
end

function on_input(self, action_id, action)
	if action_id == hash("touch") and action.pressed then -- <2>
		local button = gui.get_node("button") -- <3>
		local text = gui.get_node("text") -- <4>
		if gui.pick_node(button, action.x, action.y) then -- <5>
			gui.set_text(text, "HELLO!") -- <6>
		else
			gui.set_text(text, "CLICK ME!") -- <7>
		end
	end
end

--[[
1. Tell the engine that this game object wants to receive input.
2. If the user clicks.
3. Get the instance for the node named "button" (the button box).
4. Get the instance for the node named "text" (the button label).
5. Check if the click position (`action.x` and `action.y`) is within the boundaries of 
   the button node.
6. If the user clicks on the button, change the label text.
7. If the user clicks elsewhere, change the label text to something else.
--]]
