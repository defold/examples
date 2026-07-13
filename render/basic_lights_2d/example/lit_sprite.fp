#version 140

in highp vec4 var_position;
in mediump vec2 var_texcoord0;
in highp mat4 var_view;

out vec4 out_fragColor;

uniform mediump sampler2D texture_sampler;

#define MAX_LIGHT_COUNT 4
#include "/builtins/materials/lighting.glsl"

void main()
{
    vec4 color = texture(texture_sampler, var_texcoord0);
    vec3 normal = normalize((var_view * vec4(0.0, 0.0, 1.0, 0.0)).xyz);
    vec3 light = ambient_light() + diffuse_lambert(normal, var_position.xyz);
    out_fragColor = vec4(color.rgb * light, color.a);
}
