function init(self)
	self.closenode = gui.get_node("close")
	msg.post("#", "hide")
end

function on_message(self, message_id, message, sender)
	if message_id == hash("show") then
		self.active = true
		gui.set_enabled(self.closenode, self.active)
	elseif message_id == hash("hide") then
		self.active = false
		gui.set_enabled(self.closenode, self.active)
	end
end

function on_input(self, action_id, action)
	if action_id == hash("touch") and action.pressed and self.active then
		if gui.pick_node(self.closenode, action.x, action.y) then
			msg.post("/loader#script", "unload_example")
		end
	end	
end

function on_reload(self)
	-- Add input-handling code here
	-- Remove this function if not needed
end
