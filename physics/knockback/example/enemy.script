-- move game object back and forth from the current position to a target position
local function move()
	local pos = go.get_position()
	local to = vmath.vector3(pos.x, 300, 0)
	local distance = pos.y - to.y
	local speed = 40
	local duration = distance / speed
	go.animate(".", "position", go.PLAYBACK_LOOP_PINGPONG, to, go.EASING_INOUTQUAD, duration)
end

function init(self)
	move()
end

function on_message(self, message_id, message, sender)
	if message_id == hash("contact_point_response") then
		if message.other_group == hash("bullet") then
			-- delete the bullet
			go.delete(message.other_id)

			-- get the position of the game object
			local pos = go.get_position()
			-- set a pushback direction based on the collision normal
			local to = pos + message.normal * 30
			-- knockback animation, then continue moving
			go.animate(".", "position", go.PLAYBACK_ONCE_FORWARD, to, go.EASING_OUTQUAD, 0.1, 0, move)
		end
	end
end
