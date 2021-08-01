#include "../lib/uh_util.hlsl"

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


    float4 backColor = p.c0_0;
    float outSideRate = p.f1;
    
    float2 uvOffset = float2(p.f2, p.f3);
    float scanNoiseAmp = p.f4;
    float scanNoisePhase = p.f5;
    float scanNoiseFreq = p.c1_r;
    float randomNoiseAmp = p.c1_g;
    float chromaShift = p.c1_b;

    float rgbNoiseProb = p.c1_a;
    
    int horizotalDotSize = p.f0_0;
    int verticalDotSize = p.f0_1;

    float tailDarkness = p.c2_b;
    float scanLineSpeed = p.c2_a;

    int contrast = p.f0_2;
    float vignetteDarkness = p.c3_r;
    float4 foreColor = p.c0_1;
    float4 screenColor = p.c0_2;


    // ベゼルの歪みをUVに反映
    uv -= 0.5;
    float vignette = length(uv);
    uv /= 1 - vignette * outSideRate;
    if (max(abs(uv.y) - 0.5, abs(uv.x) - 0.5) > 0)
    {
        return backColor;
    }

    // スキャン起点のずれを表現
    float2 texUV = uv + 0.5;
    texUV.x += scanNoiseAmp * sin(texUV.y * scanNoiseFreq + scanNoisePhase);
    texUV += uvOffset;
    texUV += randomNoiseAmp * (rand(floor(texUV.y * SEED0) + t) - 0.5);
    texUV = fmod(texUV, 1);
    float4 color = float4(
        tex(texUV - float2(chromaShift * 0, 0)).r,
        tex(texUV - float2(chromaShift * 1, 0)).g,
        tex(texUV - float2(chromaShift * 2, 0)).b,
        1);
    
    // rgbNoiseProbの確率でラインをホワイトノイズに置き換える
    if (rand((rand(floor(texUV.y * SEED1) + t) - 0.5) + t) < rgbNoiseProb)
    {
        color.r = rand(uv + float2(SEED2 + t, SEED3));
        color.g = rand(uv + float2(SEED3 + t, SEED4));
        color.b = rand(uv + float2(SEED4 + t, SEED2));
    }

    // 三色カラーフィルタを表現
    float floorX = fmod((uv.x + 0.5) * p.w, 3 * horizotalDotSize);
    for(int i = 0; i < 3; i++)
    {
        float start = i * horizotalDotSize;
        float end = (i + 1) * horizotalDotSize;
        color[i] *= start < floorX && floorX < end;
    }

    // 横縞
    float scanLineColor = sin(uv.y * p.h / verticalDotSize) / 2 + 0.5;
    color *= 0.5 + clamp(scanLineColor + 0.5, 0, 1) * 0.5;
    
    // 黒いのがパカパカするやつ
    float tail = clamp((frac(uv.y + t * scanLineSpeed) - 0.5) / min(0.5, 1), 0, 1);
    color *= 1 - (1 - tail) * tailDarkness;
    
    // 周囲を暗く
    color *= (1 - vignette) * vignetteDarkness;
    
    // コントラスト補正
    color = shiftContrast(color, contrast);

    return ApplyBasicParamater(pos, float4(color.rgb, tex(texUV).a));
}