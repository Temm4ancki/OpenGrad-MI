svo.GetTeamName = tdm.GetTeamName

local playsound = false
function svo.StartRoundCL()
    playsound = true
end

function svo.HUDPaint_RoundLeft(white)
    local lply = LocalPlayer()
    local name, color = svo.GetTeamName(lply)

    local startRound = roundTimeStart + 7 - CurTime()
    if startRound > 0 and lply:Alive() then
        if playsound then
            playsound = false
            surface.PlaySound("tdm_svo/start_" .. math.random(1, 2) .. ".ogg")
        end
        lply:ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255), 0.5, 0.5)

        drawRoundMode("Team Deathmatch", svo.Name, startRound, Color(155, 155, 155))
        if lply:Team() == 1 then
            drawRoundStart(name, "Уничтожь оккупантов, защищай сво.", startRound, Color(color.r, color.g, color.b))
        else
            drawRoundStart(name, "Уничтожь сепаратистов, защищай сво.", startRound, Color(color.r, color.g, color.b))
        end
        return
    end
    --draw.SimpleText(acurcetime,"HomigradFont",ScrW()/2,ScrH()-25,white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
end