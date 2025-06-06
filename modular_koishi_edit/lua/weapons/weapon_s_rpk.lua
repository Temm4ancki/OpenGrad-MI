SWEP.Base = "koishi_sweps" -- base 

SWEP.PrintName 				= "РПК"
SWEP.Purpose			= "Пулемёт под калибр 7,62х39"
SWEP.Category 				= "md3"
SWEP.WepSelectIcon = "vgui/select/w/rpk"
SWEP.IconOverride = "vgui/icon/w/rpk.png"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 45
SWEP.Primary.DefaultClip	= 45
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "7.62x39 mm"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 45
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "weapons/salat/w_rpk/rpk_fp.ogg"
SWEP.Primary.SoundFar = "weapons/salat/w_rpk/rpk_dist.ogg"
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

SWEP.HoldType = "smg"

------------------------------------------

SWEP.Slot					= 2
SWEP.SlotPos				= 0
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/weapons/salat/w_rpk/w_rpk.mdl"
SWEP.WorldModel				= "models/weapons/salat/w_rpk/w_rpk.mdl"

SWEP.RightMod = -.8
SWEP.ForwardMod = 5
SWEP.UpMod = 5.6
SWEP.AngleMod = Angle(0,5,0)
