go.property("SPEED", 90)
go.property("DIRECTION", -1)
go.property("LEFT_BOUND", -1000)
go.property("RIGHT_BOUND", 1000)
go.property("COUNT_OBJECTS", 1)


local function register_objects(self)
	for i, obj in ipairs(self.OBJECTS) do
		obj.pos = go.get_position(obj.id)
	end
	
	table.sort(self.OBJECTS, function (a, b)
		return a.pos.x < b.pos.x
	end)

	for i = 1, #self.OBJECTS - 1 do
		local current = self.OBJECTS[i]
		local next = self.OBJECTS[i + 1]

		current.next_offset = next.pos.x - current.pos.x
	end

	self.OBJECTS[#self.OBJECTS].next_offset =
	(self.RIGHT_BOUND - self.OBJECTS[#self.OBJECTS].pos.x)
	+
	(self.OBJECTS[1].pos.x - self.LEFT_BOUND)
end


function init(self)
	self.OBJECTS = {}
end


function update(self, dt)
	local dx = self.SPEED * self.DIRECTION * dt

	for _, obj in ipairs(self.OBJECTS) do
		obj.pos.x = obj.pos.x + dx
		go.set_position(obj.pos, obj.id)
	end

	if self.DIRECTION == -1 then
		local leftmost = self.OBJECTS[1]
		if leftmost.pos.x < self.LEFT_BOUND then
			local rightmost = self.OBJECTS[#self.OBJECTS]
			leftmost.pos.x = rightmost.pos.x + rightmost.next_offset
			go.set_position(leftmost.pos, leftmost.id)

			table.sort(self.OBJECTS, function(a,b)
				return a.pos.x < b.pos.x
			end)

		end
		return
	else
		local rightmost = self.OBJECTS[#self.OBJECTS]
		if rightmost.pos.x > self.RIGHT_BOUND then
			local leftmost = self.OBJECTS[1]
			rightmost.pos.x = leftmost.pos.x -- - self.SPACING
			table.sort(self.OBJECTS, function (a, b)
				return a.pos.x < b.pos.x
			end)
		end
		return
	end
end


function on_message(self, message_id, message)
	if message_id == hash("prop:register") then
		table.insert(self.OBJECTS, { id = message.id })
		if #self.OBJECTS == self.COUNT_OBJECTS then
			register_objects(self)
		end
	end
end