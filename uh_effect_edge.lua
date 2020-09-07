require "effects/lib"


-- HACK:
-- AF_Shaderにすると、VideoObjectにアタッチできなくなる。
-- これはTransitionにすることで回避できるが、
-- Transitionはパラメータを露出させることができない。
-- その為、こちらでShaderの設定をし、TransitionでGetShaderして描画するようにしている。
function GetInfo()
    local info = {
        name = "uh_effect_edge",
        displayname = {
            en = "uh_effect_edge",
            ja = "UH_手書き"
        },
        tag = "video",
        -- affects = AF_Shader, 
        shader = {
            ps = "../uh_effect_edge.cso"
        }
    };
    return info;
end


function InitEffect()
    local label = createLabelTemplate();
    label.f0_0 = {n="コントラスト補正", v=4};
    -- label.f0_1 = {n="f0_1", v=0};
    -- label.f0_2 = {n="f0_2", v=0};
    label.f1_x100 = {n="Pノイズ速度", v=1000};
    label.f2_x100 = {n="Pノイズスケール", v=1000};
    label.f3_x100 = {n="Pノイズ強度", v=50};
    label.f4_x100 = {n="エッジ強度", v=200};
    -- label.f5_x100 = {n="f5_x100", v=0};
    label.c0_rgb_0 = {n="スクリーン合成色", v=RGB256(60,59,56)};
    -- label.c0_rgb_1 = {n="c0_rgb_1", v=RGB256(255,255,255)};
    -- label.c0_rgb_2 = {n="c0_rgb_2", v=RGB256(255,255,255)};
    -- label.c0_rgb_3 = {n="c0_rgb_3", v=RGB256(255,255,255)};
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
    AddShaderProperty("edge_", label);
end


function ApplyEffect(effInfo, param)
    param.shader = SetShaderProperty("edge_", param);
    return param;
end
