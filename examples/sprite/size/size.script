function init(self)
	local rectangle_size = go.get("#stone", "size") -- <1>
	local square_size = go.get("square#stone", "size") -- <2>
	label.set_text("#info", "" .. rectangle_size.x .. "x" .. rectangle_size.y) -- <3>
	label.set_text("square#info", "" .. square_size.x .. "x" .. square_size.y) -- <4>
end

--[[
1. Read the size of the sprite with id `stone` on the same game object as this script (the game object with id `rectangle`).
2. Read the size of the sprite with id `stone` on the game object with id `square`.
3. Set the text of the label with id `info` on the same game object as this script (the game object with id `rectangle`).
4. Set the text of the label with id `info` on the game object with id `square`.
--]]
