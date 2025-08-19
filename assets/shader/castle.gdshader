shader_type canvas_item;

uniform float water_height = 0.1;
uniform vec4 wet_color: source_color;
const float scaling_factor = 150.0/81.0;

void fragment() {
		bool right_side = UV.x < 0.9;
		float progress = mod(TIME + 3.0 * UV.x, PI * 4.0) * (right_side ? 1.25 : 1.0);

		if (UV.y < water_height - sin(progress) / 200.0) {
			COLOR = wet_color;
		}

		//if ((UV.y - 0.4) * (UV.y - 0.4) + (UV.x - 0.3) * (UV.x - 0.3) * scaling_factor < 0.001) {
			//COLOR = foam_color;
		//}
}
