#version 140

in highp vec4 position;
in mediump vec2 texcoord0;
in mediump vec3 normal;

out highp vec4 var_position;
out mediump vec3 var_normal;
out mediump vec2 var_texcoord0;
out mediump vec4 var_light;

uniform vs_uniforms
{
    mediump mat4 mtx_worldview;
    mediump mat4 mtx_view;
    mediump mat4 mtx_proj;
    mediump mat4 mtx_normal;
    mediump vec4 light;
    mediump vec4 morph_targets_weights[1];
};

uniform sampler2DArray morph_targets;

vec2 get_morph_uv(int index, int width, int height)
{
    int x = index % width;
    int y = index / width;

    return vec2(
        (float(x) + 0.5) / float(width),
        (float(y) + 0.5) / float(height)
    );
}

void apply_weighted_morph_target(in vec2 uv, in float weight, inout vec3 p, inout vec3 n, in int target)
{
    if (weight == 0.0) {
        return;
    }

    int position_layer = target * 3;
    int normal_layer = target * 3 + 1;

    p += weight * texture(morph_targets, vec3(uv, position_layer)).xyz;
    n += weight * texture(morph_targets, vec3(uv, normal_layer)).xyz;
}

void get_morph_target_data(int vertex_index, out vec3 position_delta, out vec3 normal_delta)
{
    position_delta = vec3(0.0);
    normal_delta = vec3(0.0);

#ifndef EDITOR
    ivec3 morph_texture_size = textureSize(morph_targets, 0);
    vec2 uv = get_morph_uv(vertex_index, morph_texture_size.x, morph_texture_size.y);

    apply_weighted_morph_target(uv, morph_targets_weights[0].x, position_delta, normal_delta, 0);
    apply_weighted_morph_target(uv, morph_targets_weights[0].y, position_delta, normal_delta, 1);
    apply_weighted_morph_target(uv, morph_targets_weights[0].z, position_delta, normal_delta, 2);
    apply_weighted_morph_target(uv, morph_targets_weights[0].w, position_delta, normal_delta, 3);
#endif
}

void main()
{
    vec3 position_delta, normal_delta;
    get_morph_target_data(gl_VertexIndex, position_delta, normal_delta);

    vec3 morphed_position = position.xyz + position_delta;
    vec3 morphed_normal = normalize(normal + normal_delta);

    vec4 p = mtx_worldview * vec4(morphed_position, 1.0);
    var_light = mtx_view * vec4(light.xyz, 1.0);
    var_position = p;
    var_texcoord0 = texcoord0;
    var_normal = normalize((mtx_normal * vec4(morphed_normal, 0.0)).xyz);
    gl_Position = mtx_proj * p;
}
