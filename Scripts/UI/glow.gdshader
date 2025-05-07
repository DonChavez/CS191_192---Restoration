shader_type canvas_item;

uniform float glow_intensity : hint_range(0.0, 1.0) = 0.0;
uniform vec4 glow_color = vec4(1.0, 1.0, 0.0, 1.0);
uniform float outline_size : hint_range(0.0, 0.01) = 0.005;

void fragment() {
    vec2 uv = UV;
    vec4 tex_color = texture(TEXTURE, uv);
    
    // Sample neighboring pixels to create outline
    float outline = 0.0;
    for (float x = -outline_size; x <= outline_size; x += outline_size / 2.0) {
        for (float y = -outline_size; y <= outline_size; y += outline_size / 2.0) {
            if (abs(x) + abs(y) > 0.0) {
                vec4 neighbor = texture(TEXTURE, uv + vec2(x, y));
                outline += neighbor.a;
            }
        }
    }
    
    // Apply glow only to outline
    vec4 final_color = tex_color;
    if (tex_color.a == 0.0 && outline > 0.0) {
        final_color = glow_color * glow_intensity;
    }
    
    COLOR = final_color;
}