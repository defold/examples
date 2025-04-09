-- create script properties with references to three different tile sources
go.property("robot", resource.tile_source("/assets/robot.tilesource"))
go.property("zombie", resource.tile_source("/assets/zombie.tilesource"))
go.property("adventurer", resource.tile_source("/assets/adventurer.tilesource"))

local function update_tilesource(image_id)
	-- set the sprite image property to the specified tilesource
	go.set("#sprite", "image", image_id)
	-- play the run animation
	sprite.play_flipbook("#sprite", "run")
end

function init(self)
	msg.post(".", "acquire_input_focus")
	update_tilesource(self.robot)
end

-- change sprite image when key 1, 2 and 3 are pressed
function on_input(self, action_id, action)
	if action.pressed then
		if action_id == hash("key_1") then
			update_tilesource(self.robot)
		elseif action_id == hash("key_2") then
			update_tilesource(self.zombie)
		elseif action_id == hash("key_3") then
			update_tilesource(self.adventurer)
		end
	end
end