varying mediump vec2 var_texcoord0;

void main()
{  
    gl_FragColor = vec4(var_texcoord0.x, var_texcoord0.y, 0.5, 1.0f);
}

