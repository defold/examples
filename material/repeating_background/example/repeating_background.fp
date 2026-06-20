#version 140

in mediump vec2 var_texcoord0;

out vec4 out_fragColor;

uniform mediump sampler2D texture0;

uniform fs_uniforms
{
	vec4 uv_params;
	vec4 rotation_params;
	vec4 time_data;
};

void main()
{
	vec2 repeat_scale = uv_params.xy;
	vec2 scroll_speed = uv_params.zw;
	vec2 scroll_offset = fract(time_data.x * scroll_speed);
	vec2 centered_uv = (var_texcoord0 - 0.5) * repeat_scale;
	vec2 rotated_uv = vec2(
		centered_uv.x * rotation_params.x - centered_uv.y * rotation_params.y,
		centered_uv.x * rotation_params.y + centered_uv.y * rotation_params.x
	);
	vec2 uv = rotated_uv - scroll_offset;
	out_fragColor = texture(texture0, uv);
}
