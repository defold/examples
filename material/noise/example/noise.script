function init(self)
	self.time = 0
end

function update(self, dt)
	self.time = self.time + dt
	-- set the x component of the 'time' fragment constant in the material
	go.set("#model", "time.x", self.time)
end