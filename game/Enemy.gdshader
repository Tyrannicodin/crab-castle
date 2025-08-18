shader_type canvas_item;

uniform float brightness = 0;

void fragment(){
	vec4 previous_color = texture(TEXTURE, UV);
	vec4 white_color = vec4(1.0, 1.0, 1.0, previous_color.a);
	vec4 new_color = previous_color;
	new_color = mix(previous_color, white_color, brightness);
	COLOR = new_color;
}