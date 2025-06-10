-- Создаем шрифты для интерфейса
surface.CreateFont("InventoryTitle", {
    font = "Roboto",
    size = 32,
    weight = 1000,
    outline = false,
    extended = true,
    shadow = false
})

surface.CreateFont("InventoryItem", {
    font = "Roboto",
    size = 18,
    weight = 500,
    outline = false,
    extended = true,
    shadow = false
})

surface.CreateFont("InventoryItemSmall", {
    font = "Roboto",
    size = 14,
    weight = 500,
    outline = false,
    extended = true,
    shadow = true
})

local blackListedWeps = {
    ["weapon_hands"] = true,
    ["weapon_m_kabar"] = true,
    ["weapon_hg_t_vxpoison"] = true,
    ["weapon_hidebomb"] = true,
    ["weapon_hg_t_syringepoison"] = true,
    ["weapon_jahidka"] = true,
    ["weapon_hg_rgd5"] = true,
    ["weapon_trap"] = true,
    ["weapon_mask"] = true,
    ["weapon_jam"] = true,
    ["weapon_hg_t_cyanid_capsule"] = true,
}

local blackListedAmmo = {
    [8] = true,
    [9] = true,
    [10] = true
}

Gunshuy = {
    "weapon_s_p99",
    "weapon_s_cz75",
    "weapon_s_mp5a3",
    "weapon_s_ar15",
    "weapon_m134",
    "weapon_s_akm",
    "weapon_s_p99",
    "weapon_s_hk_usp",
    "weapon_s_deagle",
    "weapon_s_beretta",
    "weapon_s_ak74u",
    "weapon_l1a1",
    "weapon_s_l85a1",
    "weapon_s_galil",
    "weapon_s_asval",
    "weapon_m14",
    "weapon_m1a1",
    "weapon_s_hk416",
    "weapon_s_m249",
    "weapon_s_m4a1",
    "weapon_minu14",
    "weapon_s_p90",
    "weapon_s_rpk",
    "weapon_ump",
    "weapon_hk_usps",
    "weapon_s_m4super",
    "weapon_s_glock",
    "weapon_s_mp7",
    "weapon_s_remington870",
    "weapon_s_m4super",
    "bandage",
    "morphine",
    "medkit",
    "painkiller",
    "weapon_physgun",
    "weapon_m_kabar",
    "weapon_m_bat",
    "weapon_m_gurkha",
    "weapon_jmoddynamite",
    "weapon_jmodflash",
    "weapon_jmodnade",
    "weapon_taser",
    "weapon_tomahawk-2",
    "weapon_m_knife",
    "weapon_m_pipe",
    "weapon_s_sar2",
    "weapon_civil_famas"
}

local AmmoTypes = {
    [47] = "vgui/hud/hmcd_round_792",
    [44] = "vgui/hud/hmcd_round_792",
    [2] = "vgui/hud/hmcd_health",
    [48] = "vgui/hud/hmcd_round_9",
    [45] = "vgui/hud/hmcd_round_556",
    [1] = "vgui/hud/hmcd_round_792",
    [38] = "vgui/hud/hmcd_round_38",
    [6] = "vgui/hud/hmcd_round_arrow",
    [41] = "vgui/hud/hmcd_round_12",
    [8] = "vgui/wep_jack_hmcd_oldgrenade",
    [9] = "vgui/wep_jack_hmcd_oldgrenade",
    [10] = "vgui/wep_jack_hmcd_oldgrenade",
    [11] = "vgui/wep_jack_hmcd_ied",
    [2] = "vgui/hud/hmcd_health",
    [3] = "vgui/hud/hmcd_round_9",
    [4] = "vgui/hud/hmcd_round_556",
    [5] = "vgui/hud/hmcd_round_38",
}

-- Материал для размытия фона
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

local function StyledItemButton(parent, text, icon, isAmmo, onclick, onrightclick)
    local btn = vgui.Create("DButton", parent)
    btn:SetText("")
    btn:SetSize(80, 80)
    btn.text = text
    btn.icon = icon
    btn.isAmmo = isAmmo

    btn.Paint = function(self, w, h)
        local hover = self:IsHovered()
        local bg = hover and Color(40, 40, 40, 200) or Color(30, 30, 30, 180)
        draw.RoundedBox(0, 0, 0, w, h, bg)

        -- Обводка с контрастным цветом
        surface.SetDrawColor(44, 110, 73, hover and 255 or 180)
        for i = 0, 1 do
            surface.DrawOutlinedRect(i, i, w - i*2, h - i*2)
        end

        -- Иконка или текст
        if self.isAmmo and self.icon then
            surface.SetMaterial(Material(self.icon, "noclamp smooth"))
            surface.SetDrawColor(255, 255, 255, 255)
            surface.DrawTexturedRect(8, 8, w - 16, h - 16)
        end

        -- Название предмета
        local lines = string.Explode("\n", self.text)
        for i, line in ipairs(lines) do
            draw.SimpleText(line, "InventoryItemSmall", w / 2, 8 + (i-1) * 14, color_white, TEXT_ALIGN_CENTER)
        end
    end

    btn.DoClick = onclick

    return btn
end

local function WrapText(text, maxWidth)
    surface.SetFont("InventoryItemSmall")
    local words = string.Explode(" ", text)
    local lines = {}
    local currentLine = ""

    for _, word in ipairs(words) do
        local testLine = currentLine == "" and word or currentLine .. " " .. word
        local w = surface.GetTextSize(testLine)

        if w > maxWidth then
            if currentLine ~= "" then
                table.insert(lines, currentLine)
                currentLine = word
            else
                table.insert(lines, word)
            end
        else
            currentLine = testLine
        end
    end

    if currentLine ~= "" then
        table.insert(lines, currentLine)
    end

    return table.concat(lines, "\n")
end

local InventoryPanel
net.Receive("inventory", function()
    local lply = LocalPlayer()

    if IsValid(InventoryPanel) then
        InventoryPanel.override = true
        InventoryPanel:Remove()
        blurStrength = 0
    end

    local lootEnt = net.ReadEntity()
    local success, items = pcall(net.ReadTable)
    local nickname = lootEnt:IsPlayer() and lootEnt:GetNWString("FakeName", "Неизвестного") or ""

    if not success or not lootEnt then return end

    if items[lootEnt.curweapon] and table.HasValue(Gunshuy, lootEnt.curweapon) then
        items[lootEnt.curweapon] = nil
    end

    local items_ammo = net.ReadTable()

    -- Фильтруем заппрещенные предметы
    for i, v in pairs(items) do
        if blackListedWeps[i] then items[i] = nil end
    end

    local itemCount = 0
    for _ in pairs(items) do itemCount = itemCount + 1 end
    for ammo, _ in pairs(items_ammo) do
        if not blackListedAmmo[ammo] then
            itemCount = itemCount + 1
        end
    end

    -- Создаем основное окно
    local padding = 20
    local itemsPerRow = 5
    local itemSize = 80
    local itemSpacing = 10
    local width, height

    if itemCount == 0 then
        width = 400
        height = 200
    else
        -- Расчет для непустого инвентаря
        local rows = math.ceil(itemCount / itemsPerRow)
        width = padding * 2 + itemsPerRow * itemSize + (itemsPerRow - 1) * itemSpacing
        height = 100 + padding * 2 + rows * itemSize + (rows - 1) * itemSpacing

        width = math.min(width, 600)
        height = math.min(height, ScrH() * 0.8)
    end

    InventoryPanel = vgui.Create("DFrame")
    InventoryPanel:SetSize(width, height)
    InventoryPanel:Center()
    InventoryPanel:SetDraggable(true)
    InventoryPanel:MakePopup()
    InventoryPanel:SetTitle("")
    InventoryPanel:ShowCloseButton(true)

    function InventoryPanel:OnKeyCodePressed(key)
        if key == KEY_W or key == KEY_S or key == KEY_A or key == KEY_D then
            self:Remove()
        end
    end

    function InventoryPanel:OnRemove()
        if self.override then return end

        net.Start("inventory")
        net.WriteEntity(lootEnt)
        net.SendToServer()

        blurStrength = 0
    end

    InventoryPanel.Paint = function(self, w, h)
        if not IsValid(lootEnt) or not LocalPlayer():Alive() then
            self:Remove()
            return
        end

        BlurBackground(self)
        draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 180))
        
        -- Обводка окна
        surface.SetDrawColor(44, 110, 73, 255)
        for i = 0, 2 do
            surface.DrawOutlinedRect(i, i, w - i*2, h - i*2)
        end

        local title = "Инвентарь " .. (nickname or "")
        draw.SimpleText(title, "InventoryTitle", w / 2, 30, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    -- Создаем скроллируемую область
    local scroll = vgui.Create("DScrollPanel", InventoryPanel)
    scroll:SetPos(padding, 60)
    scroll:SetSize(width - padding * 2, height - 80)

    local sbar = scroll:GetVBar()
    function sbar:Paint(w, h) end
    function sbar.btnUp:Paint(w, h) end
    function sbar.btnDown:Paint(w, h) end
    function sbar.btnGrip:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(80, 80, 80, 160))
        surface.SetDrawColor(44, 110, 73, 200)
        surface.DrawOutlinedRect(0, 0, w, h)
    end

    local grid = vgui.Create("DIconLayout", scroll)
    grid:Dock(FILL)
    grid:SetSpaceX(itemSpacing)
    grid:SetSpaceY(itemSpacing)

    for wep in pairs(items) do
        local wepTbl = weapons.Get(wep) or WeaponByModel[wep] or wep
        local text = type(wepTbl) == "table" and wepTbl.PrintName or wep
        text = WrapText(text, itemSize - 16)

        local btn = StyledItemButton(grid, text, nil, false, function()
            net.Start("ply_take_item")
            net.WriteEntity(lootEnt)
            net.WriteString(tostring(wep))
            net.SendToServer()
        end)

        -- Отрисовка модели оружия
        btn.PaintOver = function(self, w, h)
            local x, y = self:LocalToScreen(0, 0)
            if type(wepTbl) == "table" then
                DrawWeaponSelectionEX(wepTbl, x, y, w, h)
            end
        end
    end

    for ammo, amt in pairs(items_ammo) do
        if blackListedAmmo[ammo] then continue end

        local text = game.GetAmmoName(ammo)
        text = WrapText(text, itemSize - 16)
        local icon = AmmoTypes[tonumber(ammo)] or "vgui/hud/hmcd_round_9"

        local btn = StyledItemButton(grid, text, icon, true, function()
            net.Start("ply_take_ammo")
            net.WriteEntity(lootEnt)
            net.WriteFloat(tonumber(ammo))
            net.SendToServer()
        end)
    end

    -- Если инвентарь пуст
    if itemCount == 0 then
        scroll:SetVerticalScrollbarEnabled(false)

        local label = vgui.Create("DLabel", scroll)
        label:SetText("Инвентарь пуст")
        label:SetFont("InventoryItem")
        label:SetTextColor(Color(150, 150, 150))
        label:SetContentAlignment(5)
        label:Dock(TOP)
        label:SetTall(100)
    end
end)
