SWEP.Base = "koishi_sweps" -- base

SWEP.PrintName 				= "АКМ"
SWEP.Author 				= "Homigrad"
SWEP.Purpose			= "Автоматическая винтовка под калибр 7,62х39"
SWEP.Category 				= "md3 - Rifles"

SWEP.WepSelectIcon = "vgui/select/w/akm"
SWEP.IconOverride = "vgui/icon/w/akm.png"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 30
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "7.62x39 mm"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 45
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "weapons/salat/w_akm/ak74_fp.ogg"
SWEP.Primary.SoundFar = "weapons/salat/w_akm/ak74_dist.ogg"
SWEP.Primary.Force = 240 / 3
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.07
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

SWEP.ViewModel				= "models/weapons/salat/w_akm/w_akm.mdl"
SWEP.WorldModel				= "models/weapons/salat/w_akm/w_akm.mdl"

SWEP.RightMod = -.5
SWEP.ForwardMod = 6
SWEP.UpMod = 5.2
SWEP.AngleMod = Angle(-10,2,0)

SWEP.addPos = Vector(0,0,0)
SWEP.addAng = Angle(0,0,0)

