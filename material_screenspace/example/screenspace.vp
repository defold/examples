#version 140

// The model's vertex position and texture coordinates.
in vec4 position;
in vec2 texcoord0;

// The projection, view and world matrices.
uniform general_vp
{
    mat4 mtx_world;
    mat4 mtx_view;
    mat4 mtx_proj;
};

// The output of a vertex shader are passed to the fragment shader.
// The texture coordinates of the vertex.
out vec2 var_texcoord0;

// The screen texture coordinates of the vertex.
out vec4 var_screen_texcoord;

// Converts the clip space position to the screen position.
vec4 clip_to_screen(vec4 pos)
{
    // Position is [-w,w], convert to [-0.5w,0.5w]
    vec4 o = pos * 0.5;

    // Convert from [-0.5w + 0.5w,0.5w + 0.5w] to [0,w]
    o.xy = vec2(o.x, o.y) + o.w;

    // Keep "zw" as it is
    o.zw = pos.zw;
    return o;
}

void main()
{
    // Pass the texture coordinates to the fragment shader.
    var_texcoord0 = texcoord0;

    // Transform the vertex position to clip space.
    vec4 vertex_pos = mtx_proj * mtx_view * mtx_world * vec4(position.xyz, 1.0);
    gl_Position = vertex_pos;

    // Convert the clip space position to the screen position and pass the value to the fragment shader.
    var_screen_texcoord = clip_to_screen(vertex_pos);
}
