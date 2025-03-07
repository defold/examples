function init(self)
	msg.post(".", "acquire_input_focus")
	model.play_anim("#model", "T-Pose", go.PLAYBACK_LOOP_FORWARD)
end

function on_input(self, action_id, action)
	if action_id == hash("idle") then
		model.play_anim("#model", "Idle", go.PLAYBACK_LOOP_FORWARD)
	elseif action_id == hash("walk") then
		model.play_anim("#model", "Walking_A", go.PLAYBACK_LOOP_FORWARD)
	elseif action_id == hash("attack") then
		model.play_anim("#model", "1H_Melee_Attack_Chop", go.PLAYBACK_LOOP_FORWARD)
	elseif action_id == hash("block") then
		model.play_anim("#model", "Block", go.PLAYBACK_LOOP_FORWARD)
	elseif action_id == hash("cheer") then
		model.play_anim("#model", "Cheer", go.PLAYBACK_LOOP_FORWARD)
	end
end
