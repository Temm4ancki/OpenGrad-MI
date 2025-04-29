kuhnya.GetTeamName = tdm.GetTeamName
local playsound = false
function kuhnya.StartRoundCL()
    playsound = true
end

function kuhnya.HUDPaint_RoundLeft(white)
    local lply = LocalPlayer()
	local name,color = kuhnya.GetTeamName(lply)

	local startRound = roundTimeStart + 7 - CurTime()
    if startRound > 0 and lply:Alive() then
        if playsound then
            playsound = false
            surface.PlaySound("kuhnya/barinov-start" .. math.random(1,3) .. ".wav")
            surface.PlaySound("kuhnya/round.wav")

        end
        lply:ScreenFade(SCREENFADE.IN,Color(0,0,0,255),0.5,0.5)

        drawRoundMode("ШЕФ ОПЯТЬ НАЖРАЛСЯ",svo.Name,startRound,Color(155,155,155))
        if lply:Team() == 2 then
            drawRoundStart(name,"ЭТИ ОГУЗКИ ОПЯТЬ НАПОРТАЧИЛИ",startRound,Color(color.r,color.g,color.b))
        else
            drawRoundStart(name,"ВЫЖИВИТЕ",startRound,Color(color.r,color.g,color.b))
        end
        return
    end
end