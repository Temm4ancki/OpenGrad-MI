table.insert(LevelList,"dm")
dm = {}
dm.Name = "Superfighters Legacy"
dm.LoadScreenTime = 5.5
dm.CantFight = dm.LoadScreenTime

dm.RoundRandomDefalut = 1
dm.NoSelectRandom = true

local red = Color(155,155,255)

function dm.GetTeamName(ply)
    local teamID = ply:Team()

     if teamID == 1 then return "Киборг-Убийца",red end
end

function dm.StartRound(data)
    team.SetColor(1,red)
    team.SetColor(2,blue)
    team.SetColor(1,green)

    game.CleanUpMap(false)

    if CLIENT then
        roundTimeStart = data[1]
        roundTime = data[2]
        dm.StartRoundCL()

        return
    end

    return dm.StartRoundSV()
end

if SERVER then return end

local playsound = false
function dm.StartRoundCL()
    playsound = true
end

function dm.HUDPaint_RoundLeft(white)
    local lply = LocalPlayer()
    local startRound = roundTimeStart + 7 - CurTime()
    local roleName, roleColor = dm.GetTeamName(lply)

    if startRound > 0 and lply:Alive() then
        if playsound then
            playsound = false
            surface.PlaySound("pvp_deathmatch/start_" .. math.random(1, 6) .. ".ogg")
        end

        lply:ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255), 0.5, 0.5)

        drawRoundMode("Player Vs Player", dm.Name, startRound, Color(155, 155, 255), Color(155, 155, 255))
        drawRoundStart(roleName or "Unknown", "ПОБЕДИ", startRound, Color(155, 155, 155))

        return
    end
end

net.Receive("dm die",function()
    timeStartAnyDeath = CurTime()
end)

function dm.CanUseSpectateHUD()
    return false
end

dm.RoundRandomDefalut = 3