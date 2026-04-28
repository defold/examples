local fsm = require("example.fsm")

local SET_TARGET_STATE = hash("set_target_state")
local TRIGGER_STATE = hash("trigger_state")
local ANIMATION_DONE = hash("animation_done")
local ANIMATION_STATE_CHANGED = hash("animation_state_changed")

local GUI_URL = "/gui#control"

-- <1>
local ANIMATION_STATES = {
	standing_idle = {
		animation = hash("idle"),
		loop = true
	},
	standing_run = {
		animation = hash("run"),
		loop = true
	},
	standing_jump = {
		animation = hash("jump"),
		loop = false
	},
	standing_attack = {
		animation = hash("attack"),
		loop = false
	},
	standing_turn = {
		animation = hash("turn_around"),
		loop = false
	},
	crouching_idle = {
		animation = hash("crouch_idle"),
		loop = true
	},
	crouching_run = {
		animation = hash("crouch_walk"),
		loop = true
	},
	crouching_attack = {
		animation = hash("crouch_attack"),
		loop = false
	},
	to_crouch = {
		animation = hash("to_crouch"),
		loop = false
	},
	to_standing = {
		animation = hash("from_crouch"),
		loop = false
	}
}

-- <2>
local ANIMATION_TRANSITIONS = {
	standing_idle = { "standing_run", "standing_jump", "standing_attack", "standing_turn", "to_crouch" },
	standing_run = { "standing_idle", "standing_jump", "standing_attack", "standing_turn", "to_crouch" },
	standing_jump = { "standing_idle", "standing_run", "standing_attack", "standing_turn", "to_crouch" },
	standing_attack = { "standing_idle", "standing_run", "standing_jump", "standing_turn", "to_crouch" },
	standing_turn = { "standing_idle", "standing_run", "standing_jump", "standing_attack", "to_crouch" },
	crouching_idle = { "crouching_run", "crouching_attack", "to_standing" },
	crouching_run = { "crouching_idle", "crouching_attack", "to_standing" },
	crouching_attack = { "crouching_idle", "crouching_run", "to_standing" },
	to_crouch = { "crouching_idle", "crouching_run", "crouching_attack" },
	to_standing = { "standing_idle", "standing_run", "standing_jump", "standing_attack", "standing_turn" }
}

-- <3>
local function get_animation_state_name(self)
	return fsm.get_state_name(self.animation_fsm)
end

-- <4>
local function get_animation_state(self)
	return fsm.get_state(self.animation_fsm)
end

-- <5>
local function stop_jump_effect(self)
	local position = go.get_position()
	go.cancel_animations(".", "position.y")
	go.set_position(vmath.vector3(position.x, self.ground_y, position.z))
end

-- <6>
local function start_jump_effect(self)
	stop_jump_effect(self)
	go.animate(".", "position.y", go.PLAYBACK_ONCE_PINGPONG, self.ground_y + 50, go.EASING_INOUTCUBIC, 0.6)
end

-- <7>
local function apply_facing(self)
	self.facing_left = self.desired_facing_left
	sprite.set_hflip("#sprite", self.facing_left)
end

-- <8>
local function refresh_visuals(self, previous_state_name)
	local state = get_animation_state(self)
	local current_state_name = get_animation_state_name(self)

	-- <9>
	if not state or not current_state_name then
		return
	end

	-- <10>
	if previous_state_name == "standing_jump" and current_state_name ~= "standing_jump" then
		stop_jump_effect(self)
	end

	-- <11>
	if current_state_name ~= "standing_turn" then
		apply_facing(self)
	end

	-- <12>
	sprite.play_flipbook("#sprite", state.animation)

	-- <13>
	if current_state_name == "standing_jump" then
		start_jump_effect(self)
	end

	-- <14>
	msg.post(GUI_URL, ANIMATION_STATE_CHANGED, { state = current_state_name })
end

-- <15>
local function enter_animation_state(self, next_state_name)
	local previous_state_name = get_animation_state_name(self)

	-- <16>
	if previous_state_name == next_state_name then
		if next_state_name ~= "standing_turn" then
			apply_facing(self)
		end

		return
	end

	-- <17>
	if not fsm.set_state(self.animation_fsm, next_state_name) then
		return
	end

	refresh_visuals(self, previous_state_name)
end

-- <18>
local function advance_animation_fsm(self, allow_from_finished_state)
	local requested_state = self.trigger_state or self.target_state
	local current_state = get_animation_state(self)

	-- <19>
	if not requested_state then
		return
	end

	-- <20>
	if not allow_from_finished_state and current_state and not current_state.loop then
		return
	end

	-- <21>
	if requested_state == get_animation_state_name(self) then
		enter_animation_state(self, requested_state)
		return
	end

	local path = fsm.find_path(self.animation_fsm, requested_state)

	-- <22>
	if not path then
		return
	end

	-- <23>
	for _, next_state_name in ipairs(path) do
		enter_animation_state(self, next_state_name)

		if not get_animation_state(self).loop then
			return
		end
	end
end

function init(self)
	-- <24>
	self.animation_fsm = fsm.new({
		states = ANIMATION_STATES,
		transitions = ANIMATION_TRANSITIONS
	})

	self.target_state = "standing_idle"
	self.trigger_state = nil
	self.facing_left = false
	self.desired_facing_left = false
	self.ground_y = go.get_position().y

	-- <25>
	enter_animation_state(self, self.target_state)
end

function on_message(self, message_id, message)
	-- <26>
	if message_id == SET_TARGET_STATE then
		self.target_state = message.state
		self.desired_facing_left = message.facing_left
		advance_animation_fsm(self)

	-- <27>
	elseif message_id == TRIGGER_STATE then
		self.trigger_state = message.state
		self.desired_facing_left = message.facing_left
		advance_animation_fsm(self)

	-- <28>
	elseif message_id == ANIMATION_DONE then
		if get_animation_state_name(self) == "standing_turn" then
			apply_facing(self)
		end

		-- <29>
		if self.trigger_state == get_animation_state_name(self) then
			self.trigger_state = nil
		end

		-- <30>
		advance_animation_fsm(self, true)
	end
end

--[[
1. `ANIMATION_STATES` is the data table for the knight animation FSM. Each state only stores the animation id and whether the state loops.
2. `ANIMATION_TRANSITIONS` is the animation graph. The knight may only move along these legal transitions.
3. `get_animation_state_name()` reads the current animation state id from the reusable FSM module.
4. `get_animation_state()` reads the current animation state's data table from the reusable FSM module.
5. `stop_jump_effect()` clears the extra Y movement used to visualize a jump and snaps the knight back to the ground height.
6. `start_jump_effect()` starts the temporary Y animation for the jump. This can stay simple because jump is not cancelable in this example.
7. `apply_facing()` updates the sprite horizontal flip from the direction requested by the GUI controller.
8. `refresh_visuals()` handles the visual side effects of entering a state. It does not choose the next state; it only updates how the current state looks.
9. This guard leaves the helper idle if it is called before the FSM has an active state.
10. When the FSM leaves `standing_jump`, the jump offset is removed so the knight returns to ground level.
11. `standing_turn` is special because the knight should keep the old facing until the turn animation finishes.
12. Every animation state plays its own configured flipbook on the sprite.
13. Entering `standing_jump` also starts the extra Y movement so the jump is easier to see.
14. The knight reports the active animation state to the GUI so the control panel can highlight the correct buttons.
15. `enter_animation_state()` is the one place where the knight animation FSM actually changes state.
16. Re-entering the same state does not restart the flipbook; it only applies a facing change when the state allows immediate facing updates.
17. `fsm.set_state()` performs one legal direct transition. If the transition is invalid, the function stops there.
18. `advance_animation_fsm()` is the main stepper for the animation FSM. It moves the knight toward the latest requested state.
19. If nothing has been requested, there is nothing for the animation FSM to do.
20. If a non-looping state is still playing, the knight waits for `animation_done` before continuing.
21. If the requested state is already active, the knight only needs to apply same-state side effects such as facing.
22. If the reusable FSM module cannot find a legal path, the knight ignores that request.
23. The animation FSM walks along the path until it reaches a non-looping state that must finish before the next step can happen.
24. The knight creates one reusable FSM instance for its animation logic.
25. The knight starts by entering `standing_idle` through the same helper used for all later state changes.
26. `set_target_state` updates the stable looping state the knight should eventually settle into.
27. `trigger_state` starts a one-shot state such as jump, attack, or turn.
28. Because `sprite.play_flipbook()` is called without a completion callback, Defold sends `animation_done` when a non-looping flipbook finishes.
29. After a one-shot trigger finishes, the trigger request is cleared so the knight can continue toward the latest stable target.
30. Passing `true` here allows the FSM to continue from the finished non-looping state instead of stopping on it.
--]]
