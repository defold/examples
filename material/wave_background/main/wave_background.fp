#version 140

uniform fs_uniforms
{
	vec4 time_data;
};

in vec2 var_texcoord0;

out vec4 color_out;

void main()
{
	// Get the time value automatically passed in by the engine
	// time_data.x is the total number of seconds since the engine started
	float t = time_data.x;

	// 1. Adjust coordinate scaling and tilt
	// Rotating or offsetting the UV coordinates can create a diagonal effect
	// We add time to both X and Y to create motion toward the lower-right corner
	vec2 uv = var_texcoord0 * 8.0; 

	float speed = t * 2.0;

	// 2. Core wave algorithm
	// Use sin(x + y - t) to create a wave flowing diagonally
	// Adding sin(uv.x * 0.5) makes the wave feel distorted instead of like a rigid straight line
	float wave = sin(uv.x + uv.y - speed + sin(uv.x * 0.8 + speed * 0.5));

	// 3. Define the colors
	vec3 color_bright = vec3(0.0, 0.6, 1.0); // Light blue
	vec3 color_dark = vec3(0.0, 0.45, 0.9);  // Dark blue

	// 4. Anti-aliased color split
	// Clamp the smoothing width so the transition stays crisp while still hiding aliasing.
	float edge_width = clamp(fwidth(wave), 0.01, 0.04);
	float mask = smoothstep(-edge_width, edge_width, wave);
	vec3 final_color = mix(color_dark, color_bright, mask);

	color_out = vec4(final_color, 1.0);
}