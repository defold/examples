uniform highp mat4 view_proj;

// positions are in world space
attribute highp vec4 position;
attribute mediump vec2 texcoord0;
attribute mediump vec4 mycolor;

varying mediump vec2 var_texcoord0;
varying mediump vec4 var_mycolor;

void main()
{
    gl_Position = view_proj * vec4(position.xyz, 1.0);
    var_texcoord0 = texcoord0;
    var_mycolor = mycolor;
}
