#ifndef DIRECTIONAL_SHADOWS_GLSL
#define DIRECTIONAL_SHADOWS_GLSL

// Module for directional-shadow functions.
//
// Packed shadow parameter layout:
// shadow_params.x = PCF kernel width: 1, 3, or 5 (1 means one hard comparison without filtering).
// shadow_params.y = distance between PCF samples in shadow-map texels.
// shadow_params.z = minimum receiver-side depth bias.
// shadow_params.w = slope/normal-dependent receiver-side depth bias.

// Compare the receiver depth with one shadow-map sample.
// A value of 1.0 means lit, 0.0 means shadowed.
highp float directional_shadow_compare(
	sampler2D shadow_texture,
	highp vec2 uv,
	highp float receiver_depth
)
{
	// Samples outside the light camera volume are treated as lit.
	// This avoids stretching edge texels beyond the shadow map
	// when a PCF tap crosses a texture boundary.
	if (
		any( lessThan(uv, vec2(0.0)) ) ||
		any( greaterThan(uv, vec2(1.0)) )
	)
	{
		return 1.0;
	}

	// Sample the shadow map at the given UV coordinates and return the depth value.
	highp float stored_depth = texture(shadow_texture, uv).r;

	// If the receiver depth is less than or equal to the stored depth,
	// return 1.0 (lit), otherwise return 0.0 (shadowed).
	return receiver_depth <= stored_depth ? 1.0 : 0.0;
}


// Calculate receiver-side bias from normalized vectors.
//
// Surfaces facing the light use minimum_bias.
// Surfaces close to parallel with the light direction use a larger value controlled by slope_bias.
highp float directional_shadow_receiver_bias(
	highp vec3 normalized_view_normal,
	highp vec3 normalized_direction_to_light,
	highp float minimum_bias,
	highp float slope_bias
)
{
	// Calculate the dot product of the view normal and the light direction.
	highp float n_dot_l = max( dot(normalized_view_normal, normalized_direction_to_light), 0.0 );

	// Return the maximum of the minimum bias and the slope bias multiplied by the (1 - n_dot_l).
	return max( minimum_bias, slope_bias * (1.0 - n_dot_l) );
}


// Filter a shadow comparison with a fixed 3x3 kernel.
// This function always performs nine depth-texture samples.
highp float directional_shadow_pcf_3x3(
	sampler2D shadow_texture,
	highp vec2 center_uv,
	highp float receiver_depth,
	highp vec2 sample_step
)
{
	// Initialize the visibility to 0.0.
	highp float visibility = 0.0;

	// Iterate over the 3x3 kernel.
	for (int y = -1; y <= 1; ++y)
	{
		for (int x = -1; x <= 1; ++x)
		{
			// Calculate the offset for the current sample.
			highp vec2 offset = vec2(float(x), float(y)) * sample_step;

			// Add the visibility of the current sample to the total visibility.
			visibility += directional_shadow_compare(
				shadow_texture,
				center_uv + offset,
				receiver_depth
			);
		}
	}

	// Return the average visibility of the 3x3 kernel.
	return visibility / 9.0;
}


// Filter a shadow comparison with a fixed 5x5 kernel.
// This function always performs twenty-five depth-texture samples.
highp float directional_shadow_pcf_5x5(
	sampler2D shadow_texture,
	highp vec2 center_uv,
	highp float receiver_depth,
	highp vec2 sample_step
)
{
	// Initialize the visibility to 0.0.
	highp float visibility = 0.0;

	// Iterate over the 5x5 kernel.
	for (int y = -2; y <= 2; ++y)
	{
		for (int x = -2; x <= 2; ++x)
		{
			// Calculate the offset for the current sample.
			highp vec2 offset = vec2(float(x), float(y)) * sample_step;

			// Add the visibility of the current sample to the total visibility.
			visibility += directional_shadow_compare(
				shadow_texture,
				center_uv + offset,
				receiver_depth
			);
		}
	}

	// Return the average visibility of the 5x5 kernel.
	return visibility / 25.0;
}


// Return directional-light visibility for one fragment.
// Supported kernel widths: 1 = one hard comparison, 3 = fixed 3x3 PCF, 9 samples, 5 = fixed 5x5 PCF, 25 samples.
// Parameterpcf_sample_spacing changes the distance between taps.
//It changes the filter footprint and appearance, but not the sample count of the selected kernel.
highp float directional_shadow_visibility(
	sampler2D shadow_texture,
	highp vec4 shadow_coord,
	highp vec2 shadow_texel_size,
	highp vec4 shadow_params,
	highp vec3 normalized_view_normal,
	highp vec3 normalized_direction_to_light
)
{
	// Invalid homogeneous coordinates cannot be projected into the shadow map.
	if (shadow_coord.w <= 0.0)
	{
		return 1.0;
	}

	// The shadow matrix already contains the clip-to-texture conversion,
	// so the projected coordinates are expected in the 0..1 range.
	highp vec3 projected = shadow_coord.xyz / shadow_coord.w;

	// If the projected coordinates are outside the 0..1 range, return 1.0 (lit).
	if (
		any( lessThan(projected, vec3(0.0)) ) ||
		any( greaterThan(projected, vec3(1.0)) )
	)
	{
		return 1.0;
	}

	// Extract the PCF kernel size, sample spacing, minimum bias, and slope bias from the shadow parameters.
	int pcf_kernel_size = int(shadow_params.x + 0.5);
	highp float pcf_sample_spacing = shadow_params.y;
	highp float minimum_bias = shadow_params.z;
	highp float slope_bias = shadow_params.w;

	// Calculate the receiver depth with bias.
	highp float receiver_depth = projected.z -
		directional_shadow_receiver_bias(
			normalized_view_normal,
			normalized_direction_to_light,
			minimum_bias,
			slope_bias
		);

	// If the PCF kernel size is 3, use the 3x3 PCF kernel.
	if (pcf_kernel_size == 3)
	{
		// Calculate the sample step.
		highp vec2 sample_step =
			shadow_texel_size * pcf_sample_spacing;

		// Use the 3x3 PCF kernel to calculate the visibility.
		return directional_shadow_pcf_3x3(
			shadow_texture,
			projected.xy,
			receiver_depth,
			sample_step
		);
	}

	// If the PCF kernel size is 5, use the 5x5 PCF kernel.
	if (pcf_kernel_size == 5)
	{
		// Calculate the sample step.
		highp vec2 sample_step =
			shadow_texel_size * pcf_sample_spacing;

		// Use the 5x5 PCF kernel to calculate the visibility.
		return directional_shadow_pcf_5x5(
			shadow_texture,
			projected.xy,
			receiver_depth,
			sample_step
		);
	}

	// Kernel size 1, or an unsupported value, falls back to one hard depth comparison.
	// Lua validates the normal 1/3/5 configuration path.
	return directional_shadow_compare(
		shadow_texture,
		projected.xy,
		receiver_depth
	);
}

#endif
