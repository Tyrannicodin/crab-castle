shader_type canvas_item;

uniform vec4 elite_r1: source_color;
uniform vec4 elite_r2: source_color;
uniform vec4 elite_r3: source_color;
uniform int rank = 0;

uniform float radius = 30;
uniform int samples = 15;
uniform float brightness = 0;
uniform float speed = 1.0;

float draw_band(float offset, vec2 uv, sampler2D tex, vec2 texture_pixel_size) {
	float p = mod((TIME + offset / speed), 1.0 / speed) * speed;
	float r = radius * p;
	float d = 0.0;
    for (int i = 0; i < samples; i++) {
        float angle = (2.0 * PI / float(samples)) * float(i);
        vec2 point = vec2(uv.x + cos(angle) * r * texture_pixel_size.x, uv.y + sin(angle) * r * texture_pixel_size.y);
        d += texture(tex, point).a;
		if (d >= 0.1) {
			return clamp(1.0 - p + 0.5, 0,1);
		}
    }
	return 0.0;
}

void fragment(){
	vec4 tex = texture(TEXTURE, UV);
			
	vec4 previous_color = texture(TEXTURE, UV);
    vec4 white_color = vec4(1.0, 1.0, 1.0, previous_color.a);
    vec4 new_color = previous_color;
    new_color = mix(previous_color, white_color, brightness);
    COLOR = new_color;
	
	if (COLOR.a < 0.9) {
		float band_1 = draw_band(-0.5, UV, TEXTURE, TEXTURE_PIXEL_SIZE);
		float band_2 = draw_band(0.0, UV, TEXTURE, TEXTURE_PIXEL_SIZE);
		float band_3 = draw_band(0.5, UV, TEXTURE, TEXTURE_PIXEL_SIZE);
		
		if (rank == 1) {
			COLOR = vec4(
				mix(elite_r1.rgb, white_color.rgb, brightness),
				band_1 + band_2 + band_3
			);
		} else if (rank == 2) {
			COLOR = vec4(
				mix(elite_r2.rgb, white_color.rgb, brightness),
				band_1 + band_2 + band_3
			);			
		} else if (rank == 3) {
			COLOR = vec4(
				mix(elite_r3.rgb, white_color.rgb, brightness),
				band_1 + band_2 + band_3
			);			
		}
		
	}
}