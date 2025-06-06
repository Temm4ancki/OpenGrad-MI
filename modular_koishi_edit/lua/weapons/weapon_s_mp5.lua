
SWEP.Base = 'koishi_sweps' -- base

SWEP.PrintName 				= "MP5A3 - SIB"
SWEP.Author 				= "Heckler & Koch"
SWEP.Instructions			= "Да я двигаюсь как будта тайлер дерден, па пути с качалки твою маму тайно дёрнул"
SWEP.Category 				= "md3"

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
SWEP.Primary.Sound = "weapons/mil_mp5a4/mp5_fire_01.wav"
SWEP.Primary.FarSound = "snd_jack_hmcd_smp_far.wav"
SWEP.Primary.Force = 25
SWEP.ReloadTime = 2.2
SWEP.ShootWait = 0.07
SWEP.ReloadSounds = {
    [0.1] = {"weapons/mil_mp5a4/mp5_slide.wav"},
    [0.5] = {"weapons/mil_mp5a4/mac10_mag_out.wav"},
    [1.3] = {"weapons/mil_mp5a4/mp5_clipout.wav"},
    [2] = {"weapons/mil_mp5a4/mp5_slideforward.wav"},
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

SWEP.ViewModel				= "models/homicbox_weapons/w_smg_mp5.mdl"
SWEP.WorldModel				= "models/homicbox_weapons/w_smg_mp5.mdl"

SWEP.addAng = Angle(0,0,0) -- Barrel pos adjust
SWEP.addPos = Vector(0,0,0) -- Barrel ang adjust
SWEP.SightPos = Vector(-10.5,0.9,5.2) -- Sight pos
SWEP.SightAng = Angle(-6,2,0) -- Sight ang

SWEP.Mobility = 1.3

SWEP.RightMod = 5
SWEP.ForwardMod = 5
SWEP.UpMod = 5