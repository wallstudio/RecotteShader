
function GetInfo()

    local info = {
        name = "uh_effect_rotate2",
        displayname = {
            en = "uh_effect_rotate2",
            ja = "UH_VS回転"
        },
        tag = "effect",
        affects = AF_Angle,
        thumbnail = nil
    }
    return info
end


function InitEffect()
    SetDuration(0.5)
    AddProperty(NewProperty("RotateZ",
     { ja="回転角度（Z軸）", en="RotateZ"}, 
         "float", nil, 0))

end

function ApplyEffect(effInfo, param)


    param.angle = GetProperty("RotateZ")

    return param
end