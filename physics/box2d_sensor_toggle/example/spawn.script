-- Helper function to spawn a ball at random position on top and remove it after a moment
local function spawn_ball()
	-- X position is random between 200-600
	local x = 400 + math.random(-200, 200)

	-- Spawn the ball from the ball_factory, assign the random position
	-- and store the created instance's id
	local id = factory.create("#ball_factory", vmath.vector3(x, 600, 0.0))

	-- After a moment remove the spawned ball
	timer.delay(1.2, false, function()
		go.delete(id)
	end)
end

function init(self)
	-- Initialize random number generator
	math.randomseed(os.time())

	-- Use the above helper function to spawn the ball every 0.5 second
	timer.delay(0.2, true, spawn_ball)
end
