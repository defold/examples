local position_min = 0  -- <1>
local position_max = window.get_size(width)  -- <2>

local function normalize_position(x_position)  -- <3>
	local average = (position_min + position_max) / 2;
	local range = (position_max - position_min) / 1.8;
	local result = (x_position - average) / range;
	return result;
end

function init(self)  -- <4>
	physics.set_gravity(vmath.vector3(0, 0, 0))
	msg.post("pan:/coin#collision", "apply_force", {force = vmath.vector3(1200, 1300, 0), position = go.get_world_position()})
end

function on_message(self, message_id, message, sender)  -- <5>
	if message_id == hash("collision_response") then
		local coin_pos = normalize_position(go.get_position("pan:/coin").x)
		sound.play("pan:/coin#coin", { gain = 0.6, pan = coin_pos } )
	end
end

--[[

1. - Local variable to represent the minimum x position value. 

2. - Local variable to represent the maximum x position value. window.get_size(width) to get 
	screen width used for maximum x position value.

3. - This function uses the screen x position min & max local variables that is set at the top
	of the script to get an average and range then pass in the coin objects x position into 
	result to get a normalized value and the function returns that value. note: in range if we 
	divide by 2.0 we would get range -1.0 to 1.0 full 45 degree pan at min/max positions, instead 
	use 1.8 to get around a 40 deg pan that way we always get a little bit of sound in both 
	left and right channel outputs no matter the min/max position.

4. - In the initialize function we set gravity to 0 and apply some force to the dynamic coin 
	object giving it movement.

	5. - When a collision_response is received we pass in the coin objects x position into the 
	normalize_position function and set the results to the local variable coin_pos. Then play 
	a sound and pass in coin_pos into the sounds pan property.

Now we have simple sound localization using the pan property. If you close your eyes, you should
be able to gauge which direction the collisions are occurring.(as long as you are using stereo sound) 

--]]