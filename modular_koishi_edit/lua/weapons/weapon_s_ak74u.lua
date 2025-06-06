<<<<<<<< HEAD:OpenGrad/lua/weapons/weapon_aks74u.lua
SWEP.Base = "salat_base" -- base
========
SWEP.Base = "koishi_sweps" -- base
>>>>>>>> modular3:modular_koishi_edit/lua/weapons/weapon_s_ak74u.lua

SWEP.PrintName 				= "АКС-74У"
SWEP.Author 				= "Homigrad"
SWEP.Purpose			= "Автоматическая винтовка под калибр 5,45х39"
<<<<<<<< HEAD:OpenGrad/lua/weapons/weapon_aks74u.lua
SWEP.Category 				= "Оружие"
========
SWEP.Category 				= "md3"
>>>>>>>> modular3:modular_koishi_edit/lua/weapons/weapon_s_ak74u.lua
SWEP.WepSelectIcon = "vgui/select/w/aks74u"
SWEP.IconOverride = "vgui/icon/w/aks74u.png"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 30
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "5.45x39 mm"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 40
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "weapons/salat/w_aks74u/ak74_fp.ogg"
SWEP.Primary.SoundFar = "weapons/salat/w_aks74u/ak74_dist.ogg"
SWEP.Primary.Force = 140 / 3
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.075
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

SWEP.ViewModel				= "models/weapons/salat/w_aks74u/w_aks74u.mdl"
SWEP.WorldModel				= "models/weapons/salat/w_aks74u/w_aks74u.mdl"

SWEP.vbwPos = Vector(5,-6,-6)

SWEP.RightMod = -.9
SWEP.ForwardMod = 5
SWEP.UpMod = 5.5
SWEP.AngleMod = Angle(-10,4,0)