SWEP.Base = "salat_base" -- base

SWEP.PrintName 				= "M1911 - SIB"
SWEP.Author 				= "Browning"
SWEP.Instructions			= "Знаменитый пистолет, который использовался во время Второй Мировой Войны"
SWEP.Category 				= "Оружие"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 7
SWEP.Primary.DefaultClip	= 7
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "Pistol"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 33
SWEP.Primary.Spread = 1
SWEP.Primary.Sound = "weapons/hndg_colt1911/colt_1911_fire1.wav"
SWEP.Primary.FarSound = "snd_jack_hmcd_smp_far.wav"
SWEP.Primary.Force = 40
SWEP.ReloadTime = 1.3
SWEP.ShootWait = 0.1
SWEP.ReloadSounds = {
    [0.1] = {"weapons/hndg_colt1911/colt_1911_clipout.wav"},
    [0.8] = {"weapons/hndg_colt1911/colt_1911_clipin.wav"},
    [1.2] = {"weapons/hndg_colt1911/colt_1911_slideback1.wav"},
    [1.4] = {"weapons/hndg_colt1911/colt_1911_slideforward1.wav"},
}
------------------------------------------

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.HoldType = "revolver"

------------------------------------------

SWEP.Slot					= 1
SWEP.SlotPos				= 2
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/homicbox_weapons/w_pist_1911.mdl"
SWEP.WorldModel				= "models/homicbox_weapons/w_pist_1911.mdl"

SWEP.addAng = Angle(0,0,10) -- Barrel ang adjust
SWEP.addPos = Vector(0,-2,0) -- Barrel pos adjust
SWEP.SightPos = Vector(-10,0.5,2.2) -- Sight pos
SWEP.SightAng = Angle(-5,5,-5.5) -- Sight ang