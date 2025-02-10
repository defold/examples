function init(self)
	local pos = go.get_position() -- <1>
	go.animate(".", "position.x", go.PLAYBACK_LOOP_PINGPONG, pos.x + 600, go.EASING_INOUTSINE, 6)
end

function on_message(self, message_id, message, sender)
	if message_id == hash("trigger_response") then -- <2>
		if message.enter then -- <3>
			msg.post("#sprite", "disable") -- <4>
		else
			msg.post("#sprite", "enable") -- <5>
		end
	end
end

--[[
1. Get the current position, then animate the position's x component
   looping in a ping-pong manner against an offset of 600.
2. The physics engine has detected that this game object contains
   collision object components that have collided with a trigger.
3. The `message` data table contains a field `enter` that is set
   to `true` when the trigger event signals that the trigger shape
   was entered. On exiting the trigger, this field is `false`.
4. Disable the sprite when the trigger is entered
5. Enable the sprite again on exit.
--]]