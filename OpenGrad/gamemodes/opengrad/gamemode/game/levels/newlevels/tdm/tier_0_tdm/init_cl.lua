tdm.GetTeamName = tdm.GetTeamName

local playsound = false

function tdm.StartRoundCL()
    playsound = true
end

function tdm.HUDPaint_RoundLeft(white)
    local lply = LocalPlayer()
	local name,color = tdm.GetTeamName(lply)

	local startRound = roundTimeStart + 7 - CurTime()
    if startRound > 0 and lply:Alive() then
        if playsound then
            playsound = false
            surface.PlaySound("snd_jack_hmcd_deathmatch.mp3")
        end
        lply:ScreenFade(SCREENFADE.IN,Color(0,0,0,255),0.5,0.5)


        drawRoundMode("Team Death,atch",tdm.Name,startRound,Color(155,155,255),Color(155,155,255))
        drawRoundStart(name,"ПОБЕДИТЬБ",startRound,Color(color.r,color.g,color.b))
        return
    end
end