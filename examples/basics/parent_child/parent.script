function init(self)
    msg.post(".", "acquire_input_focus") -- <1>

	local pos = go.get_position() -- <2>
	go.animate(".", "position.y", go.PLAYBACK_LOOP_PINGPONG, pos.y + 300, go.EASING_INOUTSINE, 3) -- <3>

	self.has_child = true -- <4>
end


function on_input(self, action_id, action)
    if action_id == hash("touch") and action.pressed then
    	if self.has_child then
			msg.post("child", "set_parent", { keep_world_transform = 1 }) -- <5>
			label.set_text("#label", "Click to child...") -- <6>
		else
			msg.post("child", "set_parent", { parent_id = go.get_id(), keep_world_transform = 1 }) -- <7>
			label.set_text("#label", "Click to detach...") -- <8>
		end
		self.has_child = not self.has_child -- <9>
    end 
end

--[[
1. Tell the engine that this game object wants to receive input.
2. Get the current position.
3. Animate the y position of this game object back and forth.
4. A flag to track if there is a child to this game object or not. Parent-child relations in Defold are only affecting the scene graph so we need to track this ourselves.
5. If the user clicks and there is a child, set the parent to nothing, meaning remove it as a child.
6. Set the label text accordingly.
7. If the user clicks and there is no child, set the parent to this game object.
8. Set the label text accordingly.
9. Set the flag to its inverse.
--]]