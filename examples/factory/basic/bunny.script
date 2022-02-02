function init(self)
	msg.post(".", "acquire_input_focus") -- <1>
end

function on_input(self, action_id, action)
	if action_id == hash("touch") and action.pressed then -- <2>
		local pos = vmath.vector3(action.x, action.y, 0) -- <3>
		local carrot_id = factory.create("#carrotfactory", pos) -- <4>
		go.animate(carrot_id, "euler.z", go.PLAYBACK_ONCE_FORWARD, 360, go.EASING_LINEAR, 1, 0, function()   -- <5>
			go.delete(carrot_id)  -- <6>
		end)
	end
end

--[[
1. Acquire input focus so we get input from the engine.
2. If the user clicks.
3. Set the spawning position to the mouse click position.
4. Tell the component "carrotfactory" ("#" denotes a component in the
   current game object) to spawn a game object according to its prototype.
   The function returns the id of the new game object.
5. Rotate the new game object.
6. Delete the game object
--]]