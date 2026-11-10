#version 140

uniform vs_uniforms {
    mediump mat4 mtx_worldview;
    mediump mat4 mtx_proj;
    mediump mat4 mtx_normal;
};

in highp vec4 position;
in mediump vec3 normal;
in mediump vec2 texcoord0;

out highp vec3 var_normal;
out highp vec3 var_view_position;
out mediump vec2 var_texcoord0;

void main()
{
    vec4 view_position = mtx_worldview * vec4(position.xyz, 1.0);
    gl_Position = mtx_proj * view_position;
    var_view_position = view_position.xyz;
    var_normal = normalize((mtx_normal * vec4(normal, 0.0)).xyz);
    var_texcoord0 = texcoord0;
}
