AddCSLuaFile( "shared.lua" )

include( 'shared.lua' )

function ENT:SpawnFunction( ply, tr )
if ( !tr.Hit ) then return end

local SpawnPos = tr.HitPose + tr.HitNormal * 6
self.Spawn_angles = ply:GetAngles()
self.Spawn_angles.pitch = 0
self.Spawn_angles.roll = 0
self.Spawn_angles.yaw = self.Spawn_angles.yaw + 180

local ent = ents.Create( "npc_scug_f" )
ent:SetKeyValue( "disableshadows", "1" )
ent:SetPos( SpawnPos )
ent:SetAngles( self.Spawn_angles )
ent:Spawn()
ent:Activate()

return ent
end

function ENT:Initialize()
self:SetModel("models/props_lab/huladoll.mdl")
self:SetNoDraw(true)
self:DrawShadow(false)
self:SetCollisionGroup(COLLISION_GROUP_NONE)
self:SetName(self.PrintName)
self:SetOwner(self.Owner)
self:DropToFloor()



self.npc = ents.Create( "npc_citizen" )
self.npc:SetPos(self:GetPos())
self.npc:SetAngles(self:GetAngles())
self.npc:SetKeyValue( "spawnflags", "256" )
self.npc:SetKeyValue( "citizentype", "4" )
self.npc:SetKeyValue( "spawnflags", "131072" )


self.npc:SetSpawnEffect(false)
self.npc:Spawn()
self.npc:Activate()
self:SetParent(self.npc)
self.npc:SetNWFloat("ThrowDelay", 10)
self.npc:SetNWFloat("ThrowingSpeed", 5)
self.npc:SetBloodColor(0)
self.npc:CapabilitiesAdd(CAP_AIM_GUN)
self.npc:CapabilitiesAdd(CAP_AUTO_DOORS)
self.npc:CapabilitiesAdd(CAP_DUCK)
self.npc:CapabilitiesAdd(CAP_FRIENDLY_DMG_IMMUNE)
self.npc:CapabilitiesAdd(CAP_MOVE_SHOOT)
self.npc:CapabilitiesAdd(CAP_OPEN_DOORS)
self.npc:CapabilitiesAdd(CAP_SQUAD)
self.npc:CapabilitiesAdd(CAP_USE)
if IsValid(self.npc) and IsValid(self) then self.npc:DeleteOnRemove(self) end
self:DeleteOnRemove(self.npc)
if( IsValid(self.npc))then

local min,max = self.npc:GetCollisionBounds()
local hull = self.npc:GetHullType()
self.npc:SetModel("models/crusader/rainworld/NPC/scugNPC.mdl")
self.npc:SetName("Slugcat")
self.npc:SetSolid(SOLID_BBOX)
self.npc:SetPos(self.npc:GetPos()+self.npc:GetUp()*16)
self.npc:SetHullType(hull)
self.npc:SetHullSizeNormal()
self.npc:SetCollisionBounds(min,max)
self.npc:DropToFloor()
self.npc:SetModelScale(1)
self.npc:SetColor( Color( math.random(140,255), math.random(140,255), math.random(140,255), math.random(0,255) ) )
end
end


function ENT:MeleeAttacks(npc)
	if IsValid(npc) then
		local enemy = npc:GetEnemy()

		if IsValid(enemy) and npc:Visible(enemy) and enemy:GetPos():DistToSqr(npc:GetPos()) <= 70^2 then
			if (not IsValid(npc)) or (not IsValid(enemy)) then return end
			if IsValid(enemy) and enemy:GetPos():DistToSqr(npc:GetPos()) > 70^2 then return end
			if (npc:GetNWFloat("MeleeAttack") > CurTime()) then return false end

			npc:AddGestureSequence(npc:LookupSequence("swing"))
			local pos = npc:GetShootPos()
			local ang = npc:GetAimVector()
			local damagedice = (5)
			local primdamage = (1)
			local pain = primdamage * damagedice

			local slash = {}
			slash.start = pos
			slash.endpos = pos+(ang*50)
			slash.filter = npc
			slash.mins = Vector(5,5,1)
			slash.maxs = Vector(50,50,50)
			local slashtrace = util.TraceHull(slash)
			if slashtrace.Hit then
				local targ = slashtrace.Entity
				if npc:Disposition(targ) == D_LI or npc:Disposition(targ) == D_NU then return end
				local paininfo = DamageInfo()
				paininfo:SetDamage(pain)
				paininfo:SetDamageType(DMG_CLUB)
				paininfo:SetAttacker(npc)
				if IsValid(npc:GetActiveWeapon()) then
					paininfo:SetInflictor(npc:GetActiveWeapon())
				else
					paininfo:SetInflictor(npc)
				end
				local RandomForce = math.random(100,200)
				paininfo:SetDamageForce(slashtrace.Normal * RandomForce)
				targ:SetVelocity(npc:GetForward()*500+npc:GetUp()*150)
				if targ:IsNPC() then
					targ:StopMoving()
				end
				if targ:IsPlayer() then
					targ:ViewPunch(Angle(-20,math.random(-50,50),math.random(-15,15)))
				end
				if targ:IsPlayer() or targ:IsNPC() then
					local blood = targ:GetBloodColor()	
					local fleshimpact = EffectData()
					fleshimpact:SetEntity(self.Weapon)
					fleshimpact:SetOrigin(slashtrace.HitPos)
					fleshimpact:SetNormal(slashtrace.HitPos)
					if blood >= 0 then
						fleshimpact:SetColor(blood)
						util.Effect("BloodImpact", fleshimpact)
					end
				end
				targ:TakeDamageInfo(paininfo)
			else
			end
			npc:SetNWFloat("MeleeAttack", CurTime() + 1)
		end
	end
end


function ENT:OnRemove()
if IsValid(self.npc) then
self.npc:Remove()
end
end