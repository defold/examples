go.property("invert", resource.material("/example/materials/invert.material"))
go.property("passthrough", resource.material("/example/materials/passthrough.material"))
go.property("scanlines", resource.material("/example/materials/scanlines.material"))

function init(self)
	msg.post(".", "acquire_input_focus")
	go.set("#quad", "material", self.invert)
end

function on_input(self, action_id, action)
	if action_id == hash("key_1") then
		go.set("#quad", "material", self.invert)
	elseif action_id == hash("key_2") then
		go.set("#quad", "material", self.scanlines)
		local w, h = window.get_size()
		go.set("#quad", "resolution", vmath.vector4(w, h, 0, 0))
	elseif action_id == hash("key_3") then
		go.set("#quad", "material", self.passthrough)
	end
end
