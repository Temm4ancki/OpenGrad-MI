SWEP.Base = "salat_base" -- base

SWEP.PrintName 				= "Ruger MarkII - SIB"
SWEP.Author 				= "Ruger"
SWEP.Instructions			= "Хороший пистолет, но не лучший"
SWEP.Category 				= "Оружие"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 10
SWEP.Primary.DefaultClip	= 10
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "Pistol"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 15
SWEP.Primary.Spread = 1
SWEP.Primary.Sound = "weapons/hndg_mkiii/mkiii_fire_01.wav"
SWEP.Primary.FarSound = "snd_jack_hmcd_smp_far.wav"
SWEP.Primary.Force = 15
SWEP.ReloadTime = 1.3
SWEP.ShootWait = 0.16
SWEP.ReloadSounds = {
    [0.1] = {"weapons/hndg_glock17/clipout.wav"},
    [0.8] = {"weapons/hndg_glock17/clipin.wav"},
    [1.2] = {"weapons/hndg_glock17/glock17_sliderelease.wav"},
    [1.4] = {"weapons/hndg_glock17/glock17_slidepull.wav"},
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

SWEP.ViewModel				= "models/homicbox_weapons/w_pist_mkiii.mdl"
SWEP.WorldModel				= "models/homicbox_weapons/w_pist_mkiii.mdl"

SWEP.addAng = Angle(0,0,10) -- Barrel ang adjust
SWEP.addPos = Vector(0,-2,0) -- Barrel pos adjust
SWEP.SightPos = Vector(-10,0.5,2.2) -- Sight pos
SWEP.SightAng = Angle(-5,5,-5.5) -- Sight ang