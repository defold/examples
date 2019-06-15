function init(self)
	msg.post(".", "acquire_input_focus")
	go.animate(".", "position.x", go.PLAYBACK_LOOP_PINGPONG, 2000, go.EASING_INOUTQUAD, 10) -- <1>
	msg.post("camera", "follow") -- <2>
	self.follow = true -- <3>
end


function on_input(self, action_id, action)
	if action_id == hash("touch") and action.pressed then -- <4>
		self.follow = not self.follow
		if self.follow then
			msg.post("camera", "follow")
		else
			msg.post("camera", "unfollow")
		end
	end
end

--[[
1. Move this game object back and forth across the scene.
2. Send a message to the camera game object telling it to follow this game object.
3. Keep track of if the camera is following this game object or not.
4. Toggle between following and not following the game object when the left mouse button is clicked or the screen is touched.
--]]
