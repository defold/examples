-- Update button visual state
local function update_button_visual(node, pressed)
	if pressed then
		-- Set pressed color: #6680e6
		gui.set_color(node, vmath.vector4(0.4, 0.5, 0.9, 1.0))
	else
		-- Set default color: #4d66cc
		gui.set_color(node, vmath.vector4(0.3, 0.4, 0.8, 1.0))
	end
end

function init(self)
	-- Get node references
	self.idle_node = gui.get_node("idle")
	self.run_node = gui.get_node("run")
	self.turn_around_node = gui.get_node("turn_around")
	self.jump_node = gui.get_node("jump")
	self.attack_node = gui.get_node("attack")
	self.crouch_node = gui.get_node("crouch")

	-- Start with idle highlighted (default state)
	update_button_visual(self.idle_node, true)
end

function on_message(self, message_id, message)
	-- Handle animation state changes
	if message_id == hash("animation_state_changed") then
		-- Reset all buttons to unpressed state
		update_button_visual(self.idle_node, false)
		update_button_visual(self.run_node, false)
		update_button_visual(self.turn_around_node, false)
		update_button_visual(self.jump_node, false)
		update_button_visual(self.attack_node, false)
		update_button_visual(self.crouch_node, false)

		-- Get state name
		local state = message.state

		-- Highlight the current state button
		if state:find("idle") then
			update_button_visual(self.idle_node, true)
		end
		if state:find("run") then
			update_button_visual(self.run_node, true)
		end
		if state:find("turn_around") then
			update_button_visual(self.turn_around_node, true)
		end
		if state:find("jump") then
			update_button_visual(self.jump_node, true)
		end
		if state:find("attack") then
			update_button_visual(self.attack_node, true)
		end

		-- Highlight crouch button for crouching states
		if state:find("^crouching") or state == "to_crouch" then
			update_button_visual(self.crouch_node, true)
		end
	end
end
