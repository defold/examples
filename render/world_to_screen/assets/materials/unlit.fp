#version 140

// Inputs should match the vertex shader's outputs.
in vec2 var_texcoord0;

// The texture to sample.
uniform lowp sampler2D texture0;

// The final color of the fragment.
out lowp vec4 final_color;

uniform fs_uniforms
{
    mediump vec4 tint;
};

void main()
{
    // Pre-multiply alpha since all runtime textures already are
    vec4 tint_pm = vec4(tint.xyz * tint.w, tint.w);

    // Sample the texture at the fragment's texture coordinates.
    vec4 color = texture(texture0, var_texcoord0.xy) * tint_pm;

    // Output the sampled color.
    final_color = color;
}
