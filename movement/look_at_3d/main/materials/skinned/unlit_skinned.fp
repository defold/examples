#version 140

in vec2 var_texcoord0;
uniform mediump sampler2D tex0;
out lowp vec4 final_color;
uniform fs_uniforms
{
	mediump vec4 tint;
};

void main()
{
	vec4 tint_pm = vec4(tint.xyz * tint.w, tint.w);
	vec4 color = texture(tex0, var_texcoord0.xy) * tint_pm;
	final_color = color;
}