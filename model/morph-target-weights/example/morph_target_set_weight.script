-- URL of the model in the example
local MODEL = "#model"

-- Helper function to set morph weight
local function set_morph_weight(self, weight)
	self.weights[1] = math.max(0, math.min(1, weight)) -- <1>
	model.set_blend_weights(MODEL, self.weights) -- <2>
end

function init(self)
	msg.post(".", "acquire_input_focus") -- <3>
	model.cancel(MODEL) -- <4>

	self.weights = { 0.0 } -- <5>
	set_morph_weight(self, 0.0) -- <6>
end

function on_input(self, _action_id, action)
	if action.screen_x then
		local width = window.get_size()	-- <7>
		local weight = action.screen_x / width -- <8>
		set_morph_weight(self, weight) -- <9>
		return true
	end
end


function final(self)
	model.set_blend_weights(MODEL) -- <10>
	msg.post(".", "release_input_focus")
end

--[[
1. Clamp the weight value between 0 and 1.
2. Override the model's morph target weights. This model has one morph target, so the table contains one value.
3. Enable input so pointer movement is received by `on_input`.
4. Stop the default glTF animation so the script controls the morph weight directly.
5. Weights are stored in a table of values for each morph weight.
6. Set the weight initially to 0 using the helper function.
7. Get the window size (wdith is the first returned value).
8. Convert the horizontal pointer position into a weight from 0.0 at the left edge to 1.0 at the right edge.
9. Set the weight on the model using the helper function.
10. Clear the script override so animations can drive morph weights again if the component is reused.
]]
