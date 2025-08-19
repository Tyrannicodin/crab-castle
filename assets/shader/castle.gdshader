shader_type canvas_item;

uniform float water_height = 0.3;
uniform vec4 wet_color: source_color;
uniform vec4 foam_color: source_color;
uniform vec4 border_color: source_color;
uniform vec4 target_color: source_color;

uniform float radius = 30;
uniform int samples = 15;
uniform sampler2D blend_texture;

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

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	
	float foam_size = 0.0025;
	
    if (tex.a > .9) {
        COLOR = tex * texture(blend_texture, mod(UV * 4.0, 1.0));
    } else {
		float band_1 = draw_band(0, UV, TEXTURE, TEXTURE_PIXEL_SIZE);

		COLOR = vec4(
			border_color.rgb,
			band_1
		);
	}
		
	float progress = mod(TIME + -3.5 * UV.x, PI * 4.0);
	float water_offset = sin(progress) / 200.0 + 0.003;
	if (UV.y > water_offset + 1.0 - water_height + foam_size) {
		if (tex.b >= target_color.b - 0.3 && tex.b <= target_color.b) {
			COLOR = COLOR * wet_color;
		}
	} else if (UV.y > water_offset + 1.0 - water_height - foam_size && COLOR.a > 0.9) {
		COLOR = foam_color;
	}
}

//void fragment() {
		//vec4 tex = texture(TEXTURE, UV);
		//bool right_side = UV.x < 0.95;
		//float progress = mod(TIME + 3.0 * UV.x, PI * 4.0) * (right_side ? 1.25 : 1.0);
//
		//if ((UV.x > 0.053 && UV.x < 0.1813) && (UV.y < 0.834)) {
		//}
		//else if (UV.y > 1.0 - water_height - 0.04 - sin(progress) / 200.0 && tex.a >= 0.95) {
			//vec4 blended_texture = wet_color * tex; 
			//float f = ((UV.y / 2.0) - 0.166 + water_height) * 6.0;
			//if (UV.y > water_height) {
				//COLOR = (blended_texture * f + tex * (1.0 - f));
			//}
			//COLOR.a = 1.0;
		//}
//}
