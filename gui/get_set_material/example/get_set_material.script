-- create a script resource property 'myfont' referencing a font file
go.property("mymaterial", resource.material("/example/get_set_material.material"))

function init(self)
	msg.post(".", "acquire_input_focus")

	-- get the material file on the gui component which is assigned to
	-- the material with id 'default'
	self.default_texture = go.get("#gui", "materials", { key = "default" })
end

function on_input(self, action_id, action)
	if action.pressed then
		-- get the material file currently assigned to the material with id 'default'
		local current_texture = go.get("#gui", "materials", { key = "default" })

		-- toggle between the default material and the material referenced by the
		-- script resource property 'default'
		if current_texture == self.mymaterial then
			go.set("#gui", "materials", self.default_texture, { key = "default" })
		else
			go.set("#gui", "materials", self.mymaterial, { key = "default" })
		end
	end
end

