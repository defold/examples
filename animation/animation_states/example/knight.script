-- ============================================================================
-- KNIGHT ANIMATION STATE MACHINE - Beginner Friendly Example
-- ============================================================================
-- This script demonstrates how to create a character animation system using
-- a simple implementation of a Finite State Machine (FSM) in Defold.

-- Input action hashes - these connect keyboard/gamepad buttons to our code
-- In Defold, we use hash() to convert strings to efficient identifiers
local INPUT = {
	JUMP = hash("jump"),
	CROUCH = hash("crouch"),
	ATTACK = hash("attack"),
	LEFT = hash("left"),
	RIGHT = hash("right")
}

-- ============================================================================
-- STATE MACHINE CONFIGURATION
-- ============================================================================
-- This table defines ALL possible states our character can be in.
-- Think of it as a "rule book" that tells the game:
-- - What animation to play in each state
-- - Whether the animation should loop or play once
-- - What should happen when the player presses different buttons
--
-- Each state is like a "mode" the character is in. For example:
-- - "standing_idle" = character is standing still, playing idle animation, looped
--
-- The "on_" properties define what happens when inputs are pressed, e.g.:
-- - on_attack = what state to go to when attack button is pressed
-- - on_move = what state to go to when movement keys are pressed
-- - default_next = what state to go to when animation finishes (for non-looped animations)

local STATE_CONFIG = {
	-- STANDING STATES - Character is upright and can move freely
	-- These are the "normal" states when the character is standing
	standing_idle = {
		animation = "idle",      -- Play the "idle" animation from the sprite atlas
		is_looped = true,        -- Keep playing this animation over and over
		on_crouch = "to_crouch", -- If crouch key pressed, go to "to_crouch" state
		on_attack = "standing_attack", -- If attack key pressed, go to "standing_attack" state
		on_jump = "standing_jump", -- If jump key pressed, go to "standing_jump" state
		on_move = "standing_run", -- If movement keys pressed, go to "standing_run" state
		on_turn = "standing_turn" -- If character turns around, go to "standing_turn" state
	},
	standing_run = {
		animation = "run",       -- Play the running animation
		is_looped = true,        -- Loop the running animation continuously
		on_crouch = "to_crouch", -- Can still crouch while running
		on_attack = "standing_attack", -- Can attack while running
		on_jump = "standing_jump", -- Can jump while running
		on_stop = "standing_idle", -- When movement stops, go back to idle
		on_turn = "standing_turn" -- When turning around, play turn animation
	},
	standing_jump = {
		animation = "jump",      -- Play the jump animation
		is_looped = false,       -- Play jump animation only once
		default_next = "standing_idle" -- When jump animation finishes, go back to idle
	},
	standing_attack = {
		animation = "attack",    -- Play the attack animation
		is_looped = false,       -- Play attack animation only once
		default_next = "standing_idle" -- When attack finishes, go back to idle
	},
	standing_turn = {
		animation = "turn_around", -- Play the turn around animation
		is_looped = false,        -- Play turn animation only once
		default_next = "standing_idle", -- When turn finishes, go to idle
		on_turn = "standing_turn" -- If turning again while already turning, keep turning
	},

	-- CROUCHING STATES - Character is in low position, limited movement
	-- When crouching, the character can't jump but can still move and attack
	crouching_idle = {
		animation = "crouch_idle", -- Play the crouching idle animation
		is_looped = true,         -- Loop the crouch idle animation
		on_stand = "to_standing", -- If crouch key released, start standing up
		on_attack = "crouching_attack", -- Can attack while crouching
		on_move = "crouching_run" -- Can move while crouching (crouch walk)
	},
	crouching_run = {
		animation = "crouch_walk", -- Play the crouch walking animation
		is_looped = true,         -- Loop the crouch walk animation
		on_stand = "to_standing", -- Can stand up while crouch walking
		on_attack = "crouching_attack", -- Can attack while crouch walking
		on_stop = "crouching_idle" -- When movement stops, go to crouch idle
	},
	crouching_attack = {
		animation = "crouch_attack", -- Play the crouch attack animation
		is_looped = false,         -- Play attack animation only once
		default_next = "crouching_idle", -- When attack finishes, go to crouch idle
		on_stand = "to_standing",  -- Can stand up even while attacking
	},

	-- TRANSITION STATES - Intermediate animations between major state changes
	-- These states handle the smooth transition between standing and crouching
	to_crouch = {
		animation = "to_crouch",  -- Play the "going into crouch" animation
		is_looped = false,        -- Play transition animation only once
		default_next = "crouching_idle" -- When transition finishes, go to crouch idle
	},
	to_standing = {
		animation = "from_crouch", -- Play the "standing up from crouch" animation
		is_looped = false,       -- Play transition animation only once
		default_next = "standing_idle" -- When transition finishes, go to standing idle
	}
}

-- ============================================================================
-- MOVEMENT AND DIRECTION LOGIC
-- ============================================================================

--- Updates movement state and sprite direction based on input
--- This function figures out:
--- 1. Is the character moving? (left or right key pressed)
--- 2. Which direction is the character facing? (left or right)
--- 3. Did the character just turn around? (for turn animation)
--- @param self table Script instance with input flags
local function update_movement_state(self)
	-- Start by assuming the character is not moving
	self.is_moving = false

	-- Remember the previous facing direction to detect turns
	local previous_is_flipped = self.is_flipped

	-- Check movement input and update facing direction
	if self[INPUT.LEFT] and not self[INPUT.RIGHT] then
		-- Left key is pressed and right key is not pressed
		self.is_moving = true
		self.is_flipped = true -- Character faces left (sprite is flipped)
	elseif self[INPUT.RIGHT] and not self[INPUT.LEFT] then
		-- Right key is pressed and left key is not pressed
		self.is_moving = true
		self.is_flipped = false -- Character faces right (sprite is not flipped)
	end
	-- If both keys are pressed or neither is pressed, character doesn't move

	-- Detect if the character just turned around - used to trigger the "turn around" animation
	self.is_turning = self.is_flipped ~= previous_is_flipped
end


-- ============================================================================
-- STATE TRANSITION LOGIC
-- ============================================================================

--- Determines the next state based on current input and state configuration
--- This is the "brain" of our state machine - it decides what state to go to next
---
--- INPUT PRIORITY SYSTEM (in order of importance):
--- 1. Attack - Highest priority, can interrupt most other actions
--- 2. Jump - High priority, can interrupt movement
--- 3. Movement - Medium priority, handles start/stop moving
--- 4. Crouch/Stand - Medium priority, changes posture
--- 5. Turn - Lowest priority, only when changing direction
---
--- @param self table Script instance with input flags and current state
--- @return string|nil Next state name or nil if no transition needed
local function get_next_state(self)
	-- Get current input state and configuration
	local is_crouching = self[INPUT.CROUCH] -- Is crouch key currently pressed?
	local config = STATE_CONFIG[self.state] -- Get rules for current state
	local next_state = nil               -- Will hold the next state to go to

	-- PRIORITY 1: ATTACK INPUT (Highest Priority)
	-- Attack can interrupt almost any other action
	if self[INPUT.ATTACK] then
		next_state = config.on_attack -- Go to attack state if current state allows it
	end

	-- PRIORITY 2: JUMP INPUT (High Priority)
	-- Jump can interrupt movement but not attack
	if self[INPUT.JUMP] then
		next_state = config.on_jump -- Go to jump state if current state allows it
	end

	-- PRIORITY 3: MOVEMENT STATE CHANGES (Medium Priority)
	-- Handle starting to move or stopping movement
	if self.is_moving and config.on_move then
		next_state = config.on_move -- Character is moving and current state has a "move" transition
	elseif not self.is_moving and config.on_stop then
		next_state = config.on_stop -- Character stopped moving and current state has a "stop" transition
	end

	-- PRIORITY 4: CROUCH/STAND STATE CHANGES (Medium Priority)
	-- Handle posture changes (standing vs crouching)
	if is_crouching and config.on_crouch then
		next_state = config.on_crouch -- Crouch key is pressed and current state allows crouching
	elseif not is_crouching and config.on_stand then
		next_state = config.on_stand -- Crouch key is released and current state allows standing
	end

	-- PRIORITY 5: DIRECTION CHANGE (Lowest Priority)
	-- Handle turning around (only when changing direction)
	if self.is_turning and config.on_turn then
		next_state = config.on_turn -- Character just turned around and current state has turn animation
	end

	-- Return the next state (or nil if no transition is needed)
	return next_state
end

-- ============================================================================
-- VISUAL LAYER - Handles all visual effects and animations
-- ============================================================================

--- Updates all visual elements based on current character state
--- This function is responsible for making the character look correct on screen:
--- - Playing the right animation for the current state
--- - Flipping the sprite to face the right direction
--- - Creating special effects (like the jump animation)
--- - Updating the GUI to show current state
--- @param self table Script instance with current state and flip information
local function update_visuals(self)
	-- Get the configuration for the current state
	local config = STATE_CONFIG[self.state]

	-- Play the animation for the current state
	sprite.play_flipbook("#sprite", config.animation)

	-- Visualize the jump effect
	-- (When jumping, we add a visual effect by moving the character up and down)
	if self.state == "standing_jump" then
		local pos = go.get_position()
		-- Animate the Y position to simulate a jump visually
		go.animate(".", "position.y", go.PLAYBACK_ONCE_PINGPONG, pos.y + 50, go.EASING_INOUTCUBIC, 0.6)
	else
		-- If not jumping, make sure any jump animation is cancelled and reset the character to ground level
		go.cancel_animations(".", "position.y")
		local pos = go.get_position()
		go.set_position(vmath.vector3(pos.x, 600, pos.z)) -- 600 is our ground level Y position
	end

	-- Update the GUI - send a message to the GUI component to update the UI
	msg.post("gui", "animation_state_changed", {
		state = self.state
	})
end

-- ============================================================================
-- DEFOLD LIFECYCLE FUNCTIONS
-- ============================================================================

--- Initializes the knight character when the game starts
--- It sets up the initial state and prepares the character for input
--- @param self table Script instance - this is automatically provided by Defold
function init(self)
	-- Set up initial state machine state as "standing_idle"
	self.state = "standing_idle"

	-- Set up movement and direction flags
	self.is_flipped = false -- Character starts facing right (not flipped)
	self.is_moving = false -- Character starts not moving
	self.is_turning = false -- Character starts not turning

	-- Initialize all input flags - start with all keys "not pressed" (false)
	self[INPUT.LEFT] = false -- Left arrow key
	self[INPUT.RIGHT] = false -- Right arrow key
	self[INPUT.JUMP] = false -- Space bar
	self[INPUT.ATTACK] = false -- Attack button (X)
	self[INPUT.CROUCH] = false -- Crouch button (C)

	-- Display the initial state visually
	update_visuals(self)

	-- Enable input handling
	msg.post(".", "acquire_input_focus")
end

--- Handles input events from keyboard every time the player presses or releases a key
--- It updates our input tracking and triggers state transitions
--- @param self table Script instance
--- @param action_id hash Which input was pressed (like "jump", "attack", etc.)
--- @param action table Contains information about the input (pressed/released)
function on_input(self, action_id, action)
	-- Update input state - keep track of which keys are currently being pressed:
	if action.pressed then
		self[action_id] = true -- Key was just pressed down
	elseif action.released then
		self[action_id] = false -- Key was just released
	end

	-- Process state machine:
	update_movement_state(self)          -- Update movement and direction state based on input
	local next_state = get_next_state(self) -- Decide what state to go to next

	-- If we determined a new state is needed, switch to it and update visuals:
	if next_state then
		self.state = next_state -- Change to the new state
		update_visuals(self) -- Update the visual appearance
	end
end

--- Handles messages from other game objects
--- We use it to handle messages that comes to the script when animations finish playing
--- @param self table Script instance
--- @param message_id hash What type of message this is
function on_message(self, message_id, message)
	-- This message is sent when a non-looped animation finishes playing (like attack, jump, or turn animations)
	if message_id == hash("animation_done") then

		-- Flip the sprite horizontally when the character just finished turning
		if message.id == hash("turn_around") then
			sprite.set_hflip("#sprite", self.is_flipped)
		end

		-- Process state machine:
		update_movement_state(self)       -- Update movement and direction state based on input
		local next_state = get_next_state(self) -- Decide what state to go to next

		-- Switch to the next state (or default next) and update visuals
		self.state = next_state or STATE_CONFIG[self.state].default_next
		update_visuals(self)
	end
end
