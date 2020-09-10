function writeLineToFile(arg)
    -- file::writeするとなぜかそこでLuaの処理が失敗するため、cmd経由で回避
    local path = "C:\\Users\\huser\\Documents\\Project\\RecotteShader\\log.yml";
    local msg = tostring(arg);
    msg = string.gsub(msg, "[\\<\\>\\^\\]", "^%0")
    local cmd = '"echo ' .. msg .. '" >> ' .. path;
    os.execute('cmd /c ' .. cmd .. '');
end


function indexOf(array, item)
    for i=1, #array do
        if array[i] == item then
            return i;
        end
    end
    return -1;
end


function dumpObj(obj)
    local founds = {};
    writeLineToFile("# START DUMP");
    dumpObjImpl(obj, 0, founds);
end


function dumpObjImpl(obj, depth, founds)

    local str = "";
    for i=0, depth do
        str = str .. "  ";
    end
    
    
    if type(obj) == "table" then
        if indexOf(founds, obj) > 0 then
            writeLineToFile(str .. tostring(obj) .. " (recursive)");
        else
            founds[#founds + 1] = obj;
            for k, v in pairs(obj) do
                writeLineToFile(str .. tostring(k) .. ":");
                dumpObjImpl(v, depth + 1, founds);
            end
        end
    elseif type(obj) == "number" then
        writeLineToFile(str .. string.format("%f", obj));
    else
        writeLineToFile(str .. tostring(obj));
    end
    return str;
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


function RGB256(r, g, b) return RGBA256(r, g, b, 255) end
function RGBA256(r, g, b, a)
    local rgba = {
        r = clamp(r, 0, 256) / 255,
        g = clamp(g, 0, 256) / 255,
        b = clamp(b, 0, 256) / 255,
        a = clamp(a, 0, 256) / 255,
    };
    return rgba;
end


function floatToInt(value, bits)
    local integer = math.floor(value * (1 << bits));
    return clamp(integer, 0, 1 << bits);
end


INT_BITS = 7;
INT_USE_BITS = INT_BITS;
COLOR_BITS = 5;
COLOR_USE_BITS = COLOR_BITS;
COLOR_MAX = (1 << COLOR_BITS) - 1;


function createLabelTemplate()
    local label = {
        f0_0 = {n="f0_0", v=0},
        f0_1 = {n="f0_1", v=0},
        f0_2 = {n="f0_2", v=0},
        f1_x100 = {n="f1_x100", v=0},
        f2_x100 = {n="f2_x100", v=0},
        f3_x100 = {n="f3_x100", v=0},
        f4_x100 = {n="f4_x100", v=0},
        f5_x100 = {n="f5_x100", v=0},
        c0_rgb_0 = {n="c0_rgb_0", v=RGB256(255,255,255)},
        c0_rgb_1 = {n="c0_rgb_1", v=RGB256(255,255,255)},
        c0_rgb_2 = {n="c0_rgb_2", v=RGB256(255,255,255)},
        c0_rgb_3 = {n="c0_rgb_3", v=RGB256(255,255,255)},
        c1_r_x100 = {n="c1_r_x100", v=0},
        c1_g_x100 = {n="c1_g_x100", v=0},
        c1_b_x100 = {n="c1_b_x100", v=0},
        c1_a_x100 = {n="c1_a_x100", v=0},
        c2_r_x100 = {n="c2_r_x100", v=0},
        c2_g_x100 = {n="c2_g_x100", v=0},
        c2_b_x100 = {n="c2_b_x100", v=0},
        c2_a_x100 = {n="c2_a_x100", v=0},
        c3_r_x100 = {n="c3_r_x100", v=0},
        c3_g_x100 = {n="c3_g_x100", v=0},
    };
    return label;
end


function AddShaderProperty(prefix, l)
    -- 1本のfloatに3値(7bit)詰め込む
    AddProperty(NewProperty(prefix.."f0_0", {ja=l.f0_0.n.."(0-127)", en="f0_0(0-127)"}, "int", nil, l.f0_0.v));
    AddProperty(NewProperty(prefix.."f0_1", {ja=l.f0_1.n.."(0-127)", en="f0_1(0-127)"}, "int", nil, l.f0_1.v));
    AddProperty(NewProperty(prefix.."f0_2", {ja=l.f0_2.n.."(0-127)", en="f0_2(0-127)"}, "int", nil, l.f0_2.v));

    -- 普通に5本float
    AddProperty(NewProperty(prefix.."f1_x100", {ja=l.f1_x100.n.."(x100)", en="f1(x100)"}, "float", nil, l.f1_x100.v));
    AddProperty(NewProperty(prefix.."f2_x100", {ja=l.f2_x100.n.."(x100)", en="f2(x100)"}, "float", nil, l.f2_x100.v));
    AddProperty(NewProperty(prefix.."f3_x100", {ja=l.f3_x100.n.."(x100)", en="f3(x100)"}, "float", nil, l.f3_x100.v));
    AddProperty(NewProperty(prefix.."f4_x100", {ja=l.f4_x100.n.."(x100)", en="f4(x100)"}, "float", nil, l.f4_x100.v));
    AddProperty(NewProperty(prefix.."f5_x100", {ja=l.f5_x100.n.."(x100)", en="f5(x100)"}, "float", nil, l.f5_x100.v));

    -- 1本のColorに4色(5555bit)詰め込む
    AddProperty(NewProperty(prefix.."c0_rgb_0", {ja=l.c0_rgb_0.n, en="c0_rgb_0"}, "color", nil, l.c0_rgb_0.v));
    AddProperty(NewProperty(prefix.."c0_rgb_1", {ja=l.c0_rgb_1.n, en="c0_rgb_1"}, "color", nil, l.c0_rgb_1.v));
    AddProperty(NewProperty(prefix.."c0_rgb_2", {ja=l.c0_rgb_2.n, en="c0_rgb_2"}, "color", nil, l.c0_rgb_2.v));
    AddProperty(NewProperty(prefix.."c0_rgb_3", {ja=l.c0_rgb_3.n, en="c0_rgb_3"}, "color", nil, l.c0_rgb_3.v));

    -- のこり3本のColorは、12本のfloatにSplit
    AddProperty(NewProperty(prefix.."c1_r_x100", {ja=l.c1_r_x100.n.."(x100)", en="c1_r(x100)"}, "float", nil, l.c1_r_x100.v));
    AddProperty(NewProperty(prefix.."c1_g_x100", {ja=l.c1_g_x100.n.."(x100)", en="c1_g(x100)"}, "float", nil, l.c1_g_x100.v));
    AddProperty(NewProperty(prefix.."c1_b_x100", {ja=l.c1_b_x100.n.."(x100)", en="c1_b(x100)"}, "float", nil, l.c1_b_x100.v));
    AddProperty(NewProperty(prefix.."c1_a_x100", {ja=l.c1_a_x100.n.."(x100)", en="c1_a(x100)"}, "float", nil, l.c1_a_x100.v));
    AddProperty(NewProperty(prefix.."c2_r_x100", {ja=l.c2_r_x100.n.."(x100)", en="c2_r(x100)"}, "float", nil, l.c2_r_x100.v));
    AddProperty(NewProperty(prefix.."c2_g_x100", {ja=l.c2_g_x100.n.."(x100)", en="c2_g(x100)"}, "float", nil, l.c2_g_x100.v));
    AddProperty(NewProperty(prefix.."c2_b_x100", {ja=l.c2_b_x100.n.."(x100)", en="c2_b(x100)"}, "float", nil, l.c2_b_x100.v));
    AddProperty(NewProperty(prefix.."c2_a_x100", {ja=l.c2_a_x100.n.."(x100)", en="c2_a(x100)"}, "float", nil, l.c2_a_x100.v));
    AddProperty(NewProperty(prefix.."c3_r_x100", {ja=l.c3_r_x100.n.."(x100)", en="c3_r(x100)"}, "float", nil, l.c3_r_x100.v));
    AddProperty(NewProperty(prefix.."c3_g_x100", {ja=l.c3_g_x100.n.."(x100)", en="c3_g(x100)"}, "float", nil, l.c3_g_x100.v));
    -- AddProperty(NewProperty(prefix.."c3_b_x100", {ja=l.c3_b_x100.n.."(x100)", en="c3_b(x100)"}, "float", nil, l.c3_b_x100.v));
    -- AddProperty(NewProperty(prefix.."c3_a_x100", {ja=l.c3_a_x100.n.."(x100)", en="c3_a(x100)"}, "float", nil, l.c3_a_x100.v));
end


function SetShaderProperty(prefix, param)
    local f0_0 = GetProperty(prefix.."f0_0");
    local f0_1 = GetProperty(prefix.."f0_1");
    local f0_2 = GetProperty(prefix.."f0_2");
    local f1 = GetProperty(prefix.."f1_x100") / 100;
    local f2 = GetProperty(prefix.."f2_x100") / 100;
    local f3 = GetProperty(prefix.."f3_x100") / 100;
    local f4 = GetProperty(prefix.."f4_x100") / 100;
    local f5 = GetProperty(prefix.."f5_x100") / 100;
    local c0_rgb_0 = GetProperty(prefix.."c0_rgb_0");
    local c0_rgb_1 = GetProperty(prefix.."c0_rgb_1");
    local c0_rgb_2 = GetProperty(prefix.."c0_rgb_2");
    local c0_rgb_3 = GetProperty(prefix.."c0_rgb_3");
    local c1_r = GetProperty(prefix.."c1_r_x100") / 100;
    local c1_g = GetProperty(prefix.."c1_g_x100") / 100;
    local c1_b = GetProperty(prefix.."c1_b_x100") / 100;
    local c1_a = GetProperty(prefix.."c1_a_x100") / 100;
    local c2_r = GetProperty(prefix.."c2_r_x100") / 100;
    local c2_g = GetProperty(prefix.."c2_g_x100") / 100;
    local c2_b = GetProperty(prefix.."c2_b_x100") / 100;
    local c2_a = GetProperty(prefix.."c2_a_x100") / 100;
    local c3_r = GetProperty(prefix.."c3_r_x100") / 100;
    local c3_g = GetProperty(prefix.."c3_g_x100") / 100;
    -- local c3_b = GetProperty(prefix.."c3_b_x100") / 100;
    -- local c3_a = GetProperty(prefix.."c3_a_x100") / 100;
    local c3_b = param.bounds.w;
    local c3_a = param.bounds.h;


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
        (floatToInt(c0_rgb_0.a, COLOR_BITS) << (COLOR_USE_BITS*0)) +
        (floatToInt(c0_rgb_1.a, COLOR_BITS) << (COLOR_USE_BITS*1)) +
        (floatToInt(c0_rgb_2.a, COLOR_BITS) << (COLOR_USE_BITS*2)) +
        (floatToInt(c0_rgb_3.a, COLOR_BITS) << (COLOR_USE_BITS*3))
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
    return shader;
end