svo.GetTeamName = tdm.GetTeamName

local playsound = false
local bhop
function svo.StartRoundCL()
    --[[sound.PlayURL("https://cdn.discordapp.com/attachments/1136982600829894656/1138472303294951544/challengecomplete_metal.wav","mono noblock",function(snd)
        bhop = snd

        snd:SetVolume(1)
    end) ]]--
	playsound = true
end


function svo.HUDPaint_RoundLeft(white)
    local lply = LocalPlayer()
	local name,color = svo.GetTeamName(lply)

	local startRound = roundTimeStart + 5 - CurTime()
    if startRound > 0 and lply:Alive() then
        if playsound then
            playsound = false
            surface.PlaySound("snd_jack_hmcd_disaster.mp3")
        end
        lply:ScreenFade(SCREENFADE.IN,Color(0,0,0,255),0.5,0.5)


        drawRoundMode("Team Deathmatch",svo.Name,startRound,Color(155,155,155))
        if name == "ВС Сепаратистов" then
            drawRoundStart(name,"Уничтожь оккупантов, защищай своих.",startRound,Color(color.r,color.g,color.b))
        else
            drawRoundStart(name,"Уничтожь сепаратистов, защищай своих.",startRound,Color(color.r,color.g,color.b))
        end
        return
    end

    --draw.SimpleText(acurcetime,"HomigradFont",ScrW()/2,ScrH()-25,white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
end