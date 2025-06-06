SWEP.Base = "koishi_sweps" -- base

SWEP.PrintName 				= "Glock 17"
SWEP.Author 				= "Homigrad"
SWEP.Purpose			= "Пистолет под калибр 9х19"
SWEP.Category 				= "md3"
SWEP.WepSelectIcon = "vgui/select/w/glock17"
SWEP.IconOverride = "vgui/icon/w/glock17.png"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 17
SWEP.Primary.DefaultClip	= 17
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "9х19 mm Parabellum"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 25
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "weapons/salat/w_glock17/glock_fire_01.ogg"
SWEP.Primary.SoundFar = "weapons/salat/w_glock17/snd_jack_hmcd_smp_far.ogg"
SWEP.Primary.Force = 90 / 3
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

SWEP.ViewModel				= "models/weapons/salat/w_glock17/w_glock17.mdl"
SWEP.WorldModel				= "models/weapons/salat/w_glock17/w_glock17.mdl"

SWEP.dwsPos = Vector(13,13,5)
SWEP.dwsItemPos = Vector(10,-1,-2)

SWEP.addAng = Angle(0.4,0,0)
SWEP.addPos = Vector(0,0,-1)
--SWEP.vbwPos = Vector(7,-10,-6)

SWEP.RightMod = -.1
SWEP.ForwardMod = 15
SWEP.UpMod = 4.4
SWEP.AngleMod = Angle(-10,5,0)