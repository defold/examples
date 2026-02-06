local M = {}

-- Attach the font resource to the default font resource
-- and prewarm the glyphs for smooth rendering.
function M.set_runtime_font_and_prewarm(self, on_font_ready_callback)

	-- If the requested language has a proxy, attach the runtime font:
	if self.languages[self.requested_lang].proxy then
		-- Add the runtime font to the default font resource.
		font.add_font(self.default_font_resource, self.languages[self.requested_lang].ttf_hash)
	end

	-- Prewarm the glyphs for smooth rendering for the given requested text.
	local text = self.requested_text.text
	font.prewarm_text(self.default_font_resource, text, on_font_ready_callback)
end

-- Finalize language switch once the required font can render requested text.
function M.finish_language_change(self, on_font_ready_callback)
	-- Prepare a callback function that will be called when fonts are ready.
	local on_language_changed = function()
		
		-- New language has been set, change the current language variable.
		self.current_lang = self.requested_lang

		on_font_ready_callback(self)
	end

	-- Set the runtime font and prewarm the glyphs for smooth rendering.
	M.set_runtime_font_and_prewarm(self, on_language_changed)
end

-- Process the language change.
function M.process_language_change(self, callback_on_font_ready)
	-- If the requested language is the same as the current language:
	if self.requested_lang == self.current_lang then

		-- No change needed, skip the rest of the language change process.
		return
	end

	-- Otherwise:
	-- Release the input focus during the language change,
	-- so the user cannot interact in the meantime.
	-- You can still allow it, if needed in your game,
	-- but in that case keep track of the status of (un)loading.
	msg.post(".", "release_input_focus")

	local requested_language_proxy = self.languages[self.requested_lang].proxy
	local current_language_proxy = self.languages[self.current_lang].proxy

	-- If the requested language font is the same as the current:
	if requested_language_proxy == current_language_proxy then
		-- Finish the language change with prewarm.
		M.finish_language_change(self, callback_on_font_ready)

		-- And skip the rest of the language change process.
		return
	end

	-- Otherwise:
	-- If the current language is with a loaded proxy:
	if current_language_proxy then

		-- Unload this collection with the font resource first.
		msg.post(current_language_proxy, "unload")

		-- And skip the rest of the language change process.
		return
	end

	-- Load the new font.
	msg.post(requested_language_proxy, "async_load")
end


-- JSON file handling ------------------------------------------

-- Get the text for the requested language from the JSON file.
function M.get_content_from_json(self)
	-- Load the JSON file for the requested language.
	local language = self.languages[self.requested_lang]
	local json_file = sys.load_resource(language.json)
	assert(json_file, "Failed to load JSON file for language: " .. self.requested_lang)

	-- Return the decoded JSON file as a table.
	return json.decode(json_file) or {}
end

return M
