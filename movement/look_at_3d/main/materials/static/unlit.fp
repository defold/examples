#version 140


in mediump vec2 var_texcoord0;
uniform mediump sampler2D tex0;
in highp mat4 var_view;

out vec4 out_fragColor;

uniform fs_uniforms
{
	mediump vec4 tint;
};

void main()
{
	// Pre-multiply alpha since all runtime textures already are
	vec4 tint_pm = vec4(tint.xyz * tint.w, tint.w);

	// Sample the texture at the fragment's texture coordinates.
	vec4 color = texture(tex0, var_texcoord0.xy) * tint_pm;

	// Output the sampled color.
	out_fragColor = color;
}