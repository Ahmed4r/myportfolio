#version 460 core

#include <flutter/runtime_effect.glsl>

// المدخلات القادمة من رماز Dart
uniform vec2 uSize;
uniform vec2 uMouse;
uniform float uTime;

// المخرج النهائي لبكسل الشاشة
out vec4 fragColor;

// دالة توليد القيم العشوائية الناعمة
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

// دالة توليد الضوضاء (Value Noise)
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    
    return mix(mix(hash(i + vec2(0.0, 0.0)), hash(i + vec2(1.0, 0.0)), u.x),
               mix(hash(i + vec2(0.0, 1.0)), hash(i + vec2(1.0, 1.0)), u.x), u.y);
}

// دالة تركيب طبقات الضوضاء (Fractional Brownian Motion)
float fbm(vec2 p) {
    float value = 0.0;
    float amplitude = 0.5;
    float frequency = 1.0;
    for (int i = 0; i < 3; i++) {
        value += amplitude * noise(p * frequency);
        frequency *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

void main() {
    // جلب إحداثيات البكسل الحالي وتوحيدها بين 0 و 1
    vec2 uv = flutter_FragCoord.xy / uSize;
    
    // ضبط النسبة والتناسب لمنع تمطط الشادر على الشاشات العريضة
    vec2 aspectCorrectedUV = uv;
    aspectCorrectedUV.x *= (uSize.x / uSize.y);
    
    vec2 mouseUV = uMouse / uSize;
    mouseUV.x *= (uSize.x / uSize.y);
    
    // حساب التفاعل مع مؤشر الفأرة / اللمس
    float mouseDistance = length(aspectCorrectedUV - mouseUV);
    float mouseForce = smoothstep(0.4, 0.0, mouseDistance) * 0.25;
    vec2 mouseOffset = normalize((aspectCorrectedUV - mouseUV) + vec2(0.001)) * mouseForce;
    
    // بناء موجات الشفق المتداخلة (Domain Warping)
    vec2 param1 = (aspectCorrectedUV * 1.5) + vec2(uTime * 0.15, uTime * 0.08) + mouseOffset;
    vec2 param2 = (aspectCorrectedUV * 1.5) + vec2(uTime * 0.05, uTime * 0.12) - mouseOffset;
    vec2 warpA = vec2(fbm(param1), fbm(param2));
    
    vec2 param3 = (aspectCorrectedUV * 2.0) + (warpA * 4.0) + vec2(uTime * 0.1);
    vec2 param4 = (aspectCorrectedUV * 2.0) + (warpA * 4.0) + vec2(uTime * -0.05);
    vec2 warpB = vec2(fbm(param3), fbm(param4));
    
    vec2 param5 = (aspectCorrectedUV * 1.2) + (warpB * 3.5);
    float fluidDensity = fbm(param5);
    
    // التدرج اللوني للشفق القطبي
    vec3 spaceBg = vec3(0.02, 0.005, 0.04);       // البنفسجي الداكن (الفضاء)
    vec3 coreAurora = vec3(0.66, 0.33, 1.0);     // الأرجواني الساطع
    vec3 accentGlow = vec3(0.12, 0.53, 0.95);    // الأزرق المضيء
    
    // مزج الألوان بناءً على الكثافة وحركة الأمواج
    vec3 mixedColor = mix(spaceBg, coreAurora, clamp(fluidDensity * 1.8, 0.0, 1.0));
    mixedColor = mix(mixedColor, accentGlow, clamp(length(warpA) * 0.6, 0.0, 1.0));
    
    // إضافة إضاءة بيضاء ساطعة في قلب الموجات الأكثر كثافة
    mixedColor += (vec3(0.9, 0.8, 1.0) * pow(fluidDensity, 4.0)) * 0.35;
    
    // تطبيق تأثير العتمة الطرفية (Vignette) في الأسفل لدمج الخلفية السينمائية
    float canvasVignette = smoothstep(1.0, 0.25, uv.y);
    vec3 finalOutput = mixedColor * canvasVignette;
    
    // تلوين البكسل
    fragColor = vec4(finalOutput, 1.0);
}