<<<<<<< HEAD:OpenGrad/lua/weapons/weapon_ar15.lua
SWEP.Base = "salat_base" -- base

SWEP.PrintName 				= "AR-15"
SWEP.Author 				= "Homigrad"
SWEP.Purpose			= "Полуавтоматическая винтовка под калибр 5,56х45"
SWEP.Category 				= "Оружие"
=======
SWEP.Base = 'koishi_sweps' -- base

SWEP.PrintName 				= "AR-15"
SWEP.Author 				= "Homigrad"
SWEP.Instructions			= "Полуавтоматическая винтовка под калибр 5,56х45"
SWEP.Category 				= "md3"
>>>>>>> modular3:modular_koishi_edit/lua/weapons/weapon_s_ar15.lua
SWEP.WepSelectIcon = "vgui/select/w/m4a1"
SWEP.IconOverride = "vgui/icon/w/m4a1.png"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 30
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "5.56x45 mm"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 40
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "weapons/salat/w_m4a1/m4a1_fp.ogg"
SWEP.Primary.SoundFar = "weapons/salat/w_m4a1/m4a1_dist.ogg"
<<<<<<< HEAD:OpenGrad/lua/weapons/weapon_ar15.lua
SWEP.Primary.Force = 160 / 3
=======
SWEP.Primary.Force = 160/3
>>>>>>> modular3:modular_koishi_edit/lua/weapons/weapon_s_ar15.lua
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.08
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
<<<<<<< HEAD:OpenGrad/lua/weapons/weapon_ar15.lua
=======


>>>>>>> modular3:modular_koishi_edit/lua/weapons/weapon_s_ar15.lua
