#version 140

in highp vec4 var_position;
in mediump vec3 var_normal;
in mediump vec2 var_texcoord0;

// Required by /builtins/materials/lighting.glsl. Its helper functions use this
// matrix to transform light positions and directions from world to view space.
in highp mat4 var_view;

// Homogeneous shadow texture coordinates produced by the receiver vertex shader.
// The perspective divide is performed per fragment.
in highp vec4 var_shadow_coord;

out vec4 out_fragColor;

uniform mediump sampler2D tex0;
uniform highp sampler2D shadow_map;

uniform fs_uniforms
{
	mediump vec4 tint;

	// xy = reciprocal shadow-map width and height.
	highp vec4 shadow_texel_size;

	// x = PCF kernel width (1, 3, or 5)
	// y = PCF sample spacing in shadow-map texels
	// z = minimum receiver bias
	// w = slope/normal-dependent receiver bias
	highp vec4 shadow_params;
};

#define MAX_LIGHT_COUNT 8

// Keep Defold's built-in lighting implementation unchanged.
#include "/builtins/materials/lighting.glsl"

// Reusable shadow functions with an explicit, name-independent interface.
#include "/example/materials/shadows.glsl"


// Equivalent to Defold's diffuse_lambert(view_normal, view_position),
// except that directional-light contributions are multiplied by shadow visibility.
// Point and spot lights are not affected by this directional shadow map.
vec3 shadowed_diffuse_lambert(vec3 view_normal, vec3 view_position)
{
	vec3 total_light = vec3(0.0);
	int light_count = int(light_info.w);

	// Iterate over the lights.
	for (int i = 0; i < MAX_LIGHT_COUNT; ++i)
	{
		// If the light index is greater than the light count, break.
		if (i >= light_count)
		{
			break;
		}

		// Calculate the light contribution for the current light.
		vec3 light_contribution = diffuse_lambert(i, view_normal, view_position);

		// If the light is directional, calculate the shadow visibility.
		if (int(lights[i].params.x) == LIGHT_DIRECTIONAL)
		{
			// This is the same normalized direction convention used internally
			// by Defold's directional branch in diffuse_lambert().
			highp vec3 direction_to_light = -world_to_view_dir(lights[i].direction_range.xyz);

			// Calculate the shadow visibility for the current light.
			light_contribution *= directional_shadow_visibility(
				shadow_map,
				var_shadow_coord,
				shadow_texel_size.xy,
				shadow_params,
				view_normal,
				direction_to_light
			);
		}

		// Add the light contribution to the total light.
		total_light += light_contribution;
	}

	// Return the total light.
	return total_light;
}


void main()
{
	// Texture profiles may premultiply color textures,
	// so premultiply the tint as well before combining them.
	vec4 tint_pm = vec4(tint.xyz * tint.w, tint.w);

	// Multiply the texture by the tinted color.
	vec4 color = texture(tex0, var_texcoord0.xy) * tint_pm;

	// directional_shadow_visibility() expects a normalized view-space normal.
	vec3 view_normal = normalize(var_normal);

	// Calculate the ambient light.
	vec3 ambient = ambient_light();

	// Calculate the diffuse light.
	vec3 diffuse = shadowed_diffuse_lambert(view_normal, var_position.xyz);

	// Combine the ambient and diffuse light for an output color.
	out_fragColor = vec4(color.rgb * (ambient + diffuse), color.a);
}
