
local WIDTH = 4.4

function init(self)
	self.time = 0

	-- Get the mesh buffer assigned to the Mesh component.
	self.resource = go.get("#mesh", "vertices")
	self.mesh = resource.get_buffer(self.resource)

	-- Get the vertex position and normal streams.
	self.positions = buffer.get_stream(self.mesh, "position")
	self.normals = buffer.get_stream(self.mesh, "normal")
end

function update(self, dt)
	self.time = self.time + dt

	-- Each vertex has three components (x, y, z).
	for i = 1, #self.positions, 3 do
		local x, y = self.positions[i], self.positions[i + 1]

		-- Increase the wave amplitude toward the free edge.
		local amount = 0.28 * x / WIDTH
		local phase = 2.8 * x + 0.25 * y - 2.3 * self.time
		local s, c = math.sin(phase), math.cos(phase)

		-- Move vertices along Z to create the waving effect.
		self.positions[i + 2] = amount * s

		-- Recalculate vertex normals to follow the deformed surface.
		local dx = 0.28 / WIDTH * s + amount * 2.8 * c
		local dy = amount * 0.25 * c
		local inv = 1 / math.sqrt(1 + dx * dx + dy * dy)

		self.normals[i] = -dx * inv
		self.normals[i + 1] = -dy * inv
		self.normals[i + 2] = inv
	end

	-- Upload the modified vertex data to the mesh.
	resource.set_buffer(self.resource, self.mesh)
end
