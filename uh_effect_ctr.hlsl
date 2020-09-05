#include "util.hlsl"

cbuffer cbuf0
{
  float4x4 colorMat;
  float alpha;
  int useColorKey;
  float colorKeyRange;
  float colorKeyAlpha;
  float4 colorKey;
  float brightness;
  float contrast;
  float gamma;
  float reserved;
  float x;
  float y;
  float width;
  float height;
  float t;
  float timeInEffect;
  float Float0;
  float Float1;
  float Float2;
  float Float3;
  float Float4;
  float Float5;
  float4 Color0;
  float4 Color1;
  float4 Color2;
  float4 Color3;
}

sampler decSampler;
Texture2D<float4> decTexture;

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

    // Param Test
    #if PARAM_DEBUG
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
    
    float width = p.c2_r;
    float height = p.c2_g;
    int horizotalDotSize = p.f0_0;
    int verticalDotSize = p.f0_1;

    float tailDarkness = p.c2_b;
    float scanLineSpeed = p.c2_a;

    int contrast = p.f0_2;
    float vignetteDarkness = p.c3_r;
    float4 foreColor = p.c0_1;
    float4 screenColor = p.c0_2; // black

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
    float4 color;
    color.a = decTexture.Sample(decSampler, texUV).a;
    color.r = decTexture.Sample(decSampler, texUV - float2(chromaShift * 0, 0)).r;
    color.g = decTexture.Sample(decSampler, texUV - float2(chromaShift * 1, 0)).g;
    color.b = decTexture.Sample(decSampler, texUV - float2(chromaShift * 2, 0)).b;
    
    // rgbNoiseProbの確率でラインをホワイトノイズに置き換える
    if (rand((rand(floor(texUV.y * SEED1) + t) - 0.5) + t) < rgbNoiseProb)
    {
        color.r = rand(uv + float2(SEED2 + t, SEED3));
        color.g = rand(uv + float2(SEED3 + t, SEED4));
        color.b = rand(uv + float2(SEED4 + t, SEED2));
    }

    // 三色カラーフィルタを表現
    float floorX = fmod((uv.x + 0.5) * width, 3 * horizotalDotSize);
    for(int i = 0; i < 3; i++)
    {
        float start = i * horizotalDotSize;
        float end = (i + 1) * horizotalDotSize;
        color[i] *= start < floorX && floorX < end;
    }

    // 横縞
    float scanLineColor = sin(uv.y * height / verticalDotSize) / 2 + 0.5;
    color *= 0.5 + clamp(scanLineColor + 0.5, 0, 1) * 0.5;
    
    // 黒いのがパカパカするやつ
    float tail = clamp((frac(uv.y + t * scanLineSpeed) - 0.5) / min(0.5, 1), 0, 1);
    color *= 1 - (1 - tail) * tailDarkness;
    
    // 周囲を暗く
    color *= (1 - vignette) * vignetteDarkness;
    
    // コントラスト補正
    color = 1 / (1 + exp(-contrast * (color - 0.5)));

    return color;
}