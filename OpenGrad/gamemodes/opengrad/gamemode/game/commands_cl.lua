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

    LevelMenuFrame = HG_UI.CreateStyledFrame("Управление раундом", width, height, {
        titleY = 35,
        titleFont = HG_UI.FONTS.TITLE
    })

    -- Верхняя панель с кнопкой вне скролла
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

    -- Скроллируемая область с уровнями
    local scroll = vgui.Create("DScrollPanel", LevelMenuFrame)
    scroll:SetPos(padding, topPanel:GetY() + topPanel:GetTall())
    scroll:SetSize(width - padding * 2, height - scroll:GetY() - padding)

    -- Стилизация скроллбара
    HG_UI.StyleScrollPanel(scroll)

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
        HG_UI.CreateStyledButton(layout, string.upper(level), {
            textColor = HG_UI.COLORS.TEXT_SECONDARY,
            font = HG_UI.FONTS.SMALL,
            dock = TOP,
            margin = {0, 0, 0, 10},
            onClick = function()
                net.Start("HGLEVEL_NEXT_COMMAND")
                net.WriteString(level)
                net.SendToServer()
                LevelMenuFrame:Close()
            end
        })
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