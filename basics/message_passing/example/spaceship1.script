local function landed(self) -- <2>
	label.set_text("#speech", "I'm there!")
	msg.post("spaceship2#script", "i'm there")
end

function on_message(self, message_id, message, sender)
	if message_id == hash("go to") then -- <1>
		label.set_text("#speech", "Ok...")
		go.animate(".", "position", go.PLAYBACK_ONCE_FORWARD, message.position, go.EASING_INOUTCUBIC, 1, 0, landed)
	end	
end

--[[
1. If someone sends us a "go to" message, set the speech label text and animate to the position supplied
   in the message data. At the end of animation, call the function `landed()`
2. This function is called when the position animation is completed. It sets the speech label text and then
   sends a message called "i'm there" to the component "script" in the "spaceship2" game object.
--]]
