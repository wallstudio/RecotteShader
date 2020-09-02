function dumpFile(arg)
    -- file::writeするとなぜかそこでLuaの処理が失敗するため、cmd経由で回避
    local path = "C:\\Users\\huser\\Desktop\\RseMod\\log.yml";
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
            dumpObj(value, tab + 1, depth);
        end
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
            ps = "../transitions/mod.cso"
        }
    }
    return info
end


function InitEffect()
    SetDuration(0.5)
    AddProperty(NewProperty("f0", { ja="f0", en="f0"}, "float", nil, 1))
    AddProperty(NewProperty("f1", { ja="f1", en="f1"}, "float", nil, 1))
end

function ApplyEffect(effInfo, param)
    local shader = GetShader("ps")
    SetShaderFloat(shader, 2, GetProperty("f0"))
    SetShaderFloat(shader, 3, GetProperty("f1"))
    param.shader = shader
    return param
end