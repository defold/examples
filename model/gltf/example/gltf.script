local TRACK_PART_COUNT = 6
local TRACK_PART_SIZE = 4

function init(self)
	self.current_z = 0 -- <1>
	self.loop_at_z = TRACK_PART_SIZE * (TRACK_PART_COUNT - 2) -- <2>
	self.speed = 5 -- <3>
end

function update(self, dt)
	self.current_z = self.current_z + self.speed * dt -- <4>
	if self.current_z > self.loop_at_z then -- <5>
		self.current_z = self.current_z - self.loop_at_z
	end
	go.set("/track", "position.z", self.current_z) -- <6>
end

--[[
1. Start the track at Z = 0.
2. Precompute the distance before the road should loop back.
3. Set the scrolling speed of the whole track.
4. Move the track forward every frame using delta time.
5. Wrap the track when it reaches the end of the visible road.
6. Apply the updated position to the `track` game object.
]]
