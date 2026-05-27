function init(self)
	msg.post(".", "acquire_input_focus") -- <1>
end

function on_input(self, action_id, action)
	if action_id == hash("touch") and action.pressed then -- <2>
		local body = b2d.get_body("#collisionobject") -- <3>
		local position = b2d.body.get_position(body) -- <4>

		b2d.body.apply_linear_impulse(body, vmath.vector3(0, 600, 0), position) -- <5>
	end
end

function final(self)
	msg.post(".", "release_input_focus") -- <6>
end

--[[
1. The cube game object receives touch and mouse input.
2. The built-in touch action is sent when clicking or touching the screen.
3. b2d.get_body() gets the Box2D body from the cube collision object.
4. The body's current world position is used as the impulse application point.
5. apply_linear_impulse() immediately changes the body's velocity upward.
6. Input focus is released when the script instance is destroyed.
--]]
