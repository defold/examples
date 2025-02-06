function init(self)
	msg.post(".", "acquire_input_focus") -- <1>
	msg.post("#splashscreenproxy", "async_load") -- <2>
end

function on_message(self, message_id, message, sender)
	if message_id == hash("proxy_loaded") then -- <3>
		if sender.fragment == hash("splashscreenproxy") then -- <4>
			msg.post("#splashscreenproxy", "enable") -- <5>
			msg.post("#menuproxy", "async_load") -- <6>
			self.menu_loading_started_time = os.time() -- <7>
		elseif sender.fragment == hash("menuproxy") then -- <8>
			local total_menu_loading_time = os.time() - self.menu_loading_started_time
			local minimum_splash_duration = 5
			local delay = math.max(minimum_splash_duration - total_menu_loading_time, 0) -- <9>
			timer.delay(delay, false, function() -- <10>
				msg.post("#splashscreenproxy", "unload") -- <11>
				msg.post("#menuproxy", "enable") -- <12>
			end)
		end
	end
end

--[[
1. Acquire input focus for this game object. This is required for input to be able to propagate into any of the collection proxies on the same game object as this script.
2. Load the splash screen
3. The "proxy_loaded" message is received whenever a collection proxy has been loaded
4. Here we check if it was the splash screen proxy which was loaded
5. Enable the splash screen proxy so that the splash screen is shown
6. Load the menu screen
7. Save the time when the menu screen loading was started
8. Was the menu proxy loaded?
9. Calculate how much longer the splash screen should remain visible, based on how long it took to load the menu
10. Start a timer for the remaining time
11. Unload the splash screen
12. Show the menu
--]]