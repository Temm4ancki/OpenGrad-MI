SWEP.Base = "salat_base" -- base

SWEP.PrintName 				= "Winchester 1892 - SIB"
SWEP.Author 				= "Winchester"
SWEP.Instructions			= "I am the Sheriff"
SWEP.Category 				= "Оружие"

SWEP.Spawnable 				= false
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 15
SWEP.Primary.DefaultClip	= 15
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "357"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 63
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "weapons/shtg_winchestersx3/shotgun_semiauto_fire1.wav"
SWEP.Primary.FarSound = "snd_jack_hmcd_smp_far.wav"
SWEP.Primary.Force = 60
SWEP.ReloadTime = 2.8
SWEP.ShootWait = 0.6
SWEP.ReloadSounds = {
    [0.2] = {"weapons/shtg_winchestersx3/shotgun_semiauto_reload1.wav"},
    [0.8] = {"weapons/shtg_winchestersx3/shotgun_semiauto_reload2.wav"},
    [1.5] = {"weapons/shtg_winchestersx3/shotgun_semiauto_reload3.wav"},
    [1.8] = {"weapons/shtg_winchestersx3/shotgun_semiauto_reload4.wav"},
    [2.1] = {"weapons/shtg_winchestersx3/shotgun_semiauto_reload5.wav"},
    [2.6] = {"weapons/shtg_winchestersx3/shotgun_semiauto_reload1.wav"},
    [2.7] = {"weapons/shtg_winchestersx3/shotgun_semiauto_slide2.wav"},
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

SWEP.ViewModel				= "models/homicbox_weapons/w_rif_win1892.mdl"
SWEP.WorldModel				= "models/homicbox_weapons/w_rif_win1892.mdl"

SWEP.addAng = Angle(0,1,10) -- Barrel pos adjust
SWEP.addPos = Vector(0,0,0) -- Barrel ang adjust
SWEP.SightPos = Vector(-3,1.02,3.8) -- Sight pos
SWEP.SightAng = Angle(-8,5,-2) -- Sight ang

SWEP.Mobility = 1.4


function SWEP:DrawWorldModel()
    self:DrawModel()
end