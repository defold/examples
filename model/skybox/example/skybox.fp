varying mediump vec3 var_texcoord0;

uniform samplerCube cubemap;

void main() {
	gl_FragColor = textureCube(cubemap, var_texcoord0);
}