SWEP.Base = "koishi_sweps" -- base

SWEP.PrintName 				= "UMP"
SWEP.Purpose			= "Что может еще делать ПП? СТРЕЛЯТЬ В ЛИЦО!"
SWEP.Category 				= "md3"
SWEP.WepSelectIcon = "vgui/select/w/ump45"
SWEP.IconOverride = "vgui/icon/w/ump45.png"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 30
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "357"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 30
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "weapons/salat/w_ump/mp5k_fp.ogg"
SWEP.Primary.SoundFar = "weapons/salat/w_ump/mp5k_dist.ogg"
SWEP.Primary.Force = 85 / 3
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.09
SWEP.TwoHands = true

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

------------------------------------------

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.HoldType = "smg"

------------------------------------------

SWEP.Slot					= 2
SWEP.SlotPos				= 0
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/weapons/w_smg_ump45.mdl"
SWEP.WorldModel				= "models/weapons/w_smg_ump45.mdl"

SWEP.vbwPos = Vector(-2,-4,-4)
SWEP.vbwRifle = true

SWEP.RightMod = -.87
SWEP.ForwardMod = 9
SWEP.UpMod = 6.7
SWEP.AngleMod = Angle(0,5,0)

SWEP.addPos = Vector(0,0,0)
SWEP.addAng = Angle(0,0,0)