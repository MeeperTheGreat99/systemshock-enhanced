#version 110

// The texture alpha value has two separate functions in this shader:
// - Pixels with a zero alpha value are transparent.
// - Pixels with non-zero alpha are opaque, and the alpha value
//   defines a minimum light level.

#define CLASSIC_LIGHT_STEP 5.0
#define CLASSIC_LIGHT_STEP_INV 1.0 / CLASSIC_LIGHT_STEP

varying vec2 TexCoords;
varying float Light;

uniform sampler2D tex;
uniform bool nightsight;
uniform bool mutant;

float light_step(float light, float step, float step_inv, float magnitude) {
	return floor(light * step * magnitude) * step_inv / magnitude;
}

vec4 desaturate(vec3 color, float factor) {
	vec3 lum = vec3(0.299, 0.587, 0.114);
	vec3 gray = vec3(dot(lum, color));
	return vec4(mix(color, gray, factor), 1.0);
}

// makes the lighting have more of a software renderer look
float sw_light(float baselight, float emissive) {
	// x - baselight, y - addlight, z - smoothlight
	vec3 lightvals = vec3(
		pow(min(1.0, baselight + emissive + 0.1), 2.0),
		0.0, 0.0
	);
	lightvals.y = (1.0 - lightvals.x) * 1.5;
	lightvals.z = lightvals.x * (1.0 + lightvals.y);
	
	float light = lightvals.z;
	return light;
}

void main() {
    vec4 t = texture2D(tex, TexCoords);

    // Alpha values > 0.5 are emissive
    float alpha = t.a > 0.5 ? 1.0 : t.a * 2.0;

    if (nightsight) {
        // approximate the blue tint of palette colors 0xb0..0xbf
        float gray = 0.40 * t.r + 0.59 * t.g + 0.11 * t.b;
        float rg = 0.7 * gray;
        float b = 0.75 * gray + 0.1;
        gl_FragColor = vec4(rg, rg, b, (mutant ? 0.2 * alpha : alpha));
    } else {
        float emissive = t.a > 0.5 ? (t.a - 0.5) * 2.0 : 0.0;
		float light = sw_light(Light, emissive);
		
        if (mutant)
            gl_FragColor = vec4(0.5 * t.r * light, 0.5 * t.r * light, 0.5 * t.r * light, 0.2 * alpha);
        else
			//gl_FragColor = vec4(light * 0.3, light * 0.3, light * 0.3, alpha);
            gl_FragColor = vec4(t.r * light, t.g * light, t.b * light, alpha);
    }
	
}
