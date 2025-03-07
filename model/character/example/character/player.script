-- play a model animation unless already playing the animation
local function play_animation(self, animation_id, playback, callback)
	if self.animation_id ~= animation_id then
		self.animation_id = animation_id
		model.play_anim("#model", animation_id, playback, nil, callback)
	end
end

-- play the Idle animation if the player is not moving
local function idle(self)
	
end

-- play the Walk animation
local function walk(self)
	
end

local function attack(self)
	
end

function init(self)
	msg.post(".", "acquire_input_focus")
	play_animation(self, "T-Pose", go.PLAYBACK_LOOP_FORWARD)
end

function on_input(self, action_id, action)
	if action_id == hash("idle") then
		play_animation(self, "Idle", go.PLAYBACK_LOOP_FORWARD)
	elseif action_id == hash("walk") then
		play_animation(self, "Walking_A", go.PLAYBACK_LOOP_FORWARD)
	elseif action_id == hash("attack") then
		play_animation(self, "1H_Melee_Attack_Chop", go.PLAYBACK_LOOP_FORWARD)
	elseif action_id == hash("block") then
		play_animation(self, "Block", go.PLAYBACK_LOOP_FORWARD)
	elseif action_id == hash("cheer") then
		play_animation(self, "Cheer", go.PLAYBACK_LOOP_FORWARD)
	end
end
