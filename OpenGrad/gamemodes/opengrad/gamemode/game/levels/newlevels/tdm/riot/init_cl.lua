riot.GetTeamName = tdm.GetTeamName

local playsound = false
function riot.StartRoundCL()
    playsound = true
end

function riot.HUDPaint_RoundLeft(white)
    local lply = LocalPlayer()
    local name, color = riot.GetTeamName(lply)

    local startRound = roundTimeStart + 7 - CurTime()
    if startRound > 0 and lply:Alive() then
        if playsound then
            playsound = false
            surface.PlaySound("tdm_riot/start_1.ogg")
        end
        lply:ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255), 0.5, 0.5)

        drawRoundMode("Team Deathmatch", riot.Name, startRound, Color(155, 155, 55), Color(155, 155, 55))
        drawRoundStart(name, "Победите", startRound, Color(color.r, color.g, color.b))
        return
    end
    --draw.SimpleText(acurcetime,"HomigradFont",ScrW()/2,ScrH()-25,white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
end