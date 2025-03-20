local sprite_to_color = "/new#sprite" local brightness = 0.3

local function random_color(self) -- create a new_color of random-ish float values (0.3 or 1.3)
	local random_number_r = math.random(0, 1)+brightness
	local random_number_b = math.random(0, 1)+brightness
	local random_number_g = math.random(0, 1)+brightness
	local new_color = vmath.vector4(random_number_r, random_number_g, random_number_b, self.outline_io)
	return new_color
end

function init(self)
	msg.post("@render:", "clear_color", { color = vmath.vector4(0.25960784,0.2315686274509804,0.229607843, 1.0) } )
	
	self.outline_io = 0.0 -- float is used when setting the w value of the material vertex attribute "outline" 0.0 = off 1.0 = on
	
	math.randomseed(socket.gettime()*10000)

end

function on_message(self, message_id, message)

	if message_id == hash("outline_io") then

		if self.outline_io <= 0.0 then
			self.outline_io = 1.0 
		else 
			self.outline_io = 0.0 
		end
		go.set(sprite_to_color, "outline.w", self.outline_io)

	elseif message_id == hash("outline_color") then

		go.set(sprite_to_color, "outline", random_color(self)) -- set color for outline

	elseif	message_id == hash("fluid_color") then

		go.set(sprite_to_color, "newcolor", random_color(self)) -- set color for potion fluid

	end

end