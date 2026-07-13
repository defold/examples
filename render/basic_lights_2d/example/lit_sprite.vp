#version 140

in highp vec4 position;
in mediump vec2 texcoord0;

out highp vec4 var_position;
out mediump vec2 var_texcoord0;
out highp mat4 var_view;

uniform vs_uniforms
{
    highp mat4 view_proj;
    highp mat4 mtx_view;
};

void main()
{
    var_position = mtx_view * vec4(position.xyz, 1.0);
    var_texcoord0 = texcoord0;
    var_view = mtx_view;
    gl_Position = view_proj * vec4(position.xyz, 1.0);
}
