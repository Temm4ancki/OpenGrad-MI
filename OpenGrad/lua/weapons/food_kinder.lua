AddCSLuaFile()
SWEP.Base = "food_base"
SWEP.PrintName = "Киндер сюрприз"
SWEP.Purpose = "всегда дарит радость"
SWEP.Category = "Вкусности"
SWEP.Spawnable = true
SWEP.WorldModel = "models/foodnhouseholditems/kindersurprise.mdl"
SWEP.WorldPos = Vector(4,-2,-2)
SWEP.WorldAng = Angle(180, -150, 0)
SWEP.AdrenalineAmt = 0
SWEP.StaminaAmt = 10
SWEP.Drink = false

local blevotasfx = {
    "homigradsfx/blevota/blevotahmcd.mp3",
    "homigradsfx/blevota/blevotalarge.mp3",
    "homigradsfx/blevota/blevotamedium.mp3",
    "homigradsfx/blevota/blevotasmall.mp3"
}

function SWEP:CustomEat()
	local owner = self:GetOwner()
	if math.random(1, 2) == 2 then
		owner.Blood = owner.Blood - 25
		local snd = table.Random(blevotasfx)
		owner:EmitSound(snd)
		for i = 1, 10 do
			BloodParticle(owner:EyePos(),owner:EyeAngles():Forward()*150+Vector(math.random(-1,1),math.random(-1,1),math.random(-1,1))*30)
		end
		owner.pain = math.max(owner.pain + 100,0)
		owner:ChatPrint("В киндере попалась игла... Ауч.")
	else
		owner.Blood = owner.Blood + 25
		owner.pain = math.max(owner.pain - 100,0)
		owner:ChatPrint("В киндере ничего не было... Вкусненько :yum:")
	end
end

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