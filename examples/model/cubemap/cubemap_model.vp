uniform mediump mat4 view_proj;
uniform mediump mat4 world;
uniform mediump mat4 normal_transform;
uniform mediump mat4 world_view;
uniform mediump vec4 cameraPosition;

attribute mediump vec3 position;
attribute mediump vec3 normal;
attribute mediump vec2 texcoord0;

varying mediump vec3 vReflect;

void main()
{
	vec4 worldP = world * vec4(position, 1.0);
	gl_Position = view_proj * worldP;
	
	vec3 worldNormal = normalize(normal);
	vec3 cameraToVertex = normalize( worldP.xyz - cameraPosition.xyz );
	vReflect = reflect( cameraToVertex, worldNormal );
}
