function init(self)
	local seed = os.time()
	math.randomseed(seed) -- <1>

	label.set_text("#label", "Seed: " .. seed
	.. "\nRandom number (0 - 1): " .. math.random()	 -- <2>
	.. "\nRandom integer (1 - 100): " .. math.random(100)	 -- <3>
	.. "\nRandom integer (-10 - 0): " .. math.random(-10,0))	 -- <4>
end

--[[
1. First, set the randomseed. It can be specific, if you always want to generate same numbers,
	otherwise you can utilise e.g. os.time, like in the example to make it different each time.
2. math.random() with no arguments - generates a random floating point number between 0-1.
3. math.random(X) with one argument - generates an integer between 1 - X.
4. math.random(X, Y) with two arguments - generates an integer between X - Y.
--]]