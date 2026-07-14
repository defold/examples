function init(self)
	msg.post(".", "acquire_input_focus") -- <1>
end

function on_input(self, action_id, action)
	if action_id == nil then
		local position = go.get_position()
		position.x = action.x
		position.y = action.y
		go.set_position(position) -- <2>
	end
end

--[[
1. Acquire input focus so this script receives mouse movement.
2. Move the Point Light game object to the cursor while preserving its Z position.
]]
