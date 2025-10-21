#version 140

in highp vec4 var_position;
in mediump vec3 var_normal;
in mediump vec2 var_texcoord0;
in mediump vec4 var_light;

out vec4 out_fragColor;

uniform mediump sampler2D tex0;

uniform fs_uniforms
{
    mediump vec4 tint;
};

void main()
{
    // Pre-multiply alpha since all runtime textures already are
    vec4 tint_pm = vec4(tint.xyz * tint.w, tint.w);
    vec4 color = texture(tex0, var_texcoord0.xy) * tint_pm;

    // Lighting
    vec3 ambient_light = vec3(0.8);
    vec3 L = normalize(var_light.xyz - var_position.xyz);
    float diff = max(dot(var_normal, L), 0.0);
    vec3 lighting = clamp(ambient_light + diff, 0.0, 1.0);

    out_fragColor = vec4(color.rgb * lighting, 1.0);
}

