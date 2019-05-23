function init(self)
	msg.post(".", "acquire_input_focus") -- <1>
end

function on_input(self, action_id, action)
	if action_id == hash("touch") and action.pressed then -- <2>
		local pos = go.get_position()
		pos.x = pos.x + 100 -- <3>
		local carrot_id = factory.create("#carrotfactory", pos) -- <4>
		go.animate(carrot_id, "position.x", go.PLAYBACK_ONCE_FORWARD, 720, go.EASING_LINEAR, 3) -- <5>
	end
end

--[[
1. Acquire input focus so we get input from the engine.
2. If the user clicks.
3. Calculate a spawning position.
4. Tell the component "carrotfactory" ("#" denotes a component in the
   current game object) to spawn a game object according to its prototype.
   The function returns the id of the new game object.
5. Animate the position of the new game object.
--]]