SWEP.Base = "salat_base" -- base 

SWEP.PrintName 				= "MP7"
SWEP.Purpose			= "Пистолет-пулемёт под калибр 4,6×30"
SWEP.Category 				= "Оружие"
SWEP.WepSelectIcon = "vgui/select/w/mp7"
SWEP.IconOverride = "vgui/icon/w/mp7.png"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 40
SWEP.Primary.DefaultClip	= 40
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "4.6×30 mm"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 30
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "weapons/salat/w_mp7/mp5k_fp.ogg"
SWEP.Primary.SoundFar = "weapons/salat/w_mp7/mp5k_dist.ogg"
SWEP.Primary.Force = 120 / 3
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.06
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

SWEP.ViewModel				= "models/weapons/salat/w_mp7/w_mp7.mdl"
SWEP.WorldModel				= "models/weapons/salat/w_mp7/w_mp7.mdl"

SWEP.addPos = Vector(0,0,0)
SWEP.addAng = Angle(-0.5,0,0)