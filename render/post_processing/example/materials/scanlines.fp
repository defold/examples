#version 140

in mediump vec2 var_texcoord0;

out vec4 out_fragColor;

uniform mediump sampler2D tex0;
uniform fs_uniforms
{
	mediump vec4 resolution;
};

// https://www.shadertoy.com/view/XdXXD4
void main()
{
	vec2 uv = var_texcoord0.xy;
	vec4 col = texture(tex0, uv );

	// scanline
	float scanline = sin(uv.y*resolution.y)*0.04;
	col -= scanline;

	out_fragColor = col;
}
