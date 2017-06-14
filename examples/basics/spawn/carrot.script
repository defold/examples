function init(self)
	self.t = 2 -- <1>
end

function update(self, dt)
	self.t = self.t - dt -- <2>
	if self.t < 0 then
		go.delete() -- <3>
	end
end

--[[
1. Store a value `t` in the current script component (`self`).
2. Decrease `t` with delta time (elapsed since last call to `update()`).
3. If `t` is below 0, delete the current game object
   ("." is shorthand for that).
--]]