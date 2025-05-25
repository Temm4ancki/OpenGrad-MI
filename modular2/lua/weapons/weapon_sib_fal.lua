SWEP.Base = "salat_base" -- base

SWEP.PrintName 				= "FN FAL - SIB"
SWEP.Author 				= "FN"
SWEP.Instructions			= "Если я пират, то моё имя Серёга"
SWEP.Category 				= "Оружие"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 20
SWEP.Primary.DefaultClip	= 20
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "AR2"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 65
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "weapons/rifle_fnfal/fnfal_fire_01.wav"
SWEP.Primary.FarSound = "snd_jack_hmcd_smp_far.wav"
SWEP.Primary.Force = 30
SWEP.ReloadTime = 2.8
SWEP.ShootWait = 0.16
SWEP.ReloadSounds = {
    [0.1] = {"weapons/rifle_fnfal/fnfal_magout_01.wav"},
    [0.8] = {"weapons/rifle_fnfal/fnfal_magin_01.wav"},
    [1.2] = {"weapons/rifle_fnfal/fnfal_boltback_01.wav"},
    [1.4] = {"weapons/rifle_fnfal/fnfal_boltforward_01.wav"},
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

SWEP.ViewModel				= "models/homicbox_weapons/w_rif_fnfal.mdl"
SWEP.WorldModel				= "models/homicbox_weapons/w_rif_fnfal.mdl"

SWEP.addAng = Angle(0,0,10) -- Barrel pos adjust
SWEP.addPos = Vector(0,0,0) -- Barrel ang adjust
SWEP.SightPos = Vector(-6,1.02,5) -- Sight pos
SWEP.SightAng = Angle(-8,5,-2) -- Sight ang

SWEP.Mobility = 1.4


function SWEP:DrawWorldModel()
    self:DrawModel()
end