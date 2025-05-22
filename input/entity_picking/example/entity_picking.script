local camera_math = require("example.camera_math")

--- Performs a raycast from the camera through a screen position to find an entity.
-- @param screen_x number The x-coordinate on the screen
-- @param screen_y number The y-coordinate on the screen
-- @param collision_groups table The collision groups to check against as array of hash values
-- @return table|nil The first entity hit by the ray, or nil if nothing was hit
local function pick_entity(screen_x, screen_y, collision_groups)
	local from = camera_math.screen_to_world(screen_x, screen_y, 0, "/camera#camera")
	local to = camera_math.screen_to_world(screen_x, screen_y, 100, "/camera#camera")
	local results = physics.raycast(from, to, collision_groups, { all = false })
	if not results then
		return nil
	end

	return results[1]
end

function init(self)
	-- Use the projection provided by the camera
	msg.post("@render:", "use_camera_projection")

	-- Acquire input focus to receive input events
	msg.post(".", "acquire_input_focus")

	self.input_pressed = false -- Tracks if the input is currently pressed
	self.last_input = nil      -- Stores the last input action received
	self.previous = nil        -- Keeps track of the previously highlighted entity
end

function update(self, dt)
	if not self.last_input then
		-- No input received yet
		return
	end

	local result = pick_entity(self.last_input.screen_x, self.last_input.screen_y, { hash("target") })
	if result then
		-- Store in the result table the model URL of the entity just for convenience
		result.model_url = msg.url(nil, result.id, "model")

		-- Set the tint of the entity to highlight it
		go.set(result.model_url, "tint.w", 1.5)

		-- If the input is currently pressed, move the camera to the entity
		if self.input_pressed then
			-- We want to move the camera to only the X,Y of the entity, so we get its position
			local move_to = go.get("/camera", "position")
			move_to.x = result.position.x
			move_to.y = result.position.y

			go.cancel_animations("/camera", "position")
			go.animate("/camera", "position", go.PLAYBACK_ONCE_FORWARD, move_to, go.EASING_INOUTQUAD, 0.5)
		end

		-- If the previously highlighted entity is different from the current entity, reset its tint
		if self.previous and self.previous.id ~= result.id then
			go.set(self.previous.model_url, "tint.w", 1)
		end
		self.previous = result
	else
		-- No entity was hit, so reset the tint of the previously highlighted entity
		if self.previous then
			go.set(self.previous.model_url, "tint.w", 1)
			self.previous = nil
		end
	end
end

function on_input(self, action_id, action)
	if action_id == hash("touch") then
		-- "touch" is a screen touch or mouse click. We only want to react to the press event.
		self.input_pressed = action.pressed
	elseif not action_id then
		-- If action_id is nil, it means that the action is a mouse move event.
		-- "action" contains the mouse move event data. We want to store it for later use.
		self.last_input = action
	end
end
