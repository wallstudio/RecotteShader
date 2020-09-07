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
    local label = createLabelTemplate();
    -- label.f0_0 = {n="f0_0", v=0};
    -- label.f0_1 = {n="f0_1", v=0};
    -- label.f0_2 = {n="f0_2", v=0};
    -- label.f1_x100 = {n="f1_x100", v=0};
    -- label.f2_x100 = {n="f2_x100", v=0};
    -- label.f3_x100 = {n="f3_x100", v=0};
    -- label.f4_x100 = {n="f4_x100", v=0};
    -- label.f5_x100 = {n="f5_x100", v=0};
    -- label.c0_rgb_0 = {n="c0_rgb_0", v=RGB256(255,255,255)};
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
    AddShaderProperty(" ", label);
end


function ApplyEffect(effInfo, param)
    param.shader = SetShaderProperty(" ", param);
    return param;
end
