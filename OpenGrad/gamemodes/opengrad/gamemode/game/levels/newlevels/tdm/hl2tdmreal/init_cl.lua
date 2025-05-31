hl2dmreal.GetTeamName = tdm.GetTeamName

local playsound = false
function hl2dmreal.StartRoundCL()
    playsound = true
    local lply = LocalPlayer()
    local startRound = roundTimeStart + 7 - CurTime()

    if lply:Team() == 1 then
        logoAnimation = DrawAnimatedLogo("vgui/tdm_hl2dmreal/rlogo" .. math.random(1, 2), 1, -512, 40, ScrH() / 2 - 256, ScrH() / 2 - 270, startRound)
    else
        logoAnimation = DrawAnimatedLogo("vgui/tdm_hl2dmreal/logo" .. math.random(1, 2), 1, -512, 40, ScrH() / 2 - 256, ScrH() / 2 - 270, startRound)
    end
end

function hl2dmreal.HUDPaint_RoundLeft(white)
    local lply = LocalPlayer()
    local name, color = hl2dmreal.GetTeamName(lply)
    local length = 500

    local startRound = roundTimeStart + 7 - CurTime()

    if startRound > 0 and lply:Alive() then
        if playsound then
            playsound = false
            surface.PlaySound("z_rounds/start/HL2DM.ogg")
            timer.Simple(5, function()
                surface.PlaySound("tdm_hl2dmreal/f_protectionresponse_" .. math.random(4, 5) .. "_spkr.ogg")
            end)
            if lply:Team() == 2 then
                timer.Simple(14, function()
                    surface.PlaySound("tdm_hl2dmreal/report_" .. math.random(1, 5) .. ".ogg")
                end)
            end
        end
        lply:ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255), 0.5, 0.5)

        drawRoundMode("Битва за Сити-17", hl2dmreal.Name, startRound, Color(255, 255, 255))
        if lply:Team() == 1 then
            drawRoundStart(name, "Комбайны обнаружили вас. Отбейтесь", startRound, Color(color.r, color.g, color.b))
        else
            drawRoundStart(name, "ОТСЕЧЬ. ОБНУЛИТЬ. ПОДТВЕРДИТЬ. ", startRound, Color(color.r, color.g, color.b), true)
        end

        if logoAnimation then
            logoAnimation(startRound)
        end

        return
    end

    if not lply:Alive() then return end
    if lply:Team() ~= 2 then return end

    local health = lply:Health()
    local barColor = InterpolateHealthColor(health)

    local scrW, scrH = ScrW(), ScrH()
    local x, y = scrW * 0.04, scrH * 0.95
    local barWidth, barHeight = 20, 150
    local padding = 5

    draw.RoundedBox(4, x, y - barHeight, barWidth, barHeight, Color(50, 50, 50, 200))
    local filledHeight = (health / 100) * barHeight
    filledHeight = math.Clamp(filledHeight, 0, barHeight)
    draw.RoundedBox(4, x, y - filledHeight, barWidth, filledHeight, barColor)
    draw.SimpleText(health, "DermaDefault", x + barWidth / 2, y - barHeight - padding,
                    Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)

    local lply_pos = lply:GetPos()

    for _, ply in ipairs(player.GetAll()) do
        if ply:Team() ~= 2 or ply == lply or not ply:Alive() then continue end

        local pos

        local rag = ply:GetNWEntity("ragdoll")
        if IsValid(rag) then 
            pos = rag:GetPos()
        else
            local boneIndex = ply:LookupBone("ValveBiped.Bip01_Pelvis")
            pos = ply:GetBonePosition(boneIndex)
        end
        local dis = lply_pos:Distance(pos)
        if dis > length then continue end

        local screenPos = pos:ToScreen()
        if not screenPos.visible then continue end

        local allyHealth = ply:Health()
        local color = InterpolateHealthColor(allyHealth)
        local alpha = Lerp(dis / length, 255, 0)
        color.a = math.Clamp(alpha, 0, 255)

        local textX = screenPos.x
        local textY = screenPos.y

        local nick = string.upper(ply:Nick())
        draw.SimpleText(nick, "Combine", textX, textY, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    combine_cam()
end

function InterpolateHealthColor(health)
    local t = math.Clamp(health / 150, 0, 1)
    if t > 0.5 then
        return Color(Lerp((t - 0.5) * 2, 255, 0), 255, 0)
    else
        return Color(255, Lerp(t * 2, 0, 255), 0)
    end
end

surface.CreateFont("Combine", {
    font = "Tahoma",
    size = 20,
    weight = 500,
    antialias = true,
    italic = false,
})