local TOUCH = hash("touch") -- <1>
local MSG_PLAY_MODEL_ANIMATION = hash("play_model_animation") -- <2>
local MODEL_SCRIPT = "/character#main" -- <3>

local ANIMATIONS = { -- <4>
	"A_TPose",
	"Crouch_Fwd_Loop",
	"Crouch_Idle_Loop",
	"Dance_Loop",
	"Death01",
	"Driving_Loop",
	"Fixing_Kneeling",
	"Hit_Chest",
	"Hit_Head",
	"Idle_Loop",
	"Idle_Talking_Loop",
	"Idle_Torch_Loop",
	"Interact",
	"Jog_Fwd_Loop",
	"Jump_Land",
	"Jump_Loop",
	"Jump_Start",
	"PickUp_Table",
	"Pistol_Aim_Down",
	"Pistol_Aim_Neutral",
	"Pistol_Aim_Up",
	"Pistol_Idle_Loop",
	"Pistol_Reload",
	"Pistol_Shoot",
	"Punch_Cross",
	"Punch_Jab",
	"Push_Loop",
	"Roll",
	"Roll_RM",
	"Sitting_Enter",
	"Sitting_Exit",
	"Sitting_Idle_Loop",
	"Sitting_Talking_Loop",
	"Spell_Simple_Enter",
	"Spell_Simple_Exit",
	"Spell_Simple_Idle_Loop",
	"Spell_Simple_Shoot",
	"Sprint_Loop",
	"Swim_Fwd_Loop",
	"Swim_Idle_Loop",
	"Sword_Attack",
	"Sword_Attack_RM",
	"Sword_Idle",
	"Walk_Formal_Loop",
	"Walk_Loop",
}

local function set_button_enabled(button_node, enabled)
	local color = enabled and vmath.vector4(1, 1, 1, 1) or vmath.vector4(0.7, 0.7, 0.7, 1)
	gui.set_color(button_node, color) -- <5>
end

function init(self)
	msg.post(".", "acquire_input_focus") -- <6>

	self.buttons = {} -- <7>
	self.selected_index = nil

	for index, animation_id in ipairs(ANIMATIONS) do -- <8>
		local button_id = "button_" .. string.format("%02d", index)
		local text_id = "button_text_" .. string.format("%02d", index)
		local button_node = gui.get_node(button_id)
		local text_node = gui.get_node(text_id)

		gui.set_text(text_node, animation_id) -- <9>
		set_button_enabled(button_node, true)

		self.buttons[index] = { -- <10>
			node = button_node,
			animation_id = animation_id,
		}
	end
end

function on_input(self, action_id, action)
	if action_id ~= TOUCH or not action.pressed then -- <11>
		return false
	end

	for index, button in ipairs(self.buttons) do
		if gui.pick_node(button.node, action.x, action.y) then -- <12>
			if self.selected_index then
				set_button_enabled(self.buttons[self.selected_index].node, true)
			end

			self.selected_index = index
			set_button_enabled(button.node, false) -- <13>

			msg.post(MODEL_SCRIPT, MSG_PLAY_MODEL_ANIMATION, { -- <14>
				animation_id = hash(button.animation_id),
				animation_name = button.animation_id,
			})

			return true
		end
	end

	return false
end

-- <1> The input binding uses the touch action for both mouse clicks and touch input in this example.
-- <2> This is the same message id used by main.script, so both scripts agree on the command name.
-- <3> GUI scripts cannot address model components directly in a clean way here, so the GUI sends a message to the character script instead.
-- <4> The animation list is ordered to match the generated GUI buttons: button_01 plays the first clip, button_02 the second clip, and so on.
-- <5> The selected button is dimmed by changing the box node color. The text nodes stay unchanged and remain readable on the separate text layer.
-- <6> The GUI must acquire input focus before on_input() receives click/touch events.
-- <7> Store runtime references to the GUI nodes once during init instead of resolving them every click.
-- <8> Button and text node ids are generated from the animation index, matching the button_01/button_text_01 naming convention in main.gui.
-- <9> The visible label is filled from the animation list, so the GUI file does not need to hardcode animation names in every text node.
-- <10> Each button entry stores the clickable box node and the animation id it should request.
-- <11> Ignore all non-press input events. This prevents the same click/touch from triggering repeatedly during release or movement phases.
-- <12> gui.pick_node() tests whether the click position is inside the button box node.
-- <13> Re-enable the previously selected button and dim the newly selected one to show which animation is currently active.
-- <14> Send the selected animation to the model-owning script. The animation is sent as a hash for model.play_anim(), with the string kept only as readable debug/context data.
