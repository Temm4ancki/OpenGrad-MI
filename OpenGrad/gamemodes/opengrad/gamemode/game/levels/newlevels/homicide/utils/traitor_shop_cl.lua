if SERVER then return end

include("homigrad_scr/game/tier_1/ui_library_cl.lua")

TraitorShop = {}
TraitorShop.Credits = 0
TraitorShop.IsOpen = false

local selectedCategory = "Оружие"
local selectedItem = nil
local selectedPreset = nil
local presetsList = {}

net.Receive("traitor_shop_credits", function()
    TraitorShop.Credits = net.ReadInt(8)
end)

net.Receive("traitor_shop_presets", function()
    presetsList = net.ReadTable()
end)

local function GetItemInfo(itemClass)
    if string.StartWith(itemClass, "ability_") then
        local abilityData = HomicideAbilities and HomicideAbilities[itemClass]
        if abilityData then
            return {
                PrintName = abilityData.name,
                Purpose = abilityData.description,
                IconOverride = abilityData.icon,
            }
        end
        return {
            PrintName = itemClass,
            Purpose = "Особая способность",
            IconOverride = "vgui/icon/ability.png",
        }
    end

    local wepTable = weapons.Get(itemClass)
    if wepTable then
        return {
            PrintName = wepTable.PrintName or itemClass,
            Purpose = wepTable.Purpose or "",
            IconOverride = wepTable.IconOverride,
            Instructions = wepTable.Instructions or "Неизвестно"
        }
    end
    return {
        PrintName = itemClass,
        Purpose = "Информация недоступна",
        IconOverride = nil,
        Instructions = "Неизвестно"
    }
end

local function DrawItemIcon(itemClass, x, y, w, h)
    local info = GetItemInfo(itemClass)
    local iconPath
    if info.IconOverride then
        iconPath = info.IconOverride
    elseif not string.StartWith(itemClass, "ability_") then
        local wepTable = weapons.Get(itemClass)
        if wepTable and wepTable.WepSelectIcon then
            iconPath = wepTable.WepSelectIcon
        end
    end

    if not iconPath then
        draw.SimpleText("?", HG_UI.FONTS.BIG, x + w / 2, y + h / 2, HG_UI.COLORS.TEXT_PRIMARY, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        return
    end

    local iconMaterial = Material(iconPath, "noclamp smooth")
    if not iconMaterial or iconMaterial:IsError() then
        draw.SimpleText("?", HG_UI.FONTS.BIG, x + w / 2, y + h / 2, HG_UI.COLORS.TEXT_PRIMARY, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        return
    end

    surface.SetMaterial(iconMaterial)
    surface.SetDrawColor(255, 255, 255, 255)

    local iconW, iconH = iconMaterial:Width(), iconMaterial:Height()

    if not iconW or not iconH or iconW <= 0 or iconH <= 0 then
        draw.SimpleText("?", HG_UI.FONTS.BIG, x + w / 2, y + h / 2, HG_UI.COLORS.TEXT_PRIMARY, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        return
    end

    local aspect = iconW / iconH

    local drawW, drawH
    if w / h > aspect then
        drawH = h
        drawW = h * aspect
    else
        drawW = w
        drawH = w / aspect
    end

    local drawX = x + (w - drawW) / 2
    local drawY = y + (h - drawH) / 2

    surface.DrawTexturedRect(drawX, drawY, drawW, drawH)
end

local function CreateShopFrame()
    local frame = HG_UI.CreateStyledFrame("Магазин Предателя", ScrW() * 0.9, ScrH() * 0.85, {
        blur = true,
        bgColor = Color(20, 20, 25, 220),
        borderColor = Color(200, 50, 50, 255)
    })

    local mainPanel = vgui.Create("DPanel", frame)
    mainPanel:Dock(FILL)
    mainPanel:DockMargin(10, 40, 10, 10)
    mainPanel.Paint = function() end

    local rightColumn = vgui.Create("DPanel", mainPanel)
    rightColumn:Dock(RIGHT)
    rightColumn:SetWide(300)
    rightColumn:DockMargin(10, 0, 0, 0)
    rightColumn.Paint = function() end

    local infoPanel = vgui.Create("DPanel", rightColumn)
    infoPanel:Dock(FILL)
    infoPanel.Paint = function(self, w, h)
        HG_UI.DrawPanel(0, 0, w, h, Color(30, 30, 35, 180), Color(200, 50, 50, 150))

        if selectedItem then
            local info = GetItemInfo(selectedItem)
            local price = GetHomicideItemPrice(selectedItem)
            draw.SimpleText("ИНФОРМАЦИЯ О ПРЕДМЕТЕ", HG_UI.FONTS.NORMAL, w / 2, 15, HG_UI.COLORS.TEXT_PRIMARY, TEXT_ALIGN_CENTER)
            local y = 50

            surface.SetFont(HG_UI.FONTS.BIG)
            local nameW, nameH = surface.GetTextSize(info.PrintName)
            draw.SimpleText(info.PrintName, HG_UI.FONTS.BIG, w / 2, y, HG_UI.COLORS.TEXT_PRIMARY, TEXT_ALIGN_CENTER)
            y = y + nameH + 10

            draw.SimpleText("Цена: " .. price .. " кредитов", HG_UI.FONTS.NORMAL, w / 2, y, Color(255, 220, 100), TEXT_ALIGN_CENTER)
            y = y + 35

            if info.Purpose and info.Purpose ~= "" then
                local descHeight = HG_UI.GetWrappedTextHeight(info.Purpose, HG_UI.FONTS.SMALL, w - 30)
                HG_UI.DrawWrappedText(info.Purpose, HG_UI.FONTS.SMALL, 15, y, w - 30, HG_UI.COLORS.TEXT_SECONDARY)
                y = y + descHeight + 20
            end

            if info.Instructions and info.Instructions ~= "Неизвестно" then
                draw.SimpleText("Instructions:", HG_UI.FONTS.NORMAL, 15, y, Color(100, 200, 255), TEXT_ALIGN_LEFT)
                y = y + 25
                HG_UI.DrawWrappedText(info.Instructions, HG_UI.FONTS.SMALL, 15, y, w - 30, HG_UI.COLORS.TEXT_SECONDARY)
            end
        elseif selectedPreset then
            draw.SimpleText("Информация о предмете", HG_UI.FONTS.NORMAL, w / 2, 15, HG_UI.COLORS.TEXT_PRIMARY, TEXT_ALIGN_CENTER)

            local y = 50

            surface.SetFont(HG_UI.FONTS.BIG)
            local nameW, nameH = surface.GetTextSize(selectedPreset.name)
            draw.SimpleText(selectedPreset.name, HG_UI.FONTS.BIG, w / 2, y, HG_UI.COLORS.TEXT_PRIMARY, TEXT_ALIGN_CENTER)
            y = y + nameH + 10

            draw.SimpleText("Цена: " .. (selectedPreset.price or 0) .. " кредитов", HG_UI.FONTS.NORMAL, w / 2, y, Color(255, 220, 100), TEXT_ALIGN_CENTER)
            y = y + 35

            if selectedPreset.description then
                local descHeight = HG_UI.GetWrappedTextHeight(selectedPreset.description, HG_UI.FONTS.SMALL, w - 30)
                HG_UI.DrawWrappedText(selectedPreset.description, HG_UI.FONTS.SMALL, 15, y, w - 30, HG_UI.COLORS.TEXT_SECONDARY)
                y = y + descHeight + 20
            end

            if selectedPreset.weapons and #selectedPreset.weapons > 0 then
                draw.SimpleText("Оружие:", HG_UI.FONTS.NORMAL, 15, y, Color(255, 200, 100), TEXT_ALIGN_LEFT)
                y = y + 25

                for _, weapon in ipairs(selectedPreset.weapons) do
                    local weaponInfo = weapons.Get(weapon)
                    local weaponName = weaponInfo and weaponInfo.PrintName or weapon

                    draw.SimpleText("• " .. weaponName, HG_UI.FONTS.SMALL, 25, y, HG_UI.COLORS.TEXT_SECONDARY, TEXT_ALIGN_LEFT)
                    y = y + 20
                end

                y = y + 15
            end

            if selectedPreset.abilities and #selectedPreset.abilities > 0 then
                draw.SimpleText("Способности:", HG_UI.FONTS.NORMAL, 15, y, Color(100, 255, 100), TEXT_ALIGN_LEFT)
                y = y + 25

                for _, ability in ipairs(selectedPreset.abilities) do
                    local abilityData = HomicideAbilities and HomicideAbilities[ability]
                    local abilityName = abilityData and abilityData.name or ability
                    local abilityDesc = abilityData and abilityData.description or "Описание отсутствует"

                    draw.SimpleText("• " .. abilityName, HG_UI.FONTS.SMALL, 25, y, Color(150, 255, 150), TEXT_ALIGN_LEFT)
                    y = y + 20

                    local descHeight = HG_UI.GetWrappedTextHeight(abilityDesc, HG_UI.FONTS.SMALL, w - 50)
                    HG_UI.DrawWrappedText(abilityDesc, HG_UI.FONTS.SMALL, 35, y, w - 50, HG_UI.COLORS.TEXT_MUTED)
                    y = y + descHeight + 10
                end
            end
        else
            draw.SimpleText("Выберите предмет или пресет", HG_UI.FONTS.NORMAL, w / 2, h / 2, HG_UI.COLORS.TEXT_MUTED, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end

    local buyButton = HG_UI.CreateStyledButton(infoPanel, "Купить", {
        dock = BOTTOM,
        height = 45,
        margin = {15, 15, 15, 15},
        font = HG_UI.FONTS.NORMAL,
        onClick = function()
            if selectedItem then
                local price = GetHomicideItemPrice(selectedItem)
                if TraitorShop.Credits >= price then
                    net.Start("traitor_shop_buy")
                    net.WriteString(selectedItem)
                    net.SendToServer()
                else
                    chat.AddText(Color(255, 100, 100), "Недостаточно кредитов!")
                end
            elseif selectedPreset then
                local price = selectedPreset.price or 0
                if TraitorShop.Credits >= price then
                    net.Start("traitor_shop_buy_preset")
                    net.WriteString(selectedPreset.id)
                    net.SendToServer()
                else
                    chat.AddText(Color(255, 100, 100), "Недостаточно кредитов!")
                end
            end
        end
    })

    local presetsPanel = vgui.Create("DPanel", rightColumn)
    presetsPanel:Dock(BOTTOM)
    presetsPanel:SetTall(220)
    presetsPanel:DockMargin(0, 10, 0, 0)
    presetsPanel.Paint = function(self, w, h)
        HG_UI.DrawPanel(0, 0, w, h, Color(30, 30, 35, 180), Color(100, 150, 255, 150))
        draw.SimpleText("Пресеты", HG_UI.FONTS.NORMAL, w / 2, 15, HG_UI.COLORS.TEXT_PRIMARY, TEXT_ALIGN_CENTER)
    end

    local presetsScroll = vgui.Create("DScrollPanel", presetsPanel)
    presetsScroll:Dock(FILL)
    presetsScroll:DockMargin(10, 40, 10, 10)
    HG_UI.StyleScrollPanel(presetsScroll)

    local leftColumn = vgui.Create("DPanel", mainPanel)
    leftColumn:Dock(FILL)
    leftColumn.Paint = function() end

    local categoryPanel = vgui.Create("DPanel", leftColumn)
    categoryPanel:Dock(TOP)
    categoryPanel:SetTall(40)
    categoryPanel.Paint = function(self, w, h)
        HG_UI.DrawPanel(0, 0, w, h, Color(30, 30, 35, 180), Color(200, 50, 50, 150))
    end

    local categoryButtons = {}
    local categories = table.GetKeys(TRAITOR_SHOP_CONFIG.CATEGORIES or {})
    for i, category in ipairs(categories) do
        local btn = HG_UI.CreateStyledButton(categoryPanel, category, {
            font = HG_UI.FONTS.SMALL,
            selected = function() return selectedCategory == category end,
            onClick = function()
                selectedCategory = category
                selectedItem = nil
                selectedPreset = nil
            end
        })

        table.insert(categoryButtons, btn)
    end

    categoryPanel.PerformLayout = function(self, w, h)
        if #categoryButtons == 0 then return end
        local btnWidth = (w - 10 - (#categoryButtons - 1) * 5) / #categoryButtons
        for i, btn in ipairs(categoryButtons) do
            btn:SetPos(5 + (btnWidth + 5) * (i - 1), 5)
            btn:SetSize(btnWidth, 30)
        end
    end

    local itemsPanel = vgui.Create("DPanel", leftColumn)
    itemsPanel:Dock(FILL)
    itemsPanel:DockMargin(0, 10, 0, 0)
    itemsPanel.Paint = function(self, w, h)
        HG_UI.DrawPanel(0, 0, w, h, Color(30, 30, 35, 180), Color(200, 50, 50, 150))
    end

    local itemsContainer = vgui.Create("DPanel", itemsPanel)
    itemsContainer:Dock(FILL)
    itemsContainer:DockMargin(10, 10, 10, 10)
    itemsContainer.Paint = function(self, w, h)
        local items = TRAITOR_SHOP_CONFIG.CATEGORIES[selectedCategory] or {}

        local cardWidth = 160
        local cardHeight = 200
        local spacing = 10
        local cols = math.floor((w - spacing) / (cardWidth + spacing))
        if cols < 1 then cols = 1 end

        for i, itemClass in ipairs(items) do
            local col = (i - 1) % cols
            local row = math.floor((i - 1) / cols)

            local x = spacing + col * (cardWidth + spacing)
            local y = spacing + row * (cardHeight + spacing)

            local info = GetItemInfo(itemClass)
            local price = GetHomicideItemPrice(itemClass)

            local mx, my = self:CursorPos()
            local hover = mx >= x and mx <= x + cardWidth and my >= y and my <= y + cardHeight
            local selected = selectedItem == itemClass

            local bgColor = selected and Color(80, 80, 90, 220) or (hover and Color(50, 50, 55, 200) or Color(40, 40, 45, 180))
            draw.RoundedBox(8, x, y, cardWidth, cardHeight, bgColor)

            local borderColor = selected and Color(220, 70, 70, 255) or (hover and Color(200, 50, 50, 220) or Color(200, 50, 50, 150))
            surface.SetDrawColor(borderColor)
            surface.DrawOutlinedRect(x, y, cardWidth, cardHeight)

            local iconSize = cardWidth - 20
            DrawItemIcon(itemClass, x + 10, y + 10, iconSize, iconSize)

            local nameY = y + iconSize + 20
            HG_UI.DrawWrappedText(info.PrintName, HG_UI.FONTS.SMALL, x + 10, nameY, cardWidth - 20, HG_UI.COLORS.TEXT_PRIMARY, TEXT_ALIGN_CENTER)

            local canAfford = TraitorShop.Credits >= price
            local priceColor = canAfford and Color(255, 220, 100) or Color(255, 100, 100)
            draw.SimpleText("Цена: " .. price, HG_UI.FONTS.SMALL, x + cardWidth / 2, y + cardHeight - 25, priceColor, TEXT_ALIGN_CENTER)
        end
    end

    itemsContainer.OnMousePressed = function(self, keyCode)
        if keyCode ~= MOUSE_LEFT then return end

        local items = TRAITOR_SHOP_CONFIG.CATEGORIES[selectedCategory] or {}
        local mx, my = self:CursorPos()

        local cardWidth = 160
        local cardHeight = 200
        local spacing = 10
        local cols = math.floor((self:GetWide() - spacing) / (cardWidth + spacing))
        if cols < 1 then cols = 1 end

        for i, itemClass in ipairs(items) do
            local col = (i - 1) % cols
            local row = math.floor((i - 1) / cols)

            local x = spacing + col * (cardWidth + spacing)
            local y = spacing + row * (cardHeight + spacing)

            if mx >= x and mx <= x + cardWidth and my >= y and my <= y + cardHeight then
                selectedItem = itemClass
                selectedPreset = nil
                break
            end
        end
    end

    local function UpdatePresetsList()
        presetsScroll:Clear()
        for _, preset in ipairs(presetsList) do
            local presetCard = vgui.Create("DPanel", presetsScroll)
            presetCard:Dock(TOP)
            presetCard:SetTall(70)
            presetCard:DockMargin(0, 0, 0, 5)

            if preset.model then
                local modelPanel = vgui.Create("DModelPanel", presetCard)
                modelPanel:SetPos(10, 10)
                modelPanel:SetSize(50, 50)
                modelPanel:SetModel(preset.model)
                modelPanel:SetFOV(40)
                modelPanel:SetCamPos(Vector(40, 0, 55))
                modelPanel:SetLookAt(Vector(0, 0, 60))
                function modelPanel:LayoutEntity(ent)
                    ent:SetAngles(Angle(0, RealTime() * 50, 0))
                end
            end

            presetCard.Paint = function(self, w, h)
                local hover = self:IsHovered()
                local selected = selectedPreset and selectedPreset.id == preset.id

                local bgColor = selected and Color(80, 80, 90, 220) or (hover and Color(50, 50, 55, 200) or Color(40, 40, 45, 180))
                draw.RoundedBox(8, 0, 0, w, h, bgColor)

                local borderColor = selected and Color(120, 170, 255, 255) or (hover and Color(120, 170, 255, 220) or Color(100, 150, 255, 150))
                surface.SetDrawColor(borderColor)
                surface.DrawOutlinedRect(0, 0, w, h)

                HG_UI.DrawWrappedText(preset.name, HG_UI.FONTS.SMALL, 60, 10, w - 70, HG_UI.COLORS.TEXT_PRIMARY)
                draw.SimpleText("Цена: " .. (preset.price or 0), HG_UI.FONTS.SMALL, 60, 35, Color(255, 220, 100), TEXT_ALIGN_LEFT)
            end

            presetCard.OnMousePressed = function()
                selectedPreset = preset
                selectedItem = nil
            end
        end
    end

    local creditsLabel = vgui.Create("DLabel", frame)
    creditsLabel:Dock(TOP)
    creditsLabel:SetTall(30)
    creditsLabel:DockMargin(10, 5, 10, 0)
    creditsLabel:SetFont(HG_UI.FONTS.NORMAL)
    creditsLabel:SetTextColor(Color(255, 220, 100))
    creditsLabel:SetContentAlignment(5)

    local oldItemCount = 0

    frame.Think = function()
        local currentItemCount = #presetsList
        if oldItemCount ~= currentItemCount then
            oldItemCount = currentItemCount
            UpdatePresetsList()
        end

        creditsLabel:SetText("Кредиты: " .. TraitorShop.Credits)
    end

    UpdatePresetsList()
    TraitorShop.IsOpen = true
    frame.OnClose = function()
        TraitorShop.IsOpen = false
    end

    return frame
end

function OpenTraitorShop()
    if TraitorShop.IsOpen then return end

    local lply = LocalPlayer()
    if not IsValid(lply) or not lply.roleT then
        chat.AddText(Color(255, 100, 100), "Только предатели могут использовать магазин!")
        return
    end

    net.Start("traitor_shop_request")
    net.SendToServer()
    CreateShopFrame()
end

concommand.Add("traitor_shop", function()
    OpenTraitorShop()
end)