-- Weapon Selector Menu
if SERVER then return end

-- Используем общую библиотеку UI
include("homigrad_scr/game/tier_1/ui_library_cl.lua")

surface.CreateFont("WeaponSelectorTitle", {
    font = "Roboto",
    size = 24,
    weight = 800,
    outline = true,
    shadow = true
})

surface.CreateFont("WeaponSelectorSlot", {
    font = "Roboto",
    size = 20,
    weight = 600,
    outline = true,
    shadow = true
})

surface.CreateFont("WeaponSelectorWeapon", {
    font = "Roboto",
    size = 18,
    weight = 500,
    outline = true,
    shadow = true
})

surface.CreateFont("WeaponSelectorAmmo", {
    font = "Roboto",
    size = 14,
    weight = 500,
    outline = true,
    shadow = true
})

surface.CreateFont("WeaponInfoTitle", {
    font = "Roboto",
    size = 20,
    weight = 700,
    outline = true,
    shadow = true
})

surface.CreateFont("WeaponInfoText", {
    font = "Roboto",
    size = 16,
    weight = 500,
    outline = true,
    shadow = true
})

surface.CreateFont("WeaponInfoSmall", {
    font = "Roboto",
    size = 14,
    weight = 400,
    outline = true,
    shadow = true
})

local WeaponSelector = {}
WeaponSelector.Show = false
WeaponSelector.SelectedSlot = 1
WeaponSelector.SelectedWeapon = 1
WeaponSelector.LastActivity = 0
WeaponSelector.FadeTime = 2
WeaponSelector.Alpha = 0
WeaponSelector.Weapons = {}

local function GetRoleColors()
    local roleColors = HG_UI.GetRoleColors()
    return {
        SELECTED = roleColors.PRIMARY,
        HOVER = roleColors.HOVER,
        INFO_BORDER = roleColors.BORDER
    }
end

local COLOR_BACKGROUND = Color(0, 0, 0, 200)
local COLOR_TEXT = Color(255, 255, 255, 255)
local COLOR_AMMO = Color(255, 200, 0, 255)
local COLOR_EMPTY = Color(255, 80, 80, 255)
local COLOR_INFO_BG = Color(0, 0, 0, 200)

local WEAPON_3D_OFFSET_Y = -25

local WEAPON_3D_POSITIONS = {
    ["med_band_small"] = {
        offset_x = 0,
        offset_y = -35
    },
    ["med_band_big"] = {
        offset_x = 0,
        offset_y = -35
    },
    ["weapon_mask"] = {
        pos = Vector(0, 0, 0),
        ang = Angle(0, 90, 0),
        scale = 1.5,
        offset_x = 0,
        offset_y = -50
    },
    ["weapon_s_deserteagle"] = {
        pos = Vector(0, 0, 0),
        ang = Angle(0, 90, 0),
        scale = 0.5,
        offset_x = 0,
        offset_y = -10
    },
    ["weapon_s_p90"] = {
        pos = Vector(0, 0, 0),
        ang = Angle(0, 90, 0),
        scale = 0.5,
        offset_x = 0,
        offset_y = -20
    },
}

local WEAPON_ICONS = {
    ["weapon_hands"] = "vgui/wep_jack_hmcd_hands",
}

-- Функция для получения оружия по слотам
local function GetWeaponsBySlots()
    local ply = LocalPlayer()
    if not IsValid(ply) then return {} end

    local weapons = {}
    for i = 0, 6 do
        weapons[i] = {}
    end

    for _, wep in pairs(ply:GetWeapons()) do
        if IsValid(wep) then
            local slot = wep:GetSlot()
            if slot >= 0 and slot <= 6 then
                table.insert(weapons[slot], wep)
            end
        end
    end

    for slot, weps in pairs(weapons) do
        table.sort(weps, function(a, b)
            return a:GetSlotPos() < b:GetSlotPos()
        end)
    end

    return weapons
end

local function DrawWeapon3D(wep, wepTable, x, y, w, h)
    if not wepTable then return end

    local wepClass = wep:GetClass()
    local customPos = WEAPON_3D_POSITIONS[wepClass]

    if customPos then
        local oldDrawWeaponSelection = DrawWeaponSelection
        DrawWeaponSelection = function(wepTbl, drawX, drawY, drawW, drawH, alpha)
            local finalX = drawX + (customPos.offset_x or 0)
            local finalY = drawY + (customPos.offset_y ~= nil and customPos.offset_y or WEAPON_3D_OFFSET_Y)

            local origPos = wepTbl.WepSelectPos
            local origAng = wepTbl.WepSelectAng
            local origScale = wepTbl.WepSelectScale

            if customPos.pos then wepTbl.WepSelectPos = customPos.pos end
            if customPos.ang then wepTbl.WepSelectAng = customPos.ang end
            if customPos.scale ~= nil then wepTbl.WepSelectScale = customPos.scale end

            oldDrawWeaponSelection(wepTbl, finalX, finalY, drawW, drawH, alpha)

            wepTbl.WepSelectPos = origPos
            wepTbl.WepSelectAng = origAng
            wepTbl.WepSelectScale = origScale
        end

        DrawWeaponSelection(wepTable, x, y, w, h, WeaponSelector.Alpha / 255)

        DrawWeaponSelection = oldDrawWeaponSelection
    else
        DrawWeaponSelection(wepTable, x, y + WEAPON_3D_OFFSET_Y, w, h, WeaponSelector.Alpha / 255)
    end
end

-- Функция для отрисовки оружия с 3D моделью или иконкой
local function DrawWeaponIcon(wep, x, y, w, h, selected)
    if not IsValid(wep) then return end

    local bgColor = selected and GetRoleColors().SELECTED or COLOR_BACKGROUND
    bgColor.a = selected and 255 or 200

    draw.RoundedBox(0, x, y, w, h, bgColor)

    local roleColors = GetRoleColors()
    surface.SetDrawColor(roleColors.SELECTED.r, roleColors.SELECTED.g, roleColors.SELECTED.b, selected and 255 or 180)
    for i = 0, (selected and 2 or 1) do
        surface.DrawOutlinedRect(x - i, y - i, w + i*2, h + i*2)
    end

    local wepClass = wep:GetClass()
    local wepTable = weapons.Get(wepClass)

    local iconPath = WEAPON_ICONS[wepClass]
    if iconPath then
        if iconPath == "wepselecticon" and wepTable and wepTable.WepSelectIcon then
            surface.SetMaterial(Material(wepTable.WepSelectIcon))
            surface.SetDrawColor(255, 255, 255, WeaponSelector.Alpha)
            surface.DrawTexturedRect(x + 10, y + 10, w - 20, h - 30)
        elseif iconPath ~= "wepselecticon" then
            local mat = Material(iconPath, "noclamp smooth")
            if mat and not mat:IsError() then
                surface.SetMaterial(mat)
                surface.SetDrawColor(255, 255, 255, WeaponSelector.Alpha)
                surface.DrawTexturedRect(x + 10, y + 10, w - 20, h - 30)
            else
                DrawWeapon3D(wep, wepTable, x, y, w, h)
            end
        else
            DrawWeapon3D(wep, wepTable, x, y, w, h)
        end
    else
        DrawWeapon3D(wep, wepTable, x, y, w, h)
    end

    local name = wep:GetPrintName() or wep:GetClass()
    draw.SimpleText(name, "WeaponSelectorWeapon", x + w/2, y + h - 15, COLOR_TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

-- Функция для получения информации об оружии
local function GetWeaponInfo(wep)
    if not IsValid(wep) then return nil end

    local info = {}
    local wepTable = weapons.Get(wep:GetClass())

    -- Основная информация
    info.PrintName = wep:GetPrintName() or wep:GetClass()
    info.Category = wepTable and wepTable.Category or "Неизвестно"
    info.Instructions = wepTable and wepTable.Instructions or ""
    info.Purpose = wepTable and wepTable.Purpose or ""
    info.Author = wepTable and wepTable.Author or ""

    -- Характеристики оружия
    info.Primary = wepTable and wepTable.Primary or {}
    info.Secondary = wepTable and wepTable.Secondary or {}

    -- Патроны
    info.Clip1 = wep:Clip1()
    info.Clip2 = wep:Clip2()
    info.Ammo1 = LocalPlayer():GetAmmoCount(wep:GetPrimaryAmmoType())
    info.Ammo2 = LocalPlayer():GetAmmoCount(wep:GetSecondaryAmmoType())
    info.AmmoType1 = game.GetAmmoName(wep:GetPrimaryAmmoType()) or ""
    info.AmmoType2 = game.GetAmmoName(wep:GetSecondaryAmmoType()) or ""

    if wepTable then
        info.Damage = wepTable.Primary and wepTable.Primary.Damage or 0
        info.NumShots = wepTable.Primary and wepTable.Primary.NumShots or 1
        info.Recoil = wepTable.Primary and wepTable.Primary.Recoil or 0
        info.Cone = wepTable.Primary and wepTable.Primary.Cone or 0
        info.Delay = wepTable.Primary and wepTable.Primary.Delay or 0
        info.Automatic = wepTable.Primary and wepTable.Primary.Automatic or false
        info.ClipSize = wepTable.Primary and wepTable.Primary.ClipSize or 0
        info.DefaultClip = wepTable.Primary and wepTable.Primary.DefaultClip or 0
    end

    return info
end

local function DrawWrappedText(text, font, x, y, maxWidth, color)
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

local function GetWrappedTextHeight(text, font, maxWidth)
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

local function CalculateInfoHeight(wep, w)
    if not IsValid(wep) then return 100 end

    local info = GetWeaponInfo(wep)
    if not info then return 100 end

    local currentY = 15
    local padding = 10
    local lineHeight = 20

    currentY = currentY + 25

    if info.Category ~= "" and info.Category ~= "Неизвестно" then
        currentY = currentY + lineHeight
    end

    if info.Author ~= "" then
        currentY = currentY + lineHeight
    end

    currentY = currentY + 5

    if info.Clip1 >= 0 or info.Ammo1 > 0 then
        currentY = currentY + lineHeight

        if info.Ammo1 > 0 then
            currentY = currentY + lineHeight - 2
        end

        currentY = currentY + 5
    end

    if info.Purpose ~= "" then
        currentY = currentY + lineHeight
        currentY = currentY + GetWrappedTextHeight(info.Purpose, "WeaponInfoSmall", w - padding * 2)
        currentY = currentY + 5
    end

    if info.Instructions ~= "" then
        currentY = currentY + lineHeight
        currentY = currentY + GetWrappedTextHeight(info.Instructions, "WeaponInfoSmall", w - padding * 2)
    end

    return currentY + 15
end

local function DrawWeaponInfo(wep, x, y, w, h)
    if not IsValid(wep) then return end

    local info = GetWeaponInfo(wep)
    if not info then return end

    draw.RoundedBox(0, x, y, w, h, COLOR_INFO_BG)

    local roleColors = GetRoleColors()
    surface.SetDrawColor(roleColors.INFO_BORDER.r, roleColors.INFO_BORDER.g, roleColors.INFO_BORDER.b, roleColors.INFO_BORDER.a)
    for i = 0, 2 do
        surface.DrawOutlinedRect(x - i, y - i, w + i*2, h + i*2)
    end

    local currentY = y + 15
    local padding = 10
    local lineHeight = 20

    draw.SimpleText(info.PrintName, "WeaponInfoTitle", x + padding, currentY, COLOR_TEXT, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    currentY = currentY + 25

    if info.Category ~= "" and info.Category ~= "Неизвестно" then
        draw.SimpleText("Категория: " .. info.Category, "WeaponInfoSmall", x + padding, currentY, Color(200, 200, 200, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        currentY = currentY + lineHeight
    end

    if info.Author ~= "" then
        draw.SimpleText("Автор: " .. info.Author, "WeaponInfoSmall", x + padding, currentY, Color(200, 200, 200, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        currentY = currentY + lineHeight
    end

    currentY = currentY + 5

    if info.Clip1 >= 0 or info.Ammo1 > 0 then
        draw.SimpleText("ПАТРОНЫ", "WeaponInfoText", x + padding, currentY, COLOR_AMMO, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        currentY = currentY + lineHeight

        if info.Ammo1 > 0 then
            draw.SimpleText("Тип: (" .. info.AmmoType1 .. ")", "WeaponInfoSmall", x + padding + 10, currentY, COLOR_TEXT, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            currentY = currentY + lineHeight - 2
        end

        currentY = currentY + 5
    end

    if info.Purpose ~= "" then
        draw.SimpleText("НАЗНАЧЕНИЕ", "WeaponInfoText", x + padding, currentY, Color(255, 200, 100, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        currentY = currentY + lineHeight
        currentY = DrawWrappedText(info.Purpose, "WeaponInfoSmall", x + padding + 10, currentY, w - padding * 2, Color(220, 220, 220, 255))
        currentY = currentY + 5
    end

    if info.Instructions ~= "" then
        draw.SimpleText("ИНСТРУКЦИИ", "WeaponInfoText", x + padding, currentY, Color(100, 200, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        currentY = currentY + lineHeight
        currentY = DrawWrappedText(info.Instructions, "WeaponInfoSmall", x + padding + 10, currentY, w - padding * 2, Color(220, 220, 220, 255))
    end
end

-- Основная функция отрисовки
local function DrawWeaponSelector()
    if not WeaponSelector.Show then
        WeaponSelector.Alpha = math.max(0, WeaponSelector.Alpha - FrameTime() * 500)
        if WeaponSelector.Alpha <= 0 then return end
    else
        WeaponSelector.Alpha = math.min(255, WeaponSelector.Alpha + FrameTime() * 500)
    end

    local ply = LocalPlayer()
    if not IsValid(ply) or not ply:Alive() then
        WeaponSelector.Show = false
        return
    end

    -- Обновляем список оружия
    WeaponSelector.Weapons = GetWeaponsBySlots()

    local scrW, scrH = ScrW(), ScrH()
    local slotWidth = 120
    local slotSpacing = 10
    local weaponHeight = 80
    local weaponSpacing = 5
    local startY = 60

    local nonEmptySlots = 0
    for slot = 0, 6 do
        if #WeaponSelector.Weapons[slot] > 0 then
            nonEmptySlots = nonEmptySlots + 1
        end
    end

    local totalWidth = nonEmptySlots * slotWidth + (nonEmptySlots - 1) * slotSpacing
    local infoWidth = 350
    local infoSpacing = 20
    local selectorWidth = totalWidth + infoSpacing + infoWidth
    local startX = (scrW - selectorWidth) / 2
    local currentSlotIndex = 0

    local selectedWeapon = nil
    local selectedWeapons = WeaponSelector.Weapons[WeaponSelector.SelectedSlot]
    if selectedWeapons and selectedWeapons[WeaponSelector.SelectedWeapon] then
        selectedWeapon = selectedWeapons[WeaponSelector.SelectedWeapon]
    end

    -- Отрисовка слотов
    for slot = 0, 6 do
        local weapons = WeaponSelector.Weapons[slot]
        if #weapons > 0 then
            local slotX = startX + (currentSlotIndex * (slotWidth + slotSpacing))
            currentSlotIndex = currentSlotIndex + 1

            local slotAlpha = WeaponSelector.Alpha
            if slot == WeaponSelector.SelectedSlot then
                slotAlpha = 255
            end

            draw.SimpleText("Слот " .. (slot + 1), "WeaponSelectorSlot", slotX + slotWidth/2, startY - 30, 
                Color(COLOR_TEXT.r, COLOR_TEXT.g, COLOR_TEXT.b, slotAlpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

            for idx, wep in ipairs(weapons) do
                local weaponY = startY + ((idx - 1) * (weaponHeight + weaponSpacing))
                local selected = (slot == WeaponSelector.SelectedSlot and idx == WeaponSelector.SelectedWeapon)

                DrawWeaponIcon(wep, slotX, weaponY, slotWidth, weaponHeight, selected)
            end
        end
    end

    if IsValid(selectedWeapon) then
        local infoX = startX + totalWidth + infoSpacing
        local infoY = startY
        local infoHeight = CalculateInfoHeight(selectedWeapon, infoWidth)

        -- Отключено плавное появление/исчезание для инфобокса - всегда полная непрозрачность
        DrawWeaponInfo(selectedWeapon, infoX, infoY, infoWidth, infoHeight)
    end

    if WeaponSelector.Show and CurTime() - WeaponSelector.LastActivity > WeaponSelector.FadeTime then
        WeaponSelector.Show = false
    end
end

local function SelectWeapon()
    local ply = LocalPlayer()
    if not IsValid(ply) then return end

    local weapons = WeaponSelector.Weapons[WeaponSelector.SelectedSlot]
    if weapons and weapons[WeaponSelector.SelectedWeapon] then
        local wep = weapons[WeaponSelector.SelectedWeapon]
        if IsValid(wep) then
            input.SelectWeapon(wep)
            WeaponSelector.Show = false
        end
    end
end

-- Функция переключения слота
local function SwitchSlot(slot)
    WeaponSelector.Weapons = GetWeaponsBySlots()
    WeaponSelector.LastActivity = CurTime()

    local weapons = WeaponSelector.Weapons[slot]
    if not weapons or #weapons == 0 then
        for i = 1, 7 do
            local nextSlot = (slot + i) % 7
            weapons = WeaponSelector.Weapons[nextSlot]
            if weapons and #weapons > 0 then
                slot = nextSlot
                break
            end
        end
    end

    if WeaponSelector.SelectedSlot == slot then
        WeaponSelector.SelectedWeapon = WeaponSelector.SelectedWeapon + 1
        if WeaponSelector.SelectedWeapon > #weapons then
            WeaponSelector.SelectedWeapon = 1
        end
    else
        WeaponSelector.SelectedSlot = slot
        WeaponSelector.SelectedWeapon = 1
    end
end

local function SwitchWeapon(delta)
    local allWeapons = {}
    local currentIndex = 0
    local foundCurrent = false

    for slot = 0, 6 do
        local weapons = WeaponSelector.Weapons[slot]
        if weapons then
            for idx, wep in ipairs(weapons) do
                table.insert(allWeapons, {slot = slot, idx = idx, weapon = wep})
                if slot == WeaponSelector.SelectedSlot and idx == WeaponSelector.SelectedWeapon then
                    currentIndex = #allWeapons
                    foundCurrent = true
                end
            end
        end
    end

    if #allWeapons == 0 then return end

    if not foundCurrent then
        currentIndex = 1
    else
        currentIndex = currentIndex + delta
        if currentIndex > #allWeapons then
            currentIndex = 1
        elseif currentIndex < 1 then
            currentIndex = #allWeapons
        end
    end

    local selected = allWeapons[currentIndex]
    if selected then
        WeaponSelector.SelectedSlot = selected.slot
        WeaponSelector.SelectedWeapon = selected.idx
        WeaponSelector.LastActivity = CurTime()
    end
end

hook.Add("HUDPaint", "DrawWeaponSelector", DrawWeaponSelector)

hook.Add("PlayerBindPress", "WeaponSelectorBindPress", function(ply, bind, pressed)
    if not pressed then return end

    if bind == "invnext" then
        if not WeaponSelector.Show then
            WeaponSelector.Show = true
            WeaponSelector.Weapons = GetWeaponsBySlots()
            WeaponSelector.LastActivity = CurTime()
        end
        SwitchWeapon(1)
        return true
    elseif bind == "invprev" then
        if not WeaponSelector.Show then
            WeaponSelector.Show = true
            WeaponSelector.Weapons = GetWeaponsBySlots()
            WeaponSelector.LastActivity = CurTime()
        end
        SwitchWeapon(-1)
        return true
    end

    for i = 1, 6 do
        if bind == "slot" .. i then
            WeaponSelector.Show = true
            WeaponSelector.Weapons = GetWeaponsBySlots()
            SwitchSlot(i - 1)
            return true
        end
    end

    if bind == "+attack" and WeaponSelector.Show then
        SelectWeapon()
        return true
    end

    if bind == "+attack2" and WeaponSelector.Show then
        WeaponSelector.Show = false
        return true
    end
end)

hook.Add("PlayerDeath", "HideWeaponSelector", function(victim)
    if victim == LocalPlayer() then
        WeaponSelector.Show = false
    end
end)

-- Альтернативный способ выбора через клавиши
hook.Add("Think", "WeaponSelectorThink", function()
    if not WeaponSelector.Show then return end

    local ply = LocalPlayer()
    if not IsValid(ply) or not ply:Alive() then
        WeaponSelector.Show = false
        return
    end

    if input.IsKeyDown(KEY_ENTER) then
        SelectWeapon()
    end

    if input.IsKeyDown(KEY_ESCAPE) then
        WeaponSelector.Show = false
    end
end)