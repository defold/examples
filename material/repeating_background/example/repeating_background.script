-- Size of a single tile in pixels
go.property("tile_size", 128)
-- Scroll speed vector (x, y, z) in pixels per second
go.property("scroll_speed", vmath.vector3(50, 0, 0))

-- Applies layout based on current window size
-- Scales the game object to fill the entire window and calculates UV scale
local function apply_layout(self)
	local width, height = window.get_size()
	-- Scale the game object to match window dimensions
	go.set(".", "scale", vmath.vector3(width, height, 1))

	-- Calculate how many tiles fit in the window (for UV tiling)
	self.uv_scale = vmath.vector3(width / self.tile_size, height / self.tile_size, 0)

	-- Send UV parameters to the shader: scale (x, y) and offset (z, w)
	local uv_params = vmath.vector4(self.uv_scale.x, self.uv_scale.y, self.offset.x, self.offset.y)
	go.set("#model", "uv_params", uv_params)
end

-- Updates UV offset for scrolling animation
-- Moves the texture offset based on scroll speed and wraps it using modulo
local function update_uv_params(self, dt)
	-- Calculate offset delta in tile units (0-1 range)
	local delta = self.scroll_speed * dt / self.tile_size
	-- Update offset (subtract because we want to scroll in the direction of scroll_speed)
	self.offset = self.offset - delta
	-- Wrap offset to 0-1 range to create seamless repeating
	self.offset.x = self.offset.x % 1
	self.offset.y = self.offset.y % 1

	-- Send updated UV parameters to the shader
	local uv_params = vmath.vector4(self.uv_scale.x, self.uv_scale.y, self.offset.x, self.offset.y)
	go.set("#model", "uv_params", uv_params)
end

-- Initialize the script
-- Sets up the initial UV offset to zero
function init(self)
	self.offset = vmath.vector3(0)
end

function final(self)
end

-- Update function called every frame
-- Applies layout and updates UV parameters for scrolling
function update(self, dt)
	apply_layout(self)
	update_uv_params(self, dt)
end
