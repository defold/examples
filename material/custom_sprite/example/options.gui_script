local script_url = "/new#set_color"

function init(self)
	msg.post(".", "acquire_input_focus")

	self.is_on = false
	self.io_text = gui.get_node("text")
	self.on_off = gui.get_node("io")
	self.oColor = gui.get_node("OutlineColor")
	self.fluid = gui.get_node("Fluid")

end

function on_input(self, action_id, action)
	if action_id == hash("touch") and action.pressed then

		if gui.pick_node(self.on_off, action.x, action.y) then

			msg.post(script_url, "outline_io")
			if self.is_on then
				gui.set_text(self.io_text,"Outline (Off)")
				self.is_on = not self.is_on
			else
				gui.set_text(self.io_text,"Outline (On)")
				self.is_on = not self.is_on
			end

		elseif gui.pick_node(self.oColor, action.x, action.y) then

			msg.post(script_url, "outline_color")

		elseif gui.pick_node(self.fluid, action.x, action.y) then

			msg.post(script_url, "fluid_color")

		end
	end
end