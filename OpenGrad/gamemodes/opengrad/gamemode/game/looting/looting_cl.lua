net.Receive("OpenLootingUI", function()
    local frame = vgui.Create("DFrame")
    frame:SetTitle("Container")
    frame:SetSize(400, 300)
    frame:Center()
    frame:MakePopup()

    -- Create scrollable panel to hold slots
    local scroll = vgui.Create("DScrollPanel", frame)
    scroll:Dock(FILL)
    scroll:DockMargin(10, 10, 10, 10)

    -- Create a grid for item slots
    local iconLayout = vgui.Create("DIconLayout", scroll)
    iconLayout:Dock(FILL)
    iconLayout:SetSpaceY(10)
    iconLayout:SetSpaceX(10)

    -- Add 12 item slots (customize as needed)
    for i = 1, 12 do
        local slot = iconLayout:Add("DButton")
        slot:SetSize(64, 64)
        slot:SetText("")
        slot:SetTooltip("Empty Slot")
        slot:SetColor(Color(255, 255, 255))
        slot.Paint = function(self, w, h)
            surface.SetDrawColor(60, 60, 60, 200)
            surface.DrawRect(0, 0, w, h)
            surface.SetDrawColor(120, 120, 120, 255)
            surface.DrawOutlinedRect(0, 0, w, h)
        end

        -- Optional: on-click logic
        slot.DoClick = function()
            chat.AddText(Color(200, 200, 200), "You clicked slot " .. i)
        end
    end
end)