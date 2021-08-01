local TILE_SIZE = 64

-- helper function check if a tile coordinate is within the bounds of the tilemap
local function within_bounds(x, y)
	local bx, by, bw, bh = tilemap.get_bounds("#level")
	return x >= bx and y >= by and x < (bx + bw) and y < (by + bh)
end

function init(self)
	msg.post(".", "acquire_input_focus")
end

function on_input(self, action_id, action)
	local tile_x = math.ceil(action.x / TILE_SIZE)
	local tile_y = math.ceil(action.y / TILE_SIZE)

	if within_bounds(tile_x, tile_y) then
		-- click to place a flower
		if action_id == hash("touch") and action.pressed then
			tilemap.set_tile("#level", "layer1", tile_x, tile_y, 77)
		end

		-- show tile info
		local tile = tilemap.get_tile("#level", "layer1", tile_x, tile_y)
		local text = ("x: %d y: %d tile: %d"):format(tile_x, tile_y, tile)
		label.set_text("#label", text)
	else
		local text = ("x: %d y: %d out of bounds"):format(tile_x, tile_y)
		label.set_text("#label", text)
	end
end
