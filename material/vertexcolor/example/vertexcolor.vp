#version 140

// positions are in world space
in highp vec4 position;
in mediump vec2 texcoord0;
in mediump vec4 mycolor; // 1. Add attribute definition

out mediump vec2 var_texcoord0;
out mediump vec4 var_mycolor; // 2. Add output variable to pass color to fp

uniform vs_uniforms
{
    highp mat4 view_proj;
};

void main()
{
    gl_Position = view_proj * vec4(position.xyz, 1.0);
    var_texcoord0 = texcoord0;
    var_mycolor = mycolor; // 3. Pass mycolor attribute value to fp.
}