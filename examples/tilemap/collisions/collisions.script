function init(self)
	msg.post(".", "acquire_input_focus") -- <1>
	for i=1,10 do
		factory.create("#enemyfactory", vmath.vector3(math.random(100, 700), 600, 1))  -- <2>
	end
end


function on_input(self, action_id, action)
	if action.pressed then
		factory.create("#enemyfactory", vmath.vector3(action.x, action.y, 1))  -- <3>
	end
end


function on_message(self, message_id, message, sender)
	if message_id == hash("collision_response") then  -- <4>
		if message.own_group == hash("danger") then  -- <5>
			go.delete(message.other_id)  -- <6>
		end
	end
end

--[[
1. Acquire input for the script
2. Spawn 10 game objects at random positions near the top of the screen
3. Spawn a game object when any key or mouse button (or touch) is pressed
4. Something collided with the tilemap if the received message was a `collision_response`
5. Check if something collided with a tile belonging to the collision group "danger"
6. Delete the game object that collided with the tilemap
--]]
