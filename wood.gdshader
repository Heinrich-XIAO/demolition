// 2D texture shader (CanvasItem) - copy into a ShaderMaterial
shader_type canvas_item;

// --- Texture and color ---
uniform sampler2D tex;            // main texture (set in material)
uniform vec4 tint_color : source_color = vec4(1.0,1.0,1.0,1.0);

// --- UV transform ---
uniform vec2 uv_scale = vec2(1.0, 1.0);
uniform vec2 uv_offset = vec2(0.0, 0.0);
uniform float rotation = 0.0;    // radians
uniform float time_speed = 0.0;  // UV panning speed multiplier (adds to x component)

// --- Image adjustments ---
uniform float contrast = 1.0;    // 0..inf (1 = none)
uniform float grayscale = 0.0;   // 0..1 (0 = color, 1 = full grayscale)
uniform float hue_degrees = 0.0; // hue shift in degrees
uniform float alpha_cutoff = 0.0; // if alpha < cutoff, discard (use 0 for no cutoff)


vec3 rgb2hsv(vec3 c) {
    vec4 K = vec4(0.0, -1.0/3.0, 2.0/3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));
    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv2rgb(vec3 c) {
    vec3 p = abs(fract(c.x + vec3(0.0, 2.0/3.0, 1.0/3.0)) * 6.0 - 3.0);
    return c.z * mix(vec3(1.0), clamp(p - 1.0, 0.0, 1.0), c.y);
}

void fragment() {
    // Transform UV around the center (0.5, 0.5)
    vec2 uv = UV;
    vec2 center = vec2(0.5, 0.5);
    uv -= center;

    // rotation matrix
    float s = sin(rotation);
    float c = cos(rotation);
    mat2 rot = mat2(vec2(c, s), vec2(-s, c));

    uv = rot * uv;                    // rotate
    uv *= uv_scale;                   // scale
    uv += center + uv_offset;         // move back + offset
    uv += vec2(TIME * time_speed, 0.0); // time-based panning along X

    // sample texture (fall back to TEXTURE or SCREEN_TEXTURE if needed)
    vec4 color = texture(tex, uv);

    // apply tint (multiply)
    color *= tint_color;

    // contrast (simple linear contrast)
    color.rgb = ((color.rgb - 0.5) * contrast) + 0.5;

    // grayscale mix
    float lum = dot(color.rgb, vec3(0.299, 0.587, 0.114));
    color.rgb = mix(color.rgb, vec3(lum), clamp(grayscale, 0.0, 1.0));

    // hue shift: convert to HSV, rotate hue, convert back
    if (abs(hue_degrees) > 0.001) {
        vec3 hsv = rgb2hsv(color.rgb);
        hsv.x = fract(hsv.x + hue_degrees / 360.0);
        color.rgb = hsv2rgb(hsv);
    }

    // alpha cutoff
    if (color.a <= alpha_cutoff) {
        discard;
    }

    // final
    COLOR = color;
}
