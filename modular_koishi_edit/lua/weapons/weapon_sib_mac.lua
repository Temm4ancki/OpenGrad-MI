
SWEP.Base = 'salat_base' -- base

SWEP.PrintName 				= "MAC-10 - SIB"
SWEP.Author 				= "Ingram"
SWEP.Instructions			= "Оу щит гад дэм"
SWEP.Category 				= "Оружие"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 30
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "SMG1"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 40
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "weapons/smg_mac10/mac10_fire_01.wav"
SWEP.Primary.FarSound = "snd_jack_hmcd_smp_far.wav"
SWEP.Primary.Force = 30
SWEP.ReloadTime = 2.2
SWEP.ShootWait = 0.05
SWEP.ReloadSounds = {
    [0.1] = {"weapons/mp5sd/boltback.wav"},
    [0.5] = {"weapons/smg_mac10/mac10_mag_out.wav"},
    [1.3] = {"weapons/smg_mac10/mac10_mag_in_3.wav"},
    [2] = {"weapons/smg_mac10/mac10_pull.wav"},
}
SWEP.TwoHands = true
SWEP.ShellRotate = false

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

------------------------------------------

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.HoldType = "smg"

------------------------------------------

SWEP.Slot					= 2
SWEP.SlotPos				= 0
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/homicbox_weapons/w_smg_mac10.mdl"
SWEP.WorldModel				= "models/homicbox_weapons/w_smg_mac10.mdl"

SWEP.addAng = Angle(0,0,0) -- Barrel pos adjust
SWEP.addPos = Vector(0,0,0) -- Barrel ang adjust
SWEP.SightPos = Vector(-11,-0.05,5.2) -- Sight pos
SWEP.SightAng = Angle(-6,2,0) -- Sight ang

SWEP.Mobility = 1.3
