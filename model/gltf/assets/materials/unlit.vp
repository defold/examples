#version 140

// The model's vertex position and texture coordinates.
in vec4 position;
in vec2 texcoord0;

// The model's world matrix.
in mat4 mtx_world;

// The projection and view matrices.
uniform general_vp
{
    mat4 mtx_view;
    mat4 mtx_proj;
};

// The output of a vertex shader are passed to the fragment shader.
// The texture coordinates of the vertex.
out vec2 var_texcoord0;

void main()
{
    // Pass the texture coordinates to the fragment shader.
    var_texcoord0 = texcoord0;

    // Transform the vertex position to clip space.
    gl_Position = mtx_proj * mtx_view * mtx_world * vec4(position.xyz, 1.0);
}
