#version 140

uniform vs_uniforms {
	mediump mat4 view_proj;
	mediump mat4 world;
	mediump mat4 normal_transform;
	mediump mat4 world_view;
	mediump vec4 cameraPosition;
};

in mediump vec3 position;
in mediump vec3 normal;
in mediump vec2 texcoord0;

out mediump vec3 vReflect;

void main()
{
	vec4 worldP = world * vec4(position, 1.0);
	gl_Position = view_proj * worldP;
	
	vec3 worldNormal = normalize(normal);
	vec3 cameraToVertex = normalize( worldP.xyz - cameraPosition.xyz );
	vReflect = reflect( cameraToVertex, worldNormal );
}
