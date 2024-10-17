local colors = {"red", "green", "blue"} -- list of existing fireworks colors
local instances = {} -- list of active fireworks instances

local _tension = 0.9 -- emulation of air tension. More value leads to faster deceleration
local _gravity = 980 -- gravity, measuring in mm/sq.s.

local function start_fireworks(trail_id, bang_id, start_pos, speed, time, gravity, tension)
	go.set_position(start_pos, trail_id)
	particlefx.play(trail_id)
	local m = {
		update = function(self, dt)
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
			elseif self.time <= -1.5 and self.bang  then
				go.delete(self.bang)
				self.bang = nil
			end
			self.time = self.time - dt
		end,
		start_pos = start_pos,
		time = time,
		speed = speed,
		gravity = gravity or _gravity,
		tension = tension or _tension,
		trail = trail_id,
		bang = bang_id
	}

	return m
end

local function single_shot()
	if #instances > 5 then
		return
	end
	local color = colors[math.random(1, #colors)]
	local splat = factory.create("#"..color.."_splat_factory")
	local trail = factory.create("#"..color.."_trail_factory")

	local strength = 1000+math.random()*600 		-- scalar value of speed
	local angle = (-0.2+math.random()*0.4)*math.pi	-- angle beetween central vertical line and trail
	
	local pos = vmath.vector3(360-math.sin(angle)*350, 0, 0)
	local speed = vmath.vector3(strength*math.sin(angle), strength*math.cos(angle), 0)
	table.insert(instances, 
		start_fireworks(trail, splat, 
			pos, speed, 
			1.2+math.random()*0.5
		)
	)
end

function init(self)
	single_shot()

	timer.delay(3, true, single_shot) 

	msg.post(".", "acquire_input_focus")
end

function update(self, dt)
	for i, val in ipairs(instances) do
		if not val.bang then
			table.remove(instances, i)
		else
			val:update(dt)
		end
	end
end

function on_input(self, action_id, action)
	if action.pressed then 
		single_shot()
	end
end
