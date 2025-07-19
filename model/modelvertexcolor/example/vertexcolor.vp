#version 140

// Models vertex color attribute comes in as rgba floats (vec4)
in vec4 color;

// The model's vertex position.
in vec4 position;

// The model's world matrix.
in mat4 mtx_world;

// The projection and view matrices.
uniform general_vp
{
    mat4 mtx_view;
    mat4 mtx_proj;
};

// The output of a vertex shader are passed to the fragment shader.
out vec4 vertex_color;

void main()
{
    // Setting the vertex colors to the passed varying.
    vertex_color = color;

    // Transform the vertex position to clip space.
    gl_Position = mtx_proj * mtx_view * mtx_world * vec4(position.xyz, 1.0);
}
