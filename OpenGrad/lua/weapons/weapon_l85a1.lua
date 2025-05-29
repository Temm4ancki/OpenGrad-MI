SWEP.Base = "salat_base" -- base

SWEP.PrintName 				= "L85A1"
SWEP.Author 				= "Homigrad"
SWEP.Instructions			= "Автоматическая винтовка под калибр 5,56х45"
SWEP.Category 				= "Оружие"
SWEP.WepSelectIcon = "vgui/select/w/l85a1"
SWEP.IconOverride = "vgui/icon/w/l85a1.png"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 30
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "ar2"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 35
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "weapons/salat/w_l85a1/shoot.ogg"
SWEP.Primary.Force = 240 / 3
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.1
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

SWEP.ViewModel				= "models/weapons/salat/w_l85a1/w_l85a1.mdl"
SWEP.WorldModel				= "models/weapons/salat/w_l85a1/w_l85a1.mdl"

SWEP.vbwPos = Vector(0,-4,-6)

SWEP.addPos = Vector(0,0,0)
SWEP.addAng = Angle(-0.4,0,0)