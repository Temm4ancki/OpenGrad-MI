table.insert(LevelList,"slugarena")
slugarena = {}
slugarena.Name = "Slugcat Arena"
slugarena.LoadScreenTime = 5.5
slugarena.CantFight = slugarena.LoadScreenTime

slugarena.RoundRandomDefalut = 1
slugarena.NoSelectRandom = true

local red = Color(155,155,255)

function slugarena.GetTeamName(ply)
    local teamID = ply:Team()

     if teamID == 1 then return "Слизнекот",red end
end

function slugarena.StartRound(data)
    team.SetColor(1,red)
    team.SetColor(2,blue)
    team.SetColor(1,green)

    game.CleanUpMap(false)

    if CLIENT then
        roundTimeStart = data[1]
        roundTime = data[2]
        slugarena.StartRoundCL()

        return
    end

    return slugarena.StartRoundSV()
end

if SERVER then return end

local playsound = false
function slugarena.StartRoundCL()
    playsound = true
end

function slugarena.HUDPaint_RoundLeft(white)
    local lply = LocalPlayer()

	local startRound = roundTimeStart + 7 - CurTime()
    if startRound > 0 and lply:Alive() then
        if playsound then
            playsound = false
            surface.PlaySound("snd_jack_hmcd_deathmatch.mp3")
        end
        lply:ScreenFade(SCREENFADE.IN,Color(0,0,0,255),0.5,0.5)

        drawRoundMode("Player Vs Player",slugarena.Name,startRound,Color(155,155,255))
        drawRoundStart("Слизнекот","ПОБЕДИ",startRound,Color(155,155,155))

        return
    end
end

net.Receive("slugarena die",function()
    timeStartAnyDeath = CurTime()
end)

function slugarena.CanUseSpectateHUD()
    return false
end

slugarena.RoundRandomDefalut = 3