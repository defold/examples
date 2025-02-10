function on_message(self, message_id, message, sender)
	if message_id == hash("follow") then -- <1>
		go.set_parent(".", sender) -- <2>
	elseif message_id == hash("unfollow") then -- <3>
		go.set_parent("camera", nil, true)
	end
end

--[[
1. Start following the game object that sent the `follow` message.
2. This is done by parenting the camera component to the game object that sent the message.
3. Stop following any game object. This is done removing the parent game object while maintaining the current world transform.
--]]