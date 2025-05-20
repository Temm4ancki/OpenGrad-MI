slovopacana.GetTeamName = tdm.GetTeamName

local playsound = false
function slovopacana.StartRoundCL()
    playsound = true
end

function slovopacana.HUDPaint_RoundLeft(white)
    local lply = LocalPlayer()
    local name, color = slovopacana.GetTeamName(lply)

    local startRound = roundTimeStart + 7 - CurTime()
    if startRound > 0 and lply:Alive() then
        if playsound then
            playsound = false
            surface.PlaySound("tdm_slovoeblana/start_1.ogg")
        end
        lply:ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255), 0.5, 0.5)

        drawRoundMode("Team Deathmatch", slovopacana.Name, startRound, Color(155, 155, 155))
        drawRoundStart(name, "Защити имя своего любимого города.", startRound, Color(color.r, color.g, color.b))
        return
    end
    --draw.SimpleText(acurcetime,"HomigradFont",ScrW()/2,ScrH()-25,white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
end