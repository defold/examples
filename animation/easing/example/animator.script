go.property("start_position", vmath.vector3()) -- <1>
go.property("end_position", vmath.vector3())
go.property("start_rotation", vmath.vector3())
go.property("end_rotation", vmath.vector3())
go.property("start_scale", vmath.vector3(1, 1, 1))
go.property("end_scale", vmath.vector3(1, 1, 1))
go.property("duration", 2)

local RESTART = hash("restart")

local function should_animate_position(self)
	return self.start_position ~= self.end_position -- <2>
end

local function should_animate_rotation(self)
	return self.start_rotation ~= self.end_rotation
end

local function should_animate_scale(self)
	return self.start_scale ~= self.end_scale
end

local function reset_position_rotation_scale(self)
	if should_animate_position(self) then
		go.set_position(self.start_position) -- <3>
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
		go.animate(".", "position", go.PLAYBACK_LOOP_PINGPONG, self.end_position, self.easing, self.duration) -- <4>
	end
	if should_animate_rotation(self) then
		go.animate(".", "euler", go.PLAYBACK_LOOP_PINGPONG, self.end_rotation, self.easing, self.duration)
	end
	if should_animate_scale(self) then
		go.animate(".", "scale", go.PLAYBACK_LOOP_PINGPONG, self.end_scale, self.easing, self.duration)
	end
end

function on_message(self, message_id, message)
	if message_id == RESTART then
		self.easing = message.easing -- <5>
		animate(self)
	end
end

--[[
1. These script properties can be overridden per game object in the collection. The example uses one script for all three demos and changes only the relevant start/end values.
2. A transform property is animated only when its start and end values differ. The position demo changes position, the rotation demo changes Euler rotation, and the scale demo changes scale.
3. Reset the game object before starting the animation so every easing function begins from the same visual state.
4. `go.animate()` uses ping-pong playback to animate from the start value to the end value and back again in a loop.
5. The controller sends the selected built-in `go.EASING_*` constant in a `restart` message.
]]
