in mediump vec2 var_texcoord0;
in lowp vec4 var_color;

out vec4 out_fragColor;

uniform lowp sampler2D texture_sampler;

void main()
{
    lowp vec4 tex = texture2D(texture_sampler, var_texcoord0.xy);
    out_fragColor = tex * var_color * vec4(var_texcoord0.y, var_texcoord0.x, 0.0, 1.0);
}
