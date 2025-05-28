AddCSLuaFile()

SWEP.Base = "weapon_base"

SWEP.PrintName = "Костюм маньяка"
SWEP.Category = "Примочки убийцы"
SWEP.Instructions = "\nКейс с костюмом для скрытия личности \n\nЛКМ - Скрыть личность \nПКМ - Вернуть личность"
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
	["Убийца"] = {
		name = "Убийца",
		model = "models/player/corpse1.mdl",
		color = Vector(1, 0, 0)
	},
	["Предатель"] = {
		name = "Предатель",
		model = "models/player/phoenix.mdl",
		color = Vector(0, 0, 0)
	},
	["Огузок"] = {
		name = "Огузок",
		model = "models/tdm_kuhnya/oguzok/oguzok.mdl",
		color = Vector(0, 0, 0)
	},
}

local PlayerMeta = FindMetaTable("Entity")

function PlayerMeta:HideIdentity()
	if self.IdentityHidden then return end

	self.TrueIdentity = {
		plyName = self:GetNWString("FakeName"),
		plyModel = self:GetModel(),
		plyColor = self:GetPlayerColor()
	}

	local disguise = self.SelectedDisguise
	if disguise then
		self:SetNWString("FakeName", disguise.name)
		self:SetModel(disguise.model)
		self:SetPlayerColor(disguise.color)
		sound.Play("snd_jack_hmcd_disguise.wav", self:GetPos(), 65, 110)
	end

	self.IdentityHidden = true
end

function PlayerMeta:ShowIdentity()
	if not self.IdentityHidden then return end
	sound.Play("snd_jack_hmcd_disguise.wav", self:GetPos(), 65, 90)
	self:SetNWString("FakeName", self.TrueIdentity.plyName)
	self:SetModel(self.TrueIdentity.plyModel)
	self:SetPlayerColor(self.TrueIdentity.plyColor)
	self.TrueIdentity = nil
	self.IdentityHidden = false
end

if SERVER then
	util.AddNetworkString("maniac_select_model")

	net.Receive("maniac_select_model", function(_, ply)
		local selection = net.ReadString()
		local chosen = ManiacModelChoices[selection]
		if not chosen then return end
		ply.SelectedDisguise = chosen

		if not ply.TrueIdentity then
			ply.TrueIdentity = {
				plyName = ply:GetNWString("FakeName"),
				plyModel = ply:GetModel(),
				plyColor = ply:GetPlayerColor()
			}
		end

		ply:SetNWString("FakeName", chosen.name)
		ply:SetModel(chosen.model)
		ply:SetPlayerColor(chosen.color)

		sound.Play("snd_jack_hmcd_disguise.wav", ply:GetPos(), 65, 110)
		ply.IdentityHidden = true
	end)
end

if CLIENT then
	local function CreateModelButton(layout, name, data, onClose)
		local btn = layout:Add("DButton")
		btn:SetText(name)
		btn:SetTall(30)
		btn:Dock(TOP)
		btn:DockMargin(0, 5, 0, 0)
		btn.DoClick = function()
			net.Start("maniac_select_model")
				net.WriteString(name)
			net.SendToServer()
			btn:GetParent():GetParent():Close()
			if onClose then onClose() end
		end
	end

	function OpenModelSelectMenu(onClose)
		local frame = vgui.Create("DFrame")
		frame:SetTitle("Выберите маскировку")
		frame:SetSize(300, 150)
		frame:Center()
		frame:MakePopup()
		frame.OnClose = onClose

		local layout = vgui.Create("DPanelList", frame)
		layout:Dock(FILL)
		layout:DockMargin(5, 5, 5, 5)
		layout:SetSpacing(5)
		layout:EnableVerticalScrollbar(true)

		for name, data in pairs(ManiacModelChoices) do
			CreateModelButton(layout, name, data, onClose)
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
