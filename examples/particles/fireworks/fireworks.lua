local M = {}

local _tension = 0.9
local _gravity = 980

function M.start_fireworks(trail_id, bang_id, start_pos, speed, time, delay, gravity, tension)
	local m = {
		update = function(self, dt)
			if self.delay > 0 then
				self.delay = self.delay - dt
				return
			elseif self.delay <= 0 and not self.is_started then
				particlefx.play(self.trail)
				self.is_started = true
			end
			if self.time > 0 then
				local prev_pos = vmath.vector3(self.start_pos)
				self.start_pos.x = self.start_pos.x + self.speed.x*dt
				self.start_pos.y = self.start_pos.y + self.speed.y*dt

				local triangle = vmath.vector3(prev_pos.x - start_pos.x, prev_pos.y - start_pos.y, 0)
				local angle = math.atan2(triangle.y, triangle.x)
				self.speed.x = self.speed.x - self.speed.x * self.tension*dt
				self.speed.y = self.speed.y - self.speed.y * self.tension*dt - self.gravity*dt

				go.set_position(self.start_pos, self.trail)
				go.set_rotation(vmath.quat_rotation_z(angle+math.pi/2), self.trail)
				if self.time > 0 then
					go.set_scale(self.time, self.trail)
				end
				
			elseif self.time <= 0 and not self.is_stopped then
				self.is_stopped = true
				particlefx.stop(self.trail, { clear = true })
				go.set_position(self.start_pos, self.bang)
				particlefx.play(self.bang)
			elseif self.time <= -1.5 and self.bang then
				go.delete(self.bang)
				self.bang = nil
			end
			self.time = self.time - dt
		end,
		start_pos = start_pos,
		time = time,
		speed = speed,
		delay = delay or 0,
		gravity = gravity or _gravity,
		tension = tension or _tension,
		trail = trail_id,
		bang = bang_id
	}

	return m
end

return M