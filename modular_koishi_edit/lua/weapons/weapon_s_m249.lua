<<<<<<< HEAD:OpenGrad/lua/weapons/weapon_m249.lua
SWEP.Base = "salat_base" -- base 

SWEP.PrintName 				= "M249"
SWEP.Purpose			= "Пулемёт под калибр 5,56х45"
SWEP.Category 				= "Оружие"
=======
SWEP.Base = "koishi_sweps" -- base 

SWEP.PrintName 				= "M249"
SWEP.Purpose			= "Пулемёт под калибр 5,56х45"
SWEP.Category 				= "md3"
>>>>>>> modular3:modular_koishi_edit/lua/weapons/weapon_s_m249.lua
SWEP.WepSelectIcon = "vgui/select/w/m249"
SWEP.IconOverride = "vgui/icon/w/m249.png"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 100
SWEP.Primary.DefaultClip	= 100
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "5.56x45 mm"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 40
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "weapons/salat/w_m249/m249_fp.ogg"
SWEP.Primary.SoundFar = "weapons/salat/w_m249/m249_dist.ogg"
SWEP.Primary.Force = 160 / 3
SWEP.ReloadTime = 4
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

SWEP.ViewModel				= "models/weapons/salat/w_m249/w_m249.mdl"
SWEP.WorldModel				= "models/weapons/salat/w_m249/w_m249.mdl"

SWEP.addPos = Vector(0,0,0)
SWEP.addAng = Angle(0.25,0.025,0)

SWEP.RightMod = -.87
SWEP.ForwardMod = 10
SWEP.UpMod = 7.2
SWEP.AngleMod = Angle(0,5,0)