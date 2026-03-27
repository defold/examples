#version 140

in highp vec4 position;   // Local quad vertex position (XY plane).
in highp mat4 mtx_world;  // Per-instance world matrix (translation = center, columns contain scale).
in mediump vec2 texcoord0;
in mediump vec4 color;
in lowp float billboard_mode; // 0.0 = screen-aligned, 1.0 = axis-locked (world Y axis).

uniform vs_uniforms
{
    mat4 view_proj;
    // View matrix used to derive camera basis vectors (right/up) and camera position.
    mat4 view;
    mat4 proj;
};

out mediump vec2 var_texcoord0;
out mediump vec4 var_color;

// Screen-aligned billboard:
// Uses camera right/up vectors (from the view matrix) so the quad always faces the camera.
vec3 computeScreenBillboard(vec3 center, vec2 local, float scaleX, float scaleY)
{
    // Camera basis vectors in world space.
    vec3 right = vec3(view[0][0], view[1][0], view[2][0]);
    vec3 up    = vec3(view[0][1], view[1][1], view[2][1]);
    return center + right * local.x * scaleX + up * local.y * scaleY;
}

// Axis-locked billboard (Y-up):
// Rotates towards the camera only around the world Y axis, keeping the quad upright.
vec3 computeAxisLockedBillboard(vec3 center, vec2 local, float scaleX, float scaleY)
{
    vec3 world_up = vec3(0.0, 1.0, 0.0);

    // Reconstruct camera world position from the view matrix.
    // (Equivalent to inverse(view) * vec4(0,0,0,1), but cheaper.)
    vec3 camera_position = vec3(
        -dot(view[0].xyz, view[3].xyz),
        -dot(view[1].xyz, view[3].xyz),
        -dot(view[2].xyz, view[3].xyz)
    );
    vec3 camera_vector = camera_position - center;

    // Project onto horizontal plane so we only rotate around Y.
    camera_vector.y = 0.0;

    // Avoid NaN when the camera is directly above the center (zero-length vector).
    if (length(camera_vector) < 0.0001)
    {
        camera_vector = vec3(0.0, 0.0, 1.0);
    }

    camera_vector = normalize(camera_vector);
    vec3 right = normalize(cross(world_up, camera_vector));
    vec3 up = world_up;

    return center + right * local.x * scaleX + up * local.y * scaleY;
}

void main()
{
    // Extract per-instance scale from the world matrix columns.
    // This preserves scaling applied to the sprite/particle in the editor.
    float scaleX = length(mtx_world[0].xyz);
    float scaleY = length(mtx_world[1].xyz);

    // Billboard center in world space is the translation part of the world matrix.
    vec3 center_position = mtx_world[3].xyz;

    // Local quad coordinates (in the same space as sprite/particle vertex data).
    vec2 local_position = position.xy;
    vec3 world_position;

    // Select the billboarding mode (treat anything < 1.0 as mode 0).
    if (billboard_mode < 1.0)
    {
        world_position = computeScreenBillboard(center_position, local_position, scaleX, scaleY);
    }
    else
    {
        world_position = computeAxisLockedBillboard(center_position, local_position, scaleX, scaleY);
    }

    // Transform to clip space and forward varyings to the fragment stage.
    gl_Position = view_proj * vec4(world_position, 1.0);
    var_texcoord0 = texcoord0;

    // Premultiply RGB by alpha to match Defold's built-in particle/sprite expectations.
    var_color = vec4(color.rgb * color.a, color.a);
}
