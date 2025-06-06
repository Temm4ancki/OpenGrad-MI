<<<<<<<< HEAD:OpenGrad/lua/weapons/weapon_cz75.lua
SWEP.Base = "salat_base" -- base
========
SWEP.Base = "koishi_sweps" -- base
/weapon_s_cz75.lua

SWEP.PrintName 				= "CZ75"
SWEP.Author 				= "Homigrad"
SWEP.Purpose			= "Пистолет под калибр 9х19"
<<<<<<<< HEAD:OpenGrad/lua/weapons/weapon_cz75.lua
SWEP.Category 				= "Оружие"
========
SWEP.Category 				= "md3"
/weapon_s_cz75.lua
SWEP.WepSelectIcon = "vgui/select/w/cz75"
SWEP.IconOverride = "vgui/icon/w/cz75.png"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 17
SWEP.Primary.DefaultClip	= 17
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "9х19 mm Parabellum"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 25
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "weapons/salat/w_cz75/m9_fp.ogg"
SWEP.Primary.SoundFar = "weapons/salat/w_cz75/m9_dist.ogg"
SWEP.Primary.Force = 90 / 3
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.08

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

SWEP.ViewModel				= "models/weapons/salat/w_cz75/w_cz75.mdl"
SWEP.WorldModel				= "models/weapons/salat/w_cz75/w_cz75.mdl"

SWEP.vbwPos = Vector(8.5,-10,-8)

SWEP.RightMod = -.35
SWEP.ForwardMod = 12
SWEP.UpMod = 4.5
SWEP.AngleMod = Angle(-10,5,0)