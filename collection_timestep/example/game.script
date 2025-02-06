function init(self)
	-- get input to this script
	msg.post(".", "acquire_input_focus")

	-- animate some game objects
	go.animate("enemy1", "position.x", go.PLAYBACK_LOOP_PINGPONG, 720, go.EASING_INOUTQUAD, 5, 0)
	go.animate("enemy2", "position.x", go.PLAYBACK_LOOP_PINGPONG, 720, go.EASING_INOUTQUAD, 5, 0.5)
	go.animate("enemy3", "position.x", go.PLAYBACK_LOOP_PINGPONG, 720, go.EASING_INOUTQUAD, 5, 1)
	go.animate("enemy4", "position.x", go.PLAYBACK_LOOP_PINGPONG, 720, go.EASING_INOUTQUAD, 5, 1.5)
end

function on_input(self, action_id, action)
	if action_id == hash("left") then
		msg.post("timestep:/controller", "change_speed", { amount = -0.01 })
	elseif action_id == hash("right") then
		msg.post("timestep:/controller", "change_speed", { amount = 0.01 })
	elseif action_id == hash("action") and action.pressed then
		-- flip self.to between 0 and 3 each time
		self.to = 3 - (self.to or 0)
		msg.post("timestep:/controller", "animate_speed", { to = self.to })
	end
end
