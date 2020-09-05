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

    float4 color = decTexture.Sample(decSampler, uv);
    color = float4((1-color).rgb, 1);
    return color;
}