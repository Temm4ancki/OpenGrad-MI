<<<<<<< HEAD:modular2/lua/weapons/weapon_sib_10.lua
SWEP.Base = "salat_base" -- base
=======
SWEP.Base = "koishi_sweps" -- base
>>>>>>> modular3:modular_koishi_edit/lua/weapons/weapon_s_doublebarell.lua

SWEP.PrintName 				= "Beretta SV10 - SIB"
SWEP.Author 				= "Remington"
SWEP.Instructions			= "Бакшот рулетка"
SWEP.Category 				= "md3"

SWEP.Spawnable 				= false
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 2
SWEP.Primary.DefaultClip	= 2
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "Buckshot"
SWEP.Primary.Cone = 0.05
SWEP.Primary.Damage = 50
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "weapons/shtg_berettasv10/shotgun_doublebarrel_fire1.wav"
SWEP.Primary.FarSound = "snd_jack_hmcd_sht_far.wav"
SWEP.Primary.Force = 130
SWEP.ReloadTime = 2.7
SWEP.ShootWait = 0.5
SWEP.NumBullet = 12
SWEP.ReloadSounds = {
    [0.2] = {"weapons/shtg_mossberg500/m500_loadshell1.wav"},
    [0.8] = {"weapons/shtg_mossberg500/m500_loadshell1.wav"},
    [1.5] = {"weapons/shtg_mossberg500/m500_loadshell1.wav"},
    [1.8] = {"weapons/shtg_mossberg500/m500_loadshell1.wav"},
    [2.1] = {"weapons/shtg_mossberg500/m500_loadshell1.wav"},
    [2.6] = {"weapons/shtg_mossberg500/m500_loadshell1.wav"},
    [2.7] = {"weapons/shtg_berettasv10/shotgun_doublebarrel_close.wav"},
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

SWEP.ViewModel				= "models/homicbox_weapons/w_shot_sv10.mdl"
SWEP.WorldModel				= "models/homicbox_weapons/w_shot_sv10.mdl"

SWEP.addAng = Angle(-0.5,0,0) -- Barrel pos adjust
SWEP.addPos = Vector(0,0,0) -- Barrel ang adjust
SWEP.SightPos = Vector(-2,1.1,3.4) -- Sight pos
SWEP.SightAng = Angle(-6,0,0) -- Sight ang

SWEP.Mobility = 1.5

SWEP.RightMod = -1.1
SWEP.ForwardMod = 5
SWEP.UpMod = 3.8
SWEP.AngleMod = Angle(-10,0,20)