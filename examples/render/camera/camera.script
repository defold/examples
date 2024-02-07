function init(self)
	msg.post("#camera", "acquire_camera_focus") -- <1>
	msg.post("@render:", "use_camera_projection") -- <2>
end

function on_message(self, message_id, message, sender)
	if message_id == hash("follow") then -- <3>
		go.set_parent(".", sender) -- <4>
	elseif message_id == hash("unfollow") then -- <5>
		go.set_parent("camera", nil, true)
	end
end

--[[
1. Acquire camera focus for the camera component. When a camera has focus it will send view and projection updates to the render script.
2. Tell the render script to use the view and projection provided by the camera.
3. Start following the game object that sent the `follow` message.
4. This is done by parenting the camera component to the game object that sent the message.
5. Stop following any game object. This is done removing the parent game object while maintaining the current world transform.
--]]