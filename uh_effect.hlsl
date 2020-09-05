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
    return float4(pos.xy / 1000, 1, 1);
    if(pos.y < 200 && pos.x < 50) return float4(p.f0_0, p.f0_1, p.f0_2, 1<<INT_BITS) / (1<<INT_BITS);
    if(pos.y < 200 && pos.x < 100) return float4(p.f1, p.f2, p.f3, 1);
    if(pos.y < 200 && pos.x < 150) return float4(p.f4, p.f5, Float1, 1);
    if(pos.y < 200 && pos.x < 200) return p.c0_0;
    if(pos.y < 200 && pos.x < 250) return p.c0_1;
    if(pos.y < 200 && pos.x < 300) return p.c0_2;
    if(pos.y < 200 && pos.x < 350) return p.c0_3;
    if(pos.y < 200 && pos.x < 400) return float4(p.c1_r, p.c1_g, p.c1_b, p.c1_a);
    if(pos.y < 200 && pos.x < 450) return float4(p.c2_r, p.c2_g, p.c2_b, p.c2_a);
    if(pos.y < 200 && pos.x < 500) return float4(p.c3_r, p.c3_g, p.c3_b, p.c3_a);

    float4 backColor = unpackColor(Color0, 0); // black
    float4 foreColor = unpackColor(Color0, 1); // white
    float4 screenColor = unpackColor(Color1, 0); // black
    float4 _0 = unpackColor(Color1, 1); //
    float2 uvOffset = Color2.xy; // (0, 0)
    float2 _1 = Color2.zw; // 
    float4 bounds = Color3; // (x, y, w, h)
    float scanNoiseAmp = Float0;
    float scanNoisePhase = Float1;
    float scanNoiseFreq = Float2;
    float randomNoiseAmp = Float3;
    float rgbNoiseProb = Float4;
    float chromaShift = Float5;

    float outSideRate = 0.2;
    float tailDarkness = 0.3;
    float vignetteDarkness = 1.3;

    float horizotalDotSize = 3;
    float verticalDotSize = 3;
    float scanLineSpeed = 75;
    float contrast = 8;

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
    texUV.x += sin(texUV.y + scanNoiseFreq + scanNoisePhase) * scanNoiseAmp;
    texUV += uvOffset;
    texUV += (rand(floor(texUV.y * SEED0) + t) - 0.5) * randomNoiseAmp;
    texUV = mod(texUV, 1);
    float4 color;
    color.a = decTexture.Sample(decSampler, texUV).a;
    color.r = decTexture.Sample(decSampler, texUV - float2(chromaShift * 0, 0)).r;
    color.g = decTexture.Sample(decSampler, texUV - float2(chromaShift * 1, 0)).g;
    color.b = decTexture.Sample(decSampler, texUV - float2(chromaShift * 2, 0)).b;
    
    // // rgbNoiseProbの確率でラインをホワイトノイズに置き換える
    // if (rand((rand(floor(texUV.y * SEED1) + t) - 0.5) + t) < rgbNoiseProb)
    // {
    //     color.r = rand(uv + float2(SEED2 + t, SEED3));
    //     color.g = rand(uv + float2(SEED3 + t, SEED4));
    //     color.b = rand(uv + float2(SEED4 + t, SEED2));
    // }

    // // 三色カラーフィルタを表現
    // float floorX = fmod((uv.x + 0.5) * bounds.z, 3 * horizotalDotSize);
    // for(int i = 0; i < 3; i++)
    // {
    //     float start = i * horizotalDotSize;
    //     float end = (i + 1) * horizotalDotSize;
    //     color[i] *= start < floorX && floorX < end;
    // }

    // // 横縞
    // float scanLineColor = sin(uv.y * bounds.w / verticalDotSize) / 2 + 0.5;
    // color *= 0.5 + clamp(scanLineColor + 0.5, 0, 1) * 0.5;
    
    // // 黒いのがパカパカするやつ
    // float tail = clamp((frac(uv.y + t * scanLineSpeed) - 0.5) / min(0.5, 1), 0, 1);
    // color *= 1 - (1 - tail) * tailDarkness;
    
    // // 周囲を暗く
    // color *= (1 - vignette) * vignetteDarkness;
    
    // // コントラスト補正
    // color = 1 / (1 + exp(-contrast * (color - 0.5)));

    return color * Color0;
}