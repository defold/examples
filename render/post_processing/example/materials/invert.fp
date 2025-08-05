#version 140

in mediump vec2 var_texcoord0;

out vec4 out_fragColor;

uniform mediump sampler2D tex0;

void main()
{
    vec4 color = texture(tex0, var_texcoord0.xy);
    color.r = 1.0 - color.r;
    color.g = 1.0 - color.g;
    color.b = 1.0 - color.b;
        
    out_fragColor = vec4(color.rgb,1.0);
}

