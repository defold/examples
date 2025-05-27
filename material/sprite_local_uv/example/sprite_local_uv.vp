#version 140

// positions are in world space
in highp vec4 position;
in mediump vec2 texcoord0;

// position in local space
in highp vec2 position_local;
// size of sprite in pixels
in mediump vec2 sprite_size;

out mediump vec2 var_texcoord0;
out highp vec2 var_position_local;

uniform vs_uniforms
{
    highp mat4 view_proj;
};

void main()
{
    gl_Position = view_proj * vec4(position.xyz, 1.0);
    var_texcoord0 = texcoord0;
    // calculate normalized local position and pass it on to the fragment program
    var_position_local = (position_local + sprite_size * 0.5) / sprite_size;
}
