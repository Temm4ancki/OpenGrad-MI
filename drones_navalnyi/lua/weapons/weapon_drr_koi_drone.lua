AddCSLuaFile()

SWEP.PrintName	= "FPV Дрон"
SWEP.Category = "md3"
SWEP.Purpose = "Запускаемый дрон с камерой."

SWEP.Spawnable	= true
SWEP.UseHands	= true
SWEP.DrawAmmo	= false

SWEP.ViewModelFOV	= 50
SWEP.Slot			= 0
SWEP.SlotPos		= 5

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= "none"

SWEP.ViewModel = "models/dronesrewrite/cameradr/cameradr.mdl"
SWEP.WorldModel = "models/dronesrewrite/cameradr/cameradr.mdl"

SWEP.TargetDRR = NULL
SWEP.IndexDRR = 0
SWEP.WaitDRR = 0

SWEP.addPos = Vector(0,0,0)
SWEP.addAng = Angle(0,0,0)

SWEP.RightMod = -.9
SWEP.ForwardMod = 5
SWEP.UpMod = 5.5
SWEP.AngleMod = Angle(-10,4,0)

SWEP.RemoteDRRDistance = 4096

local drone = "dronesrewrite_camera"

function SWEP:DoIdle()
	timer.Create("weapon_idle" .. self:EntIndex(), self:SequenceDuration(), 1, function() 
		if IsValid(self) then 
			self:SendWeaponAnim(ACT_VM_IDLE) 
			self:DoIdle()
		end 
	end)
end

function SWEP:Initialize()
	self:SetHoldType("duel")
end

function SWEP:PrimaryAttack()
    if CLIENT then return end

    local ply = self:GetOwner()
    local ent = ents.Create(drone)
    if not IsValid(ply) then return end
    if not IsValid(ent) then return end

    ent:SetPos(ply:GetPos() + ply:GetForward() * 50 + Vector(0, 0, 50))
    ent:SetAngles(Angle(0, ply:EyeAngles().y, 0))
    ent:Spawn()
    ent:Activate()
    ent:SetOwner(ply)

	undo.Create("FPV Drone")
	undo.AddEntity(ent)
	undo.SetPlayer(ply)
    undo.Finish()


	ply:StripWeapon(self:GetClass())
	ply:Give("weapon_drr_remote")
	ply:SelectWeapon("weapon_drr_remote")
end

function SWEP:SecondaryAttack()end

function SWEP:OnRemove()
	timer.Stop("weapon_idle" .. self:EntIndex())
	timer.Stop("request_drone" .. self:EntIndex())
end

function SWEP:Holster()
	self:OnRemove()
	return true
end

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DRAW)
	self:DoIdle()

	self:SetDeploySpeed(0.7)
	
	self:SetNextPrimaryFire(CurTime() + self:SequenceDuration() * 0.8)
	self:SetNextSecondaryFire(CurTime() + self:SequenceDuration() * 0.8)

	return true
end
