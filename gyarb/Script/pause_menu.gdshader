shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform float blur_strength : hint_range(0.0, 5.0) = 2.5;
uniform float darken : hint_range(0.0, 1.0) = 0.3;

void fragment() {
    vec4 color = textureLod(screen_texture, SCREEN_UV, blur_strength);

    // darken background slightly for pause effect
    color.rgb *= (1.0 - darken);

    COLOR = color;
}