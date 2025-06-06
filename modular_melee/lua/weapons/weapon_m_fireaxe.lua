SWEP.Base = "koishi_melee"

SWEP.PrintName = "Пожарный топор"
<<<<<<< HEAD:OpenGrad/lua/weapons/weapon_hg_fireaxe.lua
SWEP.Category = "Ближний Бой"
=======
SWEP.Category = "md3melee"
>>>>>>> modular3:modular_melee/lua/weapons/weapon_m_fireaxe.lua
SWEP.Purpose = "Массивный топор для вскрытия и разборки конструкций при тушении пожара."
SWEP.WepSelectIcon = "vgui/select/w/fireaxe"
SWEP.IconOverride = "vgui/icon/w/fireaxe.png"

SWEP.Spawnable= true
SWEP.AdminSpawnable= true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 60
SWEP.ViewModel = "models/weapons/salat/w_hg_fireaxe/w_me_axe_fire.mdl"
SWEP.WorldModel = "models/weapons/salat/w_hg_fireaxe/w_me_axe_fire.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 1
SWEP.SlotPos = 2

SWEP.UseHands = true

---SWEP.HoldType = "knife"

SWEP.FiresUnderwater = false

SWEP.DrawCrosshair = false

SWEP.DrawAmmo = true

SWEP.Primary.Damage = 40
SWEP.Primary.Ammo = "none"
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Recoil = 0.5
SWEP.Primary.Delay = 1.2
SWEP.Primary.Force = 190

SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.DrawSound = "weapons/salat/w_hg_fireaxe/holster_in_light.ogg"
SWEP.HitSound = "weapons/salat/w_hg_fireaxe/shove_hit.ogg"
SWEP.FlashHitSound = "weapons/salat/w_hg_fireaxe/snd_jack_hmcd_axehit.ogg"
SWEP.ShouldDecal = true
SWEP.HoldTypeWep = "melee2"
SWEP.DamageType = DMG_SLASH