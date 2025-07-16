ghostbusters.GetTeamName = tdm.GetTeamName

local playsound = false
function ghostbusters.StartRoundCL()
    playsound = true
end

function ghostbusters.HUDPaint_RoundLeft(white)
    local lply = LocalPlayer()
    local name, color = ghostbusters.GetTeamName(lply)

    local startRound = roundTimeStart + 7 - CurTime()
    if startRound > 0 and lply:Alive() then
        if playsound then
            playsound = false
            surface.PlaySound("tdm_ghostbusters/start_1.ogg")
        end
        lply:ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255), 0.5, 0.5)

        drawRoundMode("Events", ghostbusters.Name, startRound, Color(155, 155, 55), Color(155, 155, 55))
        if lply:Team() == 1 then
            drawRoundStart(name, "Поймайте призраков на камеру", startRound, Color(color.r, color.g, color.b))
        else
            drawRoundStart(name, "Сверните шею искателям", startRound, Color(color.r, color.g, color.b))
        end
        return
    end
    --draw.SimpleText(acurcetime,"HomigradFont",ScrW()/2,ScrH()-25,white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
end