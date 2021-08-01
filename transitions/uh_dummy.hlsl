#include "../recotte_shader_effect_lib/uh_util.hlsl"

float4 main( 
   float4 pos : SV_POSITION,
   float2 uv : UV,
   float2 uvp : UVP
   ) : SV_TARGET
{
    return float4(1, 0, 0, 1);
}