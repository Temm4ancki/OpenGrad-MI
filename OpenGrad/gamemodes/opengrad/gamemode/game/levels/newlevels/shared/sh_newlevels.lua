function drawRoundMode(mode, subMode, time, color, colorSub)
    if colorSub == nil then colorSub = color end

    colorSubMode = Color(colorSub.r,colorSub.g,colorSub.b,math.Clamp(time - 0.5,0,1) * 255)
    colorMode = Color(color.r-50,color.g-50,color.b-50,math.Clamp(time - 0.5,0,1) * 255)

    draw.DrawText(subMode, "HomigradFontBig", ScrW() / 2, ScrH() / 6, colorSubMode, TEXT_ALIGN_CENTER )
    draw.DrawText(mode, "HomigradFontBig", ScrW() / 2, ScrH() / 8, colorMode , TEXT_ALIGN_CENTER )
end

function drawRoundStart(role, desc, time, color) -- for homicide
    if color == 1 then 
        colorDesc = Color(55,55,155, math.Clamp(time - 0.5,0,1) * 255 ) -- innocent CT
        colorRole = Color(41,41,192, math.Clamp(time - 0.5,0,1) * 255 )
    elseif color == 2 then 
        colorDesc = Color(155,55,55, math.Clamp(time - 0.5,0,1) * 255 ) -- traitor
        colorRole = Color(192,41,41, math.Clamp(time - 0.5,0,1) * 255 )
    elseif color == 3 then 
        colorDesc = Color(55,55,155, math.Clamp(time - 0.5,0,1) * 255 )
        colorRole = Color(155,155,155, math.Clamp(time - 0.5,0,1) * 255 )
    else    
        colorDesc = Color(color.r,color.g,color.b,math.Clamp(time - 0.5,0,1) * 255)
        colorRole = Color(color.r+30,color.g+30,color.b+30,math.Clamp(time - 0.5,0,1) * 255)
    end

    draw.DrawText(role, "HomigradFontLargeBig", ScrW() / 2, ScrH() / 2-60, colorRole , TEXT_ALIGN_CENTER )
    draw.DrawText(desc, "HomigradFontBig", ScrW() / 2, ScrH() / 1.2, colorDesc, TEXT_ALIGN_CENTER )
end

function SpawnEblan(ply,wep)
    for _, wepa in ipairs(wep) do
        ply:Give(wepa)
    end
end