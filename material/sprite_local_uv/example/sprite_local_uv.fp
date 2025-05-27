#version 140

// from sprite_local_uv.vp
in mediump vec2 var_texcoord0;
in highp vec2 var_position_local;

out vec4 out_fragColor;

uniform mediump sampler2D texture_sampler;
uniform fs_uniforms
{
    mediump vec4 tint;
};

void main()
{
    // Pre-multiply alpha since all runtime textures already are
    mediump vec4 tint_pm = vec4(tint.xyz * tint.w, tint.w);

    // sample color from sprite texture
    vec4 color = texture(texture_sampler, var_texcoord0.xy) * tint_pm;

    // mix local position with red and green color of sprite to
    // create a gradient across the entire sprite
    out_fragColor.rg = mix(color.rg, var_position_local.xy, 0.3);
    // use blue and alpha from the sprite
    out_fragColor.b = color.b;
    out_fragColor.a = color.a;
}
