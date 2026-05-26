#version 140

in mediump vec2 var_texcoord0;
out vec4 out_fragColor;

void main()
{  
    out_fragColor = vec4(var_texcoord0.x, var_texcoord0.y, 0.5, 1.0f);
}

