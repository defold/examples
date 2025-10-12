local function load_level(level_name)
	local level_path = "/levels/" .. level_name .. ".json" -- <1>
	local data = sys.load_resource(level_path) -- <2>
	local json_data = json.decode(data) -- <3>
	label.set_text("#title", json_data.title) -- <4>
end

function init(self)
	msg.post(".", "acquire_input_focus")
end


function on_input(self, action_id, action)
	if action_id == hash("key_1") then
		if action.released then
			load_level("level_001")
		end
	elseif action_id == hash("key_2") then
		if action.released then
			load_level("level_002")
		end
	end
end

--[[
1. Convinience sake we only want pass in the name of the level, but to load the resource we need to give it the full path.
2. Load the resource, this will return a string.
3. Use the json.decode to make our string into a lua table.
4. Use the loaded level data in whatever way we want.
--]]
