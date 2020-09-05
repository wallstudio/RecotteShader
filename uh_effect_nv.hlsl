#include "util.hlsl"

#define PARAM_DEBUG 1

float4 main( 
   float4 pos : SV_POSITION, // 正規化されてない
   float2 uv : UV,
   float2 uvp : UVP
   ) : SV_TARGET
{
    UnpackedParams p = unpack(
        Float0, Float1, Float2, Float3, Float4, Float5,
        Color0, Color1, Color2, Color3);

    #if PARAM_DEBUG
    float4 dump = dumpParam(p, pos.xy);
    if(dump.a > 0) return dump;
    #endif

    float chromaPower = p.f2;
    float4 filterColor = p.c0_0;
    int contrast = p.f0_0;

    float vignetteDarkness = p.f1;
    int vignetteContrast = p.f0_1;

    float noiseSpeed = p.c1_r;
    float perlinScale = p.c1_g;
    float noisePower = p.c1_b;
    int noiseContrast = p.f0_2;

    uv -= 0.5;
    float vignette = length(uv);

    float2 texUV = uv + 0.5;
    float4 color = tex(texUV);
    float4 hsv = rgb2Hsv(color);
    hsv.y *= chromaPower;
    color = hsv2Rgb(hsv);

    color *= filterColor;
    color = shiftContrast(color, contrast);
    
    float noise = 1 - noisePower * perlinNoise(uv, float2(p.w, p.h), t*noiseSpeed, perlinScale);
    color *= shiftContrast(noise, noiseContrast);

    // 周囲を暗く
    float vignetteDark = (1 - vignette) * vignetteDarkness;
    color *= shiftContrast(vignetteDark, vignetteContrast);

    return color;
}