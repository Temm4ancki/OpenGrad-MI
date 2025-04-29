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

-- Функция открытия меню
local function OpenLevelMenu()
    local ply = LocalPlayer()

    -- Проверка: является ли игрок администратором
    if not IsValid(ply) or not ply:IsAdmin() then
        notification.AddLegacy("У вас нет прав для открытия этого меню.", NOTIFY_ERROR, 5)
        surface.PlaySound("buttons/button10.wav")
        return
    end

    -- Убиваем старое окно, если оно есть
    if IsValid(LevelMenuFrame) then
        LevelMenuFrame:Remove()
    end

    -- Создаём основное окно
    LevelMenuFrame = vgui.Create("DFrame")
    LevelMenuFrame:SetSize(300, 450) -- увеличенная высота под новую кнопку
    LevelMenuFrame:Center()
    LevelMenuFrame:MakePopup()
    LevelMenuFrame:SetTitle("Выбор режима")

    -- Создаём прокручиваемую панель
    local scroll = vgui.Create("DScrollPanel", LevelMenuFrame)
    scroll:Dock(FILL)
    scroll:DockMargin(5, 5, 5, 5)

    -- Контейнер для кнопок
    local layout = vgui.Create("DListLayout", scroll)
    layout:Dock(FILL)

    -- === КНОПКА ЗАВЕРШИТЬ РАУНД ===
    local endRoundButton = vgui.Create("DButton")
    endRoundButton:SetText("Завершить раунд")
    endRoundButton:SetTall(35)
    endRoundButton:SetTextColor(Color(200, 0, 0))
    endRoundButton.DoClick = function()
        net.Start("HGLEVEL_END_COMMAND")
        net.SendToServer()
        LevelMenuFrame:Close()
    end
    layout:Add(endRoundButton)

    -- Разделитель
    local separator = vgui.Create("DPanel")
    separator:SetPaintBackground(false)
    separator:SetHeight(10)
    layout:Add(separator)

    -- Если уровень нет
    if #LevelList == 0 then
        local label = vgui.Create("DLabel")
        label:SetText("Список уровней пуст.")
        label:SetContentAlignment(5)
        label:SizeToContents()
        layout:Add(label)
        return
    end

    -- Добавляем кнопки для всех уровней
    for _, level in ipairs(LevelList) do
        local button = vgui.Create("DButton")
        button:SetText(level)
        button:SetTall(30)
        button.DoClick = function()
            net.Start("HGLEVEL_NEXT_COMMAND")
                net.WriteString(level)
            net.SendToServer()
            LevelMenuFrame:Close()
        end
        layout:Add(button)
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