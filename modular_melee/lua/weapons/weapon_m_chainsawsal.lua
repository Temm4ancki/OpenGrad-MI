SWEP.Base = "koishi_melee"

SWEP.PrintName = "Бензопила Сальвадора"
SWEP.Category = "md3 - Melee "
SWEP.Purpose = "BASTA, HIJO DE PUTA! \nДАВАЙ МОТОР! \nУХАХАХАХАХАХ!"
SWEP.Author = "Temm4ancki"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 60
SWEP.ViewModel = "models/weapons/salat/w_hg_chainsawsal/chainsawsal.mdl"
SWEP.WorldModel = "models/weapons/salat/w_hg_chainsawsal/chainsawsal.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 1
SWEP.SlotPos = 2

SWEP.UseHands = true

SWEP.FiresUnderwater = false

SWEP.DrawCrosshair = false

SWEP.DrawAmmo = true

SWEP.Primary.Damage = 5
SWEP.Primary.Ammo = "none"
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Recoil = 0.5
SWEP.Primary.Delay = 1.3
SWEP.Primary.Force = 70

SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.DrawSound = "weapons/salat/w_hg_crowbar/holster_in_light.ogg"
SWEP.HitSound = "weapons/salat/w_hg_crowbar/snd_jack_hmcd_knifehit.ogg"
SWEP.FlashHitSound = "weapons/salat/w_hg_crowbar/flesh_impact_blunt_04.ogg"
SWEP.ShouldDecal = true
SWEP.HoldTypeWep = "physgun"
SWEP.DamageType = DMG_SLASH

SWEP.EngineRunning = false
SWEP.StartingEngine = false
SWEP.LoopSound = nil
SWEP.LoopDelay = 0
SWEP.StartDelay = 2.2
SWEP.HitDelay = 1
SWEP.LoopDuration = 1.80
SWEP.NextLoopTime = 0
SWEP.LoopTimerName = ""
SWEP.IsAttacking = false
SWEP.AttackStartTime = 0
SWEP.AttackDuration = 1.0
SWEP.CanBreakDoors = true

function SWEP:Initialize()
	self:SetHoldType(self.HoldTypeWep)
	self.EngineRunning = false
	self.StartingEngine = false
	self.LoopDelay = 0
	self.StartDelay = 2.2
	self.HitDelay = 1
	self.LoopDuration = 1.80
	self.NextLoopTime = 0
	self.LoopTimerName = ""
	self.IsAttacking = false
	self.AttackStartTime = 0
	self.AttackDuration = 1.0
end

function SWEP:Deploy()
	self:SetNextPrimaryFire(CurTime())
	self:SetHoldType(self.HoldTypeWep)
	if SERVER then
		self:GetOwner():EmitSound(self.DrawSound, 60)
	end
	self.EngineRunning = false
	self.StartingEngine = false
	self:StopEngineLoop()
end

function SWEP:Holster()
	self:StopEngineLoop()
	return true
end

function SWEP:StartEngineLoop()
	if not SERVER or not IsValid(self:GetOwner()) then return end
	
	self:StopEngineLoop()
	self:PlayLoopSound()
	self:ScheduleNextLoop()
end

function SWEP:PlayLoopSound()
	if not SERVER or not IsValid(self:GetOwner()) then return end
	
	self:GetOwner():EmitSound("weapons/salat/w_hg_chainsaw/chain_lo.ogg", 75)
end

function SWEP:ScheduleNextLoop()
	if not SERVER then return end
	
	self.LoopTimerName = "chainsaw_loop_" .. self:EntIndex() .. "_" .. CurTime()
	self.NextLoopTime = CurTime() + self.LoopDuration
	
	timer.Create(self.LoopTimerName, self.LoopDuration, 0, function()
		if IsValid(self) and IsValid(self:GetOwner()) and self.EngineRunning then
			self:PlayLoopSound()
		else
			self:StopEngineLoop()
		end
	end)
end

function SWEP:StopEngineLoop()
	if self.LoopSound then
		self.LoopSound:Stop()
		self.LoopSound = nil
	end
	
	if self.LoopTimerName and self.LoopTimerName ~= "" then
		timer.Remove(self.LoopTimerName)
		self.LoopTimerName = ""
	end
	
	self.NextLoopTime = 0
end

function SWEP:SetLoopDuration(duration)
	self.LoopDuration = math.max(0.1, duration)
	
	if self.EngineRunning and SERVER then
		self:StartEngineLoop()
	end
end

function SWEP:Reload()
	if self.NextReload and self.NextReload > CurTime() then return end
	self.NextReload = CurTime() + 0.5

	if self.StartingEngine then
		self.StartingEngine = false
		if SERVER then
			self:GetOwner():EmitSound("weapons/salat/w_hg_chainsaw/chain_end.ogg", 75)
		end
		return
	end

	if self.EngineRunning then
		self.EngineRunning = false
		self:StopEngineLoop()
		if SERVER then
			self:GetOwner():EmitSound("weapons/salat/w_hg_chainsaw/chain_end.ogg", 75)
			self:GetOwner():StopSound("weapons/salat/w_hg_chainsaw/chain_strat.ogg", 75)
		end
		return
	end

	if not self.EngineRunning and not self.StartingEngine then
		self.StartingEngine = true

		if SERVER then
			self:GetOwner():EmitSound("weapons/salat/w_hg_chainsaw/chain_strat.ogg", 75)
		end

		timer.Simple(self.StartDelay, function()
			if not IsValid(self) or not IsValid(self:GetOwner()) then return end
			if not self.StartingEngine then
				return
			end

			self.StartingEngine = false
			self.EngineRunning = true

			if SERVER then
				if self.LoopDelay > 0 then
					timer.Simple(self.LoopDelay, function()
						if IsValid(self) and IsValid(self:GetOwner()) and self.EngineRunning then
							self:StartEngineLoop()
						end
					end)
				else
					self:StartEngineLoop()
				end
			end
		end)
	end
end

function SWEP:PrimaryAttack()
	if self.StartingEngine then return end

	local oldHoldType = self:GetHoldType()
	self:SetHoldType("duel")
	self:GetOwner():SetAnimation(PLAYER_ATTACK1)
	timer.Simple(0.1, function()
		if IsValid(self) then
			self:SetHoldType(oldHoldType)
		end
	end)
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay/((self:GetOwner().stamina or 100)/100)-(self:GetOwner():GetNWInt("Adrenaline")/5))

	if SERVER then
		self:GetOwner():EmitSound("weapons/slam/throw.wav", 60)
		self:GetOwner().stamina = math.max(self:GetOwner().stamina - self.Primary.Damage / 5, 0)
	end

	self:GetOwner():LagCompensation(true)
	local ply = self:GetOwner()

	local tra = {}
	tra.start = ply:GetAttachment(ply:LookupAttachment("eyes")).Pos
	tra.endpos = tra.start + ply:GetAngles():Forward() * 80
	tra.filter = self:GetOwner()
	local Tr = util.TraceLine(tra)
	local t = {}
	local pos1, pos2
	local tr

	if not Tr.Hit then
		t.start = ply:GetAttachment(ply:LookupAttachment("eyes")).Pos
		t.endpos = t.start + ply:GetAngles():Forward() * 80
		t.filter = function(ent) return ent ~= self:GetOwner() and (ent:IsPlayer() or ent:IsRagdoll()) end
		t.mins = -Vector(10,10,10)
		t.maxs = Vector(10,10,10)
		tr = util.TraceHull(t)
	else
		tr = util.TraceLine(tra)
	end

	pos1 = tr.HitPos + tr.HitNormal
	pos2 = tr.HitPos - tr.HitNormal

	self:PerformAttack(tr)

	if SERVER and Tr.Hit and self.ShouldDecal then
		if IsValid(Tr.Entity) and Tr.Entity:GetClass()=="prop_ragdoll" then
			util.Decal("Blood",tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
		else
			util.Decal("ManhackCut",pos1,pos2)
		end
	end

	self:GetOwner():LagCompensation(false)
end


function SWEP:PerformAttack(tr)
	if not SERVER then return end

	if self.EngineRunning then
		self:GetOwner():EmitSound("weapons/salat/w_hg_chainsaw/chain_cut.ogg", 75)
	else
		self:GetOwner():EmitSound(self.HitSound, 60)
	end

	if IsValid(tr.Entity) then
		local damage = self.EngineRunning and 100 or 5

		local dmginfo = DamageInfo()
		dmginfo:SetDamageType(self.DamageType)
		dmginfo:SetAttacker(self:GetOwner())
		dmginfo:SetInflictor(self)
		dmginfo:SetDamagePosition(tr.HitPos)
		dmginfo:SetDamageForce(self:GetOwner():GetForward() * self.Primary.Force)

		local angle = self:GetOwner():GetAngles().y - tr.Entity:GetAngles().y
		if angle < -180 then angle = 360 + angle end

		if angle <= 90 and angle >= -90 then
			dmginfo:SetDamage(damage * 3)
		else
			dmginfo:SetDamage(damage)
		end

		self:HandleDoorBreaking(tr.Entity, damage)

		if tr.Entity:IsNPC() or tr.Entity:IsPlayer() then
			if self.EngineRunning then
				self:GetOwner():EmitSound("weapons/salat/w_hg_chainsaw/chain_hit.ogg", 75)
				timer.Simple(self.HitDelay, function()
					if IsValid(self) and IsValid(self:GetOwner()) then
						self:GetOwner():EmitSound("weapons/salat/w_hg_chainsaw/chain_hitend.ogg", 75)
					end
				end)
			else
				self:GetOwner():EmitSound(self.FlashHitSound, 60)
			end

		elseif IsValid(tr.Entity:GetPhysicsObject()) then
			local dmginfo2 = DamageInfo()
			dmginfo2:SetDamageType(self.DamageType)
			dmginfo2:SetAttacker(self:GetOwner())
			dmginfo2:SetInflictor(self)
			dmginfo2:SetDamagePosition(tr.HitPos)
			dmginfo2:SetDamageForce(self:GetOwner():GetForward() * self.Primary.Force * 7)
			dmginfo2:SetDamage(damage)
			tr.Entity:TakeDamageInfo(dmginfo2)

			if tr.Entity:GetClass() == "prop_ragdoll" then
				if self.EngineRunning then
					timer.Simple(self.HitDelay, function()
						if IsValid(self) and IsValid(self:GetOwner()) then
							self:GetOwner():EmitSound("weapons/salat/w_hg_chainsaw/chain_hitend.ogg", 75)
						end
					end)
				else
					self:GetOwner():EmitSound(self.FlashHitSound, 60)
				end
			end
		end

		tr.Entity:TakeDamageInfo(dmginfo)
	end
end

function SWEP:HandleDoorBreaking(entity, damage)
	if not self.CanBreakDoors then return end
	if not (entity:GetClass() == "prop_door_rotating" or entity:GetClass() == "func_door") then return end

	entity:EmitSound("physics/wood/wood_box_impact_hard"..math.random(1,6)..".wav")

	local currentChance = entity:GetNWInt("DoorBreakChance", 0)
	if currentChance == 0 then
		local baseDamage = math.max(damage, 20)
		currentChance = math.min(baseDamage, 20)
	else
		currentChance = currentChance + 5
	end
	entity:SetNWInt("DoorBreakChance", currentChance)
	if math.random(1, 100) <= currentChance then
		entity:EmitSound("physics/metal/metal_box_break"..math.random(1,2)..".wav")
		local doorPos = entity:GetPos()
		local doorAng = entity:GetAngles()
		local doorModel = entity:GetModel()
		local doorSkin = entity:GetSkin()
		local doorColor = entity:GetColor()
		local doorMaterial = entity:GetMaterial()
		local prop = ents.Create("prop_physics")
		if IsValid(prop) then
			if doorModel and doorModel ~= "" then
				prop:SetModel(doorModel)
			else
				prop:SetModel("models/props_c17/door01_left.mdl")
			end
			prop:SetPos(doorPos)
			prop:SetAngles(doorAng)
			prop:SetSkin(doorSkin)
			prop:SetColor(doorColor)
			if doorMaterial and doorMaterial ~= "" then
				prop:SetMaterial(doorMaterial)
			end
			prop:Spawn()
			prop:Activate()
			for i = 0, entity:GetNumBodyGroups() - 1 do
				prop:SetBodygroup(i, entity:GetBodygroup(i))
			end
			local phys = prop:GetPhysicsObject()
			if IsValid(phys) then
				phys:SetVelocity(self:GetOwner():GetForward() * 200 + Vector(0, 0, 100))
				phys:AddAngleVelocity(VectorRand() * 300)
			end
		end
		entity:Remove()
	end
end

function SWEP:Think()
	if SERVER and self.EngineRunning and IsValid(self:GetOwner()) then
		if CurTime() >= self.NextLoopTime and (not self.LoopTimerName or self.LoopTimerName == "") then
			self:StartEngineLoop()
		end
	end
end

function SWEP:OnRemove()
	self:StopEngineLoop()
end