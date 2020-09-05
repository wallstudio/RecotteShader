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


L_f0_0 = "走査線幅";
L_f0_1 = "カラーフィルタ幅";
L_f0_2 = "コントラスト補正";
L_f1_x100 = "ベゼル";
L_f2_x100 = "UVxオフセット";
L_f3_x100 = "UVyオフセット";
L_f4_x100 = "Sノイズ振幅";
L_f5_x100 = "Sノイズ位相";
L_c0_rgb_0 = "背景色";
L_c0_a_0 = "c0_a_0";
L_c0_rgb_1 = "c0_rgb_1";
L_c0_a_1 = "c0_a_1";
L_c0_rgb_2 = "c0_rgb_2";
L_c0_a_2 = "c0_a_2";
L_c0_rgb_3 = "c0_rgb_3";
L_c0_a_3 = "c0_a_3";
L_c1_r_x100 = "Sノイズ周波数";
L_c1_g_x100 = "Sノイズランダム";
L_c1_b_x100 = "色ずれ";
L_c1_a_x100 = "Wノイズランダム";
L_c2_r_x100 = "Width";
L_c2_g_x100 = "Height";
L_c2_b_x100 = "残像暗度";
L_c2_a_x100 = "スキャン速度";
L_c3_r_x100 = "Vignette暗度";
L_c3_g_x100 = "c3_g";
L_c3_b_x100 = "c3_b";
L_c3_a_x100 = "c3_a";


function InitEffect()
    SetDuration(0.5);
    AddShaderProperty();
end


function ApplyEffect(effInfo, param)
    param.shader = SetShaderProperty();
    return param;
end
