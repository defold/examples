function init(self)
	self.name_node = gui.get_node("player_name")
end

function final(self)
end

function update(self, dt)
end

function on_message(self, message_id, message, sender)
	if message_id == hash("update_data") then
		local screen_position = message.screen_position
		-- Use screen position to set the position of the player name node
		screen_position.z = 0 -- "z" should be reset to 0.
		gui.set_screen_position(self.name_node, screen_position)
	end
end
