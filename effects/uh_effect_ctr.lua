require "recotte_shader_effect_lib/uh_util"


-- HACK:
-- AF_Shaderにすると、VideoObjectにアタッチできなくなる。
-- これはTransitionにすることで回避できるが、
-- Transitionはパラメータを露出させることができない。
-- その為、こちらでShaderの設定をし、TransitionでGetShaderして描画するようにしている。
function GetInfo()
    local info = {
        name = "uh_effect_ctr",
        displayname = {
            en = "uh_effect_ctr",
            ja = "UH_ブラウン管"
        },
        tag = "video",
        -- affects = AF_Shader, 
        shader = {
            ps = "uh_effect_ctr.cso"
        }
    };
    return info;
end


function InitEffect()
    local label = createLabelTemplate();
    label.f0_0 = {n="走査線幅", v=5};
    label.f0_1 = {n="カラーフィルタ幅", v=2};
    label.f0_2 = {n="コントラスト補正", v=10};
    label.f1_x100 = {n="ベゼル", v=21};
    label.f2_x100 = {n="UVxオフセット", v=2};
    label.f3_x100 = {n="UVyオフセット", v=2};
    label.f4_x100 = {n="Sノイズ振幅", v=2};
    label.f5_x100 = {n="Sノイズ位相", v=0};
    label.c0_rgb_0 = {n="背景色", v=RGBA256(0,0,0,0)};
    -- label.c0_rgb_1 = {n="c0_rgb_1", v=RGB256(255,255,255)};
    -- label.c0_rgb_2 = {n="c0_rgb_2", v=RGB256(255,255,255)};
    -- label.c0_rgb_3 = {n="c0_rgb_3", v=RGB256(255,255,255)};
    label.c1_r_x100 = {n="Sノイズ周波数", v=500};
    label.c1_g_x100 = {n="Sノイズランダム", v=0.2};
    label.c1_b_x100 = {n="色ずれ", v=0.3};
    label.c1_a_x100 = {n="Wノイズランダム", v=0.5};
    -- label.c2_r_x100 = {n="c2_r_x100", v=0};
    -- label.c2_g_x100 = {n="c2_g_x100", v=0};
    label.c2_b_x100 = {n="残像暗度", v=19};
    label.c2_a_x100 = {n="スキャン速度", v=2000};
    label.c3_r_x100 = {n="Vignette暗度", v=138};
    -- label.c3_g_x100 = {n="c3_g_x100", v=0};

    SetDuration(0.5);
    AddShaderProperty("ctr_", label);
end


function ApplyEffect(effInfo, param)
    param.shader = SetShaderProperty("ctr_", param);
    return param;
end
