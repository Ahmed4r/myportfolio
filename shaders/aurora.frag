#include <flutter/runtime_effect.glsl>

precision mediump float;

uniform vec2 uSize;
uniform vec2 uMouse;
uniform float uTime;

uniform float uSpeed;
uniform float uFrequency;
uniform float uNoise;
uniform float uIntensity;
uniform float uFadeTop;

out vec4 fragColor;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);

    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));

    vec2 u = f * f * (3.0 - 2.0 * f);

    return mix(a, b, u.x) +
           (c - a) * u.y * (1.0 - u.x) +
           (d - b) * u.x * u.y;
}

float fbm(vec2 p) {
    float v = 0.0;
    float a = 0.5;

    for (int i = 0; i < 5; i++) {
        v += a * noise(p);
        p *= 2.0;
        a *= 0.5;
    }
    return v;
}

void main() {
    vec2 uv = FlutterFragCoord().xy / uSize;

    vec2 aspectUV = uv;
    aspectUV.x *= uSize.x / uSize.y;

    vec2 mouseUV = uMouse / uSize;
    mouseUV.x *= uSize.x / uSize.y;

    float d = length(aspectUV - mouseUV);
    float force = smoothstep(0.4, 0.0, d) * uNoise;

    vec2 offset = normalize(aspectUV - mouseUV + 0.001) * force;

    vec2 warpA = vec2(
        fbm(aspectUV * uFrequency + uTime * uSpeed + offset),
        fbm(aspectUV * uFrequency + uTime * uSpeed * 0.5 - offset)
    );

    vec2 warpB = vec2(
        fbm(aspectUV * 2.0 + warpA * 4.0 + uTime * uSpeed),
        fbm(aspectUV * 2.0 + warpA * 4.0 - uTime * uSpeed * 0.5)
    );

    float density = fbm(aspectUV + warpB * 3.5);

    vec3 col = mix(
        vec3(0.02, 0.005, 0.04),
        vec3(0.66, 0.33, 1.0),
        density * uIntensity
    );

    col += vec3(0.12, 0.53, 0.95) * length(warpA);
    col += pow(density, 4.0) * 0.4;

    float vignette = smoothstep(1.0, 1.0 - uFadeTop, uv.y);

    fragColor = vec4(col * vignette, 1.0);
}