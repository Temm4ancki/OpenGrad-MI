<<<<<<<< HEAD:OpenGrad/lua/weapons/weapon_remington870police.lua
SWEP.Base = "salat_base" -- base
========
SWEP.Base = "koishi_sweps" -- base
>>>>>>>> modular3:modular_koishi_edit/lua/weapons/weapon_s_remington870police.lua

SWEP.PrintName 				= "Травматический дробовик"
SWEP.Author 				= "Homigrad"
SWEP.Purpose			= "Дробовик под калибр 12/70 beanbag (нелетальный)"
<<<<<<<< HEAD:OpenGrad/lua/weapons/weapon_remington870police.lua
SWEP.Category 				= "Оружие"
========
SWEP.Category 				= "md3"
>>>>>>>> modular3:modular_koishi_edit/lua/weapons/weapon_s_remington870police.lua
SWEP.WepSelectIcon = "vgui/select/w/remington870police"
SWEP.IconOverride = "vgui/icon/w/remington870police.png"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 8
SWEP.Primary.DefaultClip	= 8
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "12/70 beanbag"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 10
SWEP.RubberBullets = true
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "weapons/salat/w_remington870police/toz_fp.ogg"
SWEP.Primary.SoundFar = "weapons/salat/w_remington870police/toz_dist.ogg"
SWEP.Primary.Force = 0.5
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.7
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
SWEP.shotgun = true

------------------------------------------

SWEP.Slot					= 2
SWEP.SlotPos				= 0
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/weapons/salat/w_remington870police/w_remington870police.mdl"
SWEP.WorldModel				= "models/weapons/salat/w_remington870police/w_remington870police.mdl"

SWEP.vbwPos = Vector(-8,-6,-6)

SWEP.addAng = Angle(0.4,0,0)
SWEP.addPos = Vector(0,0,0)

SWEP.RightMod = -1.07
SWEP.ForwardMod = 5
SWEP.UpMod = 5.4
SWEP.AngleMod = Angle(-2,5,0)