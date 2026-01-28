#version 140

in mediump vec2 var_texcoord0;

out vec4 out_fragColor;

uniform mediump sampler2D texture0;

void main()
{
    out_fragColor = texture(texture0, var_texcoord0);
}
