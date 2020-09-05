function GetInfo()

    local info = {
        name = "uh_dummy",
        displayname = {
            en = "mod",
            ja = "もっど"
        },
        shader = {
            ps = "../uh_dummy.cso"
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
    -- mod_effectと合わせて使用、mod_effectで設定したものを取ってくる
    param.shader = GetShader("ps")
    Draw(tex,param)
end

function RenderB(effInfo, tex, param)
    Draw(tex,param)
end