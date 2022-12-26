local lookup = require "examples.animation.easing.easing_functions"

local PREVIOUS = -1; local NEXT = 1

local function change_index_by(index, delta)
	index = (index + delta) % #lookup
	if index < 1 then
		index = #lookup
	end
	return index
end

local function restart_demo_animations(easing)
	msg.post("position_demo", "restart", { easing = easing.value })
	msg.post("rotation_demo", "restart", { easing = easing.value })
	msg.post("scale_demo", "restart", { easing = easing.value })
end

local function update_gui(self)
	msg.post("/hud#gui", "demo_changed", {
		index = self.index,
		total = #lookup,
		easing_name = self.easing.name
	})
end

local function change_easing_demo(self, index_change)
	self.index = change_index_by(self.index, index_change)
	self.easing = lookup.get_by_index(self.index)
	restart_demo_animations(self.easing)
	update_gui(self)
end

function init(self)
	msg.post(".", "acquire_input_focus")
	self.index = 1
	self.easing = lookup.get_by_index(self.index)
	restart_demo_animations(self.easing)
	update_gui(self)
end

function final(self)
	msg.post(".", "release_input_focus")
end

function on_message(self, message_id, message, sender)
	if message_id == hash("prev_easing_demo") then
		change_easing_demo(self, PREVIOUS)
	elseif message_id == hash("next_easing_demo") then
		change_easing_demo(self, NEXT)
	end
end

function on_input(self, action_id, action)
	if action_id == hash("left") and action.pressed then
		change_easing_demo(self, PREVIOUS)
	elseif action_id == hash("right") and action.pressed then
		change_easing_demo(self, NEXT)
	end
end
