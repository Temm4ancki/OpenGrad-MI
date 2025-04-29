SWEP.Base = "weapon_hg_melee_base"

SWEP.PrintName = "копье"
SWEP.Category = "Ближний Бой"
SWEP.Instructions = "копе кидац."

SWEP.Spawnable= true
SWEP.AdminSpawnable= true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 60
SWEP.ViewModel = "models/props_junk/harpoon002a.mdl"
SWEP.WorldModel = "models/props_junk/harpoon002a.mdl"
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

SWEP.Primary.Damage = 10
SWEP.Primary.Ammo = "none"
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Recoil = 0.5
SWEP.Primary.Delay = 0.7
SWEP.Primary.Force = 60

SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.DrawSound = "snd_jack_hmcd_knifedraw.wav"
SWEP.HitSound = "physics/metal/metal_canister_impact_hard3.wav"
SWEP.FlashHitSound = "snd_jack_hmcd_axehit.wav"
SWEP.ShouldDecal = true
SWEP.HoldTypeWep = "melee"
SWEP.DamageType = DMG_SLASH

SWEP.dwmForward = 3
SWEP.dwmRight = 2
SWEP.dwmUp = -10

SWEP.dwmAUp = 0
SWEP.dwmARight = -90
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

	model:SetModelScale(0.7)

	model:DrawModel()
end

-- почините копьё плиз