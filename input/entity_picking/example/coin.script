function init(self)
	local start_angle = go.get(".", "euler.y")
	local to_angle = start_angle - 3600

	-- Simply animate ...
	go.animate(".", "euler.y", go.PLAYBACK_LOOP_FORWARD, to_angle, go.EASING_LINEAR, 8)
end
