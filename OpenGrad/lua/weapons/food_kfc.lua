AddCSLuaFile()
SWEP.Base = "food_base"
SWEP.PrintName = "Ножка кфс"
SWEP.Purpose = "скинь ножки"
SWEP.Category = "Вкусности"
SWEP.Spawnable = true
SWEP.WorldModel = "models/foodnhouseholditems/mcdfriedchickenleg.mdl"
SWEP.WorldPos = Vector(3, -2.5, -4)
SWEP.WorldAng = Angle(-90, 180, 0)
SWEP.AdrenalineAmt = 0
SWEP.StaminaAmt = 12
SWEP.Drink = false

if (CLIENT) then
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