#version 140

// Positions can be world or local space, since world and normal
// matrices are identity for world vertex space materials.
// If world vertex space is selected, you can remove the
// normal matrix multiplication for optimal performance.

in highp vec4 position;
in mediump vec2 texcoord0;

out highp vec4 var_position;
out mediump vec2 var_texcoord0;

uniform vs_uniforms
{
	uniform mediump mat4 mtx_worldview;
	uniform mediump mat4 mtx_proj;
	uniform mediump mat4 mtx_view;
};

void main()
{
	vec4 p = mtx_worldview * vec4(position.xyz, 1.0);
	var_position = p;
	var_texcoord0 = texcoord0;
	gl_Position = mtx_proj * p;
}
