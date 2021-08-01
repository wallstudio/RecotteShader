require "recotte_shader_effect_lib/uh_util"


function GetInfo()

    local info = {
        name = "uh_dummy",
        displayname = {
            en = "mod",
            ja = "シェーダー適用"
        },
        shader = {
            ps = "uh_dummy.cso"
        }
    }
    return info
end


function InitTransition()
end

function UpdateProperty()
end

function Order(effInfo)
    return 1
end

function RenderA(effInfo, tex, param)
    Draw(tex,param)
end

function RenderB(effInfo, tex, param)
    Draw(tex,param)
end