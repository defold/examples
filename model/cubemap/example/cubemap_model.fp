#version 140

// These values are calculated per vertex in `cubemap_model.vp` and
// interpolated for each fragment.
in vec3 var_reflection;
in float var_fresnel;

// Output fragment color
out vec4 out_frag_color;

// Environment map
// This sampler name must match the sampler in `cubemap_model.material` and
// the texture binding in the Model component.
uniform samplerCube env_map;

void main()
{
	// Normalize after interpolation, then sample the cubemap in that direction.
	vec3 reflected_color = texture(env_map, normalize(var_reflection)).rgb;

	// You can add a small base color so the logo still has shape in darker cubemap areas.
	vec3 base_color = vec3(0.06, 0.08, 0.1);

	// Fresnel makes shallow viewing angles more reflective, which helps show
	// that the cubemap is responding to the model's surface direction.
	float reflection_strength = mix(0.72, 1.0, var_fresnel);
	vec3 color = mix(base_color, reflected_color, reflection_strength);

	out_frag_color = vec4(color, 1.0);
}
