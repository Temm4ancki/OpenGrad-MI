AddCSLuaFile()

if engine.ActiveGamemode() == "terrortown" then
	SWEP.Base = "weapon_tttbase"
	SWEP.Slot = 8
else
	SWEP.Base = "weapon_base"
	SWEP.Slot = 4
end

SWEP.AutoSpawnable = false
SWEP.InLoadoutFor = nil
SWEP.AllowDrop = false
SWEP.IsSilent = false
SWEP.NoSights = true

SWEP.Spawnable	= false
SWEP.AdminOnly	= false
SWEP.HoldType = "slam"
SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true
SWEP.DrawCrosshair        = false
SWEP.BounceWeaponIcon   = false

SWEP.Primary.ClipSize        = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic        = true
SWEP.Primary.Ammo            = "None" 

SWEP.Secondary.ClipSize        = -1 
SWEP.Secondary.DefaultClip    = -1 
SWEP.Secondary.Automatic    = false 
SWEP.Secondary.Ammo            = "none"
SWEP.FumoCount = 0


local cvarMinSqueezes = 3
local cvarExpChance = 0.1
local cvarForceKill = 0
local cvarTripCooldown = 8
local cvarDetonateTime = 5
local cvarUseTracks = 1

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	self.ClickCount = 0
	self.Idle = 0
	self.IdleTimer = CurTime() + 1
end

-- Seems to be a fix for the weapon's staying static after playing the deploy animation.
function SWEP:Think()
	if self.Idle == 0 and self.IdleTimer <= CurTime() then
		if SERVER then
			local vm = self.Owner:GetViewModel()
			vm:SendViewModelMatchingSequence( vm:LookupSequence( "idle" ) )
		end
		self.Idle = 1
	end
end

function SWEP:Holster()
	if CLIENT and IsValid(self.WorldModelEnt) then
		self.WorldModelEnt:Remove()
	end
	return true
end

function SWEP:Deploy()
	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "deploy" ) )
	self.Idle = 0
	self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()

	if SERVER then self.Owner:EmitSound("carryable_fumos/fumosays.wav") end
end

SWEP.Primary.Delay = 5


function SWEP:PrimaryAttack()
	local music = self.ThemeMusic
	self.TimerName = self.PrintName .. self.FumoCount .. "_spin"
    local ply = self:GetOwner()
    if not IsValid( ply ) then return end
    ply:SetAnimation( PLAYER_ATTACK1 )
    local vm = ply:GetViewModel()
    if not IsValid( vm ) then return end
    vm:SendViewModelMatchingSequence( vm:LookupSequence( "deploy" ) )
    if SERVER then
        local ply = self:GetOwner()
        self.Primary.Delay = CurTime() + cvarTripCooldown + 0.01
        local pos = ply:GetPos() + Vector(0,0,10)
        local ent = ents.Create("prop_physics")
        ent:SetModel(self.WorldModel)
        ent:SetPos(pos)
        ent:SetCollisionGroup(COLLISION_GROUP_WORLD)
        ent:SetMoveType(MOVETYPE_NONE)
        ent:SetSolid(SOLID_NONE)
        ent:Spawn()
		ent:EmitSound("carryable_fumos/wtfac4.wav", 100, 130)
		ent:EmitSound(music, 75, 100)
		ent:CallOnRemove( "StopFumoSound", function() ent:StopSound( music ) end ) -- <- кстати тут есть че то что тебе нужно @Temm4ancki 
		self.FumoCount = self.FumoCount + 2
        timer.Simple(cvarDetonateTime, function()
            if IsValid(ent) then
				ent:Remove()
                local explosion = ents.Create("env_explosion")
                explosion:SetPos(ent:GetPos())
                explosion:SetOwner(ply)
                explosion:SetKeyValue("iMagnitude", "220")
                explosion:Spawn()
                explosion:Fire("Explode", "", 0)
				JMod.BlastDoors(ent, ent:GetPos() + Vector(0, 0, 60), 10*.25)
                ent:Remove()
				ent:StopSound("carryable_fumos/fumofunkyy.wav")
				
				--some quick patch
				if ply:Alive() then
					self.FumoCount = self.FumoCount - 1
				end
            end
        end)
    local ang = Angle(0,0,-80)
        local phys = ent:GetPhysicsObject()
        if IsValid(phys) then
            phys:EnableMotion(false)
        end

        timer.Create(self.TimerName, 0.01, 0, function()
            if IsValid(ent) then
                ang.y = ang.y + 10
                ent:SetAngles(ang)
                ent:SetPos(pos + Vector(0,0,math.sin(CurTime()*5)*5))
            end
        end)
    end
	if SERVER then
    self:SetNextPrimaryFire(CurTime() + cvarTripCooldown)
	end
end

function SWEP:SecondaryAttack()
    self.Owner:EmitSound("carryable_fumos/fumosquee.wav", 100, 100)
    if self:GetNextSecondaryFire() > CurTime() then return end
    self:SetNextSecondaryFire(CurTime() + 1)

    if SERVER and self.ClickCount >= cvarMinSqueezes and math.random() < cvarExpChance then 
        local explosion = ents.Create("env_explosion") 
        explosion:SetPos(self.Owner:GetPos()) 
        explosion:SetOwner(self.Owner)
        explosion:Spawn()
        explosion:SetKeyValue("iMagnitude", "200")
        explosion:Fire("Explode", 0, 0)

		if cvarForceKill then
			self.Owner:Kill()
		end
    end
	
	self.ClickCount = self.ClickCount + 1
end

function SWEP:DrawWeaponSelection(x,y,wide,tall,alpha)
    local bounce = 5 * math.sin(RealTime() * 10)
    surface.SetDrawColor(255, 255, 255, alpha)
    surface.SetMaterial(Material(self.FumoIcon))
    surface.DrawTexturedRect(x + wide/4, y + tall/7 + bounce, wide/2, tall/1.5)
end

function SWEP:DrawWorldModel()
	local _Owner = self:GetOwner()
	local ownervalid = IsValid(_Owner)
	
	if not IsValid(self.WorldModelEnt) then
		self.WorldModelEnt = ClientsideModel(self.WorldModel)
		self.WorldModelEnt:SetNoDraw(true) -- fix to prevent fumo's rendering twice when in front of mirrors
	end

	self.WorldModelEnt:SetModel(self.WorldModel)

	if ownervalid then
		local boneid = _Owner:LookupBone("ValveBiped.Bip01_R_Hand")
		if !boneid then return end

		local matrix = _Owner:GetBoneMatrix(boneid)
		if !matrix then return end

		local newPos, newAng = LocalToWorld(self.OffsetVec or Vector(-5, -2, -5), self.OffsetAng or Angle(-50, 50, 80), matrix:GetTranslation(), matrix:GetAngles())

		self.WorldModelEnt:SetPos(newPos)
		self.WorldModelEnt:SetAngles(newAng)

		self.WorldModelEnt:SetupBones()
	else
		self.WorldModelEnt:SetPos(self:GetPos())
		self.WorldModelEnt:SetAngles(self:GetAngles())
	end

	self.WorldModelEnt:DrawModel()
end