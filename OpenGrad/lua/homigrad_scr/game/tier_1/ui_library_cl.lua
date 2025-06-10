-- Библиотека общих элементов интерфейса OpenGrad

if SERVER then return end

-- Создаем глобальную таблицу для библиотеки UI
HG_UI = HG_UI or {}

-- ========================================
-- КОНСТАНТЫ И НАСТРОЙКИ
-- ========================================

HG_UI.COLORS = {
    PRIMARY = Color(44, 110, 73),
    BACKGROUND = Color(10, 10, 10, 180),
    PANEL_BG = Color(20, 20, 20, 150),
    BUTTON_BG = Color(30, 30, 30, 180),
    BUTTON_HOVER = Color(40, 40, 40, 200),
    BUTTON_SELECTED = Color(60, 60, 60, 200),
    TEXT_PRIMARY = Color(255, 255, 255),
    TEXT_SECONDARY = Color(220, 220, 220),
    TEXT_MUTED = Color(180, 180, 180),
    SUCCESS = Color(80, 255, 80),
    ERROR = Color(255, 80, 80),
    WARNING = Color(255, 200, 0),
    SPEC = Color(155, 155, 155)
}

HG_UI.FONTS = {
    TITLE = "HG_UI_Title",
    HEADER = "HG_UI_Header", 
    BIG = "HG_UI_Big",
    NORMAL = "HG_UI_Normal",
    SMALL = "HG_UI_Small"
}

-- ========================================
-- СОЗДАНИЕ ШРИФТОВ
-- ========================================

surface.CreateFont(HG_UI.FONTS.TITLE, {
    font = "Roboto",
    size = 32,
    weight = 1000,
    outline = false,
    extended = true,
    shadow = false
})

surface.CreateFont(HG_UI.FONTS.HEADER, {
    font = "Roboto",
    size = 28,
    weight = 1000,
    outline = false,
    extended = true,
    shadow = false
})

surface.CreateFont(HG_UI.FONTS.BIG, {
    font = "Roboto",
    size = 25,
    weight = 1000,
    outline = false,
    extended = true,
    shadow = false
})

surface.CreateFont(HG_UI.FONTS.NORMAL, {
    font = "Roboto",
    size = 18,
    weight = 600,
    outline = false,
    extended = true,
    shadow = false
})

surface.CreateFont(HG_UI.FONTS.SMALL, {
    font = "Roboto",
    size = 15,
    weight = 500,
    outline = false,
    extended = true,
    shadow = false
})

-- ========================================
-- МАТЕРИАЛЫ
-- ========================================

HG_UI.MATERIALS = {
    BLUR = Material("pp/blurscreen"),
    GRADIENT_UP = Material("vgui/gradient-d"),
    GRADIENT_DOWN = Material("vgui/gradient-u")
}

-- ========================================
-- ФУНКЦИИ РАЗМЫТИЯ
-- ========================================

local blurStrength = 0

function HG_UI.BlurBackground(panel, strength)
    if not (IsValid(panel) and panel:IsVisible()) then return end
    
    strength = strength or 1
    local x, y = panel:LocalToScreen(0, 0)
    local w, h = ScrW(), ScrH()

    surface.SetDrawColor(255, 255, 255, 120)
    surface.SetMaterial(HG_UI.MATERIALS.BLUR)

    for i = 1, 5 do
        HG_UI.MATERIALS.BLUR:SetFloat("$blur", (i / 1) * 1 * blurStrength * strength)
        HG_UI.MATERIALS.BLUR:Recompute()
        render.UpdateScreenEffectTexture()
        surface.DrawTexturedRect(-x, -y, w, h)
    end

    surface.SetDrawColor(0, 0, 0, 100 * blurStrength * strength)
    surface.DrawRect(0, 0, panel:GetWide(), panel:GetTall())

    blurStrength = math.Clamp(blurStrength + FrameTime() * 6, 0, 1)
end

function HG_UI.ResetBlur()
    blurStrength = 0
end

-- ========================================
-- ФУНКЦИИ ОТРИСОВКИ
-- ========================================

function HG_UI.DrawFrame(x, y, w, h, color, borderColor, borderWidth)
    color = color or HG_UI.COLORS.BACKGROUND
    
    -- Используем цвета роли, если не указан конкретный цвет
    if not borderColor then
        local roleColors = HG_UI.GetRoleColors()
        borderColor = roleColors.PRIMARY
    end
    
    borderWidth = borderWidth or 2

    draw.RoundedBox(0, x, y, w, h, color)
    
    surface.SetDrawColor(borderColor.r, borderColor.g, borderColor.b, borderColor.a or 255)
    for i = 0, borderWidth do
        surface.DrawOutlinedRect(x - i, y - i, w + i*2, h + i*2)
    end
end

function HG_UI.DrawPanel(x, y, w, h, color, borderColor)
    color = color or HG_UI.COLORS.PANEL_BG
    
    -- Используем цвета роли, если не указан конкретный цвет
    if not borderColor then
        local roleColors = HG_UI.GetRoleColors()
        borderColor = roleColors.PRIMARY
    end
    
    draw.RoundedBox(0, x, y, w, h, color)
    surface.SetDrawColor(borderColor.r, borderColor.g, borderColor.b, borderColor.a or 200)
    surface.DrawOutlinedRect(x, y, w, h)
end

-- ========================================
-- СОЗДАНИЕ СТИЛИЗОВАННЫХ ЭЛЕМЕНТОВ
-- ========================================

function HG_UI.CreateStyledButton(parent, text, options)
    options = options or {}
    
    local btn = vgui.Create("DButton", parent)
    btn:SetText(text or "")
    btn:SetFont(options.font or HG_UI.FONTS.NORMAL)
    btn:SetTextColor(options.textColor or HG_UI.COLORS.TEXT_PRIMARY)
    btn:SetTall(options.height or 40)
    
    if options.dock then
        btn:Dock(options.dock)
        btn:DockMargin(options.margin and options.margin[1] or 0, 
                      options.margin and options.margin[2] or 0, 
                      options.margin and options.margin[3] or 0, 
                      options.margin and options.margin[4] or 10)
    end

    btn.Paint = function(self, w, h)
        local hover = self:IsHovered()
        local selected = options.selected and options.selected() or false
        
        local bg = selected and (options.selectedColor or HG_UI.COLORS.BUTTON_SELECTED) or
                  (hover and (options.hoverColor or HG_UI.COLORS.BUTTON_HOVER) or 
                  (options.bgColor or HG_UI.COLORS.BUTTON_BG))
        
        draw.RoundedBox(0, 0, 0, w, h, bg)
        
        -- Используем цвета роли, если не указан конкретный цвет
        local roleColors = HG_UI.GetRoleColors()
        local borderColor = options.borderColor or roleColors.PRIMARY
        local borderAlpha = selected and 255 or (hover and 255 or 180)
        surface.SetDrawColor(borderColor.r, borderColor.g, borderColor.b, borderAlpha)
        
        local borderWidth = selected and 2 or 1
        for i = 0, borderWidth do
            surface.DrawOutlinedRect(i, i, w - i*2, h - i*2)
        end
    end

    if options.onClick then
        btn.DoClick = options.onClick
    end

    return btn
end

function HG_UI.CreateStyledFrame(title, width, height, options)
    options = options or {}
    
    HG_UI.ResetBlur()
    
    local frame = vgui.Create("DFrame")
    frame:SetTitle("")
    frame:SetSize(width, height)
    frame:Center()
    frame:MakePopup()
    frame:ShowCloseButton(options.showClose ~= false)
    frame:SetDraggable(options.draggable ~= false)

    frame.Paint = function(self, w, h)
        if options.blur ~= false then
            HG_UI.BlurBackground(self, options.blurStrength)
        end
        
        HG_UI.DrawFrame(0, 0, w, h, options.bgColor, options.borderColor, options.borderWidth)
        
        if title and title ~= "" then
            local titleFont = options.titleFont or HG_UI.FONTS.HEADER
            local titleColor = options.titleColor or HG_UI.COLORS.TEXT_PRIMARY
            local titleY = options.titleY or 25
            draw.SimpleText(title, titleFont, w / 2, titleY, titleColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end

    return frame
end

function HG_UI.StyleScrollPanel(scroll, options)
    options = options or {}
    
    local sbar = scroll:GetVBar()
    function sbar:Paint(w, h) end
    function sbar.btnUp:Paint(w, h) end
    function sbar.btnDown:Paint(w, h) end
    function sbar.btnGrip:Paint(w, h)
        local gripColor = options.gripColor or Color(80, 80, 80, 160)
        
        -- Используем цвета роли, если не указан конкретный цвет
        local borderColor = options.borderColor
        if not borderColor then
            local roleColors = HG_UI.GetRoleColors()
            borderColor = roleColors.PRIMARY
        end
        
        draw.RoundedBox(0, 0, 0, w, h, gripColor)
        surface.SetDrawColor(borderColor.r, borderColor.g, borderColor.b, 200)
        surface.DrawOutlinedRect(0, 0, w, h)
    end
end

function HG_UI.CreateInfoPanel(parent, x, y, w, h, options)
    options = options or {}
    
    local panel = vgui.Create("Panel", parent)
    panel:SetPos(x, y)
    panel:SetSize(w, h)
    
    panel.Paint = function(self, pw, ph)
        HG_UI.DrawPanel(0, 0, pw, ph, options.bgColor, options.borderColor)
        
        if options.text then
            local textColor = options.textColor or HG_UI.COLORS.TEXT_PRIMARY
            local font = options.font or HG_UI.FONTS.NORMAL
            local align = options.align or TEXT_ALIGN_CENTER
            draw.SimpleText(options.text, font, pw / 2, ph / 2, textColor, align, TEXT_ALIGN_CENTER)
        end
    end
    
    return panel
end

-- ========================================
-- ФУНКЦИИ ДЛЯ РАБОТЫ С ТЕКСТОМ
-- ========================================

function HG_UI.DrawWrappedText(text, font, x, y, maxWidth, color)
    surface.SetFont(font)
    local lineHeight = select(2, surface.GetTextSize("A")) + 2
    local currentY = y

    local lines = string.Explode("\n", text)
    for _, line in ipairs(lines) do
        local words = string.Explode(" ", line)
        local currentLine = ""

        for _, word in ipairs(words) do
            local testLine = currentLine == "" and word or (currentLine .. " " .. word)
            local textW = surface.GetTextSize(testLine)

            if textW > maxWidth and currentLine ~= "" then
                draw.SimpleText(currentLine, font, x, currentY, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                currentY = currentY + lineHeight
                currentLine = word
            else
                currentLine = testLine
            end
        end

        if currentLine ~= "" then
            draw.SimpleText(currentLine, font, x, currentY, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            currentY = currentY + lineHeight
        end
    end

    return currentY
end

function HG_UI.GetWrappedTextHeight(text, font, maxWidth)
    surface.SetFont(font)
    local lineHeight = select(2, surface.GetTextSize("A")) + 2
    local height = 0

    local lines = string.Explode("\n", text)
    for _, line in ipairs(lines) do
        local words = string.Explode(" ", line)
        local currentLine = ""

        for _, word in ipairs(words) do
            local testLine = currentLine == "" and word or (currentLine .. " " .. word)
            local textW = surface.GetTextSize(testLine)

            if textW > maxWidth and currentLine ~= "" then
                height = height + lineHeight
                currentLine = word
            else
                currentLine = testLine
            end
        end

        if currentLine ~= "" then
            height = height + lineHeight
        end
    end

    return height
end

-- ========================================
-- ФУНКЦИИ ДЛЯ ПОЛУЧЕНИЯ ЦВЕТОВ ПО РОЛЯМ
-- ========================================

function HG_UI.GetRoleColors(ply)
    ply = ply or LocalPlayer()
    
    -- Проверяем, является ли игрок предателем в режиме homicide
    local isHomicideMode = false
    
    -- Правильный способ определить режим homicide через TableRound()
    if TableRound and TableRound().Name == "Homicide" then
        isHomicideMode = true
    end
    
    if IsValid(ply) and ply.roleT and isHomicideMode then
        return {
            PRIMARY = Color(155, 55, 55, 255),
            HOVER = Color(155, 55, 55, 180),
            BORDER = Color(155, 55, 55, 200)
        }
    else
        -- В остальных случаях используем цвет игрока или стандартный
        local playerColor = HG_UI.COLORS.PRIMARY
        
        if IsValid(ply) then
            -- Получаем цвет игрока
            local plyColor = ply:GetPlayerColor()
            if plyColor and plyColor ~= Vector(0, 0, 0) then
                -- Конвертируем Vector в Color и делаем ярче для UI
                playerColor = Color(
                    math.min(255, math.max(50, plyColor.x * 255 * 1.2)),
                    math.min(255, math.max(50, plyColor.y * 255 * 1.2)), 
                    math.min(255, math.max(50, plyColor.z * 255 * 1.2)),
                    255
                )
            end
        end
        
        return {
            PRIMARY = playerColor,
            HOVER = Color(playerColor.r, playerColor.g, playerColor.b, 180),
            BORDER = Color(playerColor.r, playerColor.g, playerColor.b, 200)
        }
    end
end

-- ========================================
-- АНИМАЦИИ
-- ========================================

function HG_UI.CreateScrollAnimation(panel)
    local animWheelUp, animWheelDown = 0, 0
    
    panel.DrawScrollAnimation = function(self, w, h)
        surface.SetMaterial(HG_UI.MATERIALS.GRADIENT_DOWN)
        surface.SetDrawColor(125, 125, 155, math.min(animWheelUp * 255, 10))
        surface.DrawTexturedRect(0, 0, w, animWheelUp)

        surface.SetMaterial(HG_UI.MATERIALS.GRADIENT_UP)
        surface.SetDrawColor(125, 125, 155, math.min(animWheelDown * 255, 10))
        surface.DrawTexturedRect(0, h - animWheelDown, w, animWheelDown)

        local lerp = math.max(FrameTime() / (1 / 60) * 0.1, 0)
        animWheelUp = Lerp(lerp, animWheelUp, 0)
        animWheelDown = Lerp(lerp, animWheelDown, 0)
    end
    
    panel.TriggerScrollUp = function()
        animWheelUp = animWheelUp + 32
    end
    
    panel.TriggerScrollDown = function()
        animWheelDown = animWheelDown + 32
    end
end

-- ========================================
-- УТИЛИТЫ
-- ========================================

function HG_UI.CreateMenu(options)
    options = options or {}
    
    local menu = vgui.Create("DMenu")
    menu:SetPos(input.GetCursorPos())

    menu.Paint = function(self, w, h)
        -- Используем цвета роли, если не указан конкретный цвет
        local borderColor = options.borderColor
        if not borderColor then
            local roleColors = HG_UI.GetRoleColors()
            borderColor = roleColors.PRIMARY
        end
        
        HG_UI.DrawFrame(0, 0, w, h, 
                       options.bgColor or Color(20, 20, 20, 240),
                       borderColor,
                       1)
    end

    return menu
end

function HG_UI.AddMenuOption(menu, text, func, options)
    options = options or {}
    
    local option = menu:AddOption(text, func)
    option:SetFont(options.font or HG_UI.FONTS.NORMAL)
    option:SetColor(options.color or HG_UI.COLORS.TEXT_SECONDARY)
    
    return option
end

-- ========================================
-- СОВМЕСТИМОСТЬ СО СТАРЫМ КОДОМ
-- ========================================

-- Функции для обратной совместимости
function BlurBackground(panel, strength)
    return HG_UI.BlurBackground(panel, strength)
end

function StyledButton(parent, text, color, font, onclick)
    return HG_UI.CreateStyledButton(parent, text, {
        textColor = color,
        font = font,
        onClick = onclick,
        dock = TOP,
        margin = {0, 0, 0, 10}
    })
end

print("[HG_UI] Библиотека интерфейса загружена успешно!")