#version 140

in highp vec4 position;
in mediump vec2 texcoord0;
in mediump vec3 normal;

uniform vp_uniforms
{
    mediump mat4 mtx_worldview;
    mediump mat4 mtx_proj;
};

out highp vec4 var_position;
out mediump vec2 var_texcoord0;

void main()
{
    highp vec4 p = mtx_worldview * vec4(position.xyz, 1.0);
    var_texcoord0 = texcoord0;

    gl_Position = mtx_proj * p;
}

