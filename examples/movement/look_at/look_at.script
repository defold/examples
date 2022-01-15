function init(self)
	-- make sure the script will receive user input
	msg.post(".", "acquire_input_focus")
end

function on_input(self, action_id, action)
	-- the position to look at (mouse/finger)
	local look_at = vmath.vector3(action.x, action.y, 0)
	-- own positon
	local my_position = go.get_position()

	-- calculate the angle that this object has to rotate to look at the given point
	local angle = math.atan2(my_position.x - look_at.x, look_at.y - my_position.y)
	-- set rotation as a quaternion
	go.set_rotation(vmath.quat_rotation_z(angle))
end