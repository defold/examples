local EASING_FUNCTIONS = require("example.easing_functions") -- <1>
local DEMO_URLS = { "position_demo", "rotation_demo", "scale_demo" } -- <2>

local PREVIOUS = -1
local NEXT = 1
local PREV_EASING_DEMO = hash("prev_easing_demo")
local NEXT_EASING_DEMO = hash("next_easing_demo")
local DEMO_CHANGED = hash("demo_changed")
local KEY_LEFT = hash("key_left")
local KEY_RIGHT = hash("key_right")
local RESTART = hash("restart")

local function wrap_index(index)
	if index < 1 then
		return #EASING_FUNCTIONS
	elseif index > #EASING_FUNCTIONS then
		return 1
	end
	return index
end

local function restart_demo_animations(easing)
	for _, url in ipairs(DEMO_URLS) do
		msg.post(url, RESTART, { easing = easing.value }) -- <3>
	end
end

local function update_gui(self)
	msg.post("/hud#gui", DEMO_CHANGED, { -- <4>
		index = self.index,
		total = #EASING_FUNCTIONS,
		easing_name = self.easing.name
	})
end

local function change_easing_demo(self, index_change)
	self.index = wrap_index(self.index + index_change) -- <5>
	self.easing = EASING_FUNCTIONS.get_by_index(self.index)
	restart_demo_animations(self.easing)
	update_gui(self)
end

function init(self)
	msg.post(".", "acquire_input_focus") -- <6>
	self.index = 1
	self.easing = EASING_FUNCTIONS.get_by_index(self.index)
	restart_demo_animations(self.easing)
	update_gui(self)
end

function final(self)
	msg.post(".", "release_input_focus")
end

function on_message(self, message_id)
	if message_id == PREV_EASING_DEMO then
		change_easing_demo(self, PREVIOUS)
	elseif message_id == NEXT_EASING_DEMO then
		change_easing_demo(self, NEXT)
	end
end

function on_input(self, action_id, action)
	if action_id == KEY_LEFT and action.pressed then -- <7>
		change_easing_demo(self, PREVIOUS)
	elseif action_id == KEY_RIGHT and action.pressed then
		change_easing_demo(self, NEXT)
	end
end

--[[
1. The helper module stores the built-in easing constants together with display names for the HUD.
2. These child game objects all use `animator.script`, but their script property overrides make them animate different transform properties.
3. The controller does not animate the logos directly. It sends the selected easing constant to each animator in a `restart` message.
4. The HUD receives only presentation data: the current index, total count, and easing name.
5. Wrap the index so pressing left on the first easing function jumps to the last one, and pressing right on the last jumps back to the first.
6. The controller acquires input focus so it can receive keyboard actions from the built-in input binding.
7. The left and right arrow keys step through the easing list.
]]
