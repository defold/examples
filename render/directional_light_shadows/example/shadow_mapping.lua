local M = {}

--[[
Directional shadow mapping for a custom Defold render script.
The module for shadow mapping renders models twice:
1. Shadow depth pass - Models are rendered from the directional light camera into a depth texture.
2. Main scene pass - Models are rendered from the display camera with a receiver material that samples checks if a fragment is shadowed.

Public integration functions:
M.init() in init()
M.on_message() in on_message()
M.render_depth() and M.render_models(renders) in update()
M.final() in final()
--]]

-- Message ID for configuring shadow mapping parameters.
local MSG_SET_DIRECTIONAL_SHADOW = hash("set_directional_shadow")

-- Render resources declared in directional_light_shadows.render.
local DEPTH_MATERIAL = "directional_shadow_depth"
local RECEIVER_MATERIAL = "directional_shadow_receiver"

-- Sampler declared by directional_shadow_receiver.material.
local SHADOW_SAMPLER = "shadow_map"

-- Supported PCF kernel widths.
-- A width of 1 performs one hard depth comparison and therefore means that PCF filtering is disabled.
local PCF_KERNEL_HARD = 1
local PCF_KERNEL_3X3 = 3
local PCF_KERNEL_5X5 = 5
local DEFAULT_PCF_KERNEL_SIZE = PCF_KERNEL_3X3

-- Distance between neighboring PCF samples, measured in shadow-map texels.
-- This changes the filter footprint but not the number of texture samples.
local DEFAULT_PCF_SAMPLE_SPACING = 1.0

-- Caster-side depth bias.
-- These values affect the depth written into the shadow map through polygon offset.
local DEFAULT_POLYGON_OFFSET_FACTOR = 2.0
local DEFAULT_POLYGON_OFFSET_UNITS = 4.0

-- Receiver-side comparison bias. These values are passed to the fragment shader
-- and used when comparing receiver depth with stored shadow-map depth.
local DEFAULT_RECEIVER_MIN_BIAS = 0.0002
local DEFAULT_RECEIVER_SLOPE_BIAS = 0.0015

-- Validate the fixed PCF implementations available in shadows.glsl.
local function validate_pcf_kernel_size(kernel_size)
	assert(kernel_size == PCF_KERNEL_HARD
			or kernel_size == PCF_KERNEL_3X3
			or kernel_size == PCF_KERNEL_5X5,
		"pcf_kernel_size must be 1, 3, or 5")
	return kernel_size
end

-- Convert light clip/NDC coordinates from -1..1 into texture coordinates in the 0..1 range.
-- This is commonly called a "bias matrix", but it is unrelated to the depth bias used to prevent shadow acne.
local function create_clip_to_texture_matrix()
	local matrix = vmath.matrix4()
	matrix.c0 = vmath.vector4(0.5, 0.0, 0.0, 0.0)
	matrix.c1 = vmath.vector4(0.0, 0.5, 0.0, 0.0)
	matrix.c2 = vmath.vector4(0.0, 0.0, 0.5, 0.0)
	matrix.c3 = vmath.vector4(0.5, 0.5, 0.5, 1.0)
	return matrix
end

-- Create a depth-only render target. The depth attachment is also exposed as a texture
-- because it is sampled by the receiver fragment shader during the main scene pass.
local function create_depth_target(resolution)
	local depth_params = {
		format = graphics.TEXTURE_FORMAT_DEPTH,	-- Depth only format.
		width = resolution,	-- Resolution of the depth target (square)
		height = resolution,

		-- The shader performs explicit depth comparisons for PCF.
		-- Nearest filtering returns the exact stored depth for each selected texel.
		-- Linear filtering would interpolate raw depth values before comparison,
		-- which is not equivalent to filtering comparison results.
		min_filter = graphics.TEXTURE_FILTER_NEAREST,
		mag_filter = graphics.TEXTURE_FILTER_NEAREST,

		-- Clamp the texture coordinates to the edge of the texture.
		u_wrap = graphics.TEXTURE_WRAP_CLAMP_TO_EDGE,
		v_wrap = graphics.TEXTURE_WRAP_CLAMP_TO_EDGE,

		-- The depth texture is used as a sampler in the receiver fragment shader.
		flags = render.TEXTURE_BIT,
	}

	return render.render_target("directional_shadow_map", { [graphics.BUFFER_TYPE_DEPTH_BIT] = depth_params })
end

-- Replace the depth target when the configured resolution changes.
local function recreate_depth_target(context, resolution)
	-- Delete the existing depth target if it exists.
	if context.target then
		render.delete_render_target(context.target)
	end

	-- Create a new depth target with the new resolution.
	context.target = create_depth_target(resolution)
	context.resolution = resolution		

	-- The receiver shader uses this value to convert PCF offsets expressed in
	-- texels into normalized texture-coordinate offsets.
	context.constants.shadow_texel_size = vmath.vector4( 1.0 / resolution, 1.0 / resolution, 0.0, 0.0 )
end

-- Pack four scalar shadow settings into one vec4 material constant:
-- x = PCF kernel width: 1, 3, or 5 (1 means one hard comparison without filtering).
-- y = distance between PCF samples in shadow-map texels.
-- z = minimum receiver-side depth bias.
-- w = slope/normal-dependent receiver-side depth bias.
local function update_shadow_parameters(context)
	context.constants.shadow_params = vmath.vector4(
		context.pcf_kernel_size,
		context.pcf_sample_spacing,
		context.receiver_min_bias,
		context.receiver_slope_bias
	)
end

-- Read the current light camera matrices and build the matrix used by the receiver vertex shader.
local function update_shadow_matrices(context)
	-- Get the view and projection matrices from the light camera.
	context.shadow_view = camera.get_view(context.camera)
	context.shadow_projection = camera.get_projection(context.camera)

	-- World space -> light view space -> light clip space.
	context.shadow_frustum = context.shadow_projection * context.shadow_view

	-- World space -> light clip space -> shadow texture space.
	context.constants.mtx_shadow = context.clip_to_texture * context.shadow_frustum
end

-- Preserve the display camera's culling options
-- while supplying the shadow constant buffer to the receiver material.
local function create_receiver_draw_options(world_options, constants)
	local options = {
		constants = constants,
	}

	if not world_options then
		return options
	end

	if world_options.frustum then
		options.frustum = world_options.frustum
	end

	if world_options.frustum_planes then
		options.frustum_planes = world_options.frustum_planes
	end

	return options
end


-- Create the module state.
function M.init()
	local context = {
		clip_to_texture = create_clip_to_texture_matrix(),
		constants = render.constant_buffer(),

		target = nil,
		resolution = nil,
		camera = nil,

		shadow_view = nil,
		shadow_projection = nil,
		shadow_frustum = nil,

		pcf_kernel_size = DEFAULT_PCF_KERNEL_SIZE,
		pcf_sample_spacing = DEFAULT_PCF_SAMPLE_SPACING,

		polygon_offset_factor = DEFAULT_POLYGON_OFFSET_FACTOR,
		polygon_offset_units = DEFAULT_POLYGON_OFFSET_UNITS,

		receiver_min_bias = DEFAULT_RECEIVER_MIN_BIAS,
		receiver_slope_bias = DEFAULT_RECEIVER_SLOPE_BIAS,
	}

	update_shadow_parameters(context)
	return context
end


-- Release the shadow render target owned by this module.
function M.final(context)
	if context.target then
		render.delete_render_target(context.target)
		context.target = nil
	end
end


-- Handle the set_directional_shadow configuration message.
function M.on_message(context, message_id, message)
	if message_id ~= MSG_SET_DIRECTIONAL_SHADOW then
		return false
	end

	assert(message.camera, "set_directional_shadow requires message.camera")
	assert(message.resolution and message.resolution > 0, "set_directional_shadow requires a positive message.resolution")

	context.camera = message.camera

	-- Shadow textures require integer dimensions. Fractional input is truncated.
	local resolution = math.max(1, math.floor(message.resolution))
	if not context.target or context.resolution ~= resolution then
		recreate_depth_target(context, resolution)
	end

	-- Validate and update the PCF kernel size and sample spacing.
	context.pcf_kernel_size = validate_pcf_kernel_size(message.pcf_kernel_size or context.pcf_kernel_size)
	context.pcf_sample_spacing = message.pcf_sample_spacing or context.pcf_sample_spacing
	assert(context.pcf_sample_spacing >= 0.0, "pcf_sample_spacing must be greater than or equal to 0")

	-- Validate and update the polygon offset factor and units.
	context.polygon_offset_factor = message.polygon_offset_factor or context.polygon_offset_factor
	context.polygon_offset_units = message.polygon_offset_units or context.polygon_offset_units
	context.receiver_min_bias = message.receiver_min_bias or context.receiver_min_bias
	context.receiver_slope_bias = message.receiver_slope_bias or context.receiver_slope_bias

	update_shadow_parameters(context)
	return true
end


-- Render shadow casters into the depth texture from the light camera.
function M.render_depth(context, model_predicate)
	if not context.target or not context.camera then
		return
	end

	update_shadow_matrices(context)

	render.set_render_target(context.target)
	render.set_viewport(0, 0, context.resolution, context.resolution)

	-- Clear any selected Camera component and provide the shadow camera matrices
	-- explicitly for this pass.
	render.set_camera()
	render.set_view(context.shadow_view)
	render.set_projection(context.shadow_projection)

	-- The target contains only depth; no color output is needed.
	render.set_color_mask(false, false, false, false)
	render.set_depth_mask(true)
	render.set_depth_func(graphics.COMPARE_FUNC_LEQUAL)
	render.enable_state(graphics.STATE_DEPTH_TEST)

	render.enable_state(graphics.STATE_CULL_FACE)
	render.set_cull_face(graphics.FACE_TYPE_BACK)
	render.disable_state(graphics.STATE_BLEND)

	-- Caster-side bias. Increase these values to reduce remaining shadow acne,
	-- but reduce them if shadows visibly detach from their casters.
	render.enable_state(graphics.STATE_POLYGON_OFFSET_FILL)
	render.set_polygon_offset(
		context.polygon_offset_factor,
		context.polygon_offset_units
	)

	-- A depth value of 1.0 represents the far end of the depth range.
	render.clear({
		[graphics.BUFFER_TYPE_DEPTH_BIT] = 1.0,
	})

	-- Override all caster materials with the minimal depth material.
	render.enable_material(DEPTH_MATERIAL)
	render.draw(model_predicate, {
		frustum = context.shadow_frustum,
		frustum_planes = render.FRUSTUM_PLANES_ALL,
	})
	render.disable_material()

	-- Restore state that must not leak into the main scene pass.
	render.set_polygon_offset(0.0, 0.0)
	render.disable_state(graphics.STATE_POLYGON_OFFSET_FILL)
	render.set_color_mask(true, true, true, true)
	render.set_render_target(render.RENDER_TARGET_DEFAULT)

	-- The main render script should restore the display camera and viewport next.
end


-- Render normal models with the shadow receiver material and depth texture.
function M.render_models(context, model_predicate, world_options)
	if not context.target or not context.camera then
		render.draw(model_predicate, world_options)
		return
	end

	-- Enable the shadow sampler and bind the shadow target's depth attachment to the receiver material.
	render.enable_texture(
		SHADOW_SAMPLER,
		context.target,
		graphics.BUFFER_TYPE_DEPTH_BIT
	)
	render.enable_material(RECEIVER_MATERIAL)

	-- Draw the model predicate using the display camera's frustum while supplying mtx_shadow, shadow_params, and shadow_texel_size.
	render.draw(
		model_predicate,
		create_receiver_draw_options(world_options, context.constants)
	)

	-- Restore the previous material and texture bindings.
	render.disable_material()
	render.disable_texture(SHADOW_SAMPLER)
end


return M
