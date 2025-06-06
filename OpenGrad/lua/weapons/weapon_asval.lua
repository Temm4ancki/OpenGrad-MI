<<<<<<<< HEAD:OpenGrad/lua/weapons/weapon_asval.lua
SWEP.Base = "salat_base" -- base
========
SWEP.Base = "koishi_sweps" -- base
/weapon_s_asval.lua

SWEP.PrintName 				= "АС «Вал»"
SWEP.Author 				= "Homigrad"
SWEP.Purpose			= "Автоматическая винтовка со встроенным глушителем под калибр 9х39"
<<<<<<<< HEAD:OpenGrad/lua/weapons/weapon_asval.lua
SWEP.Category 				= "Оружие"
========
SWEP.Category 				= "md3"
/weapon_s_asval.lua
SWEP.WepSelectIcon = "vgui/select/w/asval"
SWEP.IconOverride = "vgui/icon/w/asval.png"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 20
SWEP.Primary.DefaultClip	= 20
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "9x39 mm"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 45
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "weapons/salat/w_asval/mp5k_suppressed_fp.ogg"
SWEP.Primary.SoundFar = "weapons/salat/w_asval/mp5k_suppressed_tp.ogg"
SWEP.Primary.Force = 200 / 3
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.065
SWEP.ReloadSound = "weapons/salat/w_asval/reload.wav"
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

SWEP.ViewModel				= "models/weapons/salat/w_asval/w_asval.mdl"
SWEP.WorldModel				= "models/weapons/salat/w_asval/w_asval.mdl"

SWEP.addAng = Angle(0,0,0)
SWEP.addPos = Vector(0,0,0)

SWEP.Supressed = true

SWEP.RightMod = -.37
SWEP.ForwardMod = 5
SWEP.UpMod = 4.6
SWEP.AngleMod = Angle(-10,5,0)