shader_type spatial;

uniform vec4 grass_color : source_color = vec4(0.1, 0.8, 0.1, 1.0);
uniform float wind_speed = 2.0;
uniform float wind_strength = 0.2;

void vertex() {
    float time_offset = TIME * wind_speed;
    float wind_effect = sin(VERTEX.x * 3.0 + time_offset) * wind_strength;

    // Only apply wind effect to the upper part (Y > 0)
    float influence = clamp(VERTEX.y, 0.0, 1.0); // 0 at bottom, 1 at top
    VERTEX.xz += wind_effect * influence * vec2(0.5, 0.5);
}

void fragment() {
    ALBEDO = grass_color.rgb;
}
