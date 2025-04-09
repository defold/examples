function init(self)
	msg.post(".", "acquire_input_focus")
	model.play_anim("#model", "T-Pose", go.PLAYBACK_LOOP_FORWARD)

	-- enabled and disable meshes to get the correct look
	-- weapons
	model.set_mesh_enabled("#model", "1H_Sword", true)
	model.set_mesh_enabled("#model", "1H_Sword_Offhand", false)
	model.set_mesh_enabled("#model", "2H_Sword", false)

	-- equipment
	model.set_mesh_enabled("#model", "Knight_Helmet", true)
	model.set_mesh_enabled("#model", "Knight_Cape", true)

	-- different shields
	model.set_mesh_enabled("#model", "Spike_Shield", true)
	model.set_mesh_enabled("#model", "Round_Shield", false)
	model.set_mesh_enabled("#model", "Rectangle_Shield", false)
	model.set_mesh_enabled("#model", "Badge_Shield", false)
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
