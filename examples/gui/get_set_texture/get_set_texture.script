-- create a script resource property 'myatlas' referencing an atlas file
go.property("myatlas", resource.atlas("/examples/gui/get_set_texture/get_set_texture.atlas"))

function init(self)
	msg.post(".", "acquire_input_focus")

	-- get the atlas file on the gui component which is assigned to
	-- the atlas/texture with id 'ui'
	self.default_atlas = go.get("#gui", "textures", { key = "ui" })
end

function on_input(self, action_id, action)
	if action.pressed then
		-- get the atlas file currently assigned to the atlas/texture with id 'ui'
		local current_atlas = go.get("#gui", "textures", { key = "ui" })

		-- toggle between the default texture and the texture referenced by the
		-- script resource property 'ui'
		if current_atlas == self.myatlas then
			go.set("#gui", "textures", self.default_atlas, { key = "ui" })
		else
			go.set("#gui", "textures", self.myatlas, { key = "ui" })
		end
	end
end

