#version 140

in vec4 position;
in vec2 texcoord0;

uniform vs_uniforms
{
	mat4 mtx_worldview;
	mat4 mtx_proj;
};

out vec2 var_texcoord0;

void main()
{
	var_texcoord0 = texcoord0;
	gl_Position = mtx_proj * mtx_worldview * vec4(position.xyz, 1.0);
}
