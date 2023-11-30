function init(self)
	msg.post(".", "acquire_input_focus")

	-- a list of different bullet prototypes
	self.bullets = {
		"/examples/factory/dynamic/flame.goc",
		"/examples/factory/dynamic/lightning.goc",
		"/examples/factory/dynamic/rock.goc",
	}
	-- the currently used bullet prototype
	self.bullet_index = 1

	-- shoot one bullet per second
	-- animate the bullet up 1000 pixels and then delete it
	timer.delay(0.2, true, function()
		local id = factory.create("#bulletfactory")
		local to = go.get_position(id)
		to.y = to.y + 1000
		go.animate(id, "position", go.PLAYBACK_ONCE_FORWARD, to, go.EASING_LINEAR, 1.5, 0, function()
			go.delete(id)
		end)
	end)
end

function on_input(self, action_id, action)
	-- mouse or spacebar
	if (action_id == hash("touch") or action_id == hash("action")) and action.pressed then
		-- next bullet prototype, wrap around to the first
		self.bullet_index = self.bullet_index + 1
		if self.bullet_index > #self.bullets then
			self.bullet_index = 1
		end

		-- unload current prototype
		factory.unload("#bulletfactory")

		-- set a new prototype
		local prototype = self.bullets[self.bullet_index]
		factory.set_prototype("#bulletfactory", prototype)
	end
end
