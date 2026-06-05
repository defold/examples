go.property("tile_size", 128) -- <1>
go.property("scroll_speed", vmath.vector3(50, 0, 0)) -- <2>
go.property("pattern_angle", 15) -- <3>

local function apply_layout(self, width, height)
	go.set(".", "scale", vmath.vector3(width, height, 1)) -- <4>

	local uv_params = vmath.vector4(
		width / self.tile_size,
		height / self.tile_size,
		self.scroll_speed.x / self.tile_size,
		self.scroll_speed.y / self.tile_size
	) -- <5>
	go.set("#model", "uv_params", uv_params) -- <6>

	local angle = math.rad(self.pattern_angle)
	local rotation_params = vmath.vector4(math.cos(angle), math.sin(angle), 0, 0) -- <7>
	go.set("#model", "rotation_params", rotation_params) -- <8>
end

local function on_window_event(self, event, data)
	if event == window.WINDOW_EVENT_RESIZED then
		apply_layout(self, data.width, data.height) -- <9>
	end
end

function init(self)
	local width, height = window.get_size()
	apply_layout(self, width, height) -- <10>
	window.set_listener(on_window_event) -- <11>
end

function final(self)
	window.set_listener(nil) -- <12>
end

--[[
1. `tile_size` is the size, in pixels, of one repeated texture tile on screen.
2. `scroll_speed` is measured in pixels per second. Only x and y are used.
3. `pattern_angle` rotates the repeated texture coordinates inside the quad. It does not rotate the game object.
4. The glTF quad is one unit wide and high, so scaling the game object to the window size makes it cover the viewport.
5. The shader receives repeat scale in `uv_params.xy` and normalized scroll speed in `uv_params.zw`.
6. `uv_params` is a user material constant on the Model component.
7. Store cosine and sine so the shader can rotate UV coordinates without recalculating trigonometry per pixel.
8. `rotation_params` is another user material constant on the Model component.
9. Recalculate the layout only when the window size changes.
10. Apply the initial layout before the first frame is rendered.
11. Listen for resize events instead of recalculating the layout every frame.
12. Clear the window listener when the script is finalized.
]]
