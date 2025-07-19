#version 140

// Inputs should match the vertex shader's outputs.
in vec4 vertex_color;

// The final color of the fragment.
out lowp vec4 final_color;

uniform fs_uniforms
{
    mediump vec4 tint;
};

void main()
{
    // brightening up the displayed vertex colors
    lowp float brightness = 0.1;
    // Pre-multiply alpha for tint
    vec4 tint_pm = vec4(tint.xyz * tint.w, tint.w);

    // Sample the vertex color from vertices, add a little brightness with tint.
    vec4 color = vertex_color + brightness * tint_pm ;

    // Output the sampled color.
    final_color = color;
}
