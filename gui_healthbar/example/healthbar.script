function init(self)
	-- < 1 >
	self.player_one_health = 1.0
	self.player_two_health = 1.0
	self.game_boss_health = 1.0

	-- < 2 >
	timer.delay(1, true, function()
		-- < 3 >
		self.player_one_health = math.max(self.player_one_health - 0.1, 0)
		self.player_two_health = math.max(self.player_two_health - 0.1, 0)
		self.game_boss_health = math.max(self.game_boss_health - 0.1, 0)
		-- < 4 >
		msg.post("hud", "update_health", { health_name = "left_health", health_percentage = self.player_one_health })
		msg.post("hud", "update_health", { health_name = "right_health", health_percentage = self.player_two_health })
		msg.post("hud", "update_health", { health_name = "center_health", health_percentage = self.game_boss_health })
	end)
end

--[[
1. Set initial health percentage (1.0 = 100%, 0.0 = 0%).
2. Start a timer that will call every 1 second (first argument) repeateadly (second argument being true) a callback function (3rd argument)
3. Reduce each health percentage by 0.1 (10%), but no less than 0 (using math.max to select `0`, if `self.player_one_health - 0.1` is less than `0`).
4. Send messages to hud (gui component) to "updated_health" with health name and percentage to be set in GUI script.
]]