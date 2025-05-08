local blackListedWeps = {
	["weapon_hands"] = true,
	["weapon_physgun"] = true,
	["gmod_tool"] = true
}

local blackListedAmmo = {
	[8] = true,
	[9] = true,
	[10] = true
}

GunsList = {
	"weapon_glock18",
	"weapon_p220",
	"weapon_mp5",
	"weapon_ar15",
	"weapon_ak74",
	"weapon_akm",
	"weapon_fiveseven",
	"weapon_hk_usp",
	"weapon_deagle",
	"weapon_beretta",
	"weapon_ak74u",
	"weapon_l1a1",
	"weapon_fal",
	"weapon_galil",
	"weapon_galilsar",
	"weapon_m14",
	"weapon_m1a1",
	"weapon_mk18",
	"weapon_m249",
	"weapon_m4a1",
	"weapon_minu14",
	"weapon_mp40",
	"weapon_rpk",
	"weapon_ump",
	"weapon_hk_usps",
	"weapon_m4super",
	"weapon_glock",
	"weapon_mp7",
	"weapon_m3super",
	"weapon_xm1014",
	"bandage",
	"morphine",
	"medkit",
	"painkiller",
	"weapon_physgun",
	"weapon_kabar",
	"weapon_bat",
	"weapon_gurkha",
	"weapon_jmoddynamite",
	"weapon_jmodflash",
	"weapon_jmodnade",
	"weapon_taser",
	"weapon_t",
	"weapon_knife",
	"weapon_pipe",
	"weapon_sar2",
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

local black = Color(0,0,0,128)
local black2 = Color(64,64,64,128)

local function getText(text,limitW)
	local newText = {}
	local newText_I = 1
	local curretText = ""

	surface.SetFont("DefaultFixedDropShadow")

	for i = 1,#text do
		local sumbol = string.sub(text,i,i)
		local w,h = surface.GetTextSize(curretText .. sumbol)

		if w >= limitW then
			newText_I = newText_I + 1
			curretText = sumbol
		else
			curretText = curretText .. sumbol
		end

		newText[newText_I] = curretText
	end

	return newText
end

local panel
net.Receive("inventory", function()
	local lply = LocalPlayer()

	if IsValid(panel) then panel.override = true panel:Remove() end

	local lootEnt = net.ReadEntity()
	local success, items = pcall(net.ReadTable)
	local nickname = lootEnt:IsPlayer() and lootEnt:Name() or lootEnt:GetNWString("Nickname") or ""

	if not success or not lootEnt then return end

	if items[lootEnt.curweapon] and table.HasValue(GunsList, lootEnt.curweapon) then items[lootEnt.curweapon] = nil end

	local items_ammo = net.ReadTable()

	items.weapon_hands = nil

	panel = vgui.Create("DFrame")
	panel:SetAlpha(255)
	panel:SetMinimumSize(500, 400)
	panel:Center()
	panel:SetSizable(true)
	panel:SetDraggable(true)
	panel:SetTitle("")
	panel:MakePopup()

	if lply:GetVelocity():LengthSqr() > 10 then
		panel:Remove()
	end

	
	function panel:OnKeyCodePressed(key)
		if key == KEY_W or key == KEY_S or key == KEY_A or key == KEY_D then self:Remove() end
	end
	
	function panel:OnRemove()
		if self.override then return end

		net.Start("inventory")
		net.WriteEntity(lootEnt)
		net.SendToServer()
	end
	panel.Paint = function(self, w, h)
		if not IsValid(lootEnt) or not lply:Alive() then panel:Remove() return end
		
		draw.RoundedBox(0,0,0,w,h,black)
		surface.SetDrawColor(255,255,255,128)
		surface.DrawOutlinedRect(1, 1, w-2, h-2)
		
		draw.SimpleText("Инвентарь "..nickname, "HomigradFont", w/2, 3, color_white, TEXT_ALIGN_CENTER)
	end
	
	local x, y = 40, 40 --первая позиция ячейки
	local cellSize = 64
	local padding = 6

	if table.Count(items) == 0 then return end

	for itemName, _ in pairs(items) do
		local button = vgui.Create("DButton", panel)
		button:SetPos(x,y)
		button:SetSize(cellSize,cellSize)
		
		x = x + button:GetWide() + padding
		if x + button:GetWide() >= panel:GetWide() then
			x = 40
			y = y + button:GetTall() + padding
		end
		button:SetText("")

		local wepTbl = weapons.Get(itemName)

		local text = type(wepTbl) == "table" and wepTbl.PrintName

		text = getText(text, button:GetWide() - 6 * 2)

		local looted = lootEnt:GetNWString(itemName, false)
		if not looted then 
			button:SetFont("HomigradFontBig")

			button.inspectProgress = 0
			button.inspecting = false
			button.inspectStart = 0

			local function InspectItem(self)
				if self.inspecting then return end

				self.inspecting = true
				self.inspectStart = CurTime()

				timer.Create("ItemInspect_"..tostring(itemName), 0.1, 10, function()
					if not IsValid(self) then return end

					self.inspectProgress = (CurTime() - self.inspectStart)/1

					if self.inspectProgress >= 1 then
						self.inspectProgress = 1

						lootEnt:SetNWString(itemName, true)

						self.Paint = function(self, w, h)
							draw.RoundedBox(0,0,0,w,h,self:IsHovered() and black2 or black)
							surface.SetDrawColor(255,255,255,128)
							surface.DrawOutlinedRect(1,1,w-2,h-2)
							
							for i, text in pairs(text) do
								draw.SimpleText(text, "DefaultFixedDropShadow", 6, 6 + (i-1)*12, color_white)
							end
							
							local x,y = self:LocalToScreen(0,0)
							DrawWeaponSelectionEX(wepTbl,x,y,w,h)
						end

						self.DoClick = function()
							net.Start("ply_take_item")
							net.WriteEntity(lootEnt)
							net.WriteString(tostring(itemName))
							net.SendToServer()
						end
						
						self.DoRightClick = self.DoClick
						self:SetText("")
					end
				end)
			end

			button.DoClick = InspectItem
			button.DoRightClick = InspectItem

			button.OnCursorExited = function(self)
				if self.inspecting then
					timer.Remove("ItemInspect_"..tostring(itemName))
					self.inspectProgress = 0
					self.inspecting = false
				end
			end

			button.Paint = function(self, w, h)
				draw.RoundedBox(0,0,0,w,h,self:IsHovered() and black2 or black)
				surface.SetDrawColor(255,255,255,128)
				surface.DrawOutlinedRect(1,1,w-2,h-2)

				if self.inspecting then
					draw.RoundedBox(0,0, h*(1-self.inspectProgress), w, h*self.inspectProgress, Color(220,220,220,150))
				else
					draw.SimpleText("?","HomigradFontBig", w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end
			end

			function button:OnRemove()
				timer.Remove("ItemInspect_"..tostring(itemName))
			end
		else
			button.Paint = function(self, w, h)
				draw.RoundedBox(0,0,0,w,h,self:IsHovered() and black2 or black)
				surface.SetDrawColor(255,255,255,128)
				surface.DrawOutlinedRect(1,1,w-2,h-2)
				
				for i, text in pairs(text) do
					draw.SimpleText(text, "DefaultFixedDropShadow", 6, 6 + (i-1) * 12, color_white)
				end
				
				local x,y = self:LocalToScreen(0,0)
				DrawWeaponSelectionEX(wepTbl,x,y,w,h)
			end

			function button:OnRemove() if IsValid(model) then model:Remove() end end

			button.DoClick = function()
				net.Start("ply_take_item")
				net.WriteEntity(lootEnt)
				net.WriteString(tostring(itemName))
				net.SendToServer()
			end
			button.DoRightClick = button.DoClick
		end
	end

end)