#version 140

// Inputs should match the vertex shader's outputs.
in vec2 var_texcoord0;
in vec4 var_screen_texcoord;

// The color texture.
uniform lowp sampler2D texture0;
// The pattern texture.
uniform lowp sampler2D texture_pattern;

// The user defined uniforms.
uniform user_fp
{
    // pattern_opts.x - alpha, default 1.0 (set 0.0 to disable the screen space effect).
    // pattern_opts.y - scale, default 30.0.
    // pattern_opts.z - offset by x, default 0.0.
    // pattern_opts.w - rotation in radians.
    vec4 pattern_opts;

    // The screen size, used to calculate the aspect ratio.
    vec4 screen_size;
};

// The final color of the fragment.
out lowp vec4 final_color;

// Rotate 2D vector "v" by the "a" angle in radians
vec2 rotate(vec2 v, float a)
{
    float s = sin(a);
    float c = cos(a);
    return mat2(c, s, -s, c) * v;
}

void main()
{
    // Sample the color texture at the fragment's texture coordinates.
    vec4 color = texture(texture0, var_texcoord0.xy);

    // Counteract the perspective correction and scale the coords.
    vec2 pattern_coord = (var_screen_texcoord.xy / var_screen_texcoord.w) * pattern_opts.y;
    // + Correct the aspect ratio
    float aspect = screen_size.x / screen_size.y;
    pattern_coord.x *= aspect;
    // + Offset the grid horizontally
    pattern_coord.x += pattern_opts.z;
    // + Rotate
    pattern_coord = rotate(pattern_coord, pattern_opts.w);

    // Output the sampled color
    if (pattern_opts.x > 0.0)
    {
        // Sample the pattern at the screen space texture coordinates.
        vec4 pattern_color = texture(texture_pattern, pattern_coord);

        // Blend the colors: (sRGBA*1) + (dRGBA*(1-sA))
        final_color = pattern_color * pattern_opts.x + color * (1.0 - (pattern_color.a * pattern_opts.x));
    }
    else
    {
        // No pattern, just output the color.
        final_color = color;
    }
}
