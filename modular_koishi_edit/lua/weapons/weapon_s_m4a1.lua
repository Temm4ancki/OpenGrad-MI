<<<<<<< HEAD:OpenGrad/lua/weapons/weapon_m4a1.lua
SWEP.Base = "salat_base" -- base

SWEP.PrintName 				= "M4A1"
SWEP.Author 				= "Homigrad"
SWEP.Purpose			= "Автоматическая винтовка под калибр 5,56х45"
SWEP.Category 				= "Оружие"
SWEP.WepSelectIcon = "vgui/select/w/m4a1"
SWEP.IconOverride = "vgui/icon/w/m4a1.png"
=======
SWEP.Base = 'koishi_sweps' -- base

SWEP.PrintName 				= "M4A1"
SWEP.Author 				= "Homigrad"
SWEP.Instructions			= "Автоматическая винтовка под калибр 5,56х45"
SWEP.Category 				= "md3"

>>>>>>> modular3:modular_koishi_edit/lua/weapons/weapon_s_m4a1.lua

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 30
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "5.56x45 mm"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 40
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "weapons/salat/w_m4a1/m4a1_fp.ogg"
SWEP.Primary.SoundFar = "weapons/salat/w_m4a1/m4a1_dist.ogg"
SWEP.Primary.Force = 160 / 3
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.07
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

SWEP.ViewModel				= "models/weapons/salat/w_m4a1/w_m4a1.mdl"
SWEP.WorldModel				= "models/weapons/salat/w_m4a1/w_m4a1.mdl"

SWEP.OffsetVec = Vector(10,-2.6,2)