function init(self)
	msg.post(".", "acquire_input_focus")
	
	local scale = 0.75
	local spacingx = 160 * scale + 10
	local spacingy = 190 * scale + 10
	local startx = 40 + spacingx*0.5
	local starty = 40 + spacingy*0.5

	local maxy = 3
	local maxx = 4

	self.urls = {}

	-- 1. For all sprites in the example we set a slightly different `mycolor` vertex attribute:
	for y = 0, maxy do
		for x = 0, maxx do
			local p = vmath.vector3(startx + x*spacingx, starty + y*spacingy, 0.5)
			local id = factory.create("#factory", p, nil, nil, vmath.vector3(0.8, 0.8, 1))
			local url = msg.url(nil, id, "sprite")
			table.insert(self.urls, url)

			-- set vertex attribute:
			go.set(url, "mycolor", vmath.vector4(x/maxx, y/maxy, 0, 1))
		end
	end

	self.updated = false
	self.animation_finished = true
end

function update(self, dt)
	self.updated = true
end

function on_input(self, action_id, action)

	-- 2. On click we animate the `mycolor` vertex attribute of each of the sprites to blue and back.
	if action_id == hash("touch") and action.pressed and self.updated and self.animation_finished then
		for _, url in ipairs(self.urls) do
			self.animation_finished = false

			-- animate vertex attribute:
			go.animate(url, "mycolor", go.PLAYBACK_ONCE_PINGPONG, vmath.vector4(0, 0, 1, 1), go.EASING_LINEAR, 1, 0, function()
				self.animation_finished = true
			end)
		end
	end
end