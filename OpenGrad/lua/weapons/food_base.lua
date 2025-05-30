-- Лан вот зделал
AddCSLuaFile()

SWEP.PrintName = "Eda base"
SWEP.Author = "OpenGrad"
SWEP.Purpose = "Kysat gavno"
SWEP.Category = "Вкусности"

SWEP.Slot = 3
SWEP.SlotPos = 3
SWEP.Spawnable = false
SWEP.WorldModel = "models/other/food/sodacanc01.mdl"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.DrawCrosshair = false

function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
	if !IsValid(DrawModel) then
		DrawModel = ClientsideModel( self.WorldModel, RENDER_GROUP_OPAQUE_ENTITY );
		DrawModel:SetNoDraw( true );
	else
		DrawModel:SetModel( self.WorldModel )

		local vec = Vector(55,55,55)
		local ang = Vector(-48,-48,-48):Angle()

		cam.Start3D( vec, ang, 20, x, y+35, wide, tall, 5, 4096 )
			cam.IgnoreZ( true )
			render.SuppressEngineLighting( true )

			render.SetLightingOrigin( self:GetPos() )
			render.ResetModelLighting( 50/255, 50/255, 50/255 )
			render.SetColorModulation( 1, 1, 1 )
			render.SetBlend( 255 )

			render.SetModelLighting( 4, 1, 1, 1 )

			DrawModel:SetRenderAngles( Angle( 0, RealTime() * 30 % 360, 0 ) )
			DrawModel:DrawModel()
			DrawModel:SetRenderAngles()

			render.SetColorModulation( 1, 1, 1 )
			render.SetBlend( 1 )
			render.SuppressEngineLighting( false )
			cam.IgnoreZ( false )
		cam.End3D()
	end

	self:PrintWeaponInfo( x + wide + 20, y + tall * 0.95, alpha )

end

function SWEP:Initialize()
	self:SetHoldType( "slam" )
end

SWEP.WorldPos = Vector(4,-2.7,0)
SWEP.WorldAng = Angle(180, -45, 0)
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

SWEP.AdrenalineAmt = 0
SWEP.StaminaAmt = 10
SWEP.Drink = false
function SWEP:PrimaryAttack()
	local owner = self:GetOwner()
	if not IsValid(owner) then return end
	owner:SetAnimation(PLAYER_ATTACK1)

	if(SERVER)then
		owner.adrenaline = owner.adrenaline + self.AdrenalineAmt or 0
		owner.stamina = owner.stamina + self.StaminaAmt or 10
		owner.pain = math.max(owner.pain - ((self.StaminaAmt or 10) / 10),0)
		local healsound = self.Drink and ("other/food/snd_jack_hmcd_drink" .. math.random(1,3) .. ".ogg") or ("other/food/snd_jack_hmcd_eat" .. math.random(1,4) .. ".ogg")
		--sound.Play(healsound, self:GetPos(),75,100,0.5)
		owner:EmitSound(healsound)
		owner:SelectWeapon("weapon_hands")
		self:CustomEat()
		self:Remove()
	end
end

function SWEP:CustomEat()
	-- kodite
end

function SWEP:SecondaryAttack()
	-- чет нехочу
end