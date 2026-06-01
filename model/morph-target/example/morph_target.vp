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
    mediump vec4 morph_targets_weights[2];
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

void apply_weighted_morph_target(in vec2 uv, in float weight, inout vec3 p, in int target)
{
    if (weight == 0.0) {
        return;
    }

    int pos_layer = target * 3;
    p += weight * texture(morph_targets, vec3(uv, pos_layer)).xyz;
}

vec3 get_morph_position_delta(int vertex_index)
{
    vec3 position_delta = vec3(0.0);

#ifndef EDITOR
    ivec3 morph_texture_size = textureSize(morph_targets, 0);
    vec2 uv = get_morph_uv(vertex_index, morph_texture_size.x, morph_texture_size.y);

    apply_weighted_morph_target(uv, morph_targets_weights[0].x, position_delta, 0);
    apply_weighted_morph_target(uv, morph_targets_weights[0].y, position_delta, 1);
    apply_weighted_morph_target(uv, morph_targets_weights[0].z, position_delta, 2);
    apply_weighted_morph_target(uv, morph_targets_weights[0].w, position_delta, 3);
    apply_weighted_morph_target(uv, morph_targets_weights[1].x, position_delta, 4);
    apply_weighted_morph_target(uv, morph_targets_weights[1].y, position_delta, 5);
    apply_weighted_morph_target(uv, morph_targets_weights[1].z, position_delta, 6);
    apply_weighted_morph_target(uv, morph_targets_weights[1].w, position_delta, 7);
#endif

    return position_delta;
}

void main()
{
    vec3 morphed_position = position.xyz + get_morph_position_delta(gl_VertexIndex);
    vec4 p = mtx_worldview * vec4(morphed_position, 1.0);

    var_light = mtx_view * vec4(light.xyz, 1.0);
    var_position = p;
    var_texcoord0 = texcoord0;
    var_normal = normalize((mtx_normal * vec4(normal, 0.0)).xyz);
    gl_Position = mtx_proj * p;
}
