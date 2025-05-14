tdm = tdm or {}
wick.GetTeamName = tdm.GetTeamName

if tdm.GetTeamName then
    wick.GetTeamName = tdm.GetTeamName
else
    function wick.GetTeamName(ply)
        local teamID = ply:Team()
        if teamID == 1 then
            if ply.roleT then
                return "Джон Уик", Color(255, 98, 98)
            else
                return "Наёмник", Color(125, 125, 125)
            end
        else
            return "Неизвестно", ScoreboardSpec or Color(255, 255, 255)
        end
    end
end

local colorSpec = ScoreboardSpec
function wick.Scoreboard_Status(ply)
    local lply = LocalPlayer()
    if not lply:Alive() or lply:Team() == 1002 then return true end

    return "Неизвестно", colorSpec
end

local red = Color(200, 0, 10)
local blue = Color(75, 75, 255)
local white = Color(255, 255, 255)

local playsound = false
function wick.StartRoundCL()
    playsound = true
end

function wick.HUDPaint_RoundLeft(white2, time)
    local time = math.Round(roundTimeStart + roundTime - CurTime())
    local acurcetime = string.FormattedTime(time, "%02i:%02i")
    local lply = LocalPlayer()
    local name, color = wick.GetTeamName(lply)

    local startRound = roundTimeStart + 7 - CurTime()
    if startRound > 0 and lply:Alive() then
        if playsound then
            playsound = false
            surface.PlaySound("round/start/school.ogg")
        end

        lply:ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255), 0.5, 0.5)

        drawRoundMode("Player vs Everyone", wick.Name, startRound, Color(155, 155, 155))
        
        if lply.roleT then
            drawRoundStart(name, "Вы - Джон Уик, разберитесь со всеми наемниками.", startRound, Color(color.r, color.g, color.b))
        else
            drawRoundStart(name, "Нейтрализуйте Джона Уика", startRound, Color(color.r, color.g, color.b))
        end
        return
    end

    if time > 0 then
        draw.SimpleText("До конца раунда: ", "HomigradFont", ScrW() / 2 - 200, ScrH()-25, white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText(acurcetime, "HomigradFont", ScrW() / 2 + 200, ScrH()-25, white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
    end
    blue.a = white2.a

    local lply_pos = lply:GetPos()

    for i, ply in ipairs(player.GetAll()) do
        local color = ply.roleT and red
        if not color or ply == lply or not ply:Alive() then continue end

        local boneIndex = ply:LookupBone("ValveBiped.Bip01_Pelvis")
    
        local pos = ply:GetBonePosition(boneIndex)
        local dis = lply_pos:Distance(pos)
        if dis < 0 then continue end

        local pos = pos:ToScreen()
        if not pos.visible then continue end

        color.a = 255 * (dis / 2500)

        draw.SimpleText(ply.roleT and "Джон Уик" or "", "HomigradFont", pos.x, pos.y, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
end

function wick.HUDPaint_Spectate(spec)
    local name, color = wick.GetTeamName(spec)
    draw.SimpleText(name, "HomigradFontBig", ScrW() / 2, ScrH() - 150, color, TEXT_ALIGN_CENTER)
end

function wick.PlayerClientSpawn()
    if LocalPlayer().roleT then
        showRoundInfo = CurTime() + 10
    end
end