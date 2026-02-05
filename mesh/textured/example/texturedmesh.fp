#version 140

in highp vec4 var_position;
in mediump vec2 var_texcoord0;

out vec4 out_fragColor;

uniform mediump sampler2D tex0;

uniform fs_uniforms
{
	mediump vec4 tint;
};

void main()
{
	// Pre-multiply alpha since all runtime textures already are
	vec4 tint_pm = vec4(tint.xyz * tint.w, tint.w);

	vec4 color = texture(tex0, var_texcoord0) * tint_pm;

	out_fragColor = vec4(color.rgb, 1.0);
}
