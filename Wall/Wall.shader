shader_type spatial;
render_mode unshaded;

uniform vec4 COLOR_1: hint_color;
uniform vec4 COLOR_2: hint_color;

float hash(vec2 p) {
	return fract(sin(dot(p * 17.17, vec2(14.91, 67.31))) * 4791.9511);
}

float noise(vec2 x) {
	vec2 p = floor(x);
	vec2 f = fract(x);
	f = f * f * (3.0 - 2.0 * f);
	vec2 a = vec2(1.0, 0.0);
	return mix(mix(hash(p + a.yy), hash(p + a.xy), f.x), mix(hash(p + a.yx), hash(p + a.xx), f.x), f.y);
}

float fbm(vec2 x) {
	float height = 0.0;
	float amplitude = 0.5;
	float frequency = 3.0;
	for (int i = 0; i < 6; i++){
		height += noise(x * frequency) * amplitude;
		amplitude *= 0.5;
		frequency *= 2.0;
	}
	return height;
}

float height(vec2 uv) {
	return 3.0 * sin(0.5 * uv.y) + 2.0 * noise(uv * 1.5);
}

void vertex() {
	vec2 uv = VERTEX.xz + vec2(0, TIME);
	float h = height(uv);
	VERTEX.y += h;
	COLOR.y = VERTEX.y;
	
	vec2 e = vec2(0.1, 0.0);
	vec3 normal = normalize(vec3(height(uv - e) - height(uv + e), 2.0 * e.x, height(uv - e.yx) - height(uv + e.yx)));
	NORMAL = normal;
}

void fragment() {
	ALBEDO = mix(COLOR_1, COLOR_2, COLOR.y).rgb;
}