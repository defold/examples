local init_width, init_height = 0, 0

function init(self)
	msg.post(".", "acquire_input_focus")
	init_width, init_height = window.get_size()
	self.curr_width, self.curr_height = init_width, init_height


	timer.delay(1, true, function()
		msg.post("/go#layoutsui", "update_score", {score = math.random(1, 3)})
	end)
end

function on_input(self, action_id, action)
	if action_id == hash("touch") and action.released then
		if self.curr_width == init_width then
			self.curr_width = self.curr_width + 20
		else
			self.curr_width = init_width
		end
		msg.post("@render:", "resize", { width = self.curr_width, height = self.curr_height } )
	end
end
