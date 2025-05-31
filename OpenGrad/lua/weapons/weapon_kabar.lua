

SWEP.PrintName = "SOG M37 Seal pup"
SWEP.Instructions = "Тот самый нож трейтора"
SWEP.Category = "Ближний Бой"
SWEP.WepSelectIcon = "vgui/select/w/kabar"
SWEP.IconOverride = "vgui/icon/w/kabar.png"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 60
SWEP.ViewModel = "models/weapons/salat/w_kabar/w_sog_knife.mdl"
SWEP.WorldModel = "models/weapons/salat/w_kabar/w_sog_knife.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 1
SWEP.SlotPos = 2

SWEP.UseHands = true

SWEP.HoldType = "knife"

SWEP.FiresUnderwater = false

SWEP.DrawCrosshair = false

SWEP.DrawAmmo = true

SWEP.Base = "weapon_base"

SWEP.Primary.Sound = Sound( "Weapon_Crowbar.Single" )
SWEP.Primary.Damage = 25
SWEP.Primary.Ammo = "none"
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = true
SWEP.Primary.Recoil = 0.5
SWEP.Primary.Delay = 0.65
SWEP.Primary.Force = 240

SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

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

function Circle( x, y, radius, seg )
    local cir = {}

    table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
    for i = 0, seg do
        local a = math.rad( ( i / seg ) * -360 )
        table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
    end

    local a = math.rad( 0 ) -- This is needed for non absolute segment counts
    table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

    surface.DrawPoly( cir )
end

local tr = {}
function EyeTrace(ply)
	tr.start = ply:GetAttachment(ply:LookupAttachment("eyes")).Pos
	tr.endpos = tr.start + ply:GetAngles():Forward() * 80
	tr.filter = ply
	return util.TraceLine(tr)
end

function SWEP:DrawHUD()
		if not (GetViewEntity() == LocalPlayer()) then return end
		if LocalPlayer():InVehicle() then return end
			local ply = self:GetOwner()
			local t = {}
			t.start = ply:GetAttachment(ply:LookupAttachment("eyes")).Pos
			t.endpos = t.start + ply:GetAngles():Forward() * 80
			t.filter = self:GetOwner()
			local Tr = util.TraceLine(t)
			local hitPos = Tr.HitPos
			if Tr.Hit then

		local Size = math.Clamp(1 - ((hitPos - self:GetOwner():GetShootPos()):Length() / 80) ^ 2, .1, .3)
		surface.SetDrawColor(Color(200, 200, 200, 200))
		draw.NoTexture()
		Circle(hitPos:ToScreen().x, hitPos:ToScreen().y, 55 * Size, 32)

		surface.SetDrawColor(Color(255, 255, 255, 200))
		draw.NoTexture()
		Circle(hitPos:ToScreen().x, hitPos:ToScreen().y, 40 * Size, 32)
	end
end


function SWEP:Initialize()
	self:SetHoldType("knife")
	self.lerpClose = 0
end


function SWEP:Deploy()
	self:SetNextPrimaryFire(CurTime())
	self:SetHoldType("knife")
	if SERVER then
		self:GetOwner():EmitSound("weapons/salat/w_hg_kitknife/snd_jack_hmcd_knifedraw.ogg",60)
	end
	local ply = self:GetOwner()
	if not IsValid(ply) then return end
	if ply:GetNWBool("Suiciding") then ply:SetNWBool("Suiciding",false) end
end

function SWEP:Holster()
	return true
end

function SWEP:PrimaryAttack()
	self:GetOwner():SetAnimation( PLAYER_ATTACK1 )
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay/((self:GetOwner().stamina or 100)/100)-(self:GetOwner():GetNWInt("Adrenaline")/5) )

	if SERVER then
		self:GetOwner():EmitSound("weapons/slam/throw.wav", 60)
		self:GetOwner().stamina = math.max(self:GetOwner().stamina - 0.5,0)
	end

	local ply = self:GetOwner()
	if ply:GetNWBool("Suiciding") then
		if SERVER then
			ply.KillReason = "killyourself"

			local dmgInfo = DamageInfo()
			dmgInfo:SetAttacker(ply)
			dmgInfo:SetInflictor(self)
			dmgInfo:SetDamage(self.Primary.Damage * 3)
			dmgInfo:SetDamageType(DMG_SLASH)
			dmgInfo:SetDamageForce(self:GetOwner():GetForward() * self.Primary.Force)
			--dmgInfo:SetDamagePosition(ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_Head1")))
			ply:TakeDamageInfo(dmgInfo)

			ply.LastDMGInfo = dmgInfo
			ply.LastHitBoneName = "ValveBiped.Bip01_Head1"
			ply.Organs["artery"] = math.Clamp(ply.Organs["artery1"] - (self.Primary.Damage * 3), 0, 1)
			self:GetOwner():EmitSound("weapons/salat/w_kabar/snd_jack_hmcd_slash.wav", 50)
		end
		return
	end
	self:GetOwner():LagCompensation( true )

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
		t.mins = -Vector(6,6,6)
		t.maxs = Vector(6,6,6)
		tr = util.TraceHull(t)
	else
		tr = util.TraceLine(tra)
	end

	pos1 = tr.HitPos + tr.HitNormal
	pos2 = tr.HitPos - tr.HitNormal
	if true then
		if SERVER and tr.HitWorld then
			self:GetOwner():EmitSound("weapons/salat/w_kabar/snd_jack_hmcd_knifehit.ogg", 60)
		end

		if IsValid( tr.Entity ) and SERVER then
			local dmginfo = DamageInfo()
			dmginfo:SetDamageType( DMG_SLASH )
			dmginfo:SetAttacker( self:GetOwner() )
			dmginfo:SetInflictor( self )
			dmginfo:SetDamagePosition( tr.HitPos )
			dmginfo:SetDamageForce( self:GetOwner():GetForward() * self.Primary.Force )
			local angle = self:GetOwner():GetAngles().y - tr.Entity:GetAngles().y
			if angle < -180 then angle = 360 + angle end

			if angle <= 90 and angle >= -90 then
				dmginfo:SetDamage( self.Primary.Damage * 1.5 )
			else
				dmginfo:SetDamage( self.Primary.Damage / 1.5 )
			end

			if tr.Entity:IsNPC() or tr.Entity:IsPlayer() then
				self:GetOwner():EmitSound( "weapons/salat/w_kabar/snd_jack_hmcd_knifestab.ogg",60 )
			else
				if tr.Entity:GetClass() == "prop_ragdoll" then
					self:GetOwner():EmitSound(  "weapons/salat/w_kabar/snd_jack_hmcd_knifestab.ogg",60  )
				else
					self:GetOwner():EmitSound(  "weapons/salat/w_kabar/snd_jack_hmcd_knifehit.ogg",60  )
				end
			end
			tr.Entity:TakeDamageInfo( dmginfo )
		end
		-- self:GetOwner():EmitSound(Sound("Weapon_Knife.Single"), 60) -- CSoundEmitterSystemBase::GetParametersForSound:  No such sound Weapon_Crowbar.Single
	end

	if SERVER and Tr.Hit then
		if IsValid(Tr.Entity) and Tr.Entity:GetClass()=="prop_ragdoll" then
			util.Decal("Impact.Flesh",pos1,pos2)
		else
			util.Decal("ManhackCut",pos1,pos2)
		end
	end

	self:GetOwner():LagCompensation( false )
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
end

local closeAng = Angle(0,0,0)
local angZero = Angle(0,0,0)
local angSuicide = Angle(160,30,90)
local angSuicide2 = Angle(160,30,90)
local angSuicide3 = Angle(60,-30,90)
local forearm,clavicle,hand = Angle(0,0,0),Angle(0,0,0),Angle(0,0,0)
function SWEP:Think()
	local ply = self:GetOwner()
	if not IsValid(ply) or not ply:Alive() then return end
	hand:Set(angZero)
	if not self.isClose and not self:GetOwner():IsSprinting() then
		if not ply:GetNWBool("Suiciding") then
			self:SetWeaponHoldType(self.HoldType)
			hand:Set(angZero)
			forearm:Set(angZero)
		elseif not self.TwoHands and ply:GetNWBool("Suiciding") then
			self:SetWeaponHoldType("normal")
			forearm:Set(angSuicide2)
			hand:Set(angSuicide3)
		elseif ply:GetNWBool("Suiciding") then
			self:SetWeaponHoldType("normal")
			hand:Set(angSuicide)
		end
	end

	local eyeangles = (-ply:GetEyeTrace().HitPos + ply:EyePos()):Angle()
	eyeangles:RotateAroundAxis(eyeangles:Up(),180)
	
	if ((CLIENT and isLocal) or SERVER) then
		if not ply:GetNWBool("Suiciding") and not self:GetOwner():IsSprinting() then
			local numbr = self.TwoHands and 50 or 80
			if eyeangles[1] > numbr then
				hand[1] = hand[1] - (eyeangles[1] - numbr)
			end

			if eyeangles[1] < -numbr then
				hand[1] = hand[1] - (eyeangles[1] + numbr)
			end
		end
	end

	clavicle:Set(angZero)
	closeAng[3] = -40 * self.lerpClose
	clavicle:Add(closeAng)

	if not ply:LookupBone("ValveBiped.Bip01_R_Forearm") then return end--;c

	ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Forearm"),forearm,false)
	ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Clavicle"),clavicle,false)
	ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Hand"),hand,false)
end

SWEP.dwmForward = 3.5
SWEP.dwmRight = 1.5
SWEP.dwmUp = -2

SWEP.dwmAUp = -90
SWEP.dwmARight = 10
SWEP.dwmAForward = 180

function SWEP:DrawWorldModel()
	local model = GDrawWorldModel or ClientsideModel(SWEP.WorldModel,RENDER_GROUP_OPAQUE_ENTITY)
	GDrawWorldModel = model
	model:SetNoDraw(true)

	local owner = self:GetOwner()
	if not IsValid(owner) then
		self:DrawModel()
		return
	end

	local Pos,Ang = owner:GetBonePosition(owner:LookupBone("ValveBiped.Bip01_R_Hand"))
	if not Pos then return end

	model:SetModel(self.WorldModel)

	Pos:Add(Ang:Forward() * self.dwmForward)
	Pos:Add(Ang:Right() * self.dwmRight)
	Pos:Add(Ang:Up() * self.dwmUp)

	model:SetPos(Pos)

	Ang:RotateAroundAxis(Ang:Up(),self.dwmAUp)
	Ang:RotateAroundAxis(Ang:Right(),self.dwmARight)
	Ang:RotateAroundAxis(Ang:Forward(),self.dwmAForward)
	model:SetAngles(Ang)

	model:SetModelScale(1.2)

	model:DrawModel()
end