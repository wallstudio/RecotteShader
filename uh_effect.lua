require "effects/lib"


-- HACK:
-- AF_Shaderにすると、VideoObjectにアタッチできなくなる。
-- これはTransitionにすることで回避できるが、
-- Transitionはパラメータを露出させることができない。
-- その為、こちらでShaderの設定をし、TransitionでGetShaderして描画するようにしている。
function GetInfo()
    local info = {
        name = "uh_effect_",
        displayname = {
            en = "uh_effect_",
            ja = "UH_もっど"
        },
        tag = "video",
        -- affects = AF_Shader, 
        shader = {
            ps = "../uh_effect.cso"
        }
    };
    return info;
end


function InitEffect()

    local label = {
        f0_0 = "f0_0",
        f0_1 = "f0_1",
        f0_2 = "f0_2",
        f1_x100 = "f1_x100",
        f2_x100 = "f2_x100",
        f3_x100 = "f3_x100",
        f4_x100 = "f4_x100",
        f5_x100 = "f5_x100",
        c0_rgb_0 = "c0_rgb_0",
        c0_a_0 = "c0_a_0",
        c0_rgb_1 = "c0_rgb_1",
        c0_a_1 = "c0_a_1",
        c0_rgb_2 = "c0_rgb_2",
        c0_a_2 = "c0_a_2",
        c0_rgb_3 = "c0_rgb_3",
        c0_a_3 = "c0_a_3",
        c1_r_x100 = "c1_r_x100",
        c1_g_x100 = "c1_g_x100",
        c1_b_x100 = "c1_b_x100",
        c1_a_x100 = "c1_a_x100",
        c2_r_x100 = "c2_r_x100",
        c2_g_x100 = "c2_g_x100",
        c2_b_x100 = "c2_b_x100",
        c2_a_x100 = "c2_a_x100",
        c3_r_x100 = "c3_r_x100",
        c3_g_x100 = "c3_g_x100",
        c3_b_x100 = "c3_b_x100",
        c3_a_x100 = "c3_a_x100",
    };

    SetDuration(0.5);
    AddShaderProperty(" ", label);
end


function ApplyEffect(effInfo, param)
    param.shader = SetShaderProperty(" ");
    return param;
end
