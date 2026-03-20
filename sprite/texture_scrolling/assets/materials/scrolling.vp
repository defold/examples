#version 140

// Positions are in world space.
in highp vec4 position;
in mediump vec2 texcoord0;
in mediump mat3 texture_transform_2d;
in vec2  translation;

out mediump vec2 var_texcoord0;
out mediump mat3 var_texture_transform;
out vec2 var_translation;

uniform vs_uniforms
{
    highp mat4 view_proj;
};

void main()
{
    gl_Position = view_proj * vec4(position.xyz, 1.0);
    var_texcoord0 = texcoord0;
    var_texture_transform = texture_transform_2d;
    var_translation = translation;
}
