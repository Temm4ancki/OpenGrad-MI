# Библиотека HG_UI для OpenGrad

Эта библиотека предоставляет унифицированные функции для создания интерфейсов в OpenGrad, устраняя дублирование кода и обеспечивая единообразный стиль.

## Подключение

```lua
include("homigrad_scr/game/tier_1/ui_library_cl.lua")
```

## Основные компоненты

### Цвета (HG_UI.COLORS)

- `PRIMARY` - Основной цвет (зеленый)
- `BACKGROUND` - Цвет фона
- `PANEL_BG` - Цвет панелей
- `BUTTON_BG` - Цвет кнопок
- `BUTTON_HOVER` - Цвет кнопок при наведении
- `BUTTON_SELECTED` - Цвет выбранных кнопок
- `TEXT_PRIMARY` - Основной цвет текста
- `TEXT_SECONDARY` - Вторичный цвет текста
- `TEXT_MUTED` - Приглушенный цвет текста
- `SUCCESS` - Цвет успеха (зеленый)
- `ERROR` - Цвет ошибки (красный)
- `WARNING` - Цвет предупреждения (желтый)
- `SPEC` - Цвет наблюдателей

### Шрифты (HG_UI.FONTS)

- `TITLE` - Заголовок (32px)
- `HEADER` - Заголовок раздела (28px)
- `BIG` - Большой текст (25px)
- `NORMAL` - Обычный текст (18px)
- `SMALL` - Мелкий текст (15px)

## Основные функции

### HG_UI.CreateStyledFrame(title, width, height, options)

Создает стилизованное окно с размытием фона.

**Параметры:**
- `title` - заголовок окна
- `width`, `height` - размеры
- `options` - таблица опций:
  - `titleY` - позиция заголовка по Y
  - `titleFont` - шрифт заголовка
  - `titleColor` - цвет заголовка
  - `bgColor` - цвет фона
  - `borderColor` - цвет обводки
  - `blur` - включить размытие (по умолчанию true)
  - `showClose` - показать кнопку закрытия (по умолчанию true)
  - `draggable` - возможность перетаскивания (по умолчанию true)

**Пример:**
```lua
local frame = HG_UI.CreateStyledFrame("Мое меню", 400, 300, {
    titleY = 20,
    titleFont = HG_UI.FONTS.HEADER
})
```

### HG_UI.CreateStyledButton(parent, text, options)

Создает стилизованную кнопку.

**Параметры:**
- `parent` - родительский элемент
- `text` - текст кнопки
- `options` - таблица опций:
  - `textColor` - цвет текста
  - `font` - шрифт
  - `height` - высота кнопки
  - `dock` - тип докинга
  - `margin` - отступы {left, top, right, bottom}
  - `bgColor` - цвет фона
  - `hoverColor` - цвет при наведении
  - `selectedColor` - цвет выбранной кнопки
  - `borderColor` - цвет обводки
  - `selected` - функция, возвращающая состояние выбора
  - `onClick` - функция обработки клика

**Пример:**
```lua
HG_UI.CreateStyledButton(parent, "Нажми меня", {
    textColor = HG_UI.COLORS.SUCCESS,
    dock = TOP,
    margin = {0, 0, 0, 10},
    onClick = function()
        print("Кнопка нажата!")
    end
})
```

### HG_UI.StyleScrollPanel(scroll, options)

Стилизует панель прокрутки.

**Параметры:**
- `scroll` - DScrollPanel для стилизации
- `options` - опции стилизации

**Пример:**
```lua
local scroll = vgui.Create("DScrollPanel", parent)
HG_UI.StyleScrollPanel(scroll)
```

### HG_UI.CreateInfoPanel(parent, x, y, w, h, options)

Создает информационную панель.

**Пример:**
```lua
local panel = HG_UI.CreateInfoPanel(parent, 20, 60, 300, 40, {
    text = "Информационное сообщение",
    font = HG_UI.FONTS.NORMAL
})
```

### HG_UI.BlurBackground(panel, strength)

Применяет размытие фона к панели.

**Параметры:**
- `panel` - панель для размытия
- `strength` - сила размытия (по умолчанию 1)

### HG_UI.ResetBlur()

Сбрасывает силу размытия.

### HG_UI.DrawFrame(x, y, w, h, color, borderColor, borderWidth)

Рисует рамку с обводкой.

### HG_UI.DrawPanel(x, y, w, h, color, borderColor)

Рисует панель с обводкой.

## Функции для работы с текстом

### HG_UI.DrawWrappedText(text, font, x, y, maxWidth, color)

Рисует текст с переносом строк.

### HG_UI.GetWrappedTextHeight(text, font, maxWidth)

Возвращает высоту текста с переносом строк.

## Утилиты

### HG_UI.CreateMenu(options)

Создает контекстное меню.

### HG_UI.AddMenuOption(menu, text, func, options)

Добавляет опцию в меню.

### HG_UI.GetRoleColors(ply)

Возвращает цвета в зависимости от роли игрока и режима игры.

**Логика работы:**
- Если игрок является предателем (`ply.roleT`) И текущий режим - Homicide (определяется через `TableRound().Name == "Homicide"`), возвращает красные цвета (155, 55, 55)
- В остальных случаях использует цвет игрока (`ply:GetPlayerColor()`) с увеличенной яркостью для лучшей видимости в UI
- Если цвет игрока не задан или равен черному, использует стандартный зеленый цвет

**Параметры:**
- `ply` - игрок (по умолчанию LocalPlayer())

**Возвращает:**
Таблицу с цветами: `{PRIMARY, HOVER, BORDER}`

**Автоматическое использование:**
Все функции библиотеки (кнопки, рамки, панели, скроллбары, меню) автоматически используют `HG_UI.GetRoleColors()` для определения цветов, если не указаны конкретные цвета.

## Обратная совместимость

Библиотека предоставляет функции для обратной совместимости:

- `BlurBackground(panel, strength)` - алиас для `HG_UI.BlurBackground`
- `StyledButton(parent, text, color, font, onclick)` - алиас для `HG_UI.CreateStyledButton`

## Миграция существующего кода

### Было:
```lua
surface.CreateFont("MyFont", {...})
local function BlurBackground(panel) ... end
local function StyledButton(...) ... end
```

### Стало:
```lua
include("homigrad_scr/game/tier_1/ui_library_cl.lua")
-- Используем HG_UI.FONTS.NORMAL вместо создания шрифтов
-- Используем HG_UI.CreateStyledButton вместо собственной функции
```

## Примеры использования

Смотрите файл `ui_example_cl.lua` для полных примеров использования библиотеки.

Команды для тестирования:
- `hg_ui_example` - простое меню
- `hg_ui_scroll_example` - меню с прокруткой
- `hg_ui_context_example` - контекстное меню