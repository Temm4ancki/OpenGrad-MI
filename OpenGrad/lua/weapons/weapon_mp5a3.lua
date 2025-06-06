<<<<<<<< HEAD:OpenGrad/lua/weapons/weapon_mp5a3.lua
SWEP.Base = "salat_base" -- base 
========
SWEP.Base = "koishi_sweps" -- base 
/weapon_s_mp5a3.lua

SWEP.PrintName 				= "HK MP5a3"
SWEP.Author 				= "Homigrad"
SWEP.Purpose			= "Пистолет-пулемёт под калибр 9х19"
<<<<<<<< HEAD:OpenGrad/lua/weapons/weapon_mp5a3.lua
SWEP.Category 				= "Оружие"
========
SWEP.Category 				= "md3"
/weapon_s_mp5a3.lua
SWEP.WepSelectIcon = "vgui/select/w/mp5a3"
SWEP.IconOverride = "vgui/icon/w/mp5a3.png"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 30
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "9х19 mm Parabellum"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 25
SWEP.Primary.Spread = 5
SWEP.Primary.Sound = "weapons/salat/w_mp5a3/mp5k_fp.ogg"
SWEP.Primary.SoundFar = "weapons/salat/w_mp5a3/mp5k_dist.ogg"
SWEP.Primary.Force = 85 / 3
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.06
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

SWEP.ViewModel				= "models/weapons/salat/w_mp5a3/w_mp5a3.mdl"
SWEP.WorldModel				= "models/weapons/salat/w_mp5a3/w_mp5a3.mdl"

SWEP.dwsPos = Vector(20,20,5)
SWEP.dwsItemPos = Vector(-7,0,1.5)

SWEP.addAng = Angle(0,0,0)

SWEP.RightMod = -.75
SWEP.ForwardMod = 7
SWEP.UpMod = 5
SWEP.AngleMod = Angle(-10,5,0)