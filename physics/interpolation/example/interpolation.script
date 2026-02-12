-- This example compares two render paths when physics runs in fixed timestep mode:

-- 1) not_interpolated_block: visual representation copies physics representation transform directly
local not_interpolated_block = {
	physics_go = "/block1",
	sprite_go = "/block1_sprite",
}

-- 2) interpolated_block: visual representation is interpolated between previous and current fixed states
local interpolated_block = {
	physics_go = "/block2",
	sprite_go = "/block2_sprite",
}

-- Store fixed update interval in seconds from game.project Fixed Update Frequency.
local fixed_dt = 1 / (sys.get_config_number("engine.fixed_update_frequency") or 20)

function init(self)
	-- Render-time remainder inside the current fixed-step interval.
	self.render_accumulator = 0

	-- Two-sample buffer for interpolation:
	-- previous_* = transform from previous fixed update
	-- current_*  = transform from current fixed update
	-- Initialize both from real physics representation state.
	self.previous_fixed_position = go.get_position(interpolated_block.physics_go)
	self.current_fixed_position = self.previous_fixed_position
	self.previous_fixed_rotation = go.get_rotation(interpolated_block.physics_go)
	self.current_fixed_rotation = self.previous_fixed_rotation
end

function fixed_update(self, dt)
	-- Shift the transform data from current state to previous state 
	-- and sample new fixed state from the game object with the dynamic collision object component.
	self.previous_fixed_position = self.current_fixed_position
	self.previous_fixed_rotation = self.current_fixed_rotation
	self.current_fixed_position = go.get_position(interpolated_block.physics_go)
	self.current_fixed_rotation = go.get_rotation(interpolated_block.physics_go)
end	

function update(self, dt)
	-------------------------------------------------------------------------------------
	-- For not interpolated object:
	-------------------------------------------------------------------------------------
	-- Copy physics transform directly to the visual representation.
	local not_interpolated_position = go.get_position(not_interpolated_block.physics_go)
	local not_interpolated_rotation = go.get_rotation(not_interpolated_block.physics_go)
	go.set_position(not_interpolated_position, not_interpolated_block.sprite_go)
	go.set_rotation(not_interpolated_rotation, not_interpolated_block.sprite_go)


	-------------------------------------------------------------------------------------
	-- For interpolated object:
	-------------------------------------------------------------------------------------
	-- Keep accumulator inside [0, fixed_dt) using modulo wrap.
	self.render_accumulator = math.fmod(self.render_accumulator + dt, fixed_dt)

	-- Base alpha from render progress between fixed samples:
	-- alpha=0 -> previous sample, alpha=1 -> current sample.
	local alpha = self.render_accumulator / fixed_dt

	-- Calculate the difference between the current and previous fixed positions.
	local position_difference = self.current_fixed_position - self.previous_fixed_position

	-- Position interpolation is linear (lerp).
	local interpolated_position = self.previous_fixed_position + position_difference * alpha

	-- Rotation interpolation is spherical (slerp).
	local interpolated_rotation = vmath.slerp(alpha, self.previous_fixed_rotation, self.current_fixed_rotation)

	-- Render blended transform.
	go.set_position(interpolated_position, interpolated_block.sprite_go)
	go.set_rotation(interpolated_rotation, interpolated_block.sprite_go)
end
