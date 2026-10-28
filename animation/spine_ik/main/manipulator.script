local IK_BONE = hash("RED_IK")
local SPINE_COMPONENT = "#spinemodel"
local MSG_PARENT = hash("parent")

function init(self)
	self.target = go.get_id("cursor")
end

function on_message(self, message_id, message, sender)
	if message_id == MSG_PARENT then
		if message.parent then
			spine.set_ik_target(SPINE_COMPONENT, IK_BONE, self.target)
		else
			spine.reset_ik_target(SPINE_COMPONENT, IK_BONE)
		end
	end
end
