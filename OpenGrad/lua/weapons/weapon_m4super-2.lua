<<<<<<<< HEAD:OpenGrad/lua/weapons/weapon_m4super-2.lua
SWEP.Base = "salat_base" -- base
========
SWEP.Base = "koishi_sweps" -- base
/weapon_s_m4super.lua

SWEP.PrintName 				= "M4 Super 90"
SWEP.Author 				= "Homigrad"
SWEP.Purpose			= "Дробовик под калибр 12/70"
<<<<<<<< HEAD:OpenGrad/lua/weapons/weapon_m4super-2.lua
SWEP.Category 				= "Оружие"
========
SWEP.Category 				= "md3"
/weapon_s_m4super.lua
SWEP.WepSelectIcon = "vgui/select/w/m4super90"
SWEP.IconOverride = "vgui/icon/w/m4super90.png"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 8
SWEP.Primary.DefaultClip	= 8
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "12/70 gauge"
SWEP.Primary.Cone = 0.02
SWEP.Primary.Damage = 35
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "weapons/salat/w_m4super90/win1892_fire_01.ogg"
SWEP.Primary.SoundFar = "weapons/salat/w_m4super90/toz_dist.ogg"
SWEP.Primary.Force = 35
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.4
SWEP.NumBullet = 8
SWEP.Sight = true
SWEP.TwoHands = true
SWEP.shotgun = true

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

SWEP.ViewModel				= "models/weapons/salat/w_m4super90/w_m4super90.mdl"
SWEP.WorldModel				= "models/weapons/salat/w_m4super90/w_m4super90.mdl"

function SWEP:ApplyEyeSpray()
    self.eyeSpray = self.eyeSpray - Angle(5,math.Rand(-2,2),0)
end

SWEP.RightMod = -.65
SWEP.ForwardMod = 5
SWEP.UpMod = 4.8
SWEP.AngleMod = Angle(-5,5,0)