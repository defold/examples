#version 140

in highp vec4 position;
in mediump vec2 texcoord0;
in mediump vec3 normal;
in highp mat4 mtx_world;
in highp mat4 mtx_normal;

out highp vec4 var_position;
out mediump vec3 var_normal;
out mediump vec2 var_texcoord0;

// Required by /builtins/materials/lighting.glsl in the fragment shader.
out highp mat4 var_view;

// Homogeneous shadow texture coordinates. Keeping w until the fragment stage
// preserves correct interpolation before the perspective divide.
out highp vec4 var_shadow_coord;

uniform vs_uniforms
{
	highp mat4 mtx_view;
	highp mat4 mtx_proj;
	highp mat4 mtx_shadow;
};

void main()
{
	// Convert the position to world space.
	highp vec4 world_position = mtx_world * vec4(position.xyz, 1.0);

	// Convert the world position to view space.
	highp vec4 view_position = mtx_view * world_position;

	// Store the view position.
	var_position = view_position;

	// Store the normal.
	var_normal = normalize(
		(mtx_normal * vec4(normal, 0.0)).xyz
	);

	// Store the texture coordinates.
	var_texcoord0 = texcoord0;

	// Store the view matrix.
	var_view = mtx_view;

	// Convert the world position to homogeneous shadow texture coordinates texture coordinates.
	var_shadow_coord = mtx_shadow * world_position;

	gl_Position = mtx_proj * view_position;
}
