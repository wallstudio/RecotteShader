#define SEED0 457.427
#define SEED1 117.7278
#define SEED2 743.2872
#define SEED3 174.78
#define SEED4 943.677

#define WHITE (float4(1, 1, 1, 1))
#define BLACK (float4(0, 0, 0, 1))
#define ONE4 (float4(1, 1, 1, 1))
#define ONE3 (float3(1, 1, 1))
#define ONE2 (float2(1, 1))
#define ZERO4 (float4(0, 0, 0, 0))
#define ZERO3 (float3(0, 0, 0))
#define ZERO2 (float2(0, 0)
#define T transpose

#define INT_BITS (7)
#define INT_USE_BITS (INT_BITS)
#define COLOR_BITS (5)
#define COLOR_USE_BITS (COLOR_BITS)

sampler decSampler;
Texture2D<float4> decTexture;

cbuffer cbuf0
{
    float4x4 colorMat;
    float alpha;
    int useColorKey, colorKeyRange, colorKeyAlpha;
    float4 colorKey;
    float brightness, contrast, gamma;
    float reserved;
    float x, y, width, height;
    float t, timeInEffect;
    float Float0, Float1, Float2, Float3, Float4, Float5;
    float4 Color0, Color1, Color2, Color3;
}

struct UnpackedParams
{
    uint f0_0, f0_1, f0_2;
    float f1, f2, f3, f4, f5;
    float4 c0_0, c0_1, c0_2, c0_3;
    float c1_r, c1_g, c1_b, c1_a;
    float c2_r, c2_g, c2_b, c2_a;
    float c3_r, c3_g, c3_b, c3_a;
    float w, h;
};

UnpackedParams unpack(
    float _Float0,
    float _Float1,
    float _Float2,
    float _Float3,
    float _Float4,
    float _Float5,
    float4 _Color0,
    float4 _Color1,
    float4 _Color2,
    float4 _Color3)
{
    UnpackedParams o;
    o.f0_0 = (uint(_Float0) >> (INT_USE_BITS*0)) & ((1<<INT_BITS) - 1);
    o.f0_1 = (uint(_Float0) >> (INT_USE_BITS*1)) & ((1<<INT_BITS) - 1);
    o.f0_2 = (uint(_Float0) >> (INT_USE_BITS*2)) & ((1<<INT_BITS) - 1);
    o.f1 = _Float1;
    o.f2 = _Float2;
    o.f3 = _Float3;
    o.f4 = _Float4;
    o.f5 = _Float5;
    o.c0_0 = ((uint4(_Color0) >> (COLOR_USE_BITS*0)) & ((1<<COLOR_BITS) - 1)) / float(1<<COLOR_BITS);
    o.c0_1 = ((uint4(_Color0) >> (COLOR_USE_BITS*1)) & ((1<<COLOR_BITS) - 1)) / float(1<<COLOR_BITS);
    o.c0_2 = ((uint4(_Color0) >> (COLOR_USE_BITS*2)) & ((1<<COLOR_BITS) - 1)) / float(1<<COLOR_BITS);
    o.c0_3 = ((uint4(_Color0) >> (COLOR_USE_BITS*3)) & ((1<<COLOR_BITS) - 1)) / float(1<<COLOR_BITS);
    o.c1_r = _Color1.r;
    o.c1_g = _Color1.g;
    o.c1_b = _Color1.b;
    o.c1_a = _Color1.a;
    o.c2_r = _Color2.r;
    o.c2_g = _Color2.g;
    o.c2_b = _Color2.b;
    o.c2_a = _Color2.a;
    o.c3_r = _Color3.r;
    o.c3_g = _Color3.g;
    o.c3_b = _Color3.b;
    o.c3_a = _Color3.a;
    o.w = o.c3_b;
    o.h = o.c3_a;
    return o;
}

float4 shiftContrast(float4 color, int contrast);
float4 shiftGamma(float4 color, float gamma);
float4 screen(float4 color, float4 screenColor);
float4 ApplyBasicParamater(float2 pos, float4 fragColor)
{
    fragColor = clamp(fragColor, 0, 1);
    if(useColorKey)
    {
        float4 key = colorKeyAlpha ? colorKey : float4(colorKey.rgb, fragColor.a);
        float4 keyMin = clamp((key*256 - colorKeyRange/2) * 256, 0, 1);
        float4 keyMax = clamp((key*256 + colorKeyRange/2) * 256, 0, 1);
        if(keyMin.r <= fragColor.r && fragColor.r <= keyMax.r
            && keyMin.g <= fragColor.g && fragColor.g <= keyMax.g
            && keyMin.b <= fragColor.b && fragColor.b <= keyMax.b
            && keyMin.a <= fragColor.a && fragColor.a <= keyMax.a)
        {
            return ZERO4;
        }
    }
    fragColor = mul(fragColor, colorMat);
    fragColor.a *= alpha;
    fragColor = screen(fragColor, ONE4*brightness);
    // fragColor = shiftContrast(fragColor, contrast); // 標準のShaderと計算方法が違うっぽくて再現できないのでとりあえず無視
    fragColor = shiftGamma(fragColor, 1);
    return fragColor;
}


float4 tex(float2 uv)
{
    return decTexture.Sample(decSampler, uv);
}

float4 lerp4(float4 x, float4 y, float rate)
{
    float r = lerp(x.r, y.r, rate);
    float g = lerp(x.g, y.g, rate);
    float b = lerp(x.b, y.b, rate);
    float a = lerp(x.a, y.a, rate);
    return float4(r, g, b, a);
}

float rand(float2 co)
{
    return frac(sin(dot(co, float2(12.9898, 78.233))) * 43758.5453);
}

float rand3(float3 co)
{
    return frac(sin(dot(co, float3(12.9898, 78.233, 5415.41))) * 43758.5453);
}

float scaleNoise(float2 uv, float2 size, float seed, float stepSize)
{
    float3 pos = float3(uv*size/stepSize, seed);
    float3 rate = frac(pos);
    float3 base = floor(pos);
    float v000 = rand3(base + float3(0, 0, 0));
    float v001 = rand3(base + float3(0, 0, 1));
    float v010 = rand3(base + float3(0, 1, 0));
    float v011 = rand3(base + float3(0, 1, 1));
    float v100 = rand3(base + float3(1, 0, 0));
    float v101 = rand3(base + float3(1, 0, 1));
    float v110 = rand3(base + float3(1, 1, 0));
    float v111 = rand3(base + float3(1, 1, 1));
    float v00 = lerp(v000, v100, rate.x);
    float v01 = lerp(v001, v101, rate.x);
    float v10 = lerp(v010, v110, rate.x);
    float v11 = lerp(v011, v111, rate.x);
    float v0 = lerp(v00, v10, rate.y);
    float v1 = lerp(v01, v11, rate.y);
    float v = lerp(v0, v1, rate.z);
    return v;
}

float perlinNoise(float2 uv, float2 size, float seed, float stepScale)
{
    uint iterate = 6;
    float sum = 0;
    for(uint i = 0; i < iterate; i++)
    {
        sum += scaleNoise(uv, size, seed, (1 << i) * stepScale);
    }
    return sum / iterate;
}

float4 shiftContrast(float4 color, int contrast)
{
    float4 shifted = 1 / (1 + exp(-contrast * (color - 0.5)));
    float4 clamped = clamp(shifted, 0, 1);
    return float4(clamped.rgb, color.a);
}

float4 shiftGamma(float4 color, float gamma)
{
    float4 shifted = pow(color, 1/gamma);
    float4 clamped = clamp(shifted, 0, 1);
    return float4(clamped.rgb, color.a);
}

float2 mod(float2 a, float2 b)
{
    return a - floor(a / b) * b;
}

float4 mono(float4 color)
{
    float gray = 0.2126*color.r + 0.7152*color.g + 0.0722*color.b;
    return float4(gray, gray, gray, color.a);
}

float4 nega(float4 color)
{
    return float4((1 - color).rgb, color.a);
}

float4 screen(float4 color, float4 screenColor)
{
    float4 mix = nega(nega(color) * nega(screenColor));
    return float4(mix.rgb, color.a);
}


#define _SOBEL(dst, uv, size, monochromizer) \
[unroll(1)] do \
{ \
    float2 uvParPx = 1 / size; \
    float horizotal = 0; \
    horizotal += -1 * monochromizer(tex(uv - uvParPx * float2(-1, -1))); \
    horizotal += -2 * monochromizer(tex(uv - uvParPx * float2(-1, +0))); \
    horizotal += -1 * monochromizer(tex(uv - uvParPx * float2(-1, +1))); \
    horizotal += +1 * monochromizer(tex(uv - uvParPx * float2(+1, -1))); \
    horizotal += +2 * monochromizer(tex(uv - uvParPx * float2(+1, +0))); \
    horizotal += +1 * monochromizer(tex(uv - uvParPx * float2(+1, +1))); \
    float vertical = 0; \
    vertical += -1 * monochromizer(tex(uv - uvParPx * float2(-1, -1))); \
    vertical += -2 * monochromizer(tex(uv - uvParPx * float2(+0, -1))); \
    vertical += -1 * monochromizer(tex(uv - uvParPx * float2(+1, -1))); \
    vertical += +1 * monochromizer(tex(uv - uvParPx * float2(-1, +1))); \
    vertical += +2 * monochromizer(tex(uv - uvParPx * float2(+0, +1))); \
    vertical += +1 * monochromizer(tex(uv - uvParPx * float2(+1, +1))); \
    float ave = (abs(horizotal) + abs(vertical)) / 2; \
    dst = float4(ave, ave, ave, tex(uv).a); \
} \
while(0);


float _monochromizer_sobel(float4 color) { return mono(color).r; }
float4 sobel(float2 uv, float2 size)
{
    float4 dst;
    _SOBEL(dst, uv, size, _monochromizer_sobel);
    return dst;
}


float _monochromizer_alpha(float4 color) { return color.a; }
float border(float2 uv, float2 size)
{
    float4 dst;
    _SOBEL(dst, uv, size, _monochromizer_alpha);
    return dst.r;
}

#define _BLUR(dst, uv, size, pxSampler) \
[unroll(1)] do \
{ \
    uint kernel = 7; \
    int hKernel = kernel/2; \
    float weights[] = { 1, 6, 15, 20, 15, 6, 1 }; \
    float2 uvParUnit = 1 / size * 4; \
    float4 sum = ZERO4; \
    float weightSum = 0; \
    [unroll(kernel)] for(int i = -hKernel; i <= hKernel; i++) \
    [unroll(kernel)] for(int j = -hKernel; j <= hKernel; j++) \
    { \
        float weight = weights[i+hKernel] * weights[j+hKernel]; \
        weightSum += weight; \
        sum += weight * pxSampler(uv + uvParUnit * float2(i, j), size); \
    } \
    return sum / weightSum; \
} \
while(0); \


float4 _pxSampler_blur(float2 uv, float2 _) { return tex(uv); }
float4 blur(float2 uv, float2 size)
{
    float4 dst;
    _BLUR(dst, uv, size, _pxSampler_blur);
    return dst;
}


float4 _pxSampler_bluredBorder(float2 uv, float2 size) { return border(uv, size); }
float4 bluredBorder(float2 uv, float2 size)
{
    float4 dst;
    _BLUR(dst, uv, size, _pxSampler_bluredBorder);
    return dst;
}


float4 rgb2Yuv(float4 color)
{
    float4x4 m = float4x4(
        +0.299, +0.587, +0.114, 0,
        -0.147, -0.289, +0.436, 0,
        +0.615, -0.515, +0.100, 0,
        +0.000, +0.000, +0.000, 1);
    return (mul(m, (color)));
}


float4 yuv2RGB256(float4 color)
{
    float4x4 m = float4x4(
        +1.000, +0.000, +1.140, 0,
        +1.000, -0.395, -0.581, 0,
        +1.000, +2.032, +0.000, 0,
        +0.000, +0.000, +0.000, 1);
    return (mul(m, (color)));
}

float4 rgb2Hsv(float4 color)
{
    float4 hsv = BLACK;

    float maxValue = max(color.r, max(color.g, color.b));
    float minValue = min(color.r, min(color.g, color.b));
    float delta = maxValue - minValue;
    
    hsv.z = maxValue;
    
    if (maxValue != 0.0)
    {
        hsv.y = delta / maxValue;
    } else 
    {
        hsv.y = 0.0;
    }
    
    if (hsv.y > 0.0)
    {
        if (color.r == maxValue) 
        {
            hsv.x = (color.g - color.b) / delta;
        }
        else if (color.g == maxValue) 
        {
            hsv.x = 2 + (color.b - color.r) / delta;
        }
        else 
        {
            hsv.x = 4 + (color.r - color.g) / delta;
        }
        hsv.x /= 6.0;
        if (hsv.x < 0)
        {
            hsv.x += 1.0;
        }
    }
    
    return hsv;
}

// HSV->RGB変換
float4 hsv2RGB256(float4 color)
{
    float4 rgb = BLACK;

    if (color.y == 0)
    {
        rgb.r = rgb.g = rgb.b = color.z;
    } else {
        color.x *= 6.0;
        float i = floor (color.x);
        float f = color.x - i;
        float aa = color.z * (1 - color.y);
        float bb = color.z * (1 - (color.y * f));
        float cc = color.z * (1 - (color.y * (1 - f)));
        if( i < 1 ) {
            rgb.r = color.z;
            rgb.g = cc;
            rgb.b = aa;
        } else if( i < 2 ) {
            rgb.r = bb;
            rgb.g = color.z;
            rgb.b = aa;
        } else if( i < 3 ) {
            rgb.r = aa;
            rgb.g = color.z;
            rgb.b = cc;
        } else if( i < 4 ) {
            rgb.r = aa;
            rgb.g = bb;
            rgb.b = color.z;
        } else if( i < 5 ) {
            rgb.r = cc;
            rgb.g = aa;
            rgb.b = color.z;
        } else {
            rgb.r = color.z;
            rgb.g = aa;
            rgb.b = bb;
        }
    }
    return rgb;
}


float4 dumpParam(UnpackedParams p, float2 pos)
{
    if(pos.x < 50 && pos.y < 100) return float4(p.f0_0, p.f0_0, p.f0_0, 1<<INT_BITS) / (1<<INT_BITS);
    if(pos.x < 50 && pos.y < 125) return float4(p.f0_1, p.f0_1, p.f0_1, 1<<INT_BITS) / (1<<INT_BITS);
    if(pos.x < 50 && pos.y < 150) return float4(p.f0_2, p.f0_2, p.f0_2, 1<<INT_BITS) / (1<<INT_BITS);
    if(pos.x < 100 && pos.y < 100) return float4(p.f1, p.f1, p.f1, 1);
    if(pos.x < 100 && pos.y < 125) return float4(p.f2, p.f2, p.f2, 1);
    if(pos.x < 100 && pos.y < 150) return float4(p.f3, p.f3, p.f3, 1);
    if(pos.x < 100 && pos.y < 175) return float4(p.f4, p.f4, p.f4, 1);
    if(pos.x < 100 && pos.y < 200) return float4(p.f5, p.f5, p.f5, 1);
    if(pos.x < 150 && pos.y < 100) return p.c0_0;
    if(pos.x < 150 && pos.y < 125) return p.c0_1;
    if(pos.x < 150 && pos.y < 150) return p.c0_2;
    if(pos.x < 150 && pos.y < 175) return p.c0_3;
    if(pos.x < 200 && pos.y < 100) return float4(p.c1_r, p.c1_r, p.c1_r, 1);
    if(pos.x < 200 && pos.y < 100) return float4(p.c1_g, p.c1_g, p.c1_g, 1);
    if(pos.x < 200 && pos.y < 100) return float4(p.c1_b, p.c1_b, p.c1_b, 1);
    if(pos.x < 200 && pos.y < 100) return float4(p.c1_a, p.c1_a, p.c1_a, 1);
    if(pos.x < 250 && pos.y < 100) return float4(p.c2_r, p.c2_r, p.c2_r, 1);
    if(pos.x < 250 && pos.y < 100) return float4(p.c2_g, p.c2_g, p.c2_g, 1);
    if(pos.x < 250 && pos.y < 100) return float4(p.c2_b, p.c2_b, p.c2_b, 1);
    if(pos.x < 250 && pos.y < 100) return float4(p.c2_a, p.c2_a, p.c2_a, 1);
    if(pos.x < 300 && pos.y < 100) return float4(p.c3_r, p.c3_r, p.c3_r, 1);
    if(pos.x < 300 && pos.y < 100) return float4(p.c3_g, p.c3_g, p.c3_g, 1);
    if(pos.x < 300 && pos.y < 100) return float4(p.c3_b, p.c3_b, p.c3_b, 1);
    if(pos.x < 300 && pos.y < 100) return float4(p.c3_a, p.c3_a, p.c3_a, 1);
    if(pos.x < 350 && pos.y < 300) return float4(0.1, 0.1, 0.1, 1);
    return float4(0, 0, 0, 0);
}