#version 140

in highp vec4 position;
in highp mat4 mtx_world;

uniform vs_uniforms
{
	highp mat4 mtx_view;
	highp mat4 mtx_proj;
};

void main()
{
	// The fixed-function depth output is generated from gl_Position. No color
	// information is needed for the shadow map.
	gl_Position = mtx_proj * mtx_view * mtx_world * vec4(position.xyz, 1.0);
}
