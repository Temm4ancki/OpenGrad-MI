SWEP.Base = "weapon_base"

SWEP.PrintName = "База Гранаты"
SWEP.Author = "sadsalat"
SWEP.Purpose = "лкм сильно пкм слабо кинуть"

SWEP.Slot = 4
SWEP.SlotPos = 0
SWEP.Spawnable = false

SWEP.ViewModel = "models/pwb/weapons/w_f1.mdl"
SWEP.WorldModel = "models/pwb/weapons/w_f1.mdl"

SWEP.Grenade = ""

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.DrawWeaponSelection = DrawWeaponSelection
SWEP.OverridePaintIcon = OverridePaintIcon

function TrownGrenade(ply,force,grenade)
    local grenade = ents.Create(grenade)
    grenade:SetPos(ply:GetShootPos() +ply:GetAimVector()*10)
	grenade:SetAngles(ply:EyeAngles()+Angle(45,45,0))
	grenade:SetOwner(ply)
	grenade:SetPhysicsAttacker(ply)
    grenade:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	grenade:Spawn()       
	grenade:Arm()
	local phys = grenade:GetPhysicsObject()              
	if not IsValid(phys) then grenade:Remove() return end                         
	phys:SetVelocity(ply:GetVelocity() + ply:GetAimVector() * force)
	phys:AddAngleVelocity(VectorRand() * force/2)
end

function SWEP:Initialize()
    self:SetHoldType( "grenade" )
end

function SWEP:Deploy()
    self:SetHoldType( "grenade" )
end

function SWEP:PrimaryAttack()
    if SERVER then    
        TrownGrenade(self:GetOwner(),750,self.Grenade)
        self:Remove()
        self:GetOwner():SelectWeapon("weapon_hands")
    end
    self:GetOwner():SetAnimation(PLAYER_ATTACK1)
    self:EmitSound("weapons/pinpull.wav")
end

function SWEP:SecondaryAttack()
    if SERVER then
        TrownGrenade(self:GetOwner(),250,self.Grenade)
        self:Remove()
        self:GetOwner():SelectWeapon("weapon_hands")
    end
    self:GetOwner():SetAnimation(PLAYER_ATTACK1)
    self:EmitSound("weapons/pinpull.wav")
end