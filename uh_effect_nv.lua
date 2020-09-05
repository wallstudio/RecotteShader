require "effects/lib"


-- HACK:
-- AF_Shaderにすると、VideoObjectにアタッチできなくなる。
-- これはTransitionにすることで回避できるが、
-- Transitionはパラメータを露出させることができない。
-- その為、こちらでShaderの設定をし、TransitionでGetShaderして描画するようにしている。
function GetInfo()
    local info = {
        name = "uh_effect_nv",
        displayname = {
            en = "uh_effect_nv",
            ja = "UH_ナイトビジョン"
        },
        tag = "video",
        -- affects = AF_Shader, 
        shader = {
            ps = "../uh_effect_nv.cso"
        }
    };
    return info;
end


function InitEffect()
    local label = createLabelTemplate();
    label.f0_0 = {n="基本コントラスト", v=16};
    label.f0_1 = {n="Vifnette明瞭度", v=49};
    label.f0_2 = {n="ノイズ明瞭度", v=19};
    label.f1_x100 = {n="Vifnette暗度", v=95};
    label.f2_x100 = {n="彩度", v=241};
    -- label.f3_x100 = {n="f3_x100", v=0};
    -- label.f4_x100 = {n="f4_x100", v=0};
    -- label.f5_x100 = {n="f5_x100", v=0};
    label.c0_rgb_0 = {n="フィルタ色", v=RGBA(133,198,119,255)};
    -- label.c0_a_0 = {n="c0_a_0", v=COLOR_MAX};
    -- label.c0_rgb_1 = {n="c0_rgb_1", v=RGB(1,1,1)};
    -- label.c0_a_1 = {n="c0_a_1", v=COLOR_MAX};
    -- label.c0_rgb_2 = {n="c0_rgb_2", v=RGB(1,1,1)};
    -- label.c0_a_2 = {n="c0_a_2", v=COLOR_MAX};
    -- label.c0_rgb_3 = {n="c0_rgb_3", v=RGB(1,1,1)};
    -- label.c0_a_3 = {n="c0_a_3", v=COLOR_MAX};
    label.c1_r_x100 = {n="Pノイズ速度", v=10000};
    label.c1_g_x100 = {n="Pノイズスケール", v=1000};
    label.c1_b_x100 = {n="Pノイズ強度", v=67};
    -- label.c1_a_x100 = {n="c1_a_x100", v=0};
    -- label.c2_r_x100 = {n="c2_r_x100", v=0};
    -- label.c2_g_x100 = {n="c2_g_x100", v=0};
    -- label.c2_b_x100 = {n="c2_b_x100", v=0};
    -- label.c2_a_x100 = {n="c2_a_x100", v=0};
    -- label.c3_r_x100 = {n="c3_r_x100", v=0};
    -- label.c3_g_x100 = {n="c3_g_x100", v=0};

    SetDuration(0.5);
    AddShaderProperty("nv_", label);
end


function ApplyEffect(effInfo, param)
    param.shader = SetShaderProperty("nv_", param);
    return param;
end
