shader_type canvas_item;

uniform float water_height = 0.1;
uniform vec4 sky_color: source_color;
uniform vec4 water_color: source_color;
uniform vec4 underwater_color: source_color;
uniform vec4 surface_color: source_color;
uniform vec4 foam_color: source_color;
uniform float foam_size = 0.005;
const float scaling_factor = 150.0/81.0;

void fragment() {
		float progress = mod(TIME + 3.0 * UV.x, PI * 4.0);
		float water_offset = sin(progress) / 200.0;
		
		COLOR = sky_color;
		
		if (UV.y > water_height + sin(progress) / 200.0 && UV.y <= 0.5) {
			COLOR = water_color;
		} else if (UV.y > water_height - foam_size + water_offset && UV.y <= water_height + water_offset) {
			COLOR = foam_color;
		} else if (UV.y < 0.5) {
			COLOR = underwater_color;
		}
		
		if (0.5 < water_height + water_offset && UV.y < water_height - foam_size + water_offset && UV.y > 0.5) {
			COLOR = surface_color;
		}

		//if ((UV.y - 0.4) * (UV.y - 0.4) + (UV.x - 0.3) * (UV.x - 0.3) * scaling_factor < 0.001) {
			//COLOR = foam_color;
		//}
}
