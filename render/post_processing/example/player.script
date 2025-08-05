function init(self)
	msg.post(".", "acquire_input_focus")
	model.play_anim("#model", "Idle", go.PLAYBACK_LOOP_FORWARD)

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
