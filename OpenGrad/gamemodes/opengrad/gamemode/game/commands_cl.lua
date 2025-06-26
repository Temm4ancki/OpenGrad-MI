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

-- Используем общую библиотеку UI
include("homigrad_scr/game/tier_1/ui_library_cl.lua")

if SERVER then
    util.AddNetworkString("homicide_spawn_type")
end

function CreateHomicideSettingsPanel(parentFrame)
    local ply = LocalPlayer()
    if not IsValid(ply) or not ply:IsAdmin() then
        return nil
    end

    local mainX, mainY = parentFrame:GetPos()
    local mainW, mainH = parentFrame:GetSize()
    
    local spawnTypes = {
        {id = "random", name = "Случайный", desc = "Случайный выбор типа трейтора"},
        {id = "standard", name = "Классический", desc = "Классический Хомисайд"},
        {id = "shop_spawn", name = "Магазин", desc = "Трейторы получают кредиты для покупок"},
        {id = "preset_selection", name = "Выбор пресетов", desc = "Выбирает пресет при спавне"},
        {id = "random_preset", name = "Случайный пресет", desc = "Случайный выбор из пресетов"},
    }
    
    local roleColors = HG_UI.GetRoleColors()
    
    local padding = 20
    local titleHeight = 70
    local descHeight = 40
    local buttonHeight = 60
    local buttonMargin = 8
    local bottomPadding = 20
    
    local width = 350
    local height = titleHeight + descHeight + (#spawnTypes * (buttonHeight + buttonMargin)) + bottomPadding
    local x = mainX + mainW + 20
    local y = mainY

    local homicideFrame = HG_UI.CreateStyledFrame("Настройки Homicide", width, height, {
        titleY = 35,
        titleFont = HG_UI.FONTS.HEADER,
        borderColor = roleColors.PRIMARY,
        blur = true,
        blurStrength = 1
    })

    homicideFrame:SetPos(x, y)

    local scroll = vgui.Create("DScrollPanel", homicideFrame)
    scroll:SetPos(padding, titleHeight)
    scroll:SetSize(width - padding * 2, height - titleHeight - padding)
    HG_UI.StyleScrollPanel(scroll, {
        gripColor = Color(80, 80, 80, 160),
        borderColor = roleColors.BORDER
    })

    local layout = vgui.Create("DListLayout", scroll)
    layout:Dock(FILL)

    local descLabel = vgui.Create("DLabel", layout)
    descLabel:SetText("Выберите тип трейтора для режима Homicide:")
    descLabel:SetFont(HG_UI.FONTS.SMALL)
    descLabel:SetTextColor(HG_UI.COLORS.TEXT_SECONDARY)
    descLabel:SetContentAlignment(5)
    descLabel:Dock(TOP)
    descLabel:DockMargin(0, 0, 0, 15)
    descLabel:SetAutoStretchVertical(true)
    descLabel:SetWrap(true)

    for _, spawnType in ipairs(spawnTypes) do
        local btn = HG_UI.CreateStyledButton(layout, "", {
            dock = TOP,
            margin = {0, 0, 0, buttonMargin},
            height = buttonHeight,
            borderColor = roleColors.BORDER,
            bgColor = Color(25, 25, 25, 180),
            hoverColor = Color(35, 35, 35, 200),
            onClick = function()
                currentSpawnType = spawnType.id
                net.Start("homicide_spawn_type")
                net.WriteString(spawnType.id)
                net.SendToServer()
            end
        })
        
        btn.Paint = function(self, w, h)
            local hover = self:IsHovered()
            local isSelected = currentSpawnType == spawnType.id
            
            local bg
            if isSelected then
                bg = Color(50, 80, 50, 220)
            elseif hover then
                bg = Color(35, 35, 35, 200)
            else
                bg = Color(25, 25, 25, 180)
            end
            
            draw.RoundedBox(0, 0, 0, w, h, bg)
            
            local borderColor
            if isSelected then
                borderColor = Color(100, 255, 100, 255)
            else
                borderColor = Color(roleColors.PRIMARY.r, roleColors.PRIMARY.g, roleColors.PRIMARY.b, hover and 255 or 180)
            end
            surface.SetDrawColor(borderColor.r, borderColor.g, borderColor.b, borderColor.a)
            surface.DrawOutlinedRect(0, 0, w, h)
            
            if isSelected then
                surface.DrawOutlinedRect(1, 1, w-2, h-2)
            end
            
            local nameColor = isSelected and Color(150, 255, 150) or HG_UI.COLORS.TEXT_PRIMARY
            local descColor = isSelected and Color(120, 200, 120) or HG_UI.COLORS.TEXT_MUTED
            
            draw.SimpleText(spawnType.name, HG_UI.FONTS.NORMAL, 10, 8, nameColor, TEXT_ALIGN_LEFT)
            draw.SimpleText(spawnType.desc, HG_UI.FONTS.SMALL, 10, 32, descColor, TEXT_ALIGN_LEFT)
            
            if isSelected then
                draw.SimpleText("✓", HG_UI.FONTS.NORMAL, w - 25, h/2 - 10, Color(100, 255, 100), TEXT_ALIGN_CENTER)
            end
        end
    end

    homicideFrame.OnClose = function()
        if IsValid(parentFrame) then
            parentFrame:Close()
        end
    end

    return homicideFrame
end

function OpenLevelMenu()
    local ply = LocalPlayer()
    if not IsValid(ply) or not ply:IsAdmin() then
        chat.AddText(Color(255, 100, 100), "У вас нет прав для открытия этого меню.")
        surface.PlaySound("buttons/button10.wav")
        return
    end

    if IsValid(LevelMenuFrame) then LevelMenuFrame:Remove() end
    if IsValid(HomicideSettingsFrame) then HomicideSettingsFrame:Remove() end

    local padding = 20
    local maxVisibleButtons = 10
    local baseHeight = 60 + 40 + 10 + 10 + padding * 2

    local buttonCount = LevelList and #LevelList or 0
    local dynamicHeight = baseHeight + math.min(buttonCount, maxVisibleButtons) * 50
    local maxHeight = ScrH() * 0.8
    local width = 360
    local height = math.min(dynamicHeight, maxHeight)

    LevelMenuFrame = HG_UI.CreateStyledFrame("Управление раундом", width, height, {
        titleY = 35,
        titleFont = HG_UI.FONTS.TITLE,
        blur = true,
        blurStrength = 1
    })

    local topPanel = vgui.Create("Panel", LevelMenuFrame)
    topPanel:SetPos(padding, 60)
    topPanel:SetSize(width - padding * 2, 50 + 10 + 2 + 10)

    HG_UI.CreateStyledButton(topPanel, "Завершить раунд", {
        textColor = HG_UI.COLORS.ERROR,
        font = HG_UI.FONTS.BIG,
        dock = TOP,
        margin = {0, 0, 0, 10},
        onClick = function()
            net.Start("HGLEVEL_END_COMMAND")
            net.SendToServer()
            LevelMenuFrame:Close()
            if IsValid(HomicideSettingsFrame) then HomicideSettingsFrame:Close() end
        end
    })

    local line = vgui.Create("DPanel", topPanel)
    line:SetTall(2)
    line:Dock(BOTTOM)
    line:DockMargin(0, 10, 0, 10)
    line.Paint = function(self, w, h)
        local roleColors = HG_UI.GetRoleColors()
        surface.SetDrawColor(roleColors.PRIMARY.r, roleColors.PRIMARY.g, roleColors.PRIMARY.b, 100)
        surface.DrawRect(0, 0, w, h)
    end

    local scroll = vgui.Create("DScrollPanel", LevelMenuFrame)
    scroll:SetPos(padding, topPanel:GetY() + topPanel:GetTall())
    scroll:SetSize(width - padding * 2, height - scroll:GetY() - padding)

    HG_UI.StyleScrollPanel(scroll)

    local layout = vgui.Create("DListLayout", scroll)
    layout:Dock(FILL)

    if not LevelList or #LevelList == 0 then
        local label = vgui.Create("DLabel", layout)
        label:SetText("Список уровней пуст.")
        label:SetTextColor(HG_UI.COLORS.TEXT_PRIMARY)
        label:SetFont(HG_UI.FONTS.NORMAL)
        label:SetContentAlignment(5)
        label:Dock(TOP)
        label:DockMargin(0, 0, 0, 10)
        label:SetAutoStretchVertical(true)
        return
    end

    for _, level in ipairs(LevelList) do
        local btn = HG_UI.CreateStyledButton(layout, "", {
            dock = TOP,
            margin = {0, 0, 0, 8},
            height = 45,
            onClick = function()
                net.Start("HGLEVEL_NEXT_COMMAND")
                net.WriteString(level)
                net.SendToServer()
                LevelMenuFrame:Close()
                if IsValid(HomicideSettingsFrame) then HomicideSettingsFrame:Close() end
            end
        })
        
        btn.Paint = function(self, w, h)
            local hover = self:IsHovered()
            local isSelected = (roundActiveNameNext == level)
            local roleColors = HG_UI.GetRoleColors()
            
            local bg
            if isSelected then
                bg = Color(50, 80, 50, 220)
            elseif hover then
                bg = Color(35, 35, 35, 200)
            else
                bg = Color(25, 25, 25, 180)
            end
            
            draw.RoundedBox(0, 0, 0, w, h, bg)
            
            local borderColor
            if isSelected then
                borderColor = Color(100, 255, 100, 255)
            else
                borderColor = Color(roleColors.PRIMARY.r, roleColors.PRIMARY.g, roleColors.PRIMARY.b, hover and 255 or 180)
            end
            surface.SetDrawColor(borderColor.r, borderColor.g, borderColor.b, borderColor.a)
            surface.DrawOutlinedRect(0, 0, w, h)
            
            if isSelected then
                surface.DrawOutlinedRect(1, 1, w-2, h-2)
            end
            
            local textColor = isSelected and Color(150, 255, 150) or HG_UI.COLORS.TEXT_PRIMARY
            draw.SimpleText(string.upper(level), HG_UI.FONTS.NORMAL, w/2, h/2, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            
            if isSelected then
                draw.SimpleText("✓", HG_UI.FONTS.NORMAL, w - 20, h/2, Color(100, 255, 100), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        end
    end

    HomicideSettingsFrame = CreateHomicideSettingsPanel(LevelMenuFrame)
    LevelMenuFrame.OnClose = function()
        if IsValid(HomicideSettingsFrame) then
            HomicideSettingsFrame:Close()
        end
    end
end

concommand.Add("open_level_menu", OpenLevelMenu)

local isF4Pressed = false
hook.Add("Think", "CheckF4Press", function()
    if input.IsKeyDown(KEY_F4) and not isF4Pressed then
        isF4Pressed = true
        OpenLevelMenu()
    elseif not input.IsKeyDown(KEY_F4) then
        isF4Pressed = false
    end
end)