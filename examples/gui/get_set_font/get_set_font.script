-- create a script resource property 'myfont' referencing a font file
go.property("myfont", resource.font("/assets/text64.font"))

function init(self)
	msg.post(".", "acquire_input_focus")

	-- get the font file on the gui component which is assigned to
	-- the font with id 'default'
	self.default_font = go.get("#gui", "fonts", { key = "default" })
end

function on_input(self, action_id, action)
	if action.pressed then
		-- get the font file currently assigned to the font with id 'default'
		local current_font = go.get("#gui", "fonts", { key = "default" })

		-- toggle between the default font and the font referenced by the
		-- script resource property 'myfont'
		if current_font == self.myfont then
			go.set("#gui", "fonts", self.default_font, { key = "default" })
		else
			go.set("#gui", "fonts", self.myfont, { key = "default" })
		end
	end
end

