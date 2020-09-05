float rand(float2 co)
{
  return frac(sin(dot(co.xy, float2(12.9898, 78.233))) * 43758.5453);
}

float2 mod(float2 a, float2 b)
{
  return a - floor(a / b) * b;
}

#define INT_BITS (7)
#define INT_USE_BITS (INT_BITS)
#define COLOR_BITS (5)
#define COLOR_USE_BITS (COLOR_BITS)

struct UnpackedParams
{
    uint f0_0, f0_1, f0_2;
    float f1, f2, f3, f4, f5;
    float4 c0_0, c0_1, c0_2, c0_3;
    float c0_a_0, c0_a_1, c0_a_2, c0_a_3;
    float c1_r, c1_g, c1_b, c1_a;
    float c2_r, c2_g, c2_b, c2_a;
    float c3_r, c3_g, c3_b, c3_a;
};

UnpackedParams unpack(
    float _Float0,
    float _Float1,
    float _Float2,
    float _Float3,
    float _Float4,
    float _Float5,
    float4 _Color0,
    float4 _Color1,
    float4 _Color2,
    float4 _Color3)
{
    UnpackedParams o;
    o.f0_0 = (uint(_Float0) >> (INT_USE_BITS*0)) & ((1<<INT_BITS) - 1);
    o.f0_1 = (uint(_Float0) >> (INT_USE_BITS*1)) & ((1<<INT_BITS) - 1);
    o.f0_2 = (uint(_Float0) >> (INT_USE_BITS*2)) & ((1<<INT_BITS) - 1);
    o.f1 = _Float1;
    o.f2 = _Float2;
    o.f3 = _Float3;
    o.f4 = _Float4;
    o.f5 = _Float5;
    o.c0_0 = ((uint4(_Color0) >> (COLOR_USE_BITS*0)) & ((1<<COLOR_BITS) - 1)) / float(1<<COLOR_BITS);
    o.c0_1 = ((uint4(_Color0) >> (COLOR_USE_BITS*1)) & ((1<<COLOR_BITS) - 1)) / float(1<<COLOR_BITS);
    o.c0_2 = ((uint4(_Color0) >> (COLOR_USE_BITS*2)) & ((1<<COLOR_BITS) - 1)) / float(1<<COLOR_BITS);
    o.c0_3 = ((uint4(_Color0) >> (COLOR_USE_BITS*3)) & ((1<<COLOR_BITS) - 1)) / float(1<<COLOR_BITS);
    o.c0_a_0 = o.c0_0.a;
    o.c0_a_1 = o.c0_1.a;
    o.c0_a_2 = o.c0_2.a;
    o.c0_a_3 = o.c0_3.a;
    o.c1_r = _Color1.r;
    o.c1_g = _Color1.g;
    o.c1_b = _Color1.b;
    o.c1_a = _Color1.a;
    o.c2_r = _Color2.r;
    o.c2_g = _Color2.g;
    o.c2_b = _Color2.b;
    o.c2_a = _Color2.a;
    o.c3_r = _Color3.r;
    o.c3_g = _Color3.g;
    o.c3_b = _Color3.b;
    o.c3_a = _Color3.a;
    return o;
}

#define SEED0 457
#define SEED1 117
#define SEED2 743
#define SEED3 174
#define SEED4 943