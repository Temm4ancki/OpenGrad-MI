SWEP.Base = "salat_base" -- base

SWEP.PrintName 				= "HK416"
SWEP.Instructions			= "Автоматическая винтовка под калибр 5,56х45"
SWEP.Category 				= "Оружие"
SWEP.WepSelectIcon = "vgui/select/w/hk416"
SWEP.IconOverride = "vgui/icon/w/hk416.png"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 30
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "5.56x45 mm"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 40
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "weapons/salat/w_hk416/m16a4_fp.ogg"
SWEP.Primary.SoundFar = "weapons/salat/w_hk416/m16a4_dist.ogg"
SWEP.Primary.Force = 160 / 3
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

SWEP.ViewModel				= "models/weapons/salat/w_hk416/w_hk416.mdl"
SWEP.WorldModel				= "models/weapons/salat/w_hk416/w_hk416.mdl"

SWEP.vbwPos = Vector(4,-6,-6)