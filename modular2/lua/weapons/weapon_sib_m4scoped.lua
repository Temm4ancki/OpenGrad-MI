SWEP.Base = "salat_base" -- base

SWEP.PrintName 				= "M16A4-ACOG - SIB"
SWEP.Author 				= "ArmaLite"
SWEP.Instructions			= "Американская винтовка с оптикой ACOG"
SWEP.Category 				= "Оружие"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 30
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "AR2"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 50
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "weapons/mil_m16a4/m16_fire_01.wav"
SWEP.Primary.FarSound = "snd_jack_hmcd_smp_far.wav"
SWEP.Primary.Force = 30
SWEP.ReloadTime = 2.8
SWEP.ShootWait = 0.075
SWEP.ReloadSounds = {
    [0.1] = {"weapons/mil_m16a4/m16_clipout.wav"},
    [0.8] = {"weapons/mil_m16a4/m16_clipin.wav"},
    [1.2] = {"weapons/mil_m16a4/m16_slide.wav"},
    [1.4] = {"weapons/mil_m16a4/m16_sliderelease.wav"},
}
SWEP.TwoHands = true
SWEP.Shell = ""

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

SWEP.ViewModel				= "models/homicbox_weapons/w_rif_m16a4.mdl"
SWEP.WorldModel				= "models/homicbox_weapons/w_rif_m16a4.mdl"

SWEP.addAng = Angle(2,1,10) -- Barrel pos adjust
SWEP.addPos = Vector(0,0,0) -- Barrel ang adjust
SWEP.SightPos = Vector(-7,-1,6) -- Sight pos
SWEP.SightAng = Angle(-8,5,-2) -- Sight ang

SWEP.Mobility = 1.4


function SWEP:DrawWorldModel()
    self:DrawModel()
end