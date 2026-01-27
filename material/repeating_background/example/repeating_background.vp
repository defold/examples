#version 140

in vec4 position;
in vec2 texcoord0;
uniform vp_uniforms
{
    mat4 mtx_worldview;
    mat4 mtx_proj;
    vec4 uv_params;
};

out vec2 var_texcoord0;

void main()
{
    // uv_params.x = repeat scale on U axis (tiles across width)
    // uv_params.y = repeat scale on V axis (tiles across height)
    // uv_params.z = scroll offset on U axis (normalized 0..1)
    // uv_params.w = scroll offset on V axis (normalized 0..1)
    var_texcoord0 = texcoord0 * uv_params.xy + uv_params.zw;
    gl_Position = mtx_proj * mtx_worldview * vec4(position.xyz, 1.0);
}
