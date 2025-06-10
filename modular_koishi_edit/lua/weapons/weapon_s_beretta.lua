SWEP.Base = "koishi_sweps" -- base

SWEP.PrintName 				= "M9 Beretta"
SWEP.Author 				= "Homigrad"
SWEP.Purpose			= "Пистолет под калибр 9х19"
SWEP.Category 				= "md3 - Pistols"
SWEP.WepSelectIcon = "vgui/select/w/m9"
SWEP.IconOverride = "vgui/icon/w/m9.png"


SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 15
SWEP.Primary.DefaultClip	= 15
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "9х19 mm Parabellum"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 25
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "weapons/salat/w_m9/m45_fp.ogg"
SWEP.Primary.SoundFar = "weapons/salat/w_m9/m45_dist.ogg"
SWEP.Primary.Force = 65 / 3
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

SWEP.ViewModel				= "models/weapons/salat/w_m9/w_m9.mdl"
SWEP.WorldModel				= "models/weapons/salat/w_m9/w_m9.mdl"

SWEP.vbwPos = Vector(8,-9,-8)

SWEP.addPos = Vector(0,0,-0.9)
SWEP.addAng = Angle(0.3,0,0)

SWEP.RightMod = -.17
SWEP.ForwardMod = 10
SWEP.UpMod = 4.5
SWEP.AngleMod = Angle(-10,5,0)

SWEP.addPos = Vector(0,0,0)
SWEP.addAng = Angle(0,0,0)