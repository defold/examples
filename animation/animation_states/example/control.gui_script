local fsm = require("example.fsm")

local SET_TARGET_STATE = hash("set_target_state")
local TRIGGER_STATE = hash("trigger_state")
local ANIMATION_STATE_CHANGED = hash("animation_state_changed")

local KNIGHT_URL = "/knight#knight"

-- <1>
local INPUT = {
	TOUCH = hash("touch"),
	LEFT = hash("left"),
	RIGHT = hash("right"),
	JUMP = hash("jump"),
	ATTACK = hash("attack"),
	CROUCH = hash("crouch")
}

local DEFAULT_COLOR = vmath.vector4(0.3, 0.4, 0.8, 1.0)
local ACTIVE_COLOR = vmath.vector4(0.4, 0.5, 0.9, 1.0)

-- <2>
local LOCOMOTION_STATES = {
	idle = {},
	run = {}
}

-- <3>
local LOCOMOTION_TRANSITIONS = {
	idle = { "run" },
	run = { "idle" }
}

-- <4>
local POSTURE_STATES = {
	standing = {},
	crouching = {}
}

-- <5>
local POSTURE_TRANSITIONS = {
	standing = { "crouching" },
	crouching = { "standing" }
}

-- <6>
local STATE_HIGHLIGHTS = {
	standing_idle = { "idle" },
	standing_run = { "run" },
	standing_jump = { "jump" },
	standing_attack = { "attack" },
	standing_turn = { "turn_around" },
	crouching_idle = { "crouch" },
	crouching_run = { "run", "crouch" },
	crouching_attack = { "attack", "crouch" },
	to_crouch = { "crouch" },
	to_standing = { "crouch" }
}

-- <7>
local function get_locomotion_state(self)
	return fsm.get_state_name(self.locomotion_fsm)
end

-- <8>
local function get_posture_state(self)
	return fsm.get_state_name(self.posture_fsm)
end

-- <9>
local function update_button_visual(node, is_active)
	gui.set_color(node, is_active and ACTIVE_COLOR or DEFAULT_COLOR)
end

-- <10>
local function refresh_buttons(self, state_name)
	for _, node in pairs(self.buttons) do
		update_button_visual(node, false)
	end

	for _, node_id in ipairs(STATE_HIGHLIGHTS[state_name] or {}) do
		update_button_visual(self.buttons[node_id], true)
	end
end

-- <11>
local function is_keyboard_running(self)
	return self.keyboard_direction_left ~= nil
end

-- <12>
local function refresh_keyboard_direction(self)
	if self.left_down and not self.right_down then
		self.keyboard_direction_left = true
	elseif self.right_down and not self.left_down then
		self.keyboard_direction_left = false
	elseif not self.left_down and not self.right_down then
		self.keyboard_direction_left = nil
	end
end

-- <13>
local function get_requested_direction(self)
	if self.keyboard_direction_left ~= nil then
		return self.keyboard_direction_left
	end

	return self.direction_left
end

-- <14>
local function update_control_fsms(self)
	local next_locomotion_state = "idle"
	local next_posture_state = "standing"

	if self.run_requested or is_keyboard_running(self) then
		next_locomotion_state = "run"
	end

	if self.crouch_toggled or self.crouch_down then
		next_posture_state = "crouching"
	end

	if next_locomotion_state ~= get_locomotion_state(self) then
		fsm.set_state(self.locomotion_fsm, next_locomotion_state)
	end

	if next_posture_state ~= get_posture_state(self) then
		fsm.set_state(self.posture_fsm, next_posture_state)
	end
end

-- <15>
local function get_base_state(self)
	local locomotion_state = get_locomotion_state(self)
	local posture_state = get_posture_state(self)

	if posture_state == "crouching" then
		return locomotion_state == "run" and "crouching_run" or "crouching_idle"
	end

	return locomotion_state == "run" and "standing_run" or "standing_idle"
end

-- <16>
local function send_base_state(self)
	msg.post(KNIGHT_URL, SET_TARGET_STATE, {
		state = get_base_state(self),
		facing_left = self.direction_left
	})
end

-- <17>
local function send_trigger_state(self, state_name)
	msg.post(KNIGHT_URL, TRIGGER_STATE, {
		state = state_name,
		facing_left = self.direction_left
	})
end

-- <18>
local function sync_knight(self, play_turn_animation)
	local previous_direction_left = self.direction_left

	self.direction_left = get_requested_direction(self)
	update_control_fsms(self)

	-- <19>
	if play_turn_animation and previous_direction_left ~= self.direction_left and get_posture_state(self) == "standing" then
		send_trigger_state(self, "standing_turn")
	end

	send_base_state(self)
end

-- <20>
local function request_idle(self)
	self.run_requested = false
	sync_knight(self)
end

-- <21>
local function request_run(self)
	self.run_requested = true
	sync_knight(self)
end

-- <22>
local function request_turn(self)
	self.direction_left = not get_requested_direction(self)

	if get_posture_state(self) == "standing" then
		send_trigger_state(self, "standing_turn")
	end

	send_base_state(self)
end

-- <23>
local function request_jump(self)
	if get_posture_state(self) == "crouching" then
		return
	end

	send_trigger_state(self, "standing_jump")
end

-- <24>
local function request_attack(self)
	local attack_state = get_posture_state(self) == "crouching" and "crouching_attack" or "standing_attack"
	send_trigger_state(self, attack_state)
end

-- <25>
local function request_crouch_toggle(self)
	self.crouch_toggled = not self.crouch_toggled
	sync_knight(self)
end

-- <26>
local function press_button(self, node_id)
	if node_id == "idle" then
		request_idle(self)
	elseif node_id == "run" then
		request_run(self)
	elseif node_id == "turn_around" then
		request_turn(self)
	elseif node_id == "jump" then
		request_jump(self)
	elseif node_id == "attack" then
		request_attack(self)
	elseif node_id == "crouch" then
		request_crouch_toggle(self)
	end
end

-- <27>
local function pick_button(self, x, y)
	for node_id, node in pairs(self.buttons) do
		if gui.pick_node(node, x, y) then
			return node_id
		end
	end

	return nil
end

function init(self)
	-- <28>
	self.buttons = {
		idle = gui.get_node("idle"),
		run = gui.get_node("run"),
		turn_around = gui.get_node("turn_around"),
		jump = gui.get_node("jump"),
		attack = gui.get_node("attack"),
		crouch = gui.get_node("crouch")
	}

	-- <29>
	self.locomotion_fsm = fsm.new({
		states = LOCOMOTION_STATES,
		transitions = LOCOMOTION_TRANSITIONS,
		initial_state = "idle"
	})

	self.posture_fsm = fsm.new({
		states = POSTURE_STATES,
		transitions = POSTURE_TRANSITIONS,
		initial_state = "standing"
	})

	self.left_down = false
	self.right_down = false
	self.keyboard_direction_left = nil
	self.crouch_down = false
	self.crouch_toggled = false
	self.run_requested = false
	self.direction_left = false

	refresh_buttons(self, "standing_idle")

	-- <30>
	msg.post(".", "acquire_input_focus")
	send_base_state(self)
end

function on_input(self, action_id, action)
	-- <31>
	if action_id == INPUT.LEFT then
		if action.pressed then
			self.left_down = true
			self.keyboard_direction_left = true
			sync_knight(self, true)
		elseif action.released then
			self.left_down = false
			refresh_keyboard_direction(self)
			sync_knight(self)
		end

	-- <32>
	elseif action_id == INPUT.RIGHT then
		if action.pressed then
			self.right_down = true
			self.keyboard_direction_left = false
			sync_knight(self, true)
		elseif action.released then
			self.right_down = false
			refresh_keyboard_direction(self)
			sync_knight(self)
		end

	-- <33>
	elseif action_id == INPUT.CROUCH then
		if action.pressed then
			self.crouch_down = true
			sync_knight(self)
		elseif action.released then
			self.crouch_down = false
			sync_knight(self)
		end

	-- <34>
	elseif action_id == INPUT.JUMP and action.pressed then
		request_jump(self)

	-- <35>
	elseif action_id == INPUT.ATTACK and action.pressed then
		request_attack(self)

	-- <36>
	elseif action_id == INPUT.TOUCH and action.pressed then
		local node_id = pick_button(self, action.x, action.y)

		if node_id then
			press_button(self, node_id)
			return true
		end
	end
end

function on_message(self, message_id, message)
	-- <37>
	if message_id == ANIMATION_STATE_CHANGED then
		refresh_buttons(self, message.state)
	end
end

--[[
1. `INPUT` stores the action hashes used by the GUI controller.
2. `LOCOMOTION_STATES` defines one small control FSM with the states `idle` and `run`.
3. `LOCOMOTION_TRANSITIONS` says that locomotion may move back and forth between `idle` and `run`.
4. `POSTURE_STATES` defines another control FSM with the states `standing` and `crouching`.
5. `POSTURE_TRANSITIONS` says that posture may move back and forth between `standing` and `crouching`.
6. `STATE_HIGHLIGHTS` maps animation states to the GUI buttons that should be highlighted.
7. `get_locomotion_state()` reads the current state of the locomotion FSM.
8. `get_posture_state()` reads the current state of the posture FSM.
9. `update_button_visual()` changes one button between its default and active color.
10. `refresh_buttons()` redraws the whole control panel from the animation state reported by the knight.
11. Keyboard running stays active while at least one direction key is held.
12. `refresh_keyboard_direction()` keeps the most recently active keyboard direction and clears it only when both direction keys are released.
13. `get_requested_direction()` uses the active keyboard direction when present, otherwise it keeps the direction remembered from GUI controls.
14. `update_control_fsms()` derives the locomotion and posture states from the stored run and crouch input flags.
15. `get_base_state()` combines the two control FSM states into one stable looping animation target for the knight.
16. `send_base_state()` tells the knight which looping animation state it should settle into next.
17. `send_trigger_state()` starts one-shot states such as jump, attack, or turn.
18. `sync_knight()` is the main controller helper. It updates direction, advances the two control FSMs, and then sends the correct animation requests.
19. A standing direction change can play the dedicated turn animation, but crouching just changes facing immediately because there is no crouch turn state.
20. Clicking the idle button clears the stored run request.
21. Clicking the run button sets the stored run request.
22. Clicking the turn button flips direction but keeps the current locomotion and posture states.
23. Jump is only requested while the posture FSM is in the `standing` state.
24. Attack chooses the standing or crouching attack from the current posture FSM state.
25. Toggling crouch changes the raw crouch intent, and then the two controller FSMs derive the correct stable states from it.
26. `press_button()` translates GUI node names into controller actions.
27. `pick_button()` checks which on-screen button was clicked.
28. `init()` caches the GUI nodes used by the control panel.
29. The GUI creates two reusable FSM instances: one for locomotion and one for posture.
30. The GUI script owns input focus, then sends the initial idle target to the knight.
31. Left key input updates both the raw held-key state and the active keyboard direction.
32. Right key input works the same way as left key input.
33. Keyboard crouch behaves like a held input, so pressing and releasing it directly updates the raw crouch flag.
34. Jump input sends a one-shot jump request.
35. Attack input sends a one-shot attack request.
36. The mouse or single-touch action uses `gui.pick_node()` so the on-screen buttons work as controls.
37. The GUI only changes its highlights when the knight reports a new active animation state.
--]]
