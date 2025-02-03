function drawRoundStart(role, desc, time, color)
    if     color == 1 then color2 = Color(55,55,155, math.Clamp(time - 0.5,0,1) * 255 ) -- innocent CT
    elseif color == 2 then color2 = Color(155,55,55, math.Clamp(time - 0.5,0,1) * 255 ) -- traitor
    elseif color == 3 then color2 = Color(55,55,55, math.Clamp(time - 0.5,0,1) * 255 )  -- grey
    end

    draw.DrawText( role, "HomigradFontBig", ScrW() / 2, ScrH() / 2, Color(155,155,155, math.Clamp(time - 0.5,0,1) * 255 ) , TEXT_ALIGN_CENTER )
    draw.DrawText( desc, "HomigradFontBig", ScrW() / 2, ScrH() / 1.2, color2, TEXT_ALIGN_CENTER )
end

function SpawnEblan(ply,wep)
    for _, wepa in ipairs(wep) do
        ply:Give(wepa)
    end
end