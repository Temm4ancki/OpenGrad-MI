SWEP.Base = 'koishi_sweps' -- base

SWEP.PrintName 				= "Beretta 92FS - SIB"
SWEP.Author 				= "Beretta"
SWEP.Instructions			= "No bang! Hold on!"
SWEP.Category 				= "md3"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 15
SWEP.Primary.DefaultClip	= 15
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "Pistol"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 25
SWEP.Primary.Spread = 1
SWEP.Primary.Sound = "weapons/hndg_beretta92fs/beretta92_fire1.wav"
SWEP.Primary.FarSound = "snd_jack_hmcd_smp_far.wav"
SWEP.Primary.Force = 40
SWEP.ReloadTime = 1.3
SWEP.ShootWait = 0.135
SWEP.ReloadSounds = {
    [0.1] = {"weapons/hndg_beretta92fs/beretta92_clipout.wav"},
    [0.8] = {"weapons/hndg_beretta92fs/beretta92_clipin.wav"},
    [1.2] = {"weapons/hndg_beretta92fs/beretta92_sliderelease.wav"},
    [1.4] = {"weapons/hndg_beretta92fs/beretta92_slide.wav"},
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

SWEP.ViewModel				= "models/homicbox_weapons/w_pist_m92fs.mdl"
SWEP.WorldModel				= "models/homicbox_weapons/w_pist_m92fs.mdl"

SWEP.RightMod = -.6
SWEP.ForwardMod = 10
SWEP.UpMod = 4.1
SWEP.AngleMod = Angle(-10,5,0)