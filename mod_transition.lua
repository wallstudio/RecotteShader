function GetInfo()

    local info = {
        name = "mod_transition",
        displayname = {
            en = "mod",
            ja = "もっど"
        },
    }
    return info
end


function InitTransition()
end

function UpdateProperty()
end

function Order()
    return 0
end

function RenderA(effInfo, tex, param)
    Draw(tex,param)
end

function RenderB(effInfo, tex, param)
    -- mod_effectと合わせて使用、mod_effectで設定したものを取ってくる
    param.shader = GetShader("ps")
    Draw(tex,param)
end