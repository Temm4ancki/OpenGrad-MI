SWEP.Base = "salat_base" -- base

SWEP.PrintName              = "Ruger 10/22 Takedown - SIB2"
SWEP.Author                 = "Ruger"
SWEP.Instructions           = "funky1234516"
SWEP.Category               = "Оружие"

SWEP.Spawnable              = true
SWEP.AdminOnly              = false

------------------------------------------

SWEP.Primary.ClipSize       = 25
SWEP.Primary.DefaultClip    = 25
SWEP.Primary.Automatic      = false
SWEP.Primary.Ammo           = "Pistol"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 15
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "weapons/rifle_ruger1022/ruger_fire_01.wav"
SWEP.Primary.FarSound = "snd_jack_hmcd_smp_far.wav"
SWEP.Primary.Force = 20
SWEP.ReloadTime = 2.8
SWEP.ShootWait = 0.15
SWEP.ReloadSounds = {
    [0.1] = {"weapons/rifle_ruger1022/ruger_clipout.wav"},
    [0.8] = {"weapons/rifle_ruger1022/ruger_clipin.wav"},
    [1.2] = {"weapons/rifle_ruger1022/ruger_slide1.wav"},
    [1.4] = {"weapons/rifle_ruger1022/ruger_slidelock.wav"},
}
SWEP.TwoHands = true
SWEP.Shell = ""

SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = false
SWEP.Secondary.Ammo         = "none"

------------------------------------------

SWEP.Weight                 = 5
SWEP.AutoSwitchTo           = false
SWEP.AutoSwitchFrom         = false

SWEP.HoldType = "ar2"

------------------------------------------

SWEP.Slot                   = 2
SWEP.SlotPos                = 0
SWEP.DrawAmmo               = true
SWEP.DrawCrosshair          = false

SWEP.ViewModel              = "models/homicbox_weapons/w_rif_ruger1022.mdl"
SWEP.WorldModel             = "models/homicbox_weapons/w_rif_ruger1022.mdl"

SWEP.addAng = Angle(0,0,10) -- Barrel pos adjust
SWEP.addPos = Vector(0,0,0) -- Barrel ang adjust
SWEP.SightPos = Vector(-3,0.8,3.78) -- Sight pos
SWEP.SightAng = Angle(-8,5,-2) -- Sight ang

SWEP.Mobility = 1.4


function SWEP:DrawWorldModel()
    self:DrawModel()
end