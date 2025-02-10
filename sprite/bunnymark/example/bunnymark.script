local BUNNY_IMAGES = {
	hash("rabbitv3_batman"),
	hash("rabbitv3_bb8"),
	hash("rabbitv3"),
	hash("rabbitv3_ash"),
	hash("rabbitv3_frankenstein"),
	hash("rabbitv3_neo"),
	hash("rabbitv3_sonic"),
	hash("rabbitv3_spidey"),
	hash("rabbitv3_stormtrooper"),
	hash("rabbitv3_superman"),
	hash("rabbitv3_tron"),
	hash("rabbitv3_wolverine"),
}

local DISPLAY_WIDTH = sys.get_config_int("display.width")
local DISPLAY_HEIGHT = sys.get_config_int("display.height")

local SPAWN_COUNT = 1000

local function spawn(self, amount)
	for i=1,amount do
		local bunny = factory.create("#factory")
		if bunny then
			local img = BUNNY_IMAGES[math.random(1, #BUNNY_IMAGES)]
			sprite.play_flipbook(msg.url(nil, bunny, "sprite"), img)
			go.set_position(vmath.vector3(math.random(DISPLAY_WIDTH), DISPLAY_HEIGHT, 0), bunny)
			go.animate(bunny, "position.y", go.PLAYBACK_LOOP_PINGPONG, 40, go.EASING_INQUAD, 2, math.random())
			self.bunnies = self.bunnies + 1
		else
			print("Unable to create more bunnies")
			break
		end
	end
end

function init(self)
	msg.post(".", "acquire_input_focus")
	self.frames = {}
	self.bunnies = 0
	spawn(self, SPAWN_COUNT)
end

function update(self, dt)
	self.frames[#self.frames + 1] = socket.gettime()
	local fps = 0
	if #self.frames == 61 then
		table.remove(self.frames, 1)
		fps = 1 / ((self.frames[#self.frames] - self.frames[1]) / (#self.frames - 1))
	end
	label.set_text("#label", ("Bunnies: %d FPS: %.2f. Click to add more"):format(self.bunnies, fps))	
end

function on_input(self, action_id, action)
	if action_id == hash("touch") and action.released and action.y < 1030 then
		spawn(self, SPAWN_COUNT)
	end
end