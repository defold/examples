local M = {}

-- Font resource ------------------------------------------------

-- Get the font resource of the default font.
-- @param node_id The ID of the node to get the font resource of.
-- @return The font resource of the default font.
function M.get_font_resource(node_id)
	-- Get the font resource of the default font.
	return gui.get_font_resource(gui.get_font(node_id))
end

-- Buttons visuals ----------------------------------------------

-- Visual states used by language selection buttons.
M.button_state = {
	released = 1,
	hovered = 2,
	pressed = 3,
}

-- Predefined button colors for the given button state.
local button_color = {
	[M.button_state.released] = vmath.vector4(1, 1, 1, 0.7),
	[M.button_state.hovered] = vmath.vector4(1, 1, 1, 0.9),
	[M.button_state.pressed] = vmath.vector4(1, 1, 1, 1.0),
}

-- UI Initialization --------------------------------------------

-- Initialize UI with the given languages.
-- @param self The self table from the GUI script.
function M.initialize_ui(self)
	-- Resolve GUI text nodes for information display once during init.
	self.text_node = gui.get_node("text")
	self.language_name_node = gui.get_node("language_name")

	-- Create a table of all buttons with their language name, node, and state.
	self.buttons = {}
	for language_name, _ in pairs(self.languages) do
		-- Set initial button state to released.
		local state = M.button_state.released

		-- Get the button node.
		local node = gui.get_node("btn_" .. language_name)

		-- Add the button to the buttons table.
		self.buttons[language_name] = {
			language_name = language_name,
			node = node,
			state = state
		}

		-- Update initial button color according to the state.
		gui.set_color(node, button_color[state])
	end

	msg.post(".", "acquire_input_focus")
end

-- Layout definitions ------------------------------------------

-- Supported text flow directions used by language layout.
M.layout = {
	ltr = "LTR",
	rtl = "RTL",
}

-- Predefined text node positions for the given layout.
local text_position = {
	[M.layout.ltr] = vmath.vector3(-380, 0, 0),
	[M.layout.rtl] = vmath.vector3(380, 0, 0),
}

-- Predefined text node pivots for the given layout.
local text_pivot = {
	[M.layout.ltr] = gui.PIVOT_W,
	[M.layout.rtl] = gui.PIVOT_E,
}

-- Update UI content --------------------------------------------

-- Update the UI content with the requested language.
-- @param self The self table from the GUI script.
function M.update_ui_content_callback(self)
	-- Update the language text.
	gui.set_text(self.text_node, self.requested_text.text or "")

	-- Update the language name and layout information.
	local layout = self.languages[self.requested_lang].layout
	local header_text = string.format("%s (%s)", self.requested_text.title, layout)
	gui.set_text(self.language_name_node, header_text)

	-- Update the text layout.
	gui.set_pivot(self.text_node, text_pivot[layout])
	gui.set_position(self.text_node, text_position[layout])

	-- Update the input focus.
	msg.post(".", "acquire_input_focus")
end

-- Clear text nodes while a language change is in progress.
-- @param self The self table from the GUI script.
function M.clear_text_nodes(self)
	gui.set_text(self.text_node, "")
	gui.set_text(self.language_name_node, "")
end

-- Input handling -----------------------------------------------

-- Handle pointer move event.
-- @param self The self table from the GUI script.
-- @param x The x position of the pointer.
-- @param y The y position of the pointer.
function M.on_pointer_moved(self, x, y)
	-- Update the state of all buttons according to the pointer position.
	for _, button in pairs(self.buttons) do
		-- Check if the pointer is over the button.
		if gui.pick_node(button.node, x, y) then
			-- If so, set the button state to hovered.
			button.state = M.button_state.hovered
		else
			-- Otherwise, set the button state to released.
			button.state = M.button_state.released
		end
		-- Update the button color according to the new state.
		gui.set_color(button.node, button_color[button.state])
	end
end

-- Get the button pressed and return the language name.
-- @param self The self table from the GUI script.
-- @param x The x position of the pointer.
-- @param y The y position of the pointer.
function M.get_selected_language_on_pressed(self, x, y)
	local selected_language = nil
	-- Find the button pressed.
	for _, button in pairs(self.buttons) do
		-- Check if the pointer is over the button.
		if gui.pick_node(button.node, x, y) then
			-- If so, set the button state to pressed.
			button.state = M.button_state.pressed
			selected_language = button.language_name
		end
		-- Update the button color according to the new state.
		gui.set_color(button.node, button_color[button.state])
	end
	-- Return the language name of the button pressed, nil if not found
	return selected_language
end

-- Handle touch released event.
-- @param self The self table from the GUI script.
-- @param x The x position of the pointer.
-- @param y The y position of the pointer.
function M.on_touch_released(self, x, y)
	-- Find the button released.
	for _, button in pairs(self.buttons) do
		-- Check if the pointer is over the button.
		if gui.pick_node(button.node, x, y) then
			-- If so, set the button state to released.
			button.state = M.button_state.released
		end
		-- Update the button color according to the new state.
		gui.set_color(button.node, button_color[button.state])
	end
end

return M
