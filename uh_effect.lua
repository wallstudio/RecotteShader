function dumpFile(arg)
    -- file::writeするとなぜかそこでLuaの処理が失敗するため、cmd経由で回避
    local path = "C:\\Users\\huser\\Desktop\\RecotteShader\\log.yml";
    local msg = tostring(arg);
    msg = string.gsub(msg, "[\\<\\>\\^\\]", "^%0")
    local cmd = '"echo ' .. msg .. '" >> ' .. path;
    os.execute('cmd /c ' .. cmd .. '');
end

function dumpTable(obj, tab, depth)
    local str = "";

    for i = 0, tab do
        str = str .. "  ";
    end

    if tab < depth and type(obj) == "table" then
        for key, value in pairs(obj) do
            dumpFile(str .. tostring(key) .. ":");
            dumpTable(value, tab + 1, depth);
        end
    elseif type(obj) == "number" then
        dumpFile(str .. string.format("%f", obj));
    else
        dumpFile(str .. tostring(obj));
    end

    return str;
end

-- HACK:
-- AF_Shaderにすると、VideoObjectにアタッチできなくなる。
-- これはTransitionにすることで回避できるが、
-- Transitionはパラメータを露出させることができない。
-- その為、こちらでShaderの設定をし、TransitionでGetShaderして描画するようにしている。
function GetInfo()

    local info = {
        name = "mod",
        displayname = {
            en = "mod",
            ja = "もっど"
        },
        tag = "video",
        -- affects = AF_Shader, 
        shader = {
            ps = "../uh_effect.cso"
        }
    }
    return info
end

INT_BITS = 7;
INT_USE_BITS = INT_BITS;
COLOR_BITS = 5;
COLOR_USE_BITS = COLOR_BITS;
COLOR_MAX = (1 << COLOR_BITS) - 1;

function InitEffect()
    SetDuration(0.5)
    
    -- 1本のfloatに3値(7bit)詰め込む
    AddProperty(NewProperty("f0_0", { ja="f0_0(0-127)", en="f0_0(0-127)"}, "int", nil, 0));
    AddProperty(NewProperty("f0_1", { ja="f0_1(0-127)", en="f0_1(0-127)"}, "int", nil, 0));
    AddProperty(NewProperty("f0_2", { ja="f0_2(0-127)", en="f0_2(0-127)"}, "int", nil, 0));

    -- 普通に5本float
    AddProperty(NewProperty("f1_x100", { ja="f1(x100)", en="f1(x100)"}, "float", nil, 0));
    AddProperty(NewProperty("f2_x100", { ja="f2(x100)", en="f2(x100)"}, "float", nil, 0));
    AddProperty(NewProperty("f3_x100", { ja="f3(x100)", en="f3(x100)"}, "float", nil, 0));
    AddProperty(NewProperty("f4_x100", { ja="f4(x100)", en="f4(x100)"}, "float", nil, 0));
    AddProperty(NewProperty("f5_x100", { ja="f5(x100)", en="f5(x100)"}, "float", nil, 0));

    -- 1本のColorに4色(5555bit)詰め込む
    AddProperty(NewProperty("c0_rgb_0", { ja="c0_rgb_0", en="c0_rgb_0"}, "color", nil, RGB(1,1,1)));
    AddProperty(NewProperty("c0_a_0", { ja="c0_a_0(0-"..COLOR_MAX..")", en="c0_a_0(0-"..COLOR_MAX..")"}, "int", nil, COLOR_MAX));
    AddProperty(NewProperty("c0_rgb_1", { ja="c0_rgb_1", en="c0_rgb_1"}, "color", nil, RGB(1,1,1)));
    AddProperty(NewProperty("c0_a_1", { ja="c0_a_1(0-"..COLOR_MAX..")", en="c0_a_1(0-"..COLOR_MAX..")"}, "int", nil, COLOR_MAX));
    AddProperty(NewProperty("c0_rgb_2", { ja="c0_rgb_2", en="c0_rgb_2"}, "color", nil, RGB(1,1,1)));
    AddProperty(NewProperty("c0_a_2", { ja="c0_a_2(0-"..COLOR_MAX..")", en="c0_a_2(0-"..COLOR_MAX..")"}, "int", nil, COLOR_MAX));
    AddProperty(NewProperty("c0_rgb_3", { ja="c0_rgb_3", en="c0_rgb_3"}, "color", nil, RGB(1,1,1)));
    AddProperty(NewProperty("c0_a_3", { ja="c0_a_3(0-"..COLOR_MAX..")", en="c0_a_3(0-"..COLOR_MAX..")"}, "int", nil, COLOR_MAX));

    -- のこり3本のColorは、12本のfloatにSplit
    AddProperty(NewProperty("c1_r_x100", { ja="c1_r(x100)", en="c1_r(x100)"}, "float", nil, 0));
    AddProperty(NewProperty("c1_g_x100", { ja="c1_g(x100)", en="c1_g(x100)"}, "float", nil, 0));
    AddProperty(NewProperty("c1_b_x100", { ja="c1_b(x100)", en="c1_b(x100)"}, "float", nil, 0));
    AddProperty(NewProperty("c1_a_x100", { ja="c1_a(x100)", en="c1_a(x100)"}, "float", nil, 0));
    AddProperty(NewProperty("c2_r_x100", { ja="c2_r(x100)", en="c2_r(x100)"}, "float", nil, 0));
    AddProperty(NewProperty("c2_g_x100", { ja="c2_g(x100)", en="c2_g(x100)"}, "float", nil, 0));
    AddProperty(NewProperty("c2_b_x100", { ja="c2_b(x100)", en="c2_b(x100)"}, "float", nil, 0));
    AddProperty(NewProperty("c2_a_x100", { ja="c2_a(x100)", en="c2_a(x100)"}, "float", nil, 0));
    AddProperty(NewProperty("c3_r_x100", { ja="c3_r(x100)", en="c3_r(x100)"}, "float", nil, 0));
    AddProperty(NewProperty("c3_g_x100", { ja="c3_g(x100)", en="c3_g(x100)"}, "float", nil, 0));
    AddProperty(NewProperty("c3_b_x100", { ja="c3_b(x100)", en="c3_b(x100)"}, "float", nil, 0));
    AddProperty(NewProperty("c3_a_x100", { ja="c3_a(x100)", en="c3_a(x100)"}, "float", nil, 0));
end

function clamp(value, min, max)
    if value < min then
        return min;
    elseif value > max - 1 then
        return max - 1;
    else
        return value;
    end
end

function floatToInt(value, bits)
    local integer = math.floor(value * (1 << bits));
    return clamp(integer, 0, 1 << bits);
end

function ApplyEffect(effInfo, param)
    local f0_0 = GetProperty("f0_0");
    local f0_1 = GetProperty("f0_1");
    local f0_2 = GetProperty("f0_2");
    local f1 = GetProperty("f1_x100") / 100;
    local f2 = GetProperty("f2_x100") / 100;
    local f3 = GetProperty("f3_x100") / 100;
    local f4 = GetProperty("f4_x100") / 100;
    local f5 = GetProperty("f5_x100") / 100;
    local c0_rgb_0 = GetProperty("c0_rgb_0");
    local c0_a_0 = GetProperty("c0_a_0");
    local c0_rgb_1 = GetProperty("c0_rgb_1");
    local c0_a_1 = GetProperty("c0_a_1");
    local c0_rgb_2 = GetProperty("c0_rgb_2");
    local c0_a_2 = GetProperty("c0_a_2");
    local c0_rgb_3 = GetProperty("c0_rgb_3");
    local c0_a_3 = GetProperty("c0_a_3");
    local c1_r = GetProperty("c1_r_x100") / 100;
    local c1_g = GetProperty("c1_g_x100") / 100;
    local c1_b = GetProperty("c1_b_x100") / 100;
    local c1_a = GetProperty("c1_a_x100") / 100;
    local c2_r = GetProperty("c2_r_x100") / 100;
    local c2_g = GetProperty("c2_g_x100") / 100;
    local c2_b = GetProperty("c2_b_x100") / 100;
    local c2_a = GetProperty("c2_a_x100") / 100;
    local c3_r = GetProperty("c3_r_x100") / 100;
    local c3_g = GetProperty("c3_g_x100") / 100;
    local c3_b = GetProperty("c3_b_x100") / 100;
    local c3_a = GetProperty("c3_a_x100") / 100;

    local f0 = 
        (clamp(f0_0, 0, 1 << INT_BITS) << INT_USE_BITS*0) +
        (clamp(f0_1, 0, 1 << INT_BITS) << INT_USE_BITS*1) +
        (clamp(f0_2, 0, 1 << INT_BITS) << INT_USE_BITS*2);
    local c0_r = 
        (floatToInt(c0_rgb_0.r, COLOR_BITS) << (COLOR_USE_BITS*0)) +
        (floatToInt(c0_rgb_1.r, COLOR_BITS) << (COLOR_USE_BITS*1)) +
        (floatToInt(c0_rgb_2.r, COLOR_BITS) << (COLOR_USE_BITS*2)) +
        (floatToInt(c0_rgb_3.r, COLOR_BITS) << (COLOR_USE_BITS*3));
    local c0_g = 
        (floatToInt(c0_rgb_0.g, COLOR_BITS) << (COLOR_USE_BITS*0)) +
        (floatToInt(c0_rgb_1.g, COLOR_BITS) << (COLOR_USE_BITS*1)) +
        (floatToInt(c0_rgb_2.g, COLOR_BITS) << (COLOR_USE_BITS*2)) +
        (floatToInt(c0_rgb_3.g, COLOR_BITS) << (COLOR_USE_BITS*3));
    local c0_b = 
        (floatToInt(c0_rgb_0.b, COLOR_BITS) << (COLOR_USE_BITS*0)) +
        (floatToInt(c0_rgb_1.b, COLOR_BITS) << (COLOR_USE_BITS*1)) +
        (floatToInt(c0_rgb_2.b, COLOR_BITS) << (COLOR_USE_BITS*2)) +
        (floatToInt(c0_rgb_3.b, COLOR_BITS) << (COLOR_USE_BITS*3));
    local c0_a = 
        (clamp(c0_a_0, 0, 1 << COLOR_BITS) << (COLOR_USE_BITS*0)) +
        (clamp(c0_a_1, 0, 1 << COLOR_BITS) << (COLOR_USE_BITS*1)) +
        (clamp(c0_a_2, 0, 1 << COLOR_BITS) << (COLOR_USE_BITS*2)) +
        (clamp(c0_a_2, 0, 1 << COLOR_BITS) << (COLOR_USE_BITS*3));
    local c0 = { r = c0_r, g = c0_g, b = c0_b, a = c0_a };
    local c1 = { r = c1_r, g = c1_g, b = c1_b, a = c1_a };
    local c2 = { r = c2_r, g = c2_g, b = c2_b, a = c2_a };
    local c3 = { r = c3_r, g = c3_g, b = c3_b, a = c3_a };

    local shader = GetShader("ps");
    SetShaderFloat(shader, 0, f0);
    SetShaderFloat(shader, 1, f1);
    SetShaderFloat(shader, 2, f2);
    SetShaderFloat(shader, 3, f3);
    SetShaderFloat(shader, 4, f4);
    SetShaderFloat(shader, 5, f5);
    SetShaderColor(shader, 0, c0);
    SetShaderColor(shader, 1, c1);
    SetShaderColor(shader, 2, c2);
    SetShaderColor(shader, 3, c3);
    param.shader = shader;

    -- dumpTable( f1 , 1, 10);

    return param;
end