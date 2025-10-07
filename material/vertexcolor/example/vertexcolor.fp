#version 140

in mediump vec2 var_texcoord0;
in mediump vec4 var_mycolor; // 4. Add var_mycolor definition

out vec4 out_fragColor;

uniform mediump sampler2D texture_sampler;

void main()
{
    // Pre-multiply color to match premultiplied textures
    mediump vec4 tint_pm = vec4(var_mycolor.rgb * var_mycolor.a, var_mycolor.a);
    out_fragColor = texture(texture_sampler, var_texcoord0.xy) * tint_pm;
}