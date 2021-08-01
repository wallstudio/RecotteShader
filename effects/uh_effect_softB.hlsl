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


    float bluredBorderPower = p.f1;
    int borderContrast = p.f0_0;
    float mode = p.f0_1;


    float4 color = tex(uv);
    float4 mask = blur(uv, float2(p.w, p.h));
    float _border = bluredBorder(uv, float2(p.w, p.h));
    _border *= bluredBorderPower;
    _border = 1 - _border;
    _border = shiftContrast(WHITE*_border, borderContrast).r;

    if(mode == 1) return _border;
    if(mode == 2) return tex(uv);
    return ApplyBasicParamater(pos, float4(color.rgb, color.a * _border));
}