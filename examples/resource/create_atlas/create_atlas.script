local function create_texture(width, height)
	-- create a new rgba texture
	local create_texture_params = {
		width  = width,
		height = height,
		type   = resource.TEXTURE_TYPE_2D,
		format = resource.TEXTURE_FORMAT_RGBA,
	}
	local my_texture_id = resource.create_texture("/my_custom_texture.texturec", create_texture_params)

	-- create a buffer with pixel data
	local buf = buffer.create(width * height, { { name=hash("rgba"), type=buffer.VALUE_TYPE_UINT8, count=4 } } )
	local stream = buffer.get_stream(buf, hash("rgba"))

	local half_width = width / 2
	for y=1, height do
		for x=1, width do
			local index = (y-1) * width * 4 + (x-1) * 4 + 1
			stream[index + 0] = x > half_width and 0xFF or 0x00
			stream[index + 1] = x > half_width and 0x00 or 0xFF
			stream[index + 2] = x > half_width and 0x00 or 0x00
			stream[index + 3] = 0xFF
		end
	end

	-- set the pixels on the texture
	local set_texture_params = { width=width, height=height, x=0, y=0, type=resource.TEXTURE_TYPE_2D, format=resource.TEXTURE_FORMAT_RGBA, num_mip_maps=1 }
	resource.set_texture(my_texture_id, set_texture_params, buf)
	
	return my_texture_id
end

local function create_atlas(texture_id, width, height)
	local params = {
		texture = texture_id,
		animations = {
			{
				id          = "my_animation_left",
				width       = width / 2,
				height      = height,
				frame_start = 1,
				frame_end   = 2,
			},
			{
				id          = "my_animation_right",
				width       = width / 2,
				height      = height,
				frame_start = 2,
				frame_end   = 3,
			}
		},
		geometries = {
			{
				width = width / 2,
				height = height,
				pivot_x = 0.5,
				pivot_y = 0.5,
				vertices  = {
					0,         height,
					0,         0,
					width / 2, 0,
					width / 2, height
				},
				uvs = {
					0,         height,
					0,         0,
					width / 2, 0,
					width / 2, height
				},
				indices = {0,1,2,0,2,3}
			},
			{
				width = width / 2,
				height = height,
				pivot_x = 0.5,
				pivot_y = 0.5,
				vertices  = {
					0,         height,
					0,         0,
					width / 2, 0,
					width / 2, height
				},
				uvs = {
					width / 2,  height,
					width / 2,  0,
					width,      0,
					width,      height
				},
				indices = {0,1,2,0,2,3}
			}
		}
	}
	local my_atlas_id = resource.create_atlas("/my_atlas.texturesetc", params)
	return my_atlas_id
end

function init(self)
	local width = 128
	local height = 128
	local my_texture_id = create_texture(width, height)
	local my_atlas_id = create_atlas(my_texture_id, width, height)

	go.set("#sprite", "image", my_atlas_id)
	sprite.play_flipbook("#sprite", "my_animation_left")

	go.set("gui#gui", "textures", my_atlas_id, { key = "my_atlas" })
	msg.post("gui#gui", "use_atlas", { texture = "my_atlas", animation = "my_animation_right" })
end
