local MSG_PLAY_MODEL_ANIMATION = hash("play_model_animation") -- <1>
local DEFAULT_ANIMATION = hash("Sword_Idle") -- <2>

local function play_animation(animation_id)
	model.play_anim("#model", animation_id, go.PLAYBACK_LOOP_FORWARD) -- <3>
end

function init(self)
	play_animation(DEFAULT_ANIMATION) -- <4>
end

function on_message(self, message_id, message, sender)
	if message_id == MSG_PLAY_MODEL_ANIMATION then -- <5>
		play_animation(message.animation_id)
	end
end

-- <1> This message id is shared with the GUI script. The GUI does not call the model API directly; it asks this script to play an animation.
-- <2> The character starts in a known default pose/animation before the user selects anything from the GUI.
-- <3> model.play_anim() is called on the model component attached to the same game object as this script. The animation id must match a clip imported from the GLB.
-- <4> Start the default animation when the game object is initialized.
-- <5> React only to the animation-selection message. The selected animation id is sent by the GUI script in the message table.
