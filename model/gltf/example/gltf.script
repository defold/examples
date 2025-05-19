-- This script controls the movement of track parts to create an infinite scrolling effect
-- i.e. we don't move the car, we move the track.

function init(self)
	local count = 6       -- Total number of track parts
	local part_size = 4   -- Size of each track part

	self.current_z = 0    -- Current z position of the track
	self.loop_at_z = part_size * (count - 2)  -- Point at which to loop the track

	self.speed = 5        -- Movement speed of the track
end

function update(self, dt)
	-- Move the track forward based on speed and delta time
	self.current_z = self.current_z + self.speed * dt

	-- Loop the track position when it reaches the loop point
	if self.current_z > self.loop_at_z then
		self.current_z = self.current_z - self.loop_at_z
	end

	-- Update the position of the track game object
	go.set("/track", "position.z", self.current_z)
end
