require "effects/lib"

function GetInfo()

    local info = {
        name = "uh_effect_exp3D",
        displayname = {
            en = "uh_effect_exp3D",
            ja = "UH_3Dパラメータ拡張"
        },
        tag = "effect",
        -- AF_Scale | AF_Angle | AF_Color | AF_Bounds | AF_Scale| AF_Shader | AF_UV
        affects = AF_Scale | AF_Angle | AF_Color | AF_Bounds | AF_Scale,
        thumbnail = nil
    }
    return info
end


function InitEffect()
    SetDuration(0.5);
    -- AddProperty(NewProperty("exp3D_", { ja="", en="exp3D_"}, "float", nil, 0));
    AddProperty(NewProperty("exp3D_angle", { ja="角度", en="exp3D_angle"}, "int", nil, 0));
    -- AddProperty(NewProperty("exp3D_crop", { ja="", en="exp3D_crop"}, "rect", "crop_rate", Rect(0,0,50,50)));
    AddProperty(NewProperty("exp3D_brightness", { ja="明るさ", en="exp3D_brightness"}, "int", nil, 0));
    AddProperty(NewProperty("exp3D_contrast", { ja="コントラスト", en="exp3D_contrast"}, "int", nil, 0));
    AddProperty(NewProperty("exp3D_gamma", { ja="ガンマ", en="exp3D_gamma"}, "float", nil, 1.14));
    AddProperty(NewProperty("exp3D_color", {ja="乗算カラー", en="exp3D_color"}, "color", nil, RGBA256(255, 255, 255, 255)));
end

function ApplyEffect(effInfo, param)
    param.angle = GetProperty("exp3D_angle");
    -- param.bounds = GetProperty("exp3D_crop");
    -- local rect = param.bounds;
	-- param.uv.x = param.uv.x + param.uv.w *(rect.x / 100);
	-- param.uv.y = param.uv.y + param.uv.h *(rect.y / 100);
	-- param.uv.w = param.uv.w * rect.w / 100;
	-- param.uv.h = param.uv.h * rect.h / 100;
    param.brightness = GetProperty("exp3D_brightness");
    param.contrast = GetProperty("exp3D_contrast");
    param.gamma = GetProperty("exp3D_gamma");
    param.gamma = GetProperty("exp3D_color");
    local c = GetProperty("exp3D_color");
    param.cm = param.cm * MAT44.Scale(c.r, c.g, c.b);
    return param
end