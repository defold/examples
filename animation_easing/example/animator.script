go.property("start_position", vmath.vector3())
go.property("end_position", vmath.vector3())
go.property("start_rotation", vmath.vector3())
go.property("end_rotation", vmath.vector3())
go.property("start_scale", vmath.vector3(1, 1, 1))
go.property("end_scale", vmath.vector3(1, 1, 1))
go.property("duration", 2)

local function should_animate_position(self)
	return self.start_position ~= self.end_position
end
local function should_animate_rotation(self)
	return self.start_rotation ~= self.end_rotation
end
local function should_animate_scale(self)
	return self.start_scale ~= self.end_scale
end

local function reset_position_rotation_scale(self)
	if should_animate_position(self) then
		go.set_position(self.start_position)
	end
	if should_animate_rotation(self) then
		go.set(".", "euler", self.start_rotation)
	end
	if should_animate_scale(self) then
		go.set_scale(self.start_scale)
	end
end

local function animate(self)
	reset_position_rotation_scale(self)
	if should_animate_position(self) then
		go.animate(".", "position", go.PLAYBACK_LOOP_PINGPONG, self.end_position, self.easing, self.duration)
	end
	if should_animate_rotation(self) then
		go.animate(".", "euler", go.PLAYBACK_LOOP_PINGPONG, self.end_rotation, self.easing, self.duration)
	end
	if should_animate_scale(self) then
		go.animate(".", "scale", go.PLAYBACK_LOOP_PINGPONG, self.end_scale, self.easing, self.duration)
	end
end

function on_message(self, message_id, message, sender)
	if message_id == hash("restart") then
		self.easing = message.easing
		animate(self)
	end
end
