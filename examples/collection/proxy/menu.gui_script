function init(self)
	msg.post(".", "acquire_input_focus") -- <1>
end

function on_input(self, action_id, action)
	if action_id == hash("touch") and action.released then -- <2>
		if gui.pick_node(gui.get_node("level1"), action.x, action.y) then -- <3>
			msg.post("proxy:/controller#controller", "show_level1") -- <4>
		elseif gui.pick_node(gui.get_node("level2"), action.x, action.y) then
			msg.post("proxy:/controller#controller", "show_level2")
		elseif gui.pick_node(gui.get_node("level3"), action.x, action.y) then
			msg.post("proxy:/controller#controller", "show_level3")
		end
	end
end

--[[
1. Acquire input focus for this script.
2. Check if a mouse click/screen touch is released.
3. Check if the mouse click/screen touch happened on top of any of the buttons.
4. Send a `show_level1` message to the controller script component in the `proxy` collection.
--]]