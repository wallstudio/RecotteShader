#include "util.hlsl"

#define PARAM_DEBUG 0

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


    float noiseSpeed = p.f1;
    float perlinScale = p.f2;
    float noisePower = p.f3;

    float edgePower = p.f4;

    int contrast = p.f0_0;
    float4 screenColor = p.c0_0;

    float4 blurColor = blur(uv, float2(p.w, p.h));

    float noise = 1 - noisePower * perlinNoise(uv, float2(p.w, p.h), t*noiseSpeed, perlinScale);

    float4 edge = sobel(uv, float2(p.w, p.h));
    edge = nega(edge);
    edge = 1 - edgePower * (1-edge);
    
    float4 color = float4((blurColor * edge * noise).rgb, blurColor.a);
    color = shiftContrast(color, contrast);
    color = screen(color, screenColor);
    return float4(color.rgb, tex(uv).a);
}