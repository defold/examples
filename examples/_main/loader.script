function init(self)
	self.current_proxy = nil
	-- Need input focus so it can be trickled down the proxies
	msg.post(".", "acquire_input_focus")

	-- Start from specific example config or menu
	local example = sys.get_config("examples.start", nil)
	print("examples.start", example)
	if example then
		msg.post("#", "load_example", { example = hash(example), nomenu = true })
	else
		msg.post("menu#gui", "show")
	end
end

function on_message(self, message_id, message, sender)
	if message_id == hash("load_example") then
		print("load_example", message.example)
		self.current_proxy = msg.url(nil, "loader", message.example)
		msg.post(self.current_proxy, "load")
		self.nomenu = message.nomenu
	elseif message_id == hash("unload_example") then
		msg.post(self.current_proxy, "disable")
		msg.post(self.current_proxy, "final")
		msg.post(self.current_proxy, "unload")
		-- reset projection if an example might have modified it
		local view = vmath.matrix4()
		local projection = vmath.matrix4_orthographic(0, tonumber(sys.get_config("display.width")), 0, tonumber(sys.get_config("display.height")), -1, 1)
		msg.post("@render:", "set_view_projection", { id = hash("camera"), view = view, projection = projection })
	elseif message_id == hash("proxy_loaded") then
		msg.post(self.current_proxy, "init")
		msg.post(self.current_proxy, "enable")
		
		if not self.nomenu then
			msg.post("#gui", "show")
			msg.post("menu#gui", "hide")
		end
	elseif message_id == hash("proxy_unloaded") then
		msg.post("#gui", "hide")
		msg.post("menu#gui", "show")
		
	elseif message_id == hash("set_time_step") then
		msg.post(self.current_proxy, "set_time_step", message)
	end
end

function on_reload(self)
--	msg.post("loader", "load_example", { example = hash("basics/simple move")})
	msg.post("loader", "unload_example")
end
