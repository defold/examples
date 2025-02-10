varying mediump vec3 vReflect;

uniform samplerCube envMap;

void main() {
	gl_FragColor = textureCube(envMap, vReflect);
}