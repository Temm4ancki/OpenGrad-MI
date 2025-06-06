SWEP.Base = "koishi_sweps" -- base

SWEP.PrintName 				= "Winchester"
SWEP.Author 				= "Homigrad"
SWEP.Purpose			= "kowboy pushka"
SWEP.Category 				= "md3"
SWEP.WepSelectIcon = "vgui/select/w/winchester"
SWEP.IconOverride = "vgui/icon/w/winchester.png"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 6
SWEP.Primary.DefaultClip	= 30
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "5.56x45 mm"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 40
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "weapons/salat/w_winchester/m4a1_fp.ogg"
SWEP.Primary.SoundFar = "weapons/salat/w_winchester/m4a1_dist.ogg"
SWEP.Primary.Force = 160 / 3
SWEP.ReloadTime = 2
SWEP.ShootWait = .9
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

SWEP.ViewModel				= "models/weapons/salat/w_winchester/w_jmod_levergun.mdl"
SWEP.WorldModel				= "models/weapons/salat/w_winchester/w_jmod_levergun.mdl"

SWEP.RightMod = -.9
SWEP.ForwardMod = 6
SWEP.UpMod = 5.2
SWEP.AngleMod = Angle(0,0,0)