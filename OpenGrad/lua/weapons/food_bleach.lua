AddCSLuaFile()
SWEP.Base = "food_base"
SWEP.PrintName = "Отбеливатель"
SWEP.Purpose = "вкусняшка из ссср"
SWEP.Category = "Вкусности"
SWEP.Spawnable = true
SWEP.WorldModel = "models/other/food/clorox.mdl"
SWEP.WorldPos = Vector(6,-4, 10)
SWEP.WorldAng = Angle(-180, -50, 0)
SWEP.AdrenalineAmt = 0
SWEP.StaminaAmt = -20
SWEP.Drink = true

local blevotasfx = {
    "hg_homicide/sfx/blevota/blevotahmcd.ogg",
    "hg_homicide/sfx/blevota/blevotalarge.ogg",
    "hg_homicide/sfx/blevota/blevotamedium.ogg",
    "hg_homicide/sfx/blevota/blevotasmall.ogg"
}

function SWEP:CustomEat()
	local owner = self:GetOwner()

	owner.Blood = owner.Blood - 60
	local snd = table.Random(blevotasfx)
	owner:EmitSound(snd)
	for i = 1, 30 do
		BloodParticle(owner:EyePos(),owner:EyeAngles():Forward()*150+Vector(math.random(-1,1),math.random(-1,1),math.random(-1,1))*30)
		owner.pain = math.max(owner.pain + 9,0)
	end
end

if(CLIENT)then
	local WorldModel = ClientsideModel(SWEP.WorldModel)

	WorldModel:SetNoDraw(true)

	function SWEP:DrawWorldModel()
		local _Owner = self:GetOwner()

		if (IsValid(_Owner)) then
			-- Specify a good position
			local offsetVec = self.WorldPos
			local offsetAng = self.WorldAng
			
			local boneid = _Owner:LookupBone("ValveBiped.Bip01_R_Hand") -- Right Hand
			if !boneid then return end

			local matrix = _Owner:GetBoneMatrix(boneid)
			if !matrix then return end

			local newPos, newAng = LocalToWorld(offsetVec, offsetAng, matrix:GetTranslation(), matrix:GetAngles())

			WorldModel:SetPos(newPos)
			WorldModel:SetAngles(newAng)

			WorldModel:SetupBones()
		else
			WorldModel:SetPos(self:GetPos())
			WorldModel:SetAngles(self:GetAngles())
		end

		WorldModel:DrawModel()
	end
end