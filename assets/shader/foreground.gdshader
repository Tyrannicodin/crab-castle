shader_type canvas_item;

uniform float water_height = 0.1;
uniform vec4 underwater_color: source_color;

void fragment() {
		float progress = mod(TIME + 3.0 * UV.x, PI * 4.0);
		
		if (UV.y > water_height + sin(progress) / 200.0) {
			COLOR = vec4(0.0);
		} else {
			COLOR = underwater_color;
		}
}
