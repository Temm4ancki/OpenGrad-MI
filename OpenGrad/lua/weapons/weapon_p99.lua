SWEP.Base = "salat_base" -- base

SWEP.PrintName 				= "P99"
SWEP.Author 				= "Homigrad"
SWEP.Instructions			= "Пистолет под калибр 9х19"
SWEP.Category 				= "Оружие"
SWEP.WepSelectIcon = "vgui/select/w/p99"
SWEP.IconOverride = "vgui/icon/w/p99.png"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 15
SWEP.Primary.DefaultClip	= 15
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "9х19 mm Parabellum"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 30
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "weapons/salat/w_p99/colt_1911_fire1.ogg"
SWEP.Primary.SoundFar = "weapons/salat/w_p99/snd_jack_hmcd_smp_far.ogg"
SWEP.Primary.Force = 80 / 3
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.12

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

------------------------------------------

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.HoldType = "revolver"

------------------------------------------

SWEP.Slot					= 2
SWEP.SlotPos				= 1
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/weapons/salat/w_p99/w_p99.mdl"
SWEP.WorldModel				= "models/weapons/salat/w_p99/w_p99.mdl"

SWEP.dwsPos = Vector(15,15,5)
SWEP.dwsItemPos = Vector(10,-1,-3)

SWEP.vbwPos = Vector(8,-9,-8)

SWEP.addAng = Angle(0.4,-0.2,0)
SWEP.addPos = Vector(0.1,0,-0.9)