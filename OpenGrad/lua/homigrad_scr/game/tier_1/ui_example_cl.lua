-- Пример использования библиотеки HG_UI
-- Этот файл демонстрирует, как использовать новую библиотеку интерфейса

if SERVER then return end

-- Подключаем библиотеку
include("homigrad_scr/game/tier_1/ui_library_cl.lua")

-- Пример создания простого меню
local function CreateExampleMenu()
    -- Создаем стилизованное окно
    local frame = HG_UI.CreateStyledFrame("Пример меню", 400, 300, {
        titleY = 20,
        titleFont = HG_UI.FONTS.HEADER
    })

    -- Создаем панель с информацией
    local infoPanel = HG_UI.CreateInfoPanel(frame, 20, 60, 360, 40, {
        text = "Это пример использования библиотеки HG_UI",
        font = HG_UI.FONTS.NORMAL
    })

    -- Создаем кнопки
    local buttonPanel = vgui.Create("Panel", frame)
    buttonPanel:SetPos(20, 120)
    buttonPanel:SetSize(360, 120)

    HG_UI.CreateStyledButton(buttonPanel, "Обычная кнопка", {
        dock = TOP,
        margin = {0, 0, 0, 10},
        onClick = function()
            LocalPlayer():ChatPrint("Нажата обычная кнопка!")
        end
    })

    HG_UI.CreateStyledButton(buttonPanel, "Кнопка с ошибкой", {
        textColor = HG_UI.COLORS.ERROR,
        dock = TOP,
        margin = {0, 0, 0, 10},
        onClick = function()
            LocalPlayer():ChatPrint("Нажата кнопка с ошибкой!")
        end
    })

    HG_UI.CreateStyledButton(buttonPanel, "Успешная кнопка", {
        textColor = HG_UI.COLORS.SUCCESS,
        dock = TOP,
        margin = {0, 0, 0, 10},
        onClick = function()
            LocalPlayer():ChatPrint("Нажата успешная кнопка!")
        end
    })

    -- Кнопка закрытия
    HG_UI.CreateStyledButton(frame, "Закрыть", {
        textColor = HG_UI.COLORS.TEXT_MUTED,
        onClick = function()
            frame:Close()
        end
    }):SetPos(320, 260)
end

-- Команда для тестирования
concommand.Add("hg_ui_example", CreateExampleMenu)

-- Пример создания меню с прокруткой
local function CreateScrollExample()
    local frame = HG_UI.CreateStyledFrame("Пример с прокруткой", 300, 400)

    local scroll = vgui.Create("DScrollPanel", frame)
    scroll:SetPos(20, 60)
    scroll:SetSize(260, 300)

    -- Стилизуем скроллбар
    HG_UI.StyleScrollPanel(scroll)

    local layout = vgui.Create("DListLayout", scroll)
    layout:Dock(FILL)

    -- Добавляем много кнопок для демонстрации прокрутки
    for i = 1, 20 do
        HG_UI.CreateStyledButton(layout, "Кнопка " .. i, {
            dock = TOP,
            margin = {0, 0, 0, 5},
            onClick = function()
                LocalPlayer():ChatPrint("Нажата кнопка " .. i)
            end
        })
    end
end

concommand.Add("hg_ui_scroll_example", CreateScrollExample)

-- Пример создания контекстного меню
local function CreateContextMenuExample()
    local menu = HG_UI.CreateMenu()

    HG_UI.AddMenuOption(menu, "Опция 1", function()
        LocalPlayer():ChatPrint("Выбрана опция 1")
    end)

    HG_UI.AddMenuOption(menu, "Опция 2", function()
        LocalPlayer():ChatPrint("Выбрана опция 2")
    end, {
        color = HG_UI.COLORS.ERROR
    })

    HG_UI.AddMenuOption(menu, "Опция 3", function()
        LocalPlayer():ChatPrint("Выбрана опция 3")
    end, {
        color = HG_UI.COLORS.SUCCESS
    })

    menu:MakePopup()
end

concommand.Add("hg_ui_context_example", CreateContextMenuExample)

print("[HG_UI] Примеры использования загружены. Команды: hg_ui_example, hg_ui_scroll_example, hg_ui_context_example")