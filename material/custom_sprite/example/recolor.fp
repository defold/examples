#version 140

uniform sampler2D texture_sampler;
uniform f_uniform
{
    vec4 tint;
};

in vec2 var_texcoord0;
// custom vertex attributes
in vec4 new_color;
in vec4 new_outline;

out vec4 final_color;

void main()
{
    lowp vec4 tint_pm = vec4(tint.xyz * tint.w, tint.w);
    lowp vec4 sprite = texture(texture_sampler, var_texcoord0.xy);

    // float values used for comparing
    lowp float combine = (sprite.r + sprite.g);
    lowp float greenmul = sprite.g * 2;

    // when 2 channels added together equal the same as a single channel multipled then we have desaturated values
    if(combine == greenmul){
        sprite = vec4(sprite.rgb*new_color.rgb,sprite.a);
    }

    // when the green channel has a value of 1.0 and the w value is 1.0(on) then we color the outline
    if(new_outline.w >= 1.0 && sprite.g >= 1.0){
        sprite = vec4(new_outline.rgb,1.0);
    }
    else if (sprite.g >= 1.0){ //when the w value is not 1.0 we remove all values. turning the outline off
        sprite = vec4(0.0, 0.0, 0.0, 0.0);
    }
    
    final_color = vec4(sprite * tint);
}
