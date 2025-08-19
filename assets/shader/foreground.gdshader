shader_type canvas_item;

uniform float water_height = 0.1;
uniform vec4 sky_color: source_color;
uniform vec4 water_color: source_color;
uniform vec4 underwater_color: source_color;
uniform vec4 foam_color: source_color;
const float scaling_factor = 150.0/81.0;

void fragment() {
		float progress = mod(TIME + 3.0 * UV.x, PI * 4.0);

		if (UV.y > 0.5) {
			COLOR.a = 0.0;
		} else if (UV.y > water_height + sin(progress) / 200.0) {
			COLOR.a = 0.0;
		} else if (UV.y > water_height - 0.005 + sin(progress) / 200.0 && UV.x > 0.18) {
			COLOR = foam_color;
			if (UV.x < 0.19) {
				COLOR.a = (UV.x - 0.18) * 100.0;
			}
		} else {
			COLOR = underwater_color;
			COLOR.a = 0.0;
		}

		//if ((UV.y - 0.4) * (UV.y - 0.4) + (UV.x - 0.3) * (UV.x - 0.3) * scaling_factor < 0.001) {
			//COLOR = foam_color;
		//}
}
