local function load_menu(self)
	self.menu_loading_started_time = os.time() -- <5>
	collectionproxy.load("#menuproxy", nil, function(self, message_id, message, sender) -- <6>
		if message_id == hash("proxy_ready") then
			local total_menu_loading_time = os.time() - self.menu_loading_started_time
			local minimum_splash_duration = 5
			local delay = math.max(minimum_splash_duration - total_menu_loading_time, 0) -- <7>
			timer.delay(delay, false, function() -- <8>
				msg.post("#splashscreenproxy", "unload") -- <9>
				msg.post("#menuproxy", "enable") -- <10>
			end)
		end
	end)
end

local function load_splash(self)
	collectionproxy.load("#splashscreenproxy", nil, function(self, message_id, message, sender) -- <2>
		if message_id == hash("proxy_ready") then -- <3>
			msg.post("#splashscreenproxy", "enable") -- <4>
			load_menu(self) -- <5>
		end
	end)
end

function init(self)
	msg.post(".", "acquire_input_focus") -- <1>
	load_splash(self) -- <2>
end

--[[
1. Acquire input focus for this game object. This is required for input to be able to propagate into any of the collection proxies on the same game object as this script.
2. Load the splash screen
3. The "proxy_loaded" message is received whenever a collection proxy has been loaded
4. Enable the splash screen proxy so that the splash screen is shown
5. Save the time when the menu screen loading was started
6. Load the menu screen
7. Calculate how much longer the splash screen should remain visible, based on how long it took to load the menu
8. Start a timer for the remaining time
9. Unload the splash screen
10. Show the menu
--]]