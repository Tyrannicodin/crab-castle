shader_type canvas_item;

uniform vec4 border_color: source_color;
uniform float radius = 30;
uniform int samples = 15;
uniform float brightness = 0;

float draw_band(float offset, vec2 uv, sampler2D tex, vec2 texture_pixel_size) {
	float r = radius;
	float d = 0.0;
    for (int i = 0; i < samples; i++) {
        float angle = (2.0 * PI / float(samples)) * float(i);
        vec2 point = vec2(uv.x + cos(angle) * r * texture_pixel_size.x, uv.y + sin(angle) * r * texture_pixel_size.y);
        d += texture(tex, point).a;
		if (d >= 0.1) {
			return clamp(1.0, 0,1);
		}
    }
	return 0.0;
}

void fragment(){
	if (COLOR.a < 0.9) {
		vec4 tex = texture(TEXTURE, UV);
		float band_1 = draw_band(0, UV, TEXTURE, TEXTURE_PIXEL_SIZE);

		COLOR = vec4(
			border_color.rgb,
			band_1
		);	    
		
		vec4 previous_color = texture(TEXTURE, UV);
	    vec4 white_color = vec4(1.0, 1.0, 1.0, previous_color.a);
	    vec4 new_color = previous_color;
	    new_color = mix(previous_color, white_color, brightness);
	    COLOR = new_color;
	}
}