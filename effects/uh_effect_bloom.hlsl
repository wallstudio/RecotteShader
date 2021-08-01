#include "../recotte_shader_effect_lib/uh_util.hlsl"

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


    float threadshold = p.f1;
    float power = p.f2;
    int bloomContrast0 = p.f0_0;
    int bloomContrast1 = p.f0_1;
    float4 bloomColor = p.c0_0;


    float4 color = tex(uv);
    float a = color.a;
    float4 bloom = blur(uv, float2(p.w, p.h));
    bloom *= bloomColor;
    bloom = shiftContrast(bloom, bloomContrast0);
    bloom = nega(pow(abs(nega(bloom)), power));
    bloom = shiftContrast(bloom, bloomContrast1);
    
    if(mono(bloom).r > threadshold)
    {
        color = screen(color, bloom);
    }
    return ApplyBasicParamater(pos, float4(color.rgb, a));
}