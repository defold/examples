function on_message(self, message_id, message, sender)
	if message_id == hash("use_atlas") then
		local box = gui.get_node("box")
		gui.set_texture(box, message.texture)
		gui.play_flipbook(box, message.animation)
	end
end
