function init(self)
	msg.post("#camera", "acquire_camera_focus") -- <1>
end

function on_message(self, message_id, message, sender)
	if message_id == hash("follow") then -- <2>
		go.set_parent(".", sender) -- <3>
		go.set_position(vmath.vector3(-360, -360, 0)) -- <4>
	elseif message_id == hash("unfollow") then -- <5>
		go.set_parent("camera", nil, true)
	end
end

--[[
1. Acquire camera focus for the camera component. When a camera has focus it will send view and projection updates to the render script.
2. Start following the game object that sent the `follow` message.
3. This is done by parenting the camera component to the game object that sent the message.
4. Offset the camera so that it is centering on the game object (360 is half the screen width and height).
5. Stop following any game object.
5. This is done removing the parent game object while maintaining the current world transform.
--]]