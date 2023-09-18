-- load image from custom resources
-- read pixels and write them to a buffer
local function create_buffer_from_image(filename)
	local png = assert(sys.load_resource(filename))
	local loaded_image = image.load(png)
	local width = loaded_image.width
	local height = loaded_image.height
	local pixels = loaded_image.buffer

	local buffer_declaration = {
		{
			name = hash("rgba"),
			type = buffer.VALUE_TYPE_UINT8,
			count = 4
		}
	}
	local pixel_buffer = buffer.create(width * height, buffer_declaration)
	local pixel_stream = buffer.get_stream(pixel_buffer, hash("rgba"))
	for y = 1, height do
		for x = 1, width do
			-- flip image
			local pixels_index = ((height - y) * width * 4) + ((x - 1) * 4) + 1
			local r = pixels:byte(pixels_index + 0)
			local g = pixels:byte(pixels_index + 1)
			local b = pixels:byte(pixels_index + 2)
			local a = pixels:byte(pixels_index + 3)

			-- write to buffer stream
			local stream_index = ((y - 1) * width * 4) + ((x - 1) * 4) + 1
			pixel_stream[stream_index + 0] = r
			pixel_stream[stream_index + 1] = g
			pixel_stream[stream_index + 2] = b
			pixel_stream[stream_index + 3] = a
		end
	end

	return pixel_buffer, width, height
end

local function replace_atlas_image()
	-- get table with information about an atlas
	local atlas = resource.get_atlas("/examples/resource/modify_atlas/modify_atlas.a.texturesetc")
	-- get table with information about the textured used by the atlas
	local texture = resource.get_texture_info(atlas.texture)
	pprint(atlas)
	pprint(texture)

	-- load an image as a Defold buffer
	local pixel_buffer, width, height = create_buffer_from_image("/examples/resource/modify_atlas/resources/shipYellow_manned.png")

	-- get the UV coordinates of the first image in the atlas
	local first_uvs = atlas.geometries[1].uvs

	-- this offset should not be necessary but it seems like there is an issue with the
	-- UVs in Defold 1.5.0
	local x = first_uvs[1] - 0
	local y = first_uvs[2] - 6
	print(x, y)
	print(width, height)

	-- create a table with texture update information
	-- we want to update only a sub region of the atlas starting at a
	-- certain position and with a certain size
	local texture_info = {
		type = resource.TEXTURE_TYPE_2D,
		width = width,
		height = height,
		format = resource.TEXTURE_FORMAT_RGBA,
		x = x,
		y = y,
		compression_type = resource.COMPRESSION_TYPE_DEFAULT,
		num_mip_maps = texture.mipmaps,
	}
	-- update the atlas texture with the pixels from the provided buffer
	resource.set_texture(atlas.texture, texture_info, pixel_buffer)
end


function init(self)
	msg.post(".", "acquire_input_focus")
end

function on_input(self, action_id, action)
	if action.pressed then
		replace_atlas_image()
	end
end
