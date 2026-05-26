#version 140

in mediump vec3 vReflect;
out vec4 out_FragColor;

uniform samplerCube envMap;

void main()
{
	out_FragColor = texture(envMap, vReflect);
}