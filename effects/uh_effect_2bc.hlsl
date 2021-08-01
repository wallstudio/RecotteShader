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

    int dotSize = p.f0_0;
    int levelCount = p.f0_1;
    int contrast = p.f0_2;

    float4 filterColor0 = p.c0_0;
    float4 filterColor1 = p.c0_1;

    // ピクセレート
    float2 uvScale = float2(p.w, p.h) / float2(dotSize, dotSize);
    uv = floor(uv * uvScale) / uvScale;
    float4 color = tex(uv);
    float a = color.a;
    
    // レベルダウン
    float rate = mono(color).r;
    rate = clamp(rate, 0, 1);
    rate = floor(rate*levelCount) / levelCount;
    color = lerp(filterColor0, filterColor1, rate);
    color = shiftContrast(color, contrast);

    return ApplyBasicParamater(pos, float4(color.rgb, a));
}