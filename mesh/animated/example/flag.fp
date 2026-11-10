#version 140

in highp vec3 var_normal;
in highp vec3 var_view_position;
in mediump vec2 var_texcoord0;
out vec4 out_fragColor;

uniform mediump sampler2D tex0;

void main()
{
    vec4 fabric = texture(tex0, var_texcoord0);
    vec3 n = normalize(var_normal);

    // Soft fill light avoids harsh, triangle-shaped shadow transitions.
    vec3 light_dir = normalize(vec3(-0.2, 0.5, 1.0));
    float diffuse = max(dot(n, light_dir), 0.0);
    float lighting = 0.55 + 0.45 * diffuse;

    // Low-gloss fabric, not shiny plastic.
    vec3 view_dir = normalize(-var_view_position);
    vec3 h = normalize(light_dir + view_dir);
    float sheen = 0.018 * pow(max(dot(n, h), 0.0), 16.0);

    out_fragColor = vec4(fabric.rgb * lighting + vec3(sheen), fabric.a);
}
