if SERVER then return end

include("homigrad_scr/game/tier_1/ui_library_cl.lua")

local TraitorPresetMenu = {}
TraitorPresetMenu.IsOpen = false
TraitorPresetMenu.PresetSelected = false

net.Receive("homicide_traitor_preset_menu", function()
    local presetList = net.ReadTable()
    TraitorPresetMenu.PresetSelected = false
    OpenTraitorPresetMenu(presetList)
end)

function OpenTraitorPresetMenu(presetList)
    if TraitorPresetMenu.IsOpen then return end
    if IsValid(TraitorPresetMenuFrame) then TraitorPresetMenuFrame:Remove() end

    local width = 1200
    local presetCount = #presetList
    local maxVisiblePresets = 4
    local presetHeight = 130
    local baseHeight = 175
    
    local contentHeight = math.min(presetCount, maxVisiblePresets) * presetHeight
    local height = baseHeight + contentHeight
    local needsScroll = presetCount > maxVisiblePresets

    TraitorPresetMenuFrame = HG_UI.CreateStyledFrame("Выбор пресета трейтора", width, height, {
        titleY = 35,
        titleFont = HG_UI.FONTS.TITLE,
        borderColor = Color(155, 55, 55, 255),
        blur = true,
        blurStrength = 1.5
    })

    local descLabel = vgui.Create("DLabel", TraitorPresetMenuFrame)
    descLabel:SetPos(20, 60)
    descLabel:SetSize(width - 40, 25)
    descLabel:SetFont(HG_UI.FONTS.SMALL)
    descLabel:SetTextColor(HG_UI.COLORS.TEXT_SECONDARY)
    descLabel:SetText("Выберите стиль игры для вашего трейтора:")
    descLabel:SetContentAlignment(5)

    local mainPanel = vgui.Create("DPanel", TraitorPresetMenuFrame)
    mainPanel:SetPos(20, 95)
    mainPanel:SetSize(750, height - 165)
    mainPanel.Paint = function(self, w, h)
        HG_UI.DrawPanel(0, 0, w, h, Color(15, 15, 15, 180), Color(155, 55, 55, 200))
    end

    local infoPanel = vgui.Create("DPanel", TraitorPresetMenuFrame)
    infoPanel:SetPos(790, 95)
    infoPanel:SetSize(390, height - 165)
    infoPanel.Paint = function(self, w, h)
        HG_UI.DrawPanel(0, 0, w, h, Color(15, 15, 15, 180), Color(155, 55, 55, 200))
    end

    local function UpdateInfoPanel(preset)
        infoPanel:Clear()
        
        if not preset then
            local noSelectionLabel = vgui.Create("DLabel", infoPanel)
            noSelectionLabel:SetPos(20, 20)
            noSelectionLabel:SetSize(350, 30)
            noSelectionLabel:SetFont(HG_UI.FONTS.NORMAL)
            noSelectionLabel:SetTextColor(HG_UI.COLORS.TEXT_MUTED)
            noSelectionLabel:SetText("Выберите пресет для просмотра снаряжения")
            noSelectionLabel:SetContentAlignment(5)
            return
        end

        local titleLabel = vgui.Create("DLabel", infoPanel)
        titleLabel:SetPos(20, 15)
        titleLabel:SetSize(350, 30)
        titleLabel:SetFont(HG_UI.FONTS.BIG)
        titleLabel:SetTextColor(HG_UI.COLORS.TEXT_PRIMARY)
        titleLabel:SetText(preset.name)
        titleLabel:SetContentAlignment(5)

        local yPos = 55

        if preset.weapons and #preset.weapons > 0 then
            local weaponsLabel = vgui.Create("DLabel", infoPanel)
            weaponsLabel:SetPos(20, yPos)
            weaponsLabel:SetSize(350, 25)
            weaponsLabel:SetFont(HG_UI.FONTS.NORMAL)
            weaponsLabel:SetTextColor(Color(255, 200, 100))
            weaponsLabel:SetText("ОРУЖИЕ:")
            yPos = yPos + 30

            for _, weapon in ipairs(preset.weapons) do
                local weaponInfo = weapons.Get(weapon)
                local weaponName = weaponInfo and weaponInfo.PrintName or weapon
                
                local weaponLabel = vgui.Create("DLabel", infoPanel)
                weaponLabel:SetPos(30, yPos)
                weaponLabel:SetSize(340, 20)
                weaponLabel:SetFont(HG_UI.FONTS.SMALL)
                weaponLabel:SetTextColor(HG_UI.COLORS.TEXT_SECONDARY)
                weaponLabel:SetText("• " .. weaponName)
                yPos = yPos + 22
            end
            yPos = yPos + 10
        end

        if preset.abilities and #preset.abilities > 0 then
            local abilitiesLabel = vgui.Create("DLabel", infoPanel)
            abilitiesLabel:SetPos(20, yPos)
            abilitiesLabel:SetSize(350, 25)
            abilitiesLabel:SetFont(HG_UI.FONTS.NORMAL)
            abilitiesLabel:SetTextColor(Color(100, 255, 100))
            abilitiesLabel:SetText("СПОСОБНОСТИ:")
            yPos = yPos + 30

            for _, ability in ipairs(preset.abilities) do
                local abilityData = HomicideAbilities and HomicideAbilities[ability]
                local abilityName = abilityData and abilityData.name or ability
                local abilityDesc = abilityData and abilityData.description or "Описание отсутствует"
                
                local abilityLabel = vgui.Create("DLabel", infoPanel)
                abilityLabel:SetPos(30, yPos)
                abilityLabel:SetSize(340, 20)
                abilityLabel:SetFont(HG_UI.FONTS.SMALL)
                abilityLabel:SetTextColor(Color(150, 255, 150))
                abilityLabel:SetText("• " .. abilityName)
                yPos = yPos + 22

                local descLabel = vgui.Create("DLabel", infoPanel)
                descLabel:SetPos(40, yPos)
                descLabel:SetSize(330, 40)
                descLabel:SetFont(HG_UI.FONTS.SMALL)
                descLabel:SetTextColor(HG_UI.COLORS.TEXT_MUTED)
                descLabel:SetText(abilityDesc)
                descLabel:SetWrap(true)
                descLabel:SetAutoStretchVertical(true)
                yPos = yPos + 45
            end
        end
    end

    UpdateInfoPanel(nil)

    local contentPanel
    if needsScroll then
        local scroll = vgui.Create("DScrollPanel", mainPanel)
        scroll:Dock(FILL)
        scroll:DockMargin(10, 10, 10, 10)
        HG_UI.StyleScrollPanel(scroll, {
            gripColor = Color(80, 80, 80, 160),
            borderColor = Color(155, 55, 55, 200)
        })

        contentPanel = vgui.Create("DListLayout", scroll)
        contentPanel:Dock(FILL)
    else
        contentPanel = vgui.Create("DListLayout", mainPanel)
        contentPanel:Dock(FILL)
        contentPanel:DockMargin(10, 10, 10, 10)
    end

    for i, preset in ipairs(presetList) do
        local presetPanel = vgui.Create("DPanel", contentPanel)
        presetPanel:SetTall(presetHeight - 10)
        presetPanel:Dock(TOP)
        
        local topMargin = (i == 1) and 5 or 0
        local bottomMargin = 5
        presetPanel:DockMargin(0, topMargin, 0, bottomMargin)
        
        presetPanel.Paint = function(self, w, h)
            local hover = self:IsHovered()
            local bg = hover and Color(40, 40, 40, 200) or Color(25, 25, 25, 180)
            
            draw.RoundedBox(0, 0, 0, w, h, bg)
            surface.SetDrawColor(155, 55, 55, hover and 255 or 180)
            surface.DrawOutlinedRect(0, 0, w, h)
            
            if preset.model then
                surface.SetDrawColor(100, 100, 100, 150)
                surface.DrawOutlinedRect(10, 10, 100, 100)
            end
        end

        local selectBtn = HG_UI.CreateStyledButton(presetPanel, "ВЫБРАТЬ", {
            textColor = HG_UI.COLORS.TEXT_PRIMARY,
            font = HG_UI.FONTS.NORMAL,
            borderColor = Color(155, 55, 55, 200),
            bgColor = Color(30, 30, 30, 180),
            hoverColor = Color(50, 50, 50, 200),
            onClick = function()
                TraitorPresetMenu.PresetSelected = true
                
                net.Start("homicide_traitor_preset_select")
                net.WriteString(preset.id)
                net.SendToServer()
                
                TraitorPresetMenuFrame:Close()
            end
        })
        selectBtn:SetPos(620, 40)
        selectBtn:SetSize(100, 40)

        if preset.model then
            local modelPanel = vgui.Create("DModelPanel", presetPanel)
            modelPanel:SetPos(15, 15)
            modelPanel:SetSize(90, 90)
            modelPanel:SetModel(preset.model)
            modelPanel:SetFOV(45)
            modelPanel:SetCamPos(Vector(80, 0, 50))
            modelPanel:SetLookAt(Vector(0, 0, 40))
            function modelPanel:LayoutEntity(ent) return end
            modelPanel:SetMouseInputEnabled(false)
        end

        local nameLabel = vgui.Create("DLabel", presetPanel)
        nameLabel:SetPos(120, 15)
        nameLabel:SetSize(400, 30)
        nameLabel:SetFont(HG_UI.FONTS.BIG)
        nameLabel:SetTextColor(HG_UI.COLORS.TEXT_PRIMARY)
        nameLabel:SetText(preset.name)

        local descText = preset.description or "Описание отсутствует"
        local descLabel = vgui.Create("DLabel", presetPanel)
        descLabel:SetPos(120, 50)
        descLabel:SetSize(400, 60)
        descLabel:SetFont(HG_UI.FONTS.SMALL)
        descLabel:SetTextColor(HG_UI.COLORS.TEXT_SECONDARY)
        descLabel:SetText(descText)
        descLabel:SetWrap(true)
        descLabel:SetAutoStretchVertical(true)

        presetPanel.OnCursorEntered = function()
            UpdateInfoPanel(preset)
        end
    end

    local randomBtn = HG_UI.CreateStyledButton(TraitorPresetMenuFrame, "Случайный", {
        textColor = Color(255, 200, 0),
        font = HG_UI.FONTS.NORMAL,
        borderColor = Color(255, 200, 0, 200),
        onClick = function()
            if #presetList > 0 then
                TraitorPresetMenu.PresetSelected = true
                
                local randomPreset = table.Random(presetList)
                net.Start("homicide_traitor_preset_select")
                net.WriteString(randomPreset.id)
                net.SendToServer()
                
                TraitorPresetMenuFrame:Close()
            end
        end
    })
    randomBtn:SetPos(20, height - 50)
    randomBtn:SetSize(150, 40)

    
    TraitorPresetMenu.IsOpen = true
    TraitorPresetMenuFrame.OnClose = function()
        TraitorPresetMenu.IsOpen = false

        if not TraitorPresetMenu.PresetSelected then
            timer.Simple(0.1, function()
                if not TraitorPresetMenu.PresetSelected then
                    OpenTraitorPresetMenu(presetList)
                end
            end)
        end
    end

    surface.PlaySound("ui/buttonclick.wav")
end