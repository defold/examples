local MSG_TRIGGER = hash("trigger_response")
local MSG_PARENT = hash("parent")

function init(self)
	msg.post(".", "acquire_input_focus")
end

function final(self)
	msg.post(".", "release_input_focus")
end

function on_input(self, action_id, action)
	if action.x and action.y then
		go.set_position(vmath.vector3(action.x, action.y, 1))
	end
end

function on_message(self, message_id, message, sender)
	if message_id == MSG_TRIGGER then
		msg.post("/root#manipulator", MSG_PARENT, { parent = message.enter })
	end
end
