SWEP.Base = "salat_base" -- base

SWEP.PrintName 				= "SKS - SIB"
SWEP.Author 				= "Adolf Simonov"
SWEP.Instructions			= "Винтовка самозарядная Симонова"
SWEP.Category 				= "Оружие"

SWEP.Spawnable 				= false
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 10
SWEP.Primary.DefaultClip	= 10
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "7.62x39 mm"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 50
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "weapons/rifle_sks/sks_fire_01.wav"
SWEP.Primary.FarSound = "snd_jack_hmcd_smp_far.wav"
SWEP.Primary.Force = 50
SWEP.ReloadTime = 2.8
SWEP.ShootWait = 0.075
SWEP.ReloadSounds = {
    [0.1] = {"weapons/rifle_sks/sks_clipout.wav"},
    [0.8] = {"weapons/rifle_sks/sks_clipin1.wav"},
    [1.2] = {"weapons/rifle_sks/sks_slide1.wav"},
    [1.4] = {"weapons/rifle_sks/sks_clipin2.wav"},
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

SWEP.ViewModel				= "models/homicbox_weapons/w_rif_sks_nobayo.mdl"
SWEP.WorldModel				= "models/homicbox_weapons/w_rif_sks_nobayo.mdl"

SWEP.addAng = Angle(-1,1,10) -- Barrel pos adjust
SWEP.addPos = Vector(0,0,0) -- Barrel ang adjust
SWEP.SightPos = Vector(-7,1.02,4) -- Sight pos
SWEP.SightAng = Angle(-8,5,-2) -- Sight ang

SWEP.Mobility = 1.4


function SWEP:DrawWorldModel()
    self:DrawModel()
end