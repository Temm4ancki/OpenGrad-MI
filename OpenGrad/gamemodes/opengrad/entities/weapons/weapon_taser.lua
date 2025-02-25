SWEP.Base = "medkit"
SWEP.PrintName = "Электрошокер"
SWEP.Author = "Homigrad"
SWEP.Instructions = "Электрическое возбуждение передается нервным клеткам, вызывая в основном болевой шок, а также кратковременные судороги и состояние «ошарашенности», дезориентации."
SWEP.Slot = 2
SWEP.SlotPos = 4
SWEP.Spawnable = true
SWEP.Category = "Разное"

SWEP.ViewModel = "models/realistic_police/taser/w_taser.mdl"
SWEP.WorldModel = "models/realistic_police/taser/w_taser.mdl"
SWEP.AutoSwitchFrom = false
SWEP.AutoSwitchTo = false

SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "AR2AltFire"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.DrawWeaponSelection = DrawWeaponSelection
SWEP.OverridePaintIcon = OverridePaintIcon

SWEP.dwmUp = 0.5
SWEP.dwmRight = 0
SWEP.dwmForward = 0

SWEP.dwmARight = 180
SWEP.dwmAUp = 200
SWEP.dwmAForward = 0

function SWEP:DrawHUD()
	show = math.Clamp(self.AmmoChek or 0,0,1)
	self.AmmoChek = Lerp(2*FrameTime(),self.AmmoChek or 0,0)
	color_gray = Color(225,215,125,190*show)
	color_gray1 = Color(225,215,125,255*show)
	if show > 0 then
	local ply = LocalPlayer()
	local ammo,ammobag = self:GetMaxClip1(), self:Clip1()
	if ammobag > ammo - 1 then
		text = "Полон"
	elseif ammobag > ammo - ammo/3 then
		text = "~Почти полон"
	elseif ammobag > ammo/3 then
		text = "~Половина"
	elseif ammobag >= 1 then
		text = "~Почти пуст"
	elseif ammobag < 1 then
		text = "Пуст"
	end

	local ammomags = ply:GetAmmoCount( self:GetPrimaryAmmoType() )

	if oldclip ~= ammobag then
		randomx = math.random(0, 5)
		randomy = math.random(0, 5)
		timer.Simple(0.15, function()
			oldclip = ammobag
		end)
	else
		randomx = 0
		randomy = 0
	end

	if oldmag ~= ammomags then
		randomxmag = math.random(0, 5)
		randomymag = math.random(0, 5)
		timer.Simple(0.35, function()
			oldmag = ammomags
		end)
	else
		randomxmag = 0
		randomymag = 0
	end

	local hand = ply:GetAttachment(ply:LookupAttachment("anim_attachment_rh"))
	local textpos = (hand.Pos+hand.Ang:Forward()*7+hand.Ang:Up()*5+hand.Ang:Right()*-1):ToScreen()
	draw.DrawText( "Картридж | "..text, "HomigradFontBig", textpos.x+randomx, textpos.y+randomy, color_gray1, TEXT_ALIGN_RIGHT )
	draw.DrawText( "Картриджей | "..math.Round(ammomags/ammo), "HomigradFontBig", textpos.x+5+randomxmag, textpos.y+25+randomymag, color_gray, TEXT_ALIGN_RIGHT )
	end
end

function SWEP:Initialize()
	self:SetHoldType("revolver")
end

local hull = Vector(10,10,10)

function SWEP:PrimaryAttack()
	if CLIENT then return end

	if self:Clip1() <= 0 then return nil end
	self:TakePrimaryAmmo(1)

	local ply = self:GetOwner()
	local att = self:GetAttachment(1)
	
	ply:EmitSound("ambient/energy/zap3.wav")

	local dir = ply:EyeAngles():Forward()

	local tr = {
		start = att.Pos,
		endpos = att.Pos + dir * 250,
		filter = ply,
		mins = -hull,
		maxs = hull,
		mask = MASK_SHOT_HULL
	}

	local trResult = util.TraceHull(tr)

	local effectdata = EffectData()
	effectdata:SetOrigin(tr.start)
	effectdata:SetMagnitude(5)
	effectdata:SetNormal(dir * 50)
	util.Effect("Sparks",effectdata)

	local ent = trResult.Entity
	ent = (ent:IsPlayer() and ent) or RagdollOwner(ent)

	if ent and ent:Alive() then
		ent:EmitSound("hostage/hpain/hpain" .. math.random(1,6) .. ".wav")

		Stun(ent)
	end
	self:GetOwner():SetAnimation(PLAYER_ATTACK1)
	self.AmmoChek = 5
end

SWEP.ReloadSound = "weapons/arccw/ar2_reload.wav"
function SWEP:Reload()
	self.AmmoChek = 3
	if timer.Exists("reload"..self:EntIndex()) or self:Clip1()>=self:GetMaxClip1() or self:GetOwner():GetAmmoCount( self:GetPrimaryAmmoType() )<=0 then return nil end
	if self:GetOwner():IsSprinting() then return nil end
	self:GetOwner():SetAnimation(PLAYER_RELOAD)
	self:EmitSound(self.ReloadSound,60,100,0.8,CHAN_AUTO)
	timer.Create( "reload"..self:EntIndex(), 1.5, 1, function()
		if IsValid(self) and IsValid(self:GetOwner()) and self:GetOwner():GetActiveWeapon()==self then
			local oldclip = self:Clip1()
			self:SetClip1(math.Clamp(self:Clip1()+self:GetOwner():GetAmmoCount( self:GetPrimaryAmmoType() ),0,self:GetMaxClip1()))
			local needed = self:Clip1()-oldclip
			self:GetOwner():SetAmmo(self:GetOwner():GetAmmoCount( self:GetPrimaryAmmoType() )-needed, self:GetPrimaryAmmoType())
			self.AmmoChek = 5
		end
	end)
end

function SWEP:SecondaryAttack()
end