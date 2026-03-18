#version 140

in mediump vec2 var_texcoord0;
in mediump mat3 var_texture_transform;
in vec2 var_translation;

out vec4 out_fragColor;

uniform mediump sampler2D texture_sampler;
uniform fs_uniforms
{
    mediump vec4 tint;
    vec4 time;
};

void main()
{
    // Pre-multiply alpha since all runtime textures already are.
    vec4 tint_pm = vec4(tint.xyz * tint.w, tint.w);

    // Region origin in atlas UV space.
    vec2 atlas_pos = var_texture_transform[2].xy;

    // Region size in atlas UV space.
    // The first two columns encode basis vectors; their lengths correspond to size.
    vec2 atlas_size = vec2(
        length(var_texture_transform[0].xy),
        length(var_texture_transform[1].xy)
    );

    // Convert to local tile UV (0..1).
    vec2 localUV = (var_texcoord0 - atlas_pos) / atlas_size;

    // Scroll in local UV space.
    localUV += (var_translation.xy) * time.x;

    // Wrap inside tile.
    localUV = fract(localUV);

    // Convert back to atlas space.
    vec2 finalUV = atlas_pos + localUV * atlas_size;

    out_fragColor = texture(texture_sampler, finalUV) * tint_pm;

    out_fragColor.a = 1.0;
}
