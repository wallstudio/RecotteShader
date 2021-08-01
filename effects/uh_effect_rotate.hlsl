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

    float rotateZ = p.f1 * 100 / 360 * (2 * 3.14);

    float2x2 rotMat = float2x2(cos(rotateZ), -sin(rotateZ), sin(rotateZ), cos(rotateZ));
    
    uv = uv - 0.5;
    uv = uv / float2(height, width);
    uv = mul(rotMat, uv);
    uv = uv * float2(height, width);
    uv = uv + 0.5;

    float4 color = tex(uv);
    return ApplyBasicParamater(pos, color);
}