#version 140

uniform v_inputs
{
    mat4 view_proj;
};
// positions are in world space
in vec4 position;
in vec2 texcoord0;
// custom vertex attributes from material
in vec4 newcolor;
in vec4 outline;

out vec2 var_texcoord0;
// custom vertex attributes sent to fragment program
out vec4 new_color;
out vec4 new_outline;

void main()
{
    gl_Position = view_proj * vec4(position.xyz, 1.0);
    var_texcoord0 = texcoord0;
    new_color = newcolor;
    new_outline = outline;
}
