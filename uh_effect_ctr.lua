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

    local label = {
        f0_0 = "走査線幅",
        f0_1 = "カラーフィルタ幅",
        f0_2 = "コントラスト補正",
        f1_x100 = "ベゼル",
        f2_x100 = "UVxオフセット",
        f3_x100 = "UVyオフセット",
        f4_x100 = "Sノイズ振幅",
        f5_x100 = "Sノイズ位相",
        c0_rgb_0 = "背景色",
        c0_a_0 = "c0_a_0",
        c0_rgb_1 = "c0_rgb_1",
        c0_a_1 = "c0_a_1",
        c0_rgb_2 = "c0_rgb_2",
        c0_a_2 = "c0_a_2",
        c0_rgb_3 = "c0_rgb_3",
        c0_a_3 = "c0_a_3",
        c1_r_x100 = "Sノイズ周波数",
        c1_g_x100 = "Sノイズランダム",
        c1_b_x100 = "色ずれ",
        c1_a_x100 = "Wノイズランダム",
        c2_r_x100 = "Width",
        c2_g_x100 = "Height",
        c2_b_x100 = "残像暗度",
        c2_a_x100 = "スキャン速度",
        c3_r_x100 = "Vignette暗度",
        c3_g_x100 = "c3_g",
        c3_b_x100 = "c3_b",
        c3_a_x100 = "c3_a",
    };

    SetDuration(0.5);
    AddShaderProperty("ctr_", label);
end


function ApplyEffect(effInfo, param)
    param.shader = SetShaderProperty("ctr_");
    return param;
end
