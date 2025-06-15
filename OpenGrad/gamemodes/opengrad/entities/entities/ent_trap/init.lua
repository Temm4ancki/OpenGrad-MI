AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')
ENT.SWEP = "weapon_trap"

function ENT:Initialize()
	self:SetUseType(SIMPLE_USE)
	self:SetModel("models/weapons/t_trap/trap.mdl")
	self:SetColor(Color(155, 155, 155, 255))
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:GetPhysicsObject():Wake()
	self:DrawShadow(true)

	--[[timer.Simple(5, function
		self:SetMoveType(MOVETYPE_NONE) 
	end)]]
end

function ENT:Use(ply)
	if self:GetCollisionGroup() == COLLISION_GROUP_DEBRIS then
		self:SetModel("models/weapons/t_trap/trap.mdl")
		self:SetCollisionGroup(COLLISION_GROUP_NONE)

		if IsValid(self.Traped) and self.Traped.IsWeld >= 1 then
			self.Traped.IsWeld = math.max(self.Traped.IsWeld - 1, 0)
			print(self.Traped.IsWeld)
		end

		if IsValid(self.Traped) then
			for weldEntity, self in pairs(self.Traped.weld) do
				self.Traped.weld[weldEntity] = nil
				weldEntity:Remove()
			end
		end
	else
		local Alt = false
		if JMod and JMod.IsAltUsing then
			Alt = JMod.IsAltUsing(ply)
		else
			Alt = ply:KeyDown(IN_WALK)
		end

		if Alt then
			self.Owner = ply
			if util.NetworkStringToID("JMod_ColorAndArm") ~= 0 then
				net.Start("JMod_ColorAndArm")
				net.WriteEntity(self)
				net.Send(ply)
			else
				ply:ChatPrint("Система окрашивания недоступна")
			end
		else
			self:PickUp(ply)
		end
	end
end

function ENT:PickUp(ply)
	local wep = self.SWEP

	if ply.roleT and not ply:HasWeapon(wep) then
		ply:Give(wep)
		ply:SelectWeapon(wep)
		self:Remove()
	end
end

-- Функция для автоматического взведения (аналогично мине)
function ENT:Arm(armer, autoColor)
	if autoColor then
		local Tr = util.QuickTrace(self:GetPos() + Vector(0, 0, 10), Vector(0, 0, -50), self)

		if Tr.Hit and JMod and JMod.HitMatColors then
			local Info = JMod.HitMatColors[Tr.MatType]

			if Info then
				self:SetColor(Info[1])

				if Info[2] then
					self:SetMaterial(Info[2])
				end
			end
		end
	end
	
	-- Капкан уже взведен при создании, поэтому просто подтверждаем владельца
	self.Owner = armer
end

function ENT:Touch(entity)
	if entity:IsPlayer() and IsValid(entity) then

		if self:GetCollisionGroup() == COLLISION_GROUP_DEBRIS then return false end

		local ply = entity
		Faking(ply)

		self:SetModel("models/weapons/t_trap/trap_close.mdl")
		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		ply:EmitSound("weapons/trap/trap.ogg")

		--[[local dmg = DamageInfo()
		dmg:SetDamage(math.random(15,20))
		dmg:SetDamageType(DMG_SLASH)
		dmg:SetDamagePosition(self:GetPos())
		ply:TakeDamageInfo(dmg)]]

		ply.Bloodlosing = ply.Bloodlosing + 10

		local rag = ply:GetNWEntity("Ragdoll")
		local legbone = {
			"ValveBiped.Bip01_L_Foot",
			"ValveBiped.Bip01_R_Foot",
		}

		rag.IsWeld = (rag.IsWeld or 0) + 1

		local bonerand = table.Random(legbone)

		if bonerand == "ValveBiped.Bip01_L_Foot" then
			entity.LeftLeg = 0.6
			if entity.msgLeftLeg < CurTime() then
				entity.msgLeftLeg = CurTime() + 1
				entity:ChatPrint("Левая нога повреждена.")
				rag:EmitSound("NPC_Barnacle.BreakNeck", 70, 65, 0.4, CHAN_ITEM)
			end
		else
			entity.RightLeg = 0.6
			if entity.msgRightLeg < CurTime() then
				ply.msgRightLeg = CurTime() + 1
				ply:ChatPrint("Правая нога повреждена.")
				rag:EmitSound("NPC_Barnacle.BreakNeck", 70, 65, 0.4, CHAN_ITEM)
			end
		end

		local bone = rag:LookupBone(bonerand)
		local BoneObj = rag:GetPhysicsObjectNum(rag:TranslateBoneToPhysBone(bone))
		BoneObj:SetPos(self:GetPos())

		local PhysBone = rag:TranslateBoneToPhysBone(bone)

		local weldEntity = constraint.Weld(rag, self, PhysBone or 0, 0, 120000, 0, false, false)
		rag.weld = rag.weld or {}
		rag.weld[weldEntity] = self

		self.Traped = rag
	end
end

function ENT:OnTakeDamage(dmg)
	self:SetModel("models/weapons/t_trap/trap_close.mdl")
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self:EmitSound("weapons/trap/trap.ogg")
end

function ENT:OnRemove()
	if IsValid(self.Traped) then
		for weldEntity, self in pairs(self.Traped.weld) do
			self.Traped.weld[weldEntity] = nil

			weldEntity:Remove()
		end

		self.Traped.IsWeld = self.Traped.IsWeld - 1
	end
end

if CLIENT then end