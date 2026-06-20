local BUTTONS = {
	{ node = "button_1", message = hash("play_idle") },
	{ node = "button_2", message = hash("play_walk") },
	{ node = "button_3", message = hash("play_attack") },
	{ node = "button_4", message = hash("play_block") },
	{ node = "button_5", message = hash("play_cheer") },
}

local function post_animation(message_id)
	msg.post("player#player", message_id)
end

function init(self)
	msg.post(".", "acquire_input_focus") -- <1>

	self.buttons = {}
	for i = 1, #BUTTONS do
		self.buttons[i] = {
			node = gui.get_node(BUTTONS[i].node),
			message = BUTTONS[i].message,
		}
	end
end

function on_input(self, action_id, action)
	if (action_id == hash("touch") or action_id == hash("mouse_button_left")) and action.pressed then -- <2>
		for i = 1, #self.buttons do
			local button = self.buttons[i]
			if gui.pick_node(button.node, action.x, action.y) then -- <3>
				post_animation(button.message) -- <4>
				break
			end
		end
	end
end

--[[
1. Acquire input focus so the GUI receives clicks and touches.
2. React to mouse or touch press events.
3. Check whether the pointer landed on one of the button nodes.
4. Send the selected animation message to the player script.
]]
