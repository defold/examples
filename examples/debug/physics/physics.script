function init(self)
	msg.post(".", "acquire_input_focus") -- <1>
	self.show_debug = false -- <2>
end

function on_input(self, action_id, action)
	if action_id == hash("touch") and action.pressed then
		msg.post("@system:", "toggle_physics_debug") -- <3>
		if self.show_debug then -- <4>
			msg.post("main:/loader", "set_time_step", { factor = 1, mode = 0 })
		else
			msg.post("main:/loader", "set_time_step", { factor = 0.1, mode = 1 })
		end
		self.show_debug = not self.show_debug -- <5>
	end
end

--[[
1. Make sure this game object's script component gets input from the engine.
2. A state flag to track if we show debug info or not.
3. If user clicks, toggle physics visualization.
4. In addition, we want to set the timestep. That is done through the collection proxy that loaded this example. Since we cannot get hold of the proxy from this side of it we message the loader game object in the main collection and it will relay the message to the proxy component.
5. Switch the `show_debug` flag.
--]]