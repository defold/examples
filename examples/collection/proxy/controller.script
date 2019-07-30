local function show(self, proxy) -- <5>
	if self.current_proxy then -- <6>
		msg.post(self.current_proxy, "unload") -- <7>
		self.current_proxy = nil
	end
	msg.post(proxy, "async_load") -- <8>
end

function init(self)
	msg.post(".", "acquire_input_focus") -- <1>
	self.current_proxy = nil -- <2>
	msg.post("#", "show_menu") -- <3>
end

function on_message(self, message_id, message, sender)
	if message_id == hash("show_menu") then -- <4>
		show(self, "#menuproxy")
	elseif message_id == hash("show_level1") then
		show(self, "#level1proxy")
	elseif message_id == hash("show_level2") then
		show(self, "#level2proxy")
	elseif message_id == hash("show_level3") then
		show(self, "#level3proxy")
	elseif message_id == hash("proxy_loaded") then -- <9>
		self.current_proxy = sender -- <10>
		msg.post(sender, "enable") -- <11>
	elseif message_id == hash("proxy_unloaded") then
		print("Unloaded", sender)
	end
end

--[[
1. Acquire input focus for this game object. This is required for input to be able to propagate into any of the collection proxies on the same game object as this script.
2. Create a variable `current_proxy` to track which collection proxy that is loaded.
3. Post a `show_menu` message to the `on_message` function of this script. This load and show the first screen.
4. Message handler that will react to `show_menu`, `show_level1`, `show_level2` and `show_level3` messages and load the appropriate collection proxy.
5. A helper function to unload any currently loaded collection proxy and load a new collection proxy.
6. Check if a collection proxy is loaded.
7. Send an `unload` message to the currently loaded collection proxy. This will immediately unload the proxy and all of its resources. A `proxy_unloaded` message will be sent when it has been unloaded.
8. Send an `async_load` message to the collection proxy that should be loaded. This will start loading the collection proxy and all of its resources. A `proxy_loaded` message will be sent when it has been loaded.
9. Handle the `proxy_loaded` message. This is sent when a collection proxy has finished loading. The collection and all resources will be loaded but no game objects or components will be active/enabled.
10. Store the url of the proxy that was loaded. This is used in the helper function to unload it when showing another collection proxy.
11. Enable the loaded collection proxy. This will activate/enable all game objects and components within the collection.
--]]