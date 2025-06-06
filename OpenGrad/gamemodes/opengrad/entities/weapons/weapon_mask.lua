AddCSLuaFile()

SWEP.Base = "weapon_base"

SWEP.PrintName = "Костюм маньяка"
SWEP.Category = "Примочки убийцы"
SWEP.Purpose  = "Кейс с костюмом для скрытия личности"
SWEP.Purpose = "R - Выбрать одежду маньяка \nЛКМ - Скрыть личность \nПКМ - Вернуть личность"
SWEP.Author			= ""
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.IconOverride = "vgui/icon/mask.png"

SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.ViewModel = "models/props_c17/SuitCase_Passenger_Physics.mdl"
SWEP.WorldModel = "models/props_c17/SuitCase_Passenger_Physics.mdl"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.Slot = 5
SWEP.SlotPos = 3
SWEP.Weight = 3

SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false
SWEP.CommandDroppable = false

function SWEP:Initialize()
	self:SetHoldType("normal")
end

function SWEP:Deploy()
	self:SetNextPrimaryFire(CurTime() + 1)
	self:SetNextSecondaryFire(CurTime() + 1)
	return true
end

function SWEP:PrimaryAttack()
	if self:GetOwner():KeyDown(IN_SPEED) and self:GetOwner():KeyDown(IN_FORWARD) then return end

	-- Проверяем, выбрана ли маскировка
	if SERVER and not self:GetOwner().SelectedDisguise then
		self:GetOwner():ChatPrint("Сначала выберите маскировку! Нажмите R для выбора.")
		self:SetNextPrimaryFire(CurTime() + 1)
		self:SetNextSecondaryFire(CurTime() + 1)
		return
	end

	self:GetOwner():SetAnimation(PLAYER_ATTACK1)
	if SERVER then self:GetOwner():HideIdentity() end
	self:SetNextPrimaryFire(CurTime() + 1)
	self:SetNextSecondaryFire(CurTime() + 1)
end

function SWEP:SecondaryAttack()
	if self:GetOwner():KeyDown(IN_SPEED) and self:GetOwner():KeyDown(IN_FORWARD) then return end
	self:GetOwner():SetAnimation(PLAYER_ATTACK1)
	if SERVER then self:GetOwner():ShowIdentity() end
	self:SetNextPrimaryFire(CurTime() + 1)
	self:SetNextSecondaryFire(CurTime() + 1)
end

function SWEP:Reload()
	if CLIENT and not self.MenuOpen then
		self.MenuOpen = true
		timer.Simple(0, function()
			if IsValid(self) then
				OpenModelSelectMenu(function()
					if IsValid(self) then
						self.MenuOpen = false
					end
				end)
			end
		end)
	end
end

function SWEP:Think() end
function SWEP:OnDrop() end

ManiacModelChoices = {
	["Трупак"] = {
		name = "Трупак",
		model = "models/player/corpse1.mdl",
		color = Vector(255, 0, 0)
	},
	["Джейсон Вурхиз"] = {
		name = "Джейсон Вурхиз",
		model = "models/hg_homicide/traitor/MKX_Jajon.mdl",
		color = Vector(255, 255, 255)
	},
	["Джекет"] = {
		name = "Джекет",
		model = "models/hg_homicide/traitor/jacket.mdl",
		color = Vector(139, 0, 255)
	},
}

local PlayerMeta = FindMetaTable("Entity")

function PlayerMeta:HideIdentity()
	if self.IdentityHidden then return end

	local disguise = self.SelectedDisguise
	if not disguise then
		self:ChatPrint("Маскировка не выбрана!")
		return
	end

	self.TrueIdentity = {
		plyName = self:GetNWString("FakeName"),
		plyModel = self:GetModel(),
		plyColor = self:GetPlayerColor()
	}

	self:SetNWString("FakeName", disguise.name)
	self:SetModel(disguise.model)
	self:SetPlayerColor(disguise.color)
	sound.Play("weapons/mask/snd_jack_hmcd_disguise.ogg", self:GetPos(), 65, 110)

	self.IdentityHidden = true
end

function PlayerMeta:ShowIdentity()
	if not self.IdentityHidden then return end
	sound.Play("weapons/mask/snd_jack_hmcd_disguise.ogg", self:GetPos(), 65, 90)
	self:SetNWString("FakeName", self.TrueIdentity.plyName)
	self:SetModel(self.TrueIdentity.plyModel)
	self:SetPlayerColor(self.TrueIdentity.plyColor)
	self.TrueIdentity = nil
	self.IdentityHidden = false
end

hook.Add("PostCleanupMap", "ResetManiacIdentities", function()
	for _, ply in ipairs(player.GetAll()) do
		if ply.IdentityHidden and ply.ShowIdentity then
			ply:ShowIdentity()
		end

		ply.TrueIdentity = nil
		ply.IdentityHidden = false
	end
end)

if SERVER then
	util.AddNetworkString("maniac_select_model")

	net.Receive("maniac_select_model", function(_, ply)
		local selection = net.ReadString()
		local chosen = ManiacModelChoices[selection]
		if not chosen then return end
		ply.SelectedDisguise = chosen

		ply:ChatPrint("Выбрана маскировка: " .. chosen.name)

		if not ply.TrueIdentity then
			ply.TrueIdentity = {
				plyName = ply:GetNWString("FakeName"),
				plyModel = ply:GetModel(),
				plyColor = ply:GetPlayerColor()
			}
		end
	end)
end

if CLIENT then
	-- Используем общую библиотеку UI
	include("homigrad_scr/game/tier_1/ui_library_cl.lua")
	
	local Dynamic = 0
	
	local function BlurBackground(panel)
		if not (IsValid(panel) and panel:IsVisible()) then return end
		HG_UI.BlurBackground(panel, Dynamic)
		Dynamic = math.Clamp(Dynamic + FrameTime() * 7, 0, 1)
	end

	function OpenModelSelectMenu(onClose)
		local modelCount = table.Count(ManiacModelChoices)
		local modelsPerRow = math.min(modelCount, 5)
		local itemWidth, itemHeight = 160, 300
		local spacing = 10
		local padding = 20

		local rows = math.ceil(modelCount / modelsPerRow)

		local width = modelsPerRow * (itemWidth + spacing) - spacing + padding * 2
		local height = rows * (itemHeight + spacing) - spacing + padding * 2 + 20

		local frame = vgui.Create("DFrame")
		frame:SetTitle("")
		frame:SetSize(width, height)
		frame:Center()
		frame:MakePopup()
		frame.OnClose = onClose

		if IsValid(frame.btnMinim) then frame.btnMinim:SetVisible(false) end
		if IsValid(frame.btnMaxim) then frame.btnMaxim:SetVisible(false) end
		frame:ShowCloseButton(true)
		-- frame:SetDraggable(false)

		frame.Paint = function(self, w, h)
			BlurBackground(self)
			HG_UI.DrawFrame(0, 0, w, h, Color(10, 10, 10, 100), Color(155, 55, 55, 255), 2)
			draw.SimpleText("Выберите маскировку", HG_UI.FONTS.BIG, w / 2, 15, HG_UI.COLORS.TEXT_PRIMARY, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		end

		local buttonLayout = vgui.Create("DIconLayout", frame)
		buttonLayout:SetPos(padding, 50)
		buttonLayout:SetSize(width - padding * 2, height - 50 - padding)
		buttonLayout:SetSpaceX(spacing)
		buttonLayout:SetSpaceY(spacing)

		for name, data in pairs(ManiacModelChoices) do
			local panel = buttonLayout:Add("DPanel")
			panel:SetSize(itemWidth, itemHeight)
			panel.Paint = function(self, w, h)
				HG_UI.DrawPanel(0, 0, w, h, Color(20, 20, 20, 125), Color(155, 55, 55, 200))
			end

			local modelPreview = vgui.Create("DModelPanel", panel)
			modelPreview:Dock(FILL)
			modelPreview:SetModel(data.model)
			modelPreview:SetFOV(50)
			modelPreview:SetCamPos(Vector(50, 0, 60))
			modelPreview:SetLookAt(Vector(0, 0, 40))
			function modelPreview:LayoutEntity(ent) return end

			-- Добавляем обработчик клика на модель
			function modelPreview:OnMousePressed(mcode)
				if mcode == MOUSE_LEFT then
					net.Start("maniac_select_model")
					net.WriteString(name)
					net.SendToServer()
					frame:Close()
					if onClose then onClose() end
				end
			end

			local btn = vgui.Create("DButton", panel)
			btn:Dock(BOTTOM)
			btn:SetText(name)
			btn:SetFont("HomigradSmall")
			btn:SetTall(35)
			local colorVec = data.color
			local textColor = Color(colorVec.x, colorVec.y, colorVec.z, 255)
			btn:SetTextColor(textColor)

			btn.Paint = function(self, w, h)
				HG_UI.DrawPanel(0, 0, w, h, Color(5, 5, 5, 155), Color(155, 55, 55, 180))
			end
			btn.DoClick = function()
				net.Start("maniac_select_model")
				net.WriteString(name)
				net.SendToServer()
				frame:Close()
				if onClose then onClose() end
			end
		end
	end

	local model = GDrawWorldModel or ClientsideModel(SWEP.WorldModel, RENDER_GROUP_OPAQUE_ENTITY)
	GDrawWorldModel = model
	model:SetNoDraw(true)

	SWEP.dwmModeScale = 0.5
	SWEP.dwmForward = 5
	SWEP.dwmRight = 0
	SWEP.dwmUp = 0
	SWEP.dwmAUp = 0
	SWEP.dwmARight = 90
	SWEP.dwmAForward = 0

	function SWEP:DrawWorldModel()
		local owner = self:GetOwner()
		if not IsValid(owner) then self:DrawModel() return end

		local Pos, Ang = owner:GetBonePosition(owner:LookupBone("ValveBiped.Bip01_R_Hand"))
		if not Pos then return end

		model:SetModel(self.WorldModel)
		model:SetSkin(not self.bloodinside and 1 or 0)

		Pos:Add(Ang:Forward() * self.dwmForward)
		Pos:Add(Ang:Right() * self.dwmRight)
		Pos:Add(Ang:Up() * self.dwmUp)
		model:SetPos(Pos)

		Ang:RotateAroundAxis(Ang:Up(), self.dwmAUp)
		Ang:RotateAroundAxis(Ang:Right(), self.dwmARight)
		Ang:RotateAroundAxis(Ang:Forward(), self.dwmAForward)
		model:SetAngles(Ang)

		model:SetModelScale(1)
		model:DrawModel()
	end
end