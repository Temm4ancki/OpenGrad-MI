SWEP.Base = "weapon_hg_melee_base"

SWEP.PrintName = "флаг"
SWEP.Category = "Ближний Бой"
SWEP.Instructions = "ЗА АФРИКАНИСТАН"

SWEP.Spawnable= true
SWEP.AdminSpawnable= true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 60
SWEP.ViewModel = "models/addons/flag_sib_resp.mdl"
SWEP.WorldModel = "models/addons/flag_sib_resp.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 1
SWEP.SlotPos = 2

SWEP.UseHands = true

---SWEP.HoldType = "knife"

SWEP.FiresUnderwater = false

SWEP.DrawCrosshair = false

SWEP.DrawAmmo = true

SWEP.Primary.Damage = 20
SWEP.Primary.Ammo = "none"
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Recoil = 0.5
SWEP.Primary.Delay = 0.7
SWEP.Primary.Force = 50

SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.DrawSound = "physics/metal/metal_box_impact_soft2.wav"
SWEP.HitSound = "phx/epicmetal_hard.wav"
SWEP.FlashHitSound = "physics/body/body_medium_impact_hard3.wav"
SWEP.ShouldDecal = true
SWEP.HoldTypeWep = "melee"
SWEP.DamageType = DMG_CLUB

SWEP.dwmForward = 2
SWEP.dwmRight = 0
SWEP.dwmUp = 0

SWEP.dwmAUp = -30
SWEP.dwmARight = 0
SWEP.dwmAForward = 100

function SWEP:DrawWorldModel()
	local model = GDrawWorldModel or ClientsideModel(SWEP.WorldModel,RENDER_GROUP_OPAQUE_ENTITY)
	GDrawWorldModel = model
	model:SetNoDraw(true)

	local owner = self:GetOwner()
	if not IsValid(owner) then
		self:DrawModel()
		return
	end

	local Pos,Ang = owner:GetBonePosition(owner:LookupBone("ValveBiped.Bip01_R_Hand"))
	if not Pos then return end

	model:SetModel(self.WorldModel)

	Pos:Add(Ang:Forward() * self.dwmForward)
	Pos:Add(Ang:Right() * self.dwmRight)
	Pos:Add(Ang:Up() * self.dwmUp)

	model:SetPos(Pos)

	Ang:RotateAroundAxis(Ang:Up(),self.dwmAUp)
	Ang:RotateAroundAxis(Ang:Right(),self.dwmARight)
	Ang:RotateAroundAxis(Ang:Forward(),self.dwmAForward)
	model:SetAngles(Ang)

	model:DrawModel()
end