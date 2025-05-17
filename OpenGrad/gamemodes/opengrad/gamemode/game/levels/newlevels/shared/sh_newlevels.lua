function drawRoundMode(mode, subMode, time, color)
    if colorSub == nil then colorSub = color end
    local alpha = math.Clamp(time - 0.5, 0, 1) * 255
    colorMode = Color(color.r - 50, color.g - 50, color.b - 50, alpha)
    colorSubMode = Color(color.r, color.g, color.b, alpha)

    draw.DrawText(subMode, "HomigradFontBig", ScrW() / 2, ScrH() / 6, colorSubMode, TEXT_ALIGN_CENTER)
    draw.DrawText(mode, "HomigradFontBig", ScrW() / 2, ScrH() / 8, colorMode, TEXT_ALIGN_CENTER)
end

function drawRoundStart(role, desc, time, color, typingEffect)
    local alpha = math.Clamp(time - 0.5, 0, 1) * 255
    if alpha <= 0 then return end

    local colorDesc, colorRole
    if color == 1 then
        colorDesc = Color(55, 55, 155, alpha)
        colorRole = Color(41, 41, 192, alpha)
    elseif color == 2 then
        colorDesc = Color(155, 55, 55, alpha)
        colorRole = Color(192, 41, 41, alpha)
    elseif color == 3 then
        colorDesc = Color(55, 55, 155, alpha)
        colorRole = Color(155, 155, 155, alpha)
    else
        colorDesc = Color(color.r, color.g, color.b, alpha)
        colorRole = Color(color.r + 30, color.g + 30, color.b + 30, alpha)
    end

    draw.DrawText(role, "HomigradFontLargeBig", ScrW() / 2, ScrH() / 2 - 60, colorRole, TEXT_ALIGN_CENTER)

    local visibleText = desc

    if typingEffect then
        local fullDuration = 3
        local typingSpeed = #desc / fullDuration
        local timeSinceStart = math.Clamp(7 - time, 0, fullDuration)

        local charsToShow = math.floor(timeSinceStart * typingSpeed)
        visibleText = string.sub(desc, 1, charsToShow)

        if (SysTime() % 1) < 0.5 and charsToShow < #desc then
            visibleText = visibleText .. "|"
        end
    end

    draw.DrawText(visibleText, "HomigradFontBig", ScrW() / 2, ScrH() / 1.2, colorDesc, TEXT_ALIGN_CENTER)
end

function drawRoundCosmetic(time)
    local alpha = math.Clamp(time - 0.5, 0, 1) * 255
    local lply = LocalPlayer()
    local jobcolor = Color(255, 255, 255, alpha)

    draw.DrawText("Внешность - " .. homicide.GetPlayerModel(lply), "HomigradFont", ScrW() / 2, ScrH() / 1.9, jobcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.DrawText("Имя - " .. lply:GetNWString("FakeName","Неизвестный"), "HomigradFont", ScrW() / 2, ScrH() / 1.85, jobcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

-- Плиз кто умеет кодить переделайте код на более умный.
-- Уверен ИИ насрал хуйней ведь цитата Руслана "вфт зачем тебе return function(time)"
function DrawAnimatedLogo(material, duration, startX, targetX, startY, targetY, time)
    local startTime = CurTime()
    local logoMaterial = Material(material)
    local finished = false
    local posX, posY = startX, startY

    return function(time)
        if finished then
            local alpha = math.Clamp(time - 0.5, 0, 1) * 255
            surface.SetDrawColor(255, 255, 255, alpha)
            surface.SetMaterial(logoMaterial)
            surface.DrawTexturedRect(targetX, targetY, 512, 512)
            return true
        end

        local elapsedTime = CurTime() - startTime
        local t = math.min(elapsedTime / (duration or 2), 1)
        t = 1 - (1 - t) ^ 4 -- ease-out

        posX = Lerp(t, startX, targetX)
        posY = Lerp(t, startY, targetY)

        local alpha = math.Clamp(time - 0.5, 0, 1) * 255
        surface.SetDrawColor(255, 255, 255, alpha)
        surface.SetMaterial(logoMaterial)
        surface.DrawTexturedRect(posX, posY, 512, 512)

        if t >= 1 then finished = true end
        return false
    end
end

function SpawnEblan(ply, wep)
    for _, wepa in ipairs(wep) do
        ply:Give(wepa)
    end
end