-- speed of the time in the collection proxy
go.property("speed", 1)

function init(self)
	-- acquire input for this script
	msg.post(".", "acquire_input_focus")
	-- load the collection proxy
	msg.post("#gameproxy", "async_load")
end

function update(self, dt)
	-- update the time step of the proxy each frame since it might be animated
	msg.post("#gameproxy", "set_time_step", { factor = self.speed, mode = 0 })
	label.set_text("#label", tostring(self.speed))
end

function on_message(self, message_id, message, sender)
	if message_id == hash("proxy_loaded") then
		msg.post(sender, "enable")
	elseif message_id == hash("animate_speed") then
		-- cancel any current animation of the speed property
		go.cancel_animations("#", "speed")
		-- start animation of the speed property
		local to = message.to
		local change = math.abs(self.speed - to)
		local rate_of_change = 2
		local duration = change / rate_of_change
		go.animate("#", "speed", go.PLAYBACK_ONCE_FORWARD, to, go.EASING_LINEAR, duration)
	elseif message_id == hash("change_speed") then
		-- cancel any current animation of the speed property
		go.cancel_animations("#", "speed")
		-- make sure speed never goes below 0
		self.speed = math.max(self.speed + message.amount, 0)
	end
end
