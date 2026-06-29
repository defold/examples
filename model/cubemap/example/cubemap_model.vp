#version 140

// Model components provide local vertex data. The material uses
// `VERTEX_SPACE_LOCAL`, so the shader must transform positions itself.
in vec4 position;
in vec3 normal;

// Defold automatically provides `mtx_world` as a per-instance attribute for
// model materials in local vertex space. It is not listed as a material uniform.
in mat4 mtx_world;

// `mtx_view` and `mtx_proj` are vertex constants declared in `cubemap_model.material`.
uniform general_vp
{
	mat4 mtx_view;
	mat4 mtx_proj;
};

// The fragment shader samples the cubemap with this reflected world direction.
out vec3 var_reflection;

// The Fresnel value is used only to make grazing angles slightly brighter.
out float var_fresnel;

// Build a world-space normal matrix from `mtx_world`.
// This is equivalent to transpose(inverse(mat3(mtx_world))) after normalize(),
// but avoids a full matrix inverse in the shader.
mat3 adjoint(mat4 m)
{
	return mat3(
		cross(m[1].xyz, m[2].xyz),
		cross(m[2].xyz, m[0].xyz),
		cross(m[0].xyz, m[1].xyz)
	);
}

// The cubemap reflection vector needs the camera position in world space.
// Defold gives us the view matrix, so this converts it back to camera origin.
vec3 camera_position_from_view(mat4 view)
{
	return -(transpose(mat3(view)) * view[3].xyz);
}

void main()
{
	// Move the vertex from model space to world space before projecting it.
	vec4 world_position = mtx_world * vec4(position.xyz, 1.0);

	// Transform the model normal into world space so it matches the cubemap.
	vec3 world_normal = normalize(adjoint(mtx_world) * normal);

	// Create the incident view direction used by GLSL `reflect()`.
	vec3 camera_position = camera_position_from_view(mtx_view);
	vec3 camera_to_vertex = normalize(world_position.xyz - camera_position);

	// Reflect the view direction around the surface normal.
	// The result points into the cubemap and is interpolated across the model surface.
	var_reflection = reflect(camera_to_vertex, world_normal);
	var_fresnel = pow(1.0 - max(dot(-camera_to_vertex, world_normal), 0.0), 4.0);

	// Finish the model transform: world -> view -> projection.
	gl_Position = mtx_proj * mtx_view * world_position;
}
