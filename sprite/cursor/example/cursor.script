-- step animation forward or backwards 'amount' number of frames
local function step(self, amount)
	-- frame_count is the number of frames in the current animationm 
	local frame_count = go.get("#sprite", "frame_count")
	-- cursor is the normalized (0.0 to 1.0) animation cursor
	local cursor = go.get("#sprite", "cursor")

	-- normalized length of a frame in the current animation
	local frame_length = 1 / frame_count

	-- move the cursor amount number of frames
	cursor = cursor + (frame_length * amount)

	-- wrap animation if advancing beyond the first or last frame
	if cursor < 0 then
		cursor = cursor + 1
	elseif cursor >= 1 then
		cursor = cursor - 1
	end

	-- set new sprite cursor position
	go.set("#sprite", "cursor", cursor)

	-- calculate the current animation frame and show on a label
	local current_frame = 1 + math.floor(cursor * frame_count)
	label.set_text("#frame", ("%d / %d"):format(current_frame, frame_count))
end

-- stop automatic animation playback
local function stop(self)
	-- only try to stop if there is an active timer
	if self.playback_timer then
		-- visually update the start/stop sprite to show the 'start image
		sprite.play_flipbook("controls#playstop", "start")
		-- cancel the animation timer
		timer.cancel(self.playback_timer)
		self.playback_timer = nil
	end
end

-- start automatic animation playback using a timer to advance the animation
-- one frame at a time
local function start(self)
	-- visually update the start/stop sprite to show the 'stop' image
	sprite.play_flipbook("controls#playstop", "stop")
	-- start a timer to advance the animation roughly every 0.15 seconds
	self.playback_timer = timer.delay(0.15, true, function()
		step(self, 1)
	end)
end

function init(self)
	msg.post(".", "acquire_input_focus")
	self.playback_timer = nil
end

function on_input(self, action_id, action)
	if action.pressed then
		-- key left or mouse click on left part of screen
		-- step animation one frame backwards
		if action_id == hash("key_left")
		or action_id == hash("mouse_button_left") and action.x < 240
		then
			stop(self)
			step(self, -1)
			return
		end
		
		-- key right or mouse click on right part of the screen
		-- step animation one frame forward	
		if action_id == hash("key_right")
		or action_id == hash("mouse_button_left") and action.x > 480 then
			stop(self)
			step(self, 1)
			return
		end

		-- key space or mouse click in central part of the screen
		-- start or stop animation playback
		if action_id == hash("key_space")
		or action_id == hash("mouse_button_left") and action.x > 240 and action.x < 480 then
			if self.playback_timer then
				stop(self)
			else
				start(self)
			end
		end
	end
end