shader_type canvas_item;

uniform float water_height = 0.3;
uniform vec4 wet_color: source_color;

void fragment() {
		vec4 tex = texture(TEXTURE, UV);
		bool right_side = UV.x < 0.95;
		float progress = mod(TIME + 3.0 * UV.x, PI * 4.0) * (right_side ? 1.25 : 1.0);

		if ((UV.x > 0.053 && UV.x < 0.1813) && (UV.y < 0.834)) {
		}
		else if (UV.y > 1.0 - water_height - 0.04 - sin(progress) / 200.0 && tex.a >= 0.95) {
			vec4 blended_texture = wet_color * tex; 
			float f = ((UV.y / 2.0) - 0.166 + water_height) * 6.0;
			if (UV.y > water_height) {
				COLOR = (blended_texture * f + tex * (1.0 - f));
			}
			COLOR.a = 1.0;
		}
}
