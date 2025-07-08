#version 140

uniform vs_uniforms
{
	uniform mediump mat4 view_proj;
	uniform mediump mat4 world;
};

in highp vec3 position;

out mediump vec3 var_texcoord0;

void main()
{
	/*
	 * Transform the position vector using the world view projection matrix
	 * and override the Z component with the W component. After the vertex
	 * shader is complete the rasterizer takes gl_Position vector and performs
	 * perspective divide (division by W) in order to complete the projection.
	 * When we set Z to W we guarantee that the final Z value of the position
	 * will be 1.0. This Z value is always mapped to the far Z. This means that
	 * the skybox will always fail the depth test against the other models in
	 * the scene. That way the skybox will only take up the background left
	 * between the models and everything else will be infront of it.
	 */
	mat4 wvp = world * view_proj;
	vec4 wvp_pos = wvp * vec4(position, 1.0);
	gl_Position = wvp_pos.xyww;

	/*
	 * Use the original position in object space as the 3D texture coordinate.
	 * This makes sense because the way sampling from the cubemap works is by
	 * shooting a vector from the origin through a point in the box or sphere.
	 * So the position of the point actually becomes the texture coordinate.
	 * The vertex shader passes the object space coordinate of each vertex as
	 * the texture coordinate and it gets interpolated by the rasterizer for
	 * each pixel. This gives us the position of the pixel which we can use for
	 * sampling.
	 */
	var_texcoord0 = position;
}
