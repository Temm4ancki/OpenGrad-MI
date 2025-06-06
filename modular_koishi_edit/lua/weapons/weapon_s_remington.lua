SWEP.Base = 'koishi_sweps' -- base

SWEP.PrintName 				= "Дробовик"
SWEP.Author 				= "Remington"
SWEP.Instructions			= "Не хороший дробовик, вообще винтовка"
SWEP.Category 				= "md3"

SWEP.Spawnable 				= false
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 8
SWEP.Primary.DefaultClip	= 8
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "Buckshot"
SWEP.Primary.Cone = 0.05
SWEP.Primary.Damage = 40
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "weapons/shtg_remington870/shotgun_pump_fire1.wav"
SWEP.Primary.FarSound = "snd_jack_hmcd_sht_far.wav"
SWEP.Primary.Force = 130
SWEP.ReloadTime = 2.7
SWEP.ShootWait = 0.5
SWEP.NumBullet = 12
SWEP.ReloadSounds = {
    [0.2] = {"snd_jack_shotguninsert.wav"},
    [0.8] = {"snd_jack_shotguninsert.wav"},
    [1.5] = {"snd_jack_shotguninsert.wav"},
    [1.8] = {"snd_jack_shotguninsert.wav"},
    [2.1] = {"snd_jack_shotguninsert.wav"},
    [2.6] = {"snd_jack_shotguninsert.wav"},
    [2.7] = {"snd_jack_hmcd_shotpump.wav"},
}
SWEP.TwoHands = true
SWEP.Shell = "EjectBrass_12Gauge"
SWEP.ShellRotate = false

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

SWEP.ViewModel				= "models/homicbox_weapons/w_shot_870.mdl"
SWEP.WorldModel				= "models/homicbox_weapons/w_shot_870.mdl"

SWEP.addAng = Angle(-0.5,0,0) -- Barrel pos adjust
SWEP.addPos = Vector(0,0,0) -- Barrel ang adjust
SWEP.SightPos = Vector(-5,1,4) -- Sight pos
SWEP.SightAng = Angle(-6,0,0) -- Sight ang

SWEP.Mobility = 1.5

SWEP.RightMod = -1
SWEP.ForwardMod = 5
SWEP.UpMod = 4.8
SWEP.AngleMod = Angle(0,5,0)