hl2dm.GetTeamName = tdm.GetTeamName
local playsound = false
function hl2dm.StartRoundCL()
    playsound = true
end

function hl2dm.HUDPaint_RoundLeft(white)
    local lply = LocalPlayer()
	local name,color = hl2dm.GetTeamName(lply)

	local startRound = roundTimeStart + 7 - CurTime()
    if startRound > 0 and lply:Alive() then
        if playsound then
            playsound = false
            surface.PlaySound("snd_jack_hmcd_deathmatch.mp3")
        end
        lply:ScreenFade(SCREENFADE.IN,Color(0,0,0,255),0.5,0.5)

        
        if lply:GetModel() == "models/metrocat/metrocat_beta.mdl" then
            drawRoundMode("Teaw DeawMawtcwh :3","Fur-Life 2: Deawmawtch >w<",startRound,Color(155,55,142),Color(155,55,155))
            drawRoundStart("Catbine UwU nyaaa~","ВО ВСЁМ ВИНОВАТ rock",startRound,Color(color.r,color.g,color.b))
        else
            drawRoundMode("Team Deathmatch",hl2dm.Name,startRound,Color(155,155,55),Color(155,155,55))
            drawRoundStart(name,"E,BDFNM",startRound,Color(color.r,color.g,color.b))
        end
        return
    end
end