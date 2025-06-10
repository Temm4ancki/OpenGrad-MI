
SWEP.Base = "koishi_sweps" -- base

SWEP.PrintName 				= "FAMAS-Civil"
SWEP.Author 				= "Homigrad"
SWEP.Purpose			= "Полуавтоматическа винтовка под калибр 5.56×45"
SWEP.Category 				= "md3 - Rifles"
SWEP.WepSelectIcon = "vgui/select/w/famasg2"
SWEP.IconOverride = "vgui/icon/w/famasg2.png"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 30
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "5.56x45 mm"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 30
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "weapons/salat/w_famasg2/m16a4_fp.ogg"
SWEP.Primary.SoundFar = "weapons/salat/w_famasg2/m16a4_dist.ogg"
SWEP.Primary.Force = 110 / 3
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.09
SWEP.ReloadSound = "weapons/ar2/ar2_reload.wav"
SWEP.TwoHands = true

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

------------------------------------------

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.HoldType = "ar2"

------------------------------------------

SWEP.Slot					= 2
SWEP.SlotPos				= 0
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/weapons/salat/w_famasg2/w_famasg2.mdl"
SWEP.WorldModel				= "models/weapons/salat/w_famasg2/w_famasg2.mdl"

SWEP.vbwPos = Vector(-6,-6,-4)

SWEP.RightMod = -.73
SWEP.ForwardMod = 7
SWEP.UpMod = 7
SWEP.AngleMod = Angle(0,5,0)

SWEP.addPos = Vector(0,0,0)
SWEP.addAng = Angle(0,0,0)