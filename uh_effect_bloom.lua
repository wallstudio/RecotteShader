require "effects/lib"


-- HACK:
-- AF_Shaderにすると、VideoObjectにアタッチできなくなる。
-- これはTransitionにすることで回避できるが、
-- Transitionはパラメータを露出させることができない。
-- その為、こちらでShaderの設定をし、TransitionでGetShaderして描画するようにしている。
function GetInfo()
    local info = {
        name = "uh_effect_bloom",
        displayname = {
            en = "uh_effect_bloom",
            ja = "UH_ブルーム"
        },
        tag = "video",
        -- affects = AF_Shader, 
        shader = {
            ps = "../uh_effect_bloom.cso"
        }
    };
    return info;
end


function InitEffect()
    local label = createLabelTemplate();
    label.f0_0 = {n="Bloomコントラスト0", v=4};
    label.f0_1 = {n="Bloomコントラスト1", v=9};
    -- label.f0_2 = {n="f0_2", v=0};
    label.f1_x100 = {n="閾値", v=0};
    label.f2_x100 = {n="強度", v=280};
    -- label.f3_x100 = {n="f3_x100", v=0};
    -- label.f4_x100 = {n="f4_x100", v=0};
    -- label.f5_x100 = {n="f5_x100", v=0};
    label.c0_rgb_0 = {n="Bloom色", v=RGBA(150,147,30,255)};
    -- label.c0_a_0 = {n="c0_a_0", v=COLOR_MAX};
    -- label.c0_rgb_1 = {n="c0_rgb_1", v=RGB(1,1,1)};
    -- label.c0_a_1 = {n="c0_a_1", v=COLOR_MAX};
    -- label.c0_rgb_2 = {n="c0_rgb_2", v=RGB(1,1,1)};
    -- label.c0_a_2 = {n="c0_a_2", v=COLOR_MAX};
    -- label.c0_rgb_3 = {n="c0_rgb_3", v=RGB(1,1,1)};
    -- label.c0_a_3 = {n="c0_a_3", v=COLOR_MAX};
    -- label.c1_r_x100 = {n="c1_r_x100", v=0};
    -- label.c1_g_x100 = {n="c1_g_x100", v=0};
    -- label.c1_b_x100 = {n="c1_b_x100", v=0};
    -- label.c1_a_x100 = {n="c1_a_x100", v=0};
    -- label.c2_r_x100 = {n="c2_r_x100", v=0};
    -- label.c2_g_x100 = {n="c2_g_x100", v=0};
    -- label.c2_b_x100 = {n="c2_b_x100", v=0};
    -- label.c2_a_x100 = {n="c2_a_x100", v=0};
    -- label.c3_r_x100 = {n="c3_r_x100", v=0};
    -- label.c3_g_x100 = {n="c3_g_x100", v=0};

    SetDuration(0.5);
    AddShaderProperty("bloom_", label);
end


function ApplyEffect(effInfo, param)
    param.shader = SetShaderProperty("bloom_", param);
    return param;
end
