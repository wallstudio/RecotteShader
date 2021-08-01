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


    float3 baseColor = p.c0_0.rgb;
    float3 rimColor = p.c0_1.rgb;
    float rimPower = p.f1;


    float4 color = tex(uv);
    color.rgb *= baseColor;

    float4 _border = bluredBorder(uv, float2(p.w, p.h));
    _border.rgb *= rimColor.rgb;
    _border.rgb = 1 - pow(1-_border, rimPower);
    color = screen(color, _border);

    return ApplyBasicParamater(pos, color);
}