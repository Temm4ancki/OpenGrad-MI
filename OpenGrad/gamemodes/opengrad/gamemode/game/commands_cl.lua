-- хуйня для удобства ввода на клиенте, а то я заебался нахуй @temm4ancki
concommand.Add("hg_level_end", function(ply, cmd, args)
    net.Start("HGLEVEL_END_COMMAND")
    net.SendToServer()
end)

net.Receive("SendLevelNextList", function()
    LevelList = net.ReadTable()
end)

local function AutoCompleteHGLevelNext(cmd, arg)
    if not LevelList then return {} end

    local suggestions = {}
    for _, level in ipairs(LevelList) do
        table.insert(suggestions, cmd .. " " .. level)
    end
    return suggestions
end

concommand.Add("hg_level_next", function(ply, cmd, args)
    net.Start("HGLEVEL_NEXT_COMMAND")
    net.WriteString(args[1] or "")
    net.SendToServer()
end, AutoCompleteHGLevelNext)

surface.CreateFont("MenuLabel", {
    font = "Roboto",
    size = 32,
    weight = 1000,
    outline = false,
    shadow = false
})

surface.CreateFont("MenuBig", {
    font = "Roboto",
    size = 25,
    weight = 1000,
    outline = false,
    shadow = false
})

surface.CreateFont("MenuSmall", {
    font = "Roboto",
    size = 15,
    weight = 5000,
    outline = true,
    shadow = true
})

local blurMat = Material("pp/blurscreen")
local blurStrength = 0

local function BlurBackground(panel)
    if not (IsValid(panel) and panel:IsVisible()) then return end

    local x, y = panel:LocalToScreen(0, 0)
    local w, h = ScrW(), ScrH()

    surface.SetDrawColor(255, 255, 255, 120)
    surface.SetMaterial(blurMat)

    for i = 1, 5 do
        blurMat:SetFloat("$blur", (i / 1) * 1 * blurStrength)
        blurMat:Recompute()
        render.UpdateScreenEffectTexture()
        surface.DrawTexturedRect(-x, -y, w, h)
    end

    surface.SetDrawColor(0, 0, 0, 100 * blurStrength)
    surface.DrawRect(0, 0, panel:GetWide(), panel:GetTall())

    blurStrength = math.Clamp(blurStrength + FrameTime() * 6, 0, 1)
end

local function StyledButton(parent, text, color, font, onclick)
    local btn = vgui.Create("DButton", parent)
    btn:SetText(text)
    btn:SetFont(font or "DermaDefaultBold")
    btn:SetTextColor(color or color_white)
    btn:SetTall(40)
    btn:Dock(TOP)
    btn:DockMargin(0, 0, 0, 10)

    btn.Paint = function(self, w, h)
        local hover = self:IsHovered()
        local bg = hover and Color(40, 40, 40, 200) or Color(30, 30, 30, 180)
        draw.RoundedBox(0, 0, 0, w, h, bg)
        surface.SetDrawColor(44, 110, 73, hover and 255 or 180)
        for i = 0, 1 do
            surface.DrawOutlinedRect(i, i, w - i*2, h - i*2)
        end
    end

    btn.DoClick = onclick
    return btn
end

function OpenLevelMenu()
    local ply = LocalPlayer()
    if not IsValid(ply) or not ply:IsAdmin() then
        notification.AddLegacy("У вас нет прав для открытия этого меню.", NOTIFY_ERROR, 5)
        surface.PlaySound("buttons/button10.wav")
        return
    end

    if IsValid(LevelMenuFrame) then LevelMenuFrame:Remove() end

    local padding = 20
    local maxVisibleButtons = 10
    local baseHeight = 60 + 40 + 10 + 10 + padding * 2 -- заголовок + завершить + отступы

    local buttonCount = LevelList and #LevelList or 0
    local dynamicHeight = baseHeight + math.min(buttonCount, maxVisibleButtons) * 50
    local maxHeight = ScrH() * 0.8
    local width = 360
    local height = math.min(dynamicHeight, maxHeight)

    LevelMenuFrame = vgui.Create("DFrame")
    LevelMenuFrame:SetSize(width, height)
    LevelMenuFrame:Center()
    LevelMenuFrame:MakePopup()
    LevelMenuFrame:SetTitle("")
    LevelMenuFrame:ShowCloseButton(true)
    LevelMenuFrame:SetDraggable(true)

    LevelMenuFrame.Paint = function(self, w, h)
        BlurBackground(self)
        draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 180))
        surface.SetDrawColor(44, 110, 73, 255)
        for i = 0, 2 do
            surface.DrawOutlinedRect(i, i, w - i*2, h - i*2)
        end
        draw.SimpleText("Управление раундом", "MenuLabel", w / 2, 20, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
    end

    -- Верхняя панель с кнопкой вне скролла
    local topPanel = vgui.Create("Panel", LevelMenuFrame)
    topPanel:SetPos(padding, 60)
    topPanel:SetSize(width - padding * 2, 50 + 10 + 2 + 10)

    StyledButton(topPanel, "Завершить раунд", Color(255, 80, 80), "MenuBig", function()
        net.Start("HGLEVEL_END_COMMAND")
        net.SendToServer()
        LevelMenuFrame:Close()
    end)

    local line = vgui.Create("DPanel", topPanel)
    line:SetTall(2)
    line:Dock(BOTTOM)
    line:DockMargin(0, 10, 0, 10)
    line.Paint = function(self, w, h)
        surface.SetDrawColor(44, 110, 73, 100)
        surface.DrawRect(0, 0, w, h)
    end

    -- Скроллируемая область с уровнями
    local scroll = vgui.Create("DScrollPanel", LevelMenuFrame)
    scroll:SetPos(padding, topPanel:GetY() + topPanel:GetTall())
    scroll:SetSize(width - padding * 2, height - scroll:GetY() - padding)

    -- Кастомный скроллбар
    local sbar = scroll:GetVBar()
    function sbar:Paint(w, h) end
    function sbar.btnUp:Paint(w, h) end
    function sbar.btnDown:Paint(w, h) end
    function sbar.btnGrip:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(80, 80, 80, 160))
        surface.SetDrawColor(44, 110, 73, 200)
        surface.DrawOutlinedRect(0, 0, w, h)
    end

    local layout = vgui.Create("DListLayout", scroll)
    layout:Dock(FILL)

    if not LevelList or #LevelList == 0 then
        local label = vgui.Create("DLabel", layout)
        label:SetText("Список уровней пуст.")
        label:SetTextColor(color_white)
        label:SetContentAlignment(5)
        label:Dock(TOP)
        label:DockMargin(0, 0, 0, 10)
        label:SizeToContents()
        return
    end

    for _, level in ipairs(LevelList) do
        StyledButton(layout, string.upper(level), Color(220, 220, 220), "MenuSmall", function()
            net.Start("HGLEVEL_NEXT_COMMAND")
            net.WriteString(level)
            net.SendToServer()
            LevelMenuFrame:Close()
        end)
    end
end

-- Добавляем клиентскую команду (для консоли или биндов)
concommand.Add("open_level_menu", OpenLevelMenu)

-- Привязываем к F4
hook.Add("Think", "CheckF4Press", function()
    if input.IsKeyDown(KEY_F4) and not isF4Pressed then
        isF4Pressed = true
        OpenLevelMenu()
    elseif not input.IsKeyDown(KEY_F4) then
        isF4Pressed = false
    end
end)