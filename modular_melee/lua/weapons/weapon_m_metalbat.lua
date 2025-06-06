SWEP.Base = "koishi_melee"

SWEP.PrintName = "Металическая Бита"
<<<<<<< HEAD:OpenGrad/lua/weapons/weapon_hg_metalbat.lua
SWEP.Category = "Ближний Бой"
SWEP.Purpose = "Часть спортивного инвентаря, предназначенная для нанесения ударов по мячу, выполненная из металлического материала, благодаря чему урон от данной биты будет в разы сильнее, чем от её деревянного аналога. Особенности конструкции биты позволяют наносить ею тяжёлые и мощные удары, но отличается от деревянной битой тем."
SWEP.WepSelectIcon = "vgui/select/w/metalbat"
SWEP.IconOverride = "vgui/icon/w/metalbat.png"
=======
SWEP.Category = "md3melee"
SWEP.Instructions = "Часть спортивного инвентаря, предназначенная для нанесения ударов по мячу, выполненная из металлического материала, благодаря чему урон от данной биты будет в разы сильнее, чем от её деревянного аналога. Особенности конструкции биты позволяют наносить ею тяжёлые и мощные удары, но отличается от деревянной битой тем."
>>>>>>> modular3:modular_melee/lua/weapons/weapon_m_metalbat.lua

SWEP.WepSelectIcon = "vgui/select/w/metalbat"
SWEP.IconOverride = "vgui/icon/w/metalbat.png"

SWEP.Spawnable= true
SWEP.AdminSpawnable= true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 60
SWEP.ViewModel = "models/weapons/salat/w_hg_metalbat/w_me_bat_metal.mdl"
SWEP.WorldModel = "models/weapons/salat/w_hg_metalbat/w_me_bat_metal.mdl"
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
SWEP.Primary.Delay = 1.1
SWEP.Primary.Force = 100

SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.DrawSound = "weapons/salat/w_hg_metalbat/holster_in_light.ogg"
SWEP.HitSound = "physics/metal/metal_canister_impact_hard3.wav"
SWEP.FlashHitSound = "weapons/salat/w_hg_metalbat/flesh_impact_blunt_04.ogg"
SWEP.ShouldDecal = false
SWEP.HoldTypeWep = "melee2"
SWEP.DamageType = DMG_CLUB