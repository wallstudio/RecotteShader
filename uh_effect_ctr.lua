require "effects/lib"


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
            ps = "../uh_effect_ctr.cso"
        }
    };
    return info;
end


function InitEffect()
    local label = createLabelTemplate();
    label.f0_0 = "走査線幅";
    label.f0_1 = "カラーフィルタ幅";
    label.f0_2 = "コントラスト補正";
    label.f1_x100 = "ベゼル";
    label.f2_x100 = "UVxオフセット";
    label.f3_x100 = "UVyオフセット";
    label.f4_x100 = "Sノイズ振幅";
    label.f5_x100 = "Sノイズ位相";
    label.c0_rgb_0 = "背景色";
    -- label.c0_a_0 = "c0_a_0";
    -- label.c0_rgb_1 = "c0_rgb_1";
    -- label.c0_a_1 = "c0_a_1";
    -- label.c0_rgb_2 = "c0_rgb_2";
    -- label.c0_a_2 = "c0_a_2";
    -- label.c0_rgb_3 = "c0_rgb_3";
    -- label.c0_a_3 = "c0_a_3";
    label.c1_r_x100 = "Sノイズ周波数";
    label.c1_g_x100 = "Sノイズランダム";
    label.c1_b_x100 = "色ずれ";
    label.c1_a_x100 = "Wノイズランダム";
    -- label.c2_r_x100 = "c2_r_x100";
    -- label.c2_g_x100 = "c2_g_x100";
    label.c2_b_x100 = "残像暗度";
    label.c2_a_x100 = "スキャン速度";
    label.c3_r_x100 = "Vignette暗度";
    -- c3_g_x100 = "c3_g_x100";

    SetDuration(0.5);
    AddShaderProperty("ctr_", label);
end


function ApplyEffect(effInfo, param)
    param.shader = SetShaderProperty("ctr_", param);
    return param;
end
