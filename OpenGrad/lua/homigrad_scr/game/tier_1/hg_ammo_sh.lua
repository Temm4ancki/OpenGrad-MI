local ammotypes = {
    ["556x45mm"] = {
        name = "5.56x45 mm",
        dmgtype = DMG_BULLET,
        tracer = TRACER_LINE,
        plydmg = 0,
        npcdmg = 0,
        force = 200,
        maxcarry = 120,
        minsplash = 10,
        maxsplash = 5
    },
    ["762x39mm"] = {
        name = "7.62x39 mm",
        dmgtype = DMG_BULLET,
        tracer = TRACER_LINE,
        plydmg = 0,
        npcdmg = 0,
        force = 400,
        maxcarry = 120,
        minsplash = 10,
        maxsplash = 5
    },
    ["545×39mm"] = {
        name = "5.45x39 mm",
        dmgtype = DMG_BULLET,
        tracer = TRACER_LINE,
        plydmg = 0,
        npcdmg = 0,
        force = 160,
        maxcarry = 120,
        minsplash = 10,
        maxsplash = 5
    },
    ["12/70gauge"] = {
        name = "12/70 gauge",
        dmgtype = DMG_BUCKSHOT,
        tracer = TRACER_LINE,
        plydmg = 0,
        npcdmg = 0,
        force = 350,
        maxcarry = 46,
        minsplash = 10,
        maxsplash = 5
    },
    ["12/70beanbag"] = {
        name = "12/70 beanbag",
        dmgtype = DMG_BUCKSHOT,
        tracer = TRACER_LINE,
        plydmg = 0,
        npcdmg = 0,
        force = 350,
        maxcarry = 46,
        minsplash = 10,
        maxsplash = 5
    },
    ["9х19mm"] = {
        name = "9х19 mm Parabellum",
        dmgtype = DMG_BULLET,
        tracer = TRACER_LINE,
        plydmg = 0,
        npcdmg = 0,
        force = 100,
        maxcarry = 80,
        minsplash = 10,
        maxsplash = 5
    },
    [".45rubber"] = {
        name = ".45 Rubber",
        dmgtype = DMG_BULLET,
        tracer = TRACER_LINE,
        plydmg = 0,
        npcdmg = 0,
        force = 100,
        maxcarry = 80,
        minsplash = 10,
        maxsplash = 5
    },
    ["46×30mm"] = {
        name = "4.6×30 mm",
        dmgtype = DMG_BULLET,
        tracer = TRACER_LINE,
        plydmg = 0,
        npcdmg = 0,
        force = 100,
        maxcarry = 120,
        minsplash = 10,
        maxsplash = 5
    },
    ["57×28mm"] = {
        name = "5.7×28 mm",
        dmgtype = DMG_BULLET,
        tracer = TRACER_LINE,
        plydmg = 0,
        npcdmg = 0,
        force = 100,
        maxcarry = 150,
        minsplash = 10,
        maxsplash = 5
    },
    [".44magnum"] = {
        name = ".44 Remington Magnum",
        dmgtype = DMG_BULLET,
        tracer = TRACER_LINE,
        plydmg = 0,
        npcdmg = 0,
        force = 100,
        maxcarry = 150,
        minsplash = 10,
        maxsplash = 5
    },
    ["9x39mm"] = {
        name = "9x39 mm",
        dmgtype = DMG_BULLET,
        tracer = TRACER_LINE,
        plydmg = 0,
        npcdmg = 0,
        force = 100,
        maxcarry = 150,
        minsplash = 10,
        maxsplash = 5
    },
}

local ammoents = {
    ["556x45mm"] = {
        Material = "models/hmcd_ammobox_556",
        Scale = 1.2
    },
    ["762x39mm"] = {
        Material = "mmodels/hmcd_ammobox_792",
        Scale = 1,
        Color = Color(95, 95, 95)
    },
    ["545×39mm"] = {
        Material = "mmodels/hmcd_ammobox_792",
        Scale = 0.8,
        Color = Color(125, 155, 95)
    },
    ["12/70gauge"] = {
        Material = "models/hmcd_ammobox_12",
        Scale = 1.1
    },
    ["12/70beanbag"] = {
        Material = "models/hmcd_ammobox_12",
        Scale = 0.9,
        Color = Color(255, 155, 55)
    },
    ["9х19mm"] = {
        Material = "models/hmcd_ammobox_9",
        Scale = 0.8
    },
    [".45rubber"] = {
        Material = "models/hmcd_ammobox_38",
        Scale = 0.8
    },
    ["46×30mm"] = {
        Material = "models/hmcd_ammobox_22",
        Scale = 1
    },
    [".44magnum"] = {
        Material = "models/hmcd_ammobox_22",
        Scale = 0.8
    },
    ["9x39mm"] = {
        Material = "models/hmcd_ammobox_9",
        Scale = 0.9,
        Color = Color(125, 155, 95)
    },
    ["57×28mm"] = {
        Material = "models/hmcd_ammobox_22",
        Scale = 1.2,
        Color = Color(125, 155, 95)
    }
}

for k, v in pairs(ammotypes) do
    -- PrintTable(v)
    game.AddAmmoType(v)
    if CLIENT then
        language.Add(v.name .. "_ammo", v.name)
    end
    timer.Simple(1, function()
        local ammoent = {}
        ammoent.Base = "ammo_base"
        ammoent.PrintName = v.name
        ammoent.Category = "Патроны"
        ammoent.Spawnable = true
        ammoent.AmmoCount = 10
        ammoent.AmmoType = v.name
        ammoent.ModelMaterial = ammoents[k].Material
        ammoent.ModelScale = ammoents[k].Scale
        ammoent.Color = ammoents[k].Color or nil

        scripted_ents.Register(ammoent, "ent_ammo_" .. k)
    end)
end

timer.Simple(1, function()
    game.BuildAmmoTypes()
    -- PrintTable(game.GetAmmoTypes())
end)

if CLIENT then
    -- Используем общую библиотеку UI
    include("homigrad_scr/game/tier_1/ui_library_cl.lua")

    function AmmoMenu(ply)
        local selectedAmmoType = nil
        local selectedAmmoCount = 0
        local ammodrop = 0
        if not ply:Alive() then return end

        local Frame = HG_UI.CreateStyledFrame("Управление амуницией", 400, 550, {
            titleY = 35,
            titleFont = HG_UI.FONTS.HEADER
        })

        local topPanel = vgui.Create("Panel", Frame)
        topPanel:SetPos(20, 60)
        topPanel:SetSize(Frame:GetWide() - 40, 40)

        local selectedPanel = HG_UI.CreateInfoPanel(topPanel, 0, 0, topPanel:GetWide(), 40, {
            font = HG_UI.FONTS.SMALL
        })
        
        selectedPanel.Paint = function(self, w, h)
            HG_UI.DrawPanel(0, 0, w, h)
            local text = selectedAmmoType and ("Выбрано: " .. game.GetAmmoName(selectedAmmoType) .. " (" .. selectedAmmoCount .. ")") or "Выберите тип патронов"
            draw.SimpleText(text, HG_UI.FONTS.SMALL, w / 2, h / 2, HG_UI.COLORS.TEXT_PRIMARY, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        local scroll = vgui.Create("DScrollPanel", Frame)
        scroll:SetPos(20, 110)
        scroll:SetSize(Frame:GetWide() - 40, Frame:GetTall() - 240)

        local bottomPanel = vgui.Create("Panel", Frame)
        bottomPanel:SetPos(20, Frame:GetTall() - 120)
        bottomPanel:SetSize(Frame:GetWide() - 40, 100)

        local sliderPanel = vgui.Create("Panel", bottomPanel)
        sliderPanel:SetPos(0, 0)
        sliderPanel:SetSize(bottomPanel:GetWide(), 40)
        sliderPanel.Paint = function(self, w, h)
            local roleColors = HG_UI.GetRoleColors()
            draw.RoundedBox(0, 0, 0, w, h, Color(20, 20, 20, 150))
            surface.SetDrawColor(roleColors.PRIMARY.r, roleColors.PRIMARY.g, roleColors.PRIMARY.b, selectedAmmoType and 200 or 100)
            surface.DrawOutlinedRect(0, 0, w, h)
        end

        local DermaNumSlider = vgui.Create("DNumSlider", sliderPanel)
        DermaNumSlider:SetPos(10, 5)
        DermaNumSlider:SetSize(sliderPanel:GetWide() - 20, 30)
        DermaNumSlider:SetText("Количество для сброса")
        DermaNumSlider:SetMin(0)
        DermaNumSlider:SetMax(1)
        DermaNumSlider:SetDecimals(0)
        DermaNumSlider:SetEnabled(false)
        DermaNumSlider.OnValueChanged = function(self, value)
            ammodrop = math.Round(value)
        end

        local buttonPanel = vgui.Create("Panel", bottomPanel)
        buttonPanel:SetPos(0, 45)
        buttonPanel:SetSize(bottomPanel:GetWide(), 35)

        local dropButton = HG_UI.CreateStyledButton(buttonPanel, "Сбросить N патрон", {
            textColor = HG_UI.COLORS.TEXT_SECONDARY,
            font = HG_UI.FONTS.NORMAL,
            onClick = function()
                if selectedAmmoType and ammodrop > 0 then
                    net.Start("drop_ammo")
                    net.WriteFloat(selectedAmmoType)
                    net.WriteFloat(ammodrop)
                    net.SendToServer()
                    Frame:Close()
                end
            end
        })
        dropButton:SetPos(0, 0)
        dropButton:SetSize(buttonPanel:GetWide() / 2 - 5, 35)
        dropButton:Dock(NODOCK)

        local dropAllButton = HG_UI.CreateStyledButton(buttonPanel, "Сбросить все", {
            textColor = Color(255, 120, 120),
            font = HG_UI.FONTS.NORMAL,
            onClick = function()
                if selectedAmmoType then
                    net.Start("drop_ammo")
                    net.WriteFloat(selectedAmmoType)
                    net.WriteFloat(selectedAmmoCount)
                    net.SendToServer()
                    Frame:Close()
                end
            end
        })
        dropAllButton:SetPos(buttonPanel:GetWide() / 2 + 5, 0)
        dropAllButton:SetSize(buttonPanel:GetWide() / 2 - 5, 35)
        dropAllButton:Dock(NODOCK)

        HG_UI.StyleScrollPanel(scroll)

        local layout = vgui.Create("DListLayout", scroll)
        layout:Dock(FILL)

        local ammos = LocalPlayer():GetAmmo()
        local hasAmmo = false

        for k, v in pairs(ammos) do
            if v > 0 then
                hasAmmo = true
                local ammoButton = HG_UI.CreateStyledButton(layout, game.GetAmmoName(k) .. ": " .. v, {
                    textColor = HG_UI.COLORS.TEXT_SECONDARY,
                    font = HG_UI.FONTS.NORMAL,
                    dock = TOP,
                    margin = {0, 0, 0, 5},
                    selected = function() return selectedAmmoType == k end,
                    onClick = function()
                        selectedAmmoType = k
                        selectedAmmoCount = v
                        DermaNumSlider:SetMax(v)
                        DermaNumSlider:SetValue(v)
                        DermaNumSlider:SetEnabled(true)
                        ammodrop = v
                    end
                })
            end
        end

        if not hasAmmo then
            local noAmmoLabel = vgui.Create("DLabel", layout)
            noAmmoLabel:SetText("У вас нет патронов для сброса")
            noAmmoLabel:SetTextColor(HG_UI.COLORS.TEXT_MUTED)
            noAmmoLabel:SetFont(HG_UI.FONTS.NORMAL)
            noAmmoLabel:SetContentAlignment(5)
            noAmmoLabel:Dock(TOP)
            noAmmoLabel:DockMargin(0, 20, 0, 0)
            noAmmoLabel:SizeToContents()
        end
    end

    concommand.Add("hg_ammomenu", function(ply, cmd, args)
        AmmoMenu(ply)
    end)
end

local ammolistent = {}

timer.Simple(2, function()
    for ammo_key, ammo_data in pairs(ammotypes) do
        local id = game.GetAmmoID(ammo_data.name)
        if id then
            ammolistent[id] = ammo_key
        else
            print("[WARNING] Ammo type '" .. ammo_data.name .. "' not registered or invalid")
        end
    end
    --PrintTable(ammolistent)
end)

-- local ammolistent = {
--     [1] = "AR2",
--     [38] = ".308winchester",
--     [42] = ".44magnum",
--     [41] = ".45rubber",
--     [44] = "12/70beanbag",
--     [45] = "12/70gauge",
--     [46] = "46×30mm",
--     [48] = "545×39mm",
--     [49] = "556x45mm",
--     [50] = "57×28mm",
--     [51] = "762x39mm",
--     [52] = "9x39mm",
--     [53] = "9х19mm"
-- }

if SERVER then
    util.AddNetworkString("drop_ammo")

    net.Receive("drop_ammo", function(len, ply)
        if not ply:Alive() or ply.Otrub then return end

        local ammotype = net.ReadFloat()
        local count = net.ReadFloat()
        print("SERVER ammotype", ammotype)
        print("SERVER count", count)
        local pos = ply:EyePos() + ply:EyeAngles():Forward() * 15

        if ply:GetAmmoCount(ammotype) - count < 0 then
            ply:ChatPrint("У тебя столько нет пулек")
            return
        end
        if count < 1 then
            ply:ChatPrint("Ноль пулек не скинуть")
            return
        end
        if not ammolistent[ammotype] then
            ply:ChatPrint("Нету ентити этих патрон...")
            return
        end

        local AmmoEnt = ents.Create("ent_ammo_" .. ammolistent[ammotype])
        print("AmmoEnt", AmmoEnt)
        AmmoEnt:SetPos(pos)
        AmmoEnt:Spawn()
        AmmoEnt.AmmoCount = count
        ply:SetAmmo(ply:GetAmmoCount(ammotype) - count, ammotype)
        ply:EmitSound("utils/snd_jack_hmcd_ammobox.ogg", 75, math.random(80, 90), 1, CHAN_ITEM)
    end)
end
