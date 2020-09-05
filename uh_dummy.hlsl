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
   float4 pos : SV_POSITION,
   float2 uv : UV,
   float2 uvp : UVP
   ) : SV_TARGET
{
    return float4(1, 0, 0, 1);
}