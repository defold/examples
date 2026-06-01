local ANIMATIONS = {
	"TheWave",
	"Pulse",
	"Individuals"
}

function init(self)
	self.animation = 1
	msg.post("#", "acquire_input_focus")
	model.play_anim("#model", ANIMATIONS[self.animation], go.PLAYBACK_LOOP_FORWARD) -- <1>
end

function on_input(self, action_id, action)
	if action.pressed then
		self.animation = self.animation + 1
		if self.animation > 3 then
			self.animation = 1
		end
		model.play_anim("#model", ANIMATIONS[self.animation], go.PLAYBACK_LOOP_FORWARD)
	end
end

--[[
1. Play the morph target animation named "TheWave" from the glTF file in a loop.
]]
