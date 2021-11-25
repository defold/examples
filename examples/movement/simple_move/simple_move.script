function init(self)
	self.center = vmath.vector3(360, 360, 0) -- <1>
	self.radius = 160 -- <2>
	self.speed = 2 -- <3>
	self.t = 0 -- <4>
end

function update(self, dt)
	self.t = self.t + dt -- <5>
	local dx = math.sin(self.t * self.speed) * self.radius -- <6>
	local dy = math.cos(self.t * self.speed) * self.radius
	local pos = vmath.vector3() -- <7>
	pos.x = self.center.x + dx -- <8>
	pos.y = self.center.y + dy
	go.set_position(pos) -- <9>
end

--[[
1. Store the center of rotation in the script instance (available through `self`).
2. Store the movement radius.
3. Store the movement speed.
4. Store the elapsed time, in seconds.
5. Increase the elapsed time with `dt`, the delta time elapsed since last call to `update()`.
6. Compute offsets along the X and Y axis. We're using `sinus` and `cosinus` of the current time, scaled with `self.speed`, which will plot points along a circle with radius `self.radius`.
7. Create a new `vector3` which will contain the computed position.
8. Set the `x` and `y` components of the vector to the rotation center plus offsets along X and Y axis.
9. Set the computed position on the current game object.
--]]
