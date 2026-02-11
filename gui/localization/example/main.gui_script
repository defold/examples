-- Helper module for UI operations
-- Separated in order not to clutter the example.
local ui = require "example.ui_helper"

-- Helper module for localization operations
local loc = require "example.localization_helper"


function init(self)
	-- Per-language content path, layout (LTR/RTL),
	-- and an optional proxy with font resource to load,
	-- and a True Type Font (TTF) file pre-hashed path.
	self.languages = {
		en = {
			json = "/assets/texts/text_en.json",
			layout = ui.layout.ltr,
			proxy = false,
		},
		ar = {
			json = "/assets/texts/text_ar.json",
			layout = ui.layout.rtl,
			proxy = "#ar_proxy",
			ttf_hash = hash("/assets/fonts/NotoSansArabic-Medium.ttf"),
		},
		pt = {
			json = "/assets/texts/text_pt.json",
			layout = ui.layout.ltr,
			proxy = false,
		},
		ja = {
			json = "/assets/texts/text_ja.json",
			layout = ui.layout.ltr,
			proxy = "#ja_proxy",
			ttf_hash = hash("/assets/fonts/NotoSansJP-Regular.ttf"),
		},
	}

	-- We delegate UI handling to a separate helper module
	-- in order not to clutter the example.
	ui.initialize_ui(self)

	-- Store the font resource of the default font
	-- that is initally used for the text gui node.
	self.default_font_resource = ui.get_font_resource(self.text_node)

	-- Set the GUI initial current language.
	self.current_lang = "en"

	-- Set the initial requested language to the same one.
	self.requested_lang = "en"

	-- Get the text for the requested language from the JSON file.
	self.requested_text = loc.get_content_from_json(self)

	-- Clear texts and update after fonts are prewarmed.
	ui.clear_text_nodes(self)
	loc.finish_language_change(self, ui.update_ui_content_callback)
end

-- Pre-hashed message IDs.
local msg_proxy_loaded = hash("proxy_loaded")
local msg_proxy_unloaded = hash("proxy_unloaded")

function on_message(self, message_id, message, sender)
	-- React to proxy lifecycle messages and continue pending language switch.
	if message_id == msg_proxy_unloaded then

		-- Remove runtime font once its owning proxy is unloaded.
		font.remove_font(self.default_font_resource, self.languages[self.current_lang].ttf_hash)

		-- If old font resource was unloaded, load the new one (or finish with default).
		if self.languages[self.requested_lang].proxy then
			msg.post(self.languages[self.requested_lang].proxy, "async_load")
		else
			loc.finish_language_change(self, ui.update_ui_content_callback)
		end

	elseif message_id == msg_proxy_loaded then
		loc.finish_language_change(self, ui.update_ui_content_callback)
	end
end

-- Pre-hashed action ID.
local action_touch = hash("touch")

function on_input(self, action_id, action)
	-- Pointer move arrives with nil action_id in Defold.
	if action_id == nil and action.x and action.y then
		ui.on_pointer_moved(self, action.x, action.y)
	end

	-- If the action is not a touch:
	if action_id ~= action_touch then
		-- Skip the rest of the input handling.
		return
	end

	-- If the action is a touch and pressed:
	if action.pressed then
		-- Get the selected language on pressed.
		local selected_language = ui.get_selected_language_on_pressed(self, action.x, action.y)

		-- Set the requested language and text.
		self.requested_lang = selected_language or self.requested_lang

		-- If the requested language is different from the current language:
		if self.requested_lang ~= self.current_lang then
			-- Clear current texts while the new font is prepared.
			ui.clear_text_nodes(self)

			-- Get the text for the requested language from the JSON file.
			self.requested_text = loc.get_content_from_json(self)
		end

		-- Process the language change.
		loc.process_language_change(self, ui.update_ui_content_callback)
	end

	-- If the action is a touch and released:
	if action.released then
		-- Handle the touch released event.
		ui.on_touch_released(self, action.x, action.y)
	end
end
