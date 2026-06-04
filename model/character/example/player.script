local function play_animation(name)
	model.play_anim("#model", name, go.PLAYBACK_LOOP_FORWARD)
end

function init(self)
	msg.post(".", "acquire_input_focus") -- <1>
	play_animation("Idle") -- <2>

	model.set_mesh_enabled("#model", "1H_Sword", true) -- <3>
	model.set_mesh_enabled("#model", "1H_Sword_Offhand", false)
	model.set_mesh_enabled("#model", "2H_Sword", false)

	model.set_mesh_enabled("#model", "Knight_Helmet", true)
	model.set_mesh_enabled("#model", "Knight_Cape", true)

	model.set_mesh_enabled("#model", "Spike_Shield", true)
	model.set_mesh_enabled("#model", "Round_Shield", false)
	model.set_mesh_enabled("#model", "Rectangle_Shield", false)
	model.set_mesh_enabled("#model", "Badge_Shield", false)
end

function on_message(self, message_id, message, sender)
	if message_id == hash("play_idle") then -- <4>
		play_animation("Idle")
	elseif message_id == hash("play_walk") then
		play_animation("Walking_A")
	elseif message_id == hash("play_attack") then
		play_animation("1H_Melee_Attack_Chop")
	elseif message_id == hash("play_block") then
		play_animation("Block")
	elseif message_id == hash("play_cheer") then
		play_animation("Cheer")
	end
end

function on_input(self, action_id, action)
	if action_id == hash("key_1") then
		play_animation("Idle") -- <5>
	elseif action_id == hash("key_2") then
		play_animation("Walking_A") -- <6>
	elseif action_id == hash("key_3") then
		play_animation("1H_Melee_Attack_Chop") -- <7>
	elseif action_id == hash("key_4") then
		play_animation("Block") -- <8>
	elseif action_id == hash("key_5") then
		play_animation("Cheer") -- <9>
	end
end

--[[
1. Acquire input focus so the number keys are sent to the script.
2. Start with the model's Idle animation.
3. Enable the mesh parts that define the visible weapon, helmet, cape, and shield.
4. Accept animation messages from the GUI and play the requested animation.
5. Play the idle animation.
6. Play the walking animation.
7. Play the chop attack animation.
8. Play the block animation.
9. Play the cheer animation.
]]
