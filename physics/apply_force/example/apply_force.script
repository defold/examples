-- Multiplier applied to the touch->block direction vector.
local force_factor = 30

-- Debug line color used by @render:draw_line.
local debug_line_color = vmath.vector4(0, 0.5, 1, 1)

-- Game object ids of dynamic blocks controlled by this script.
-- The script is attached to the "controller" object in the collection.
local blocks = {
	[1] = "block1",
	[2] = "block2",
	[3] = "block3",
	[4] = "block4",
}

function init(self)
	-- <1> Receive touch/mouse input in on_input().
	msg.post(".", "acquire_input_focus")
end

-- Pre-hashed action id for the touch action.
local touch_action_id = hash("touch")

function on_input(self, action_id, action)
	-- <2> Built-in "touch" also maps mouse clicks on desktop.
	if action_id == touch_action_id then
		-- <3> Iterate over all blocks and apply force to each.
		for _, block in pairs(blocks) do
			-- <4> Compute the force vector by subtracting the block center from the touch position.
			local center = go.get_world_position(block)
			local touch = vmath.vector3(action.x, action.y, center.z)
			local force = (touch - center) * force_factor

			-- <5> Send force to the block's dynamic collision object.
			msg.post(block, "apply_force", {
				force = force,
				position = center
			})

			-- <6> Visualize direction from touch point to block center.
			msg.post("@render:", "draw_line", {
				start_point = touch,
				end_point = center,
				color = debug_line_color
			})
		end
	end
end

function final(self)
	-- Stop receiving input when the controller is destroyed.
	msg.post(".", "release_input_focus")
end
