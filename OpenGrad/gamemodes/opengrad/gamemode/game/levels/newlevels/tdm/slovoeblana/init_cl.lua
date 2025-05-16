slovopacana.GetTeamName = tdm.GetTeamName

local playsound = false
local bhop
function slovopacana.StartRoundCL()
    --[[sound.PlayURL("https://cdn.discordapp.com/attachments/1136982600829894656/1138472303294951544/challengecomplete_metal.wav","mono noblock",function(snd)
        bhop = snd

        snd:SetVolume(1)
    end) ]]--
	playsound = true
end


function slovopacana.HUDPaint_RoundLeft(white)
    local lply = LocalPlayer()
	local name,color = slovopacana.GetTeamName(lply)

	local startRound = roundTimeStart + 5 - CurTime()
    if startRound > 0 and lply:Alive() then
        if playsound then
            playsound = false
            surface.PlaySound("hg_rounds/start/nigshit.ogg")
        end
        lply:ScreenFade(SCREENFADE.IN,Color(0,0,0,255),0.5,0.5)


        drawRoundMode("Team Deathmatch",slovopacana.Name,startRound,Color(155,155,155))
        drawRoundStart(name,"Защити имя своего любимого города.",startRound,Color(color.r,color.g,color.b))
        return
    end

    --draw.SimpleText(acurcetime,"HomigradFont",ScrW()/2,ScrH()-25,white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
end