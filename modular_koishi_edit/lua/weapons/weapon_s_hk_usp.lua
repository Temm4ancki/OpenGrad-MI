SWEP.Base = "koishi_sweps" -- base

SWEP.PrintName 				= "HK USP"
SWEP.Author 				= "Homigrad"
SWEP.Purpose			= "Пистолет под калибр 9х19"
SWEP.Category 				= "md3 - Pistols"
SWEP.WepSelectIcon = "vgui/select/w/usp"
SWEP.IconOverride = "vgui/icon/w/usp.png"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 12
SWEP.Primary.DefaultClip	= 12
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "9х19 mm Parabellum"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 35
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "weapons/salat/w_hk_usp/beretta92_fire1.ogg"
SWEP.Primary.SoundFar = "weapons/salat/w_hk_usp/snd_jack_hmcd_smp_far.ogg"
SWEP.Primary.Force = 90 / 3
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.14

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

SWEP.ViewModel				= "models/weapons/salat/w_hk_usp/w_usptactical.mdl"
SWEP.WorldModel				= "models/weapons/salat/w_hk_usp/w_usptactical.mdl"

SWEP.vbwPos = Vector(6.5,3.4,-4)


SWEP.addPos = Vector(0,0,-0.9)
SWEP.addAng = Angle(-0.4,0.5,0)

SWEP.RightMod = -.4
SWEP.ForwardMod = 12
SWEP.UpMod = 4.5
SWEP.AngleMod = Angle(-10,10,0)