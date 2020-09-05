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
    label.f0_0 = "コントラスト補正";
    -- label.f0_1 = "f0_1";
    -- label.f0_2 = "f0_2";
    label.f1_x100 = "Pノイズ速度";
    label.f2_x100 = "Pノイズスケール";
    label.f3_x100 = "Pノイズ強度";
    label.f4_x100 = "エッジ強度";
    -- label.f5_x100 = "f5_x100";
    -- label.c0_rgb_0 = "c0_rgb_0";
    -- label.c0_a_0 = "c0_a_0";
    -- label.c0_rgb_1 = "c0_rgb_1";
    -- label.c0_a_1 = "c0_a_1";
    -- label.c0_rgb_2 = "c0_rgb_2";
    -- label.c0_a_2 = "c0_a_2";
    -- label.c0_rgb_3 = "c0_rgb_3";
    -- label.c0_a_3 = "c0_a_3";
    -- label.c1_r_x100 = "c1_r_x100";
    -- label.c1_g_x100 = "c1_g_x100";
    -- label.c1_b_x100 = "c1_b_x100";
    -- label.c1_a_x100 = "c1_a_x100";
    -- label.c2_r_x100 = "c2_r_x100";
    -- label.c2_g_x100 = "c2_g_x100";
    -- label.c2_b_x100 = "c2_b_x100";
    -- label.c2_a_x100 = "c2_a_x100";
    -- label.c3_r_x100 = "c3_r_x100";
    -- label.c3_g_x100 = "c3_g_x100";

    SetDuration(0.5);
    AddShaderProperty("edge_", label);
end


function ApplyEffect(effInfo, param)
    param.shader = SetShaderProperty("edge_", param);
    return param;
end
