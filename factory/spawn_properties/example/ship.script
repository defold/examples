function init(self)
	-- Animate automatic player position
	go.animate(".", "position.x", go.PLAYBACK_LOOP_PINGPONG, 620, go.EASING_LINEAR, 6.0)

	-- Create a timer to tick every 0.25 second:
	timer.delay(0.25, true, function()

		-- Create a simple bullet bullet using the factory
		local bullet_id = factory.create("#bulletfactory", go.get_position())

		-- Animate the created bullet towards top of screen, where it is deleted
		if bullet_id then
			go.animate(bullet_id, "position.y", go.PLAYBACK_ONCE_FORWARD, 600, go.EASING_LINEAR, 1, 0, function()
				go.delete(bullet_id)
			end)
		end
	end)
end