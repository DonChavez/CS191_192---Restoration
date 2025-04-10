shader_type canvas_item;

uniform vec4 line_color : source_color = vec4(1.0);
uniform float line_thickness : hint_range(0, 10) = 1.0;
uniform bool draw_outline = true;

const vec2 OFFSETS[8] = {
	vec2(-5, -5), vec2(-5, 0), vec2(-5, 5), vec2(0, -5), vec2(0, 5), 
	vec2(5, -5), vec2(5, 0), vec2(5, 5)
};

//void fragment() {
	//vec2 size = TEXTURE_PIXEL_SIZE * line_thickness;
	//float outline = 0.0;
	//
	//for (int i = 0; i < OFFSETS.length(); i++) {
		//outline += texture(TEXTURE, UV + size * OFFSETS[i]).a;
	//}
	//outline = min(outline, 1.0);
	//
	//vec4 color = texture(TEXTURE, UV);
	//COLOR = mix(color, line_color, outline - color.a);
//}

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	if (draw_outline) {
		vec2 size = TEXTURE_PIXEL_SIZE * line_thickness;
		float outline = 0.0;
		
		for (int i = 0; i < OFFSETS.length(); i++) {
			outline += texture(TEXTURE, UV + size * OFFSETS[i]).a;
		}
		outline = min(outline, 1.0);
		
		COLOR = mix(color, line_color, outline - color.a);
	}
	else {
		COLOR = color;
	}
}