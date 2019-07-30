function init(self)
	msg.post(".", "acquire_input_focus")
end

function on_input(self, action_id, action)
	if action_id == hash("touch") and action.released then
		msg.post("proxy:/controller", "show_menu")
	end
end
