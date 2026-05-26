#version 140
// Positions can be world or local space, since world and normal
// matrices are identity for world vertex space materials.
// If world vertex space is selected, you can remove the
// normal matrix multiplication for optimal performance.

in highp vec4 position;
in mediump vec2 texcoord0;
in mediump vec3 normal;

uniform vs_uniforms {
    mediump mat4 mtx_worldview;
    mediump mat4 mtx_view;
    mediump mat4 mtx_proj;
    mediump mat4 mtx_normal;
};

out mediump vec2 var_texcoord0;

void main()
{
    vec4 p = mtx_worldview * vec4(position.xyz, 1.0);
    var_texcoord0 = texcoord0;
    gl_Position = mtx_proj * p;
}

