#version 140

in mediump vec3 var_texcoord0;

uniform samplerCube cubemap;

void main()
{
	gl_FragColor = texture(cubemap, var_texcoord0);
}