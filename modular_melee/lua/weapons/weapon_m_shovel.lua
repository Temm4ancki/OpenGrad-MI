SWEP.Base = "koishi_melee"

<<<<<<< HEAD:OpenGrad/lua/weapons/weapon_hg_crowbar.lua
SWEP.PrintName = "Монтировка"
SWEP.Category = "Ближний Бой"
SWEP.Purpose = "Ручной ударный и рычажный инструмент, один из наиболее древних видов инструмента, известных человечеству, наряду с молотком, зубилом, топором, лопатой."
SWEP.WepSelectIcon = "vgui/select/w/crowbar"
SWEP.IconOverride = "vgui/icon/w/crowbar.png"
=======
SWEP.PrintName = "Лопата"
SWEP.Category = "md3melee"
SWEP.Purpose = "Ручной шанцевый инструмент, используемый преимущественно для работы (копание, расчистка, перенос и так далее) с грунтом."
SWEP.WepSelectIcon = "vgui/select/w/spade"
SWEP.IconOverride = "vgui/icon/w/spade.png"
>>>>>>> modular3:modular_melee/lua/weapons/weapon_m_shovel.lua

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 60
<<<<<<< HEAD:OpenGrad/lua/weapons/weapon_hg_crowbar.lua
SWEP.ViewModel = "models/weapons/salat/w_hg_crowbar/w_me_crowbar.mdl"
SWEP.WorldModel = "models/weapons/salat/w_hg_crowbar/w_me_crowbar.mdl"
=======
SWEP.ViewModel = "models/weapons/salat/w_hg_spade/w_me_spade.mdl"
SWEP.WorldModel = "models/weapons/salat/w_hg_spade/w_me_spade.mdl"
>>>>>>> modular3:modular_melee/lua/weapons/weapon_m_shovel.lua
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
SWEP.Primary.Delay = 1.3
SWEP.Primary.Force = 70

SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

<<<<<<< HEAD:OpenGrad/lua/weapons/weapon_hg_crowbar.lua
SWEP.DrawSound = "weapons/salat/w_hg_crowbar/holster_in_light.ogg"
SWEP.HitSound = "weapons/salat/w_hg_crowbar/snd_jack_hmcd_knifehit.ogg"
SWEP.FlashHitSound = "weapons/salat/w_hg_crowbar/flesh_impact_blunt_04.ogg"
=======
SWEP.DrawSound = "weapons/salat/w_hg_spade/holster_in_light.ogg"
SWEP.HitSound = "physics/metal/metal_sheet_impact_hard7.wav"
SWEP.FlashHitSound = "weapons/salat/w_hg_spade/snd_jack_hmcd_axehit.ogg"
>>>>>>> modular3:modular_melee/lua/weapons/weapon_m_shovel.lua
SWEP.ShouldDecal = true
SWEP.HoldTypeWep = "melee"
SWEP.DamageType = DMG_SLASH