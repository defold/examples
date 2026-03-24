#version 140

in mediump vec2 var_texcoord0;
in mediump vec4 var_color;

out vec4 out_fragColor;

uniform mediump sampler2D texture_sampler;

uniform fs_uniforms
{
    mediump vec4 tint;
};

void main()
{
    mediump vec4 tint_pm = vec4(tint.xyz * tint.w, tint.w);
    mediump vec4 base = texture(texture_sampler, var_texcoord0.xy) * var_color * tint_pm;
    mediump float energy = max(max(base.r, base.g), base.b);
    mediump vec3 glow = vec3(0.9, 1.4, 1.8) * energy;
    out_fragColor = vec4(base.rgb * 0.2 + glow, base.a);
}
