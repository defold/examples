function init(self)
	-- make sure the script will receive user input
	msg.post(".", "acquire_input_focus")
end

local function look_at(target_position)
	-- own positon
	local my_position = go.get_position()

	-- calculate the angle that this object has to rotate to look at the given point
	local angle = math.atan2(my_position.x - target_position.x, target_position.y - my_position.y)
	-- set rotation as a quaternion
	go.set_rotation(vmath.quat_rotation_z(angle))
end

function on_input(self, action_id, action)
	-- mouse/finger movement has action_id set to nil
	if not action_id then
		-- the position to look at (mouse/finger)
		local target_position = vmath.vector3(action.x, action.y, 0)
		-- rotate this object to look at the target position
		look_at(target_position)
	end
end