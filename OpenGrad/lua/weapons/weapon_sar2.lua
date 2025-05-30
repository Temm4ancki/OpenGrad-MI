SWEP.Base = "salat_base" -- base

SWEP.PrintName 				= "Automatic Rifle 2"
SWEP.Author 				= "Homigrad"
SWEP.Instructions			= "Основное штурмовое оружие Альянса"
SWEP.Category 				= "Оружие"
SWEP.WepSelectIcon = "vgui/select/w/sar2"
SWEP.IconOverride = "vgui/icon/w/sar2.png"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 30
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "ar2"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 40
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "weapons/salat/w_sar2/fire1.ogg"
SWEP.Primary.SoundFar = "weapons/salat/w_sar2/snd_jack_hmcd_snp_far.ogg"
SWEP.Primary.Force = 120 / 3
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.1
SWEP.ReloadSound = "weapons/arccw/npc_ar2_reload.wav"
SWEP.TwoHands = true
SWEP.Efect = "AR2Impact"
SWEP.Tracer = "AR2Tracer"

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

SWEP.ViewModel				= "models/weapons/salat/w_sar2/w_irifle.mdl"
SWEP.WorldModel				= "models/weapons/salat/w_sar2/w_irifle.mdl"

SWEP.addAng = Angle(0.5,0.9,0)