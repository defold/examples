#version 140

in mediump vec2 var_texcoord0;
out vec4 out_fragColor;

uniform lowp sampler2D texture1_sampler;
uniform lowp sampler2D texture2_sampler;

uniform fs_uniforms {
    lowp vec4 tint;
    lowp vec4 mix_amount;
};

void main()
{
    // Pre-multiply alpha since all runtime textures already are
    lowp vec4 tint_pm = vec4(tint.xyz * tint.w, tint.w);
    // sample from both textures
    lowp vec4 color1 = texture(texture1_sampler, var_texcoord0.xy);
    lowp vec4 color2 = texture(texture2_sampler, var_texcoord0.xy);
    // mix (interpolate) the colors by the mix_amount
    lowp vec4 colormix = mix(color1, color2, mix_amount.x);
    // apply tint
    out_fragColor = colormix * tint_pm;
}
