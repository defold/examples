#version 140

uniform vs_uniforms {
	mediump mat4 mtx_worldview;
	mediump mat4 mtx_proj;
};

in mediump vec4 position;
in mediump vec4 color0;

out mediump vec4 var_color;

void main()
{
	gl_Position = mtx_proj * mtx_worldview * vec4(position.xyz, 1.0);
	var_color = color0;
}