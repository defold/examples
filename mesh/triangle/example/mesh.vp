uniform mediump mat4 mtx_worldview;
uniform mediump mat4 mtx_proj;

attribute mediump vec4 position;
attribute mediump vec4 color0;

varying mediump vec4 var_color;

void main()
{
	gl_Position = mtx_proj * mtx_worldview * vec4(position.xyz, 1.0);
	var_color = color0;
}