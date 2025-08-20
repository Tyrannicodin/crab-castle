shader_type canvas_item;

uniform float water_height = 0.1;
uniform float foam_size = 0.005;

void fragment() {
		float progress = mod(TIME + 3.0 * UV.x, PI * 4.0);
		float water_offset = sin(progress) / 200.0;
		float y_squish = 1.0 / (0.4 + water_offset);
		float above_horizon = water_height >= 0.5 ? 0.3 : 0.0;
		vec4 tex = texture(TEXTURE, vec2(1.0 - UV.x + sin(TIME / 10.0 + UV.y * 1000.0) / 100.0,2.0 * UV.y / 0.6 - 1.4 + water_offset - above_horizon));
		
		if (water_height < 0.5 && UV.y > water_height + water_offset && UV.y <= 0.5) {
			COLOR = tex + vec4(-0.2,0.2,1.0,0.0);
		}
		if (water_height >= 0.5 && UV.y >= 0.5 && UV.y <= water_height + water_offset) {
			COLOR = tex + vec4(-0.2,0.2,1.0,0.0);
		}
}
