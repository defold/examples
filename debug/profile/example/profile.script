function init(self)
	msg.post(".", "acquire_input_focus") -- <1>
end

function on_input(self, action_id, action)
	if action_id == hash("touch") and action.pressed then
		msg.post("@system:", "toggle_profile") -- <2>
	end
end

--[[
1. Make sure this game object's script component gets input from the engine.
2. If user clicks, toggle profiling information.
--]]