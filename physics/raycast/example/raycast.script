local function draw_line(from, to)
	msg.post("@render:", "draw_line", { start_point = from, end_point = to, color = vmath.vector4(1,0,0,1) })
end

function init(self)
	msg.post(".", "acquire_input_focus") -- <1>
	self.to = vmath.vector3() -- <2>
end

function update(self, dt)
	local from = go.get_position()
	local to = self.to
	local result = physics.raycast(from, to, { hash("stone") }) -- <4>
	if result then
		draw_line(from, result.position) -- <5>
	else
		draw_line(from, to) -- <6>
	end
end

function on_input(self, action_id, action)
	if not action_id or action_id == hash("touch") then -- <3>
		self.to.x = action.x
		self.to.y = action.y
	end
end

--[[
1. Tell the engine that this object ("." is shorthand for the current game object) should listen to input. Any input will be received in the `on_input()` function.
2. Store a position vector `to` in `self` (the current script component) to keep track of where to do a raycast.
3. If we receive input (touch or mouse movement) we update the position to where we should cast the ray.
4. Perform a raycast from the current game object position to where the mouse/touch is. The raycast is configured to only hit collision objects belonging to the `stone` group. The result will be stored in `result` or `nil` if no hit.
5. The raycast hit something! Draw a line (using the helper function at the top of the script) from the current game object position to where the raycast hit.
6. The raycast missed! Draw a line (using the helper function at the top of the script) from the current game object position to where the mouse/touch was.
--]]